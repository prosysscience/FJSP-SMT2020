# FJSP-SMT2020

<!--Flexible Job-shop Scheduling for Semiconductor Manufacturing with Hybrid ASP-->

This work investigates solving semiconductor manufacturing scheduling tasks using Answer Set Programming (ASP). We tested our work (in progress) with small examples derived from the SMT2020 dataset.

- The following features have been considered in this work:
  - Machine Maintenance
  - Machine Setup
  - Machine Assignment (Flexible/Fixed)
- Our main objective is to minimize the total completion time (makespan) of schedules.

<!---This work has been submitted to PADL 2023 (https://popl23.sigplan.org/home/PADL-2023).-->

This repository includes the following files/folders:

<table>
<tr><th>File/Folder</th><th>Description</th></tr>
<tr><td>``README.md``</td><td>this file</td></tr>
<tr><td>``encoding_mws.lp``</td><td>main scheduling encoding</td></tr>
<tr><td>``parsing.lp``</td><td>auxiliary rules to reformat facts (included by ``encoding_mws.lp``)</td></tr>
<tr><td>``machine_selection.lp``</td><td>auxiliary rules to analyze machine groups (included by ``encoding_mws.lp``)</td></tr>
<tr><td>``instances``</td><td>instance files for testing</td></tr>
</table>

<!--
## Prerequisites

- [Python3](https://www.python.org/downloads/)
 - [Clingo](https://potassco.org/clingo/)
- [Clingo[DL]](https://potassco.org/labs/clingodl/)
-->

## Usage

Our scheduling encoding and instances can be run with [Clingo[DL]](https://potassco.org/labs/clingodl/) as illustrated by the following example calls.

- Fixed machine assignment:
  - ``clingo-dl encoding_msw.lp instances/instance04.lp --minimize-variable=makespan --time-limit=600``

- Flexible machine assignment:
  - ``clingo-dl encoding_msw.lp instances/instance04.lp --minimize-variable=makespan --time-limit=600 --const flex=1``
