# Multi-objection Optimization

Here we extend our initial work on semiconductor manufacturing scheduling by means of Answer Set Programming (ASP) modulo difference logic with three new features:

- Partially Flexible Machine Assigment Strategies
- Batch Processing of Operations
- Multi-objective Optimization of:
    - Makespan of Schedule
    - Mimimum Setup Usage Violations
    - Minimum Batch Size Violations

This repository includes the following files/folders:

<table>
<tr><th>File/Folder</th><th>Description</th></tr>
<tr><td style="font-family:'Courier New'">README.md</td><td>this file</td></tr>
<tr><td style="font-family:'Courier New'">encoding.lp</td><td>scheduling encoding in ASP modulo difference logic</td></tr>
<tr><td style="font-family:'Courier New'">instances</td><td>instance files for testing</td></tr>
<tr><td style="font-family:'Courier New'">main.py</td><td>Python script to run multi-shot ASP solving for multi-objective optimization</td></tr>
</table>

## Usage

The script for running our semiconductor manufacturing scheduling encoding and instances relies on the Python libraries of [Clingo](https://potassco.org/clingo/) and [Clingo[DL]](https://potassco.org/labs/clingodl/). The following example calls illustrate runs with diverse machine assignment strategies, with time limits of 450 seconds for makespan minimization as well as 150 seconds for minimizing setup and batch violations.

- Fixed machine assignment with lot-wise preallocation of operations:
    - ``./main.py instances/instance01.lp encoding.lp --const sub_size=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=1``

- Fixed machine assignment with operation-wise preallocation of operations:
    - ``./main.py instances/instance01.lp encoding.lp --const sub_size=1 --const lot_step=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=1 --const lot_step=1``

- Fully flexible machine assignment:
    - ``./main.py instances/instance01.lp encoding.lp``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp``

- Partially flexible machine assignment with lot-wise preallocation of operations:
    - ``./main.py instances/instance05.lp encoding.lp --const sub_size=2``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=2``

- Partially flexible machine assignment with operation-wise preallocation of operations:
    - ``./main.py instances/instance05.lp encoding.lp --const sub_size=2 --const lot_step=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=2 --const lot_step=1``

- Setup-based machine assignment:
    - ``./main.py instances/instance01.lp encoding.lp --const by_setup=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const by_setup=1``

- Setup-based machine assignment with lot-wise preallocation of operations:
    - ``./main.py instances/instance05.lp encoding.lp --const sub_size=2 --const by_setup=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=2 --const by_setup=1``

- Setup-based machine assignment with operation-wise preallocation of operations:
    - ``./main.py instances/instance05.lp encoding.lp --const sub_size=2 --const lot_step=1 --const by_setup=1``
    - ``...``
    - ``./main.py instances/instance12.lp encoding.lp --const sub_size=2 --const lot_step=1 --const by_setup=1``
