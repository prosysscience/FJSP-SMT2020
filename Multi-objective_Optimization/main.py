#!/usr/bin/python3

import sys
import time
import clingo
from clingo import ast, Function, Number
from clingodl import ClingoDLTheory

TIMEOUT_BOUND = 450
TIMEOUT_WEAK = 150

class Application(clingo.Application):

    def __init__(self, name):
        self.__theory = ClingoDLTheory()
        self.program_name = name
        self.version = ".".join(str(x) for x in self.__theory.version())

    def register_options(self, options):
        self.__theory.register_options(options)

    def validate_options(self):
        self.__theory.validate_options()
        return True

    def __on_statistics(self, step, accu):
        self.__theory.on_statistics(step, accu)

    def main(self, prg, files):
        global TIMEOUT_BOUND, TIMEOUT_WEAK
        bound, lastbound = 0, 0
        interrupted_calls, non_interrupted_calls = 0, 0

        def on_model(model):
            nonlocal bound, lastbound, parts
            self.__theory.on_model(model)
            makespan = self.__theory.lookup_symbol(Function('makespan', []))
            lastbound = bound
            bound = self.__theory.get_value(model.thread_id, makespan)
            if bound < lastbound: parts = [('fix', [Number(lastbound-1)])]

        self.__theory.register(prg)
        with ast.ProgramBuilder(prg) as bld:
            ast.parse_files(files, lambda stm: self.__theory.rewrite_ast(stm, bld.add))

        prg.ground([('base', []), ('weak', [])])
        self.__theory.prepare(prg)

        TIMEOUT = TIMEOUT_BOUND
        while True:
            parts = []
            with prg.solve(on_model=on_model, on_statistics=self.__on_statistics, async_=True, yield_=True) as handle:
                tick = time.time()
                handle.resume()
                wait = handle.wait(TIMEOUT)
                TIMEOUT += tick-time.time()
                if not wait:
                    interrupted_calls += 1
                    break
                if handle.model() is None:
                    non_interrupted_calls += 1
                    break
            parts.append(('opt', [Number(bound-1)]))
            prg.ground(parts)
            prg.assign_external(Function('bound', [Number(bound-1)]), True)

        print('Time of the 1st Call : {} '.format(TIMEOUT_BOUND-TIMEOUT))
        print('Interrupted Calls : {} '.format(interrupted_calls))
        print('Uninterrupted Calls : {} '.format(non_interrupted_calls))
        print('Makespan : {} '.format(bound))

        prg.release_external(Function('bound', [Number(bound-1)]))
        if bound+1 < lastbound: prg.ground([('opt', [Number(bound)]), ('fix', [Number(bound)])])

        TIMEOUT = TIMEOUT_WEAK
        with prg.solve(on_model=on_model, on_statistics=self.__on_statistics, async_=True, yield_=True) as handle:
            while True:
                tick = time.time()
                handle.resume()
                wait = handle.wait(TIMEOUT)
                TIMEOUT += tick-time.time()
                if not wait:
                    interrupted_calls += 1
                    break
                if handle.model() is None:
                    non_interrupted_calls += 1
                    break

        print('Time of the 2nd Call : {} '.format(TIMEOUT_WEAK-TIMEOUT))
        print('Interrupted Calls : {} '.format(interrupted_calls))
        print('Uninterrupted Calls : {} '.format(non_interrupted_calls))
        print('Makespan : {} '.format(bound))

sys.exit(int(clingo.clingo_main(Application('clingo-dl'), sys.argv[1:])))
