# PADL-2023

<!--Flexible Job-shop Scheduling for Semiconductor Manufacturing with Hybrid ASP-->

This work, presented in the PADL 2023 paper [Flexible Job-shop Scheduling for Semiconductor Manufacturing with Hybrid Answer Set Programming (Application Paper)](https://doi.org/10.1007/978-3-031-24841-2_6), investigates solving semiconductor manufacturing scheduling tasks using Answer Set Programming (ASP). We tested our work (in progress) with small examples derived from the SMT2020 dataset.

- The following features have been considered in this work:
    - Machine Maintenance
    - Machine Setup
    - Machine Assignment (Flexible/Fixed)
- Our main objective is to minimize the total completion time (makespan) of schedules.

This repository includes the following files/folders:

<table>
<tr><th>File/Folder</th><th>Description</th></tr>
<tr><td style="font-family:'Courier New'">README.md</td><td>this file</td></tr>
<tr><td style="font-family:'Courier New'">encoding_mws.lp</td><td>main scheduling encoding</td></tr>
<tr><td style="font-family:'Courier New'">parsing.lp</td><td>auxiliary rules to reformat facts (included by <span style="font-family:'Courier New'">encoding_mws.lp</span>)</td></tr>
<tr><td style="font-family:'Courier New'">machine_selection.lp</td><td>auxiliary rules to analyze machine groups (included by <span style="font-family:'Courier New'">encoding_mws.lp</span>)</td></tr>
<tr><td style="font-family:'Courier New'">instances</td><td>instance files for testing</td></tr>
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
