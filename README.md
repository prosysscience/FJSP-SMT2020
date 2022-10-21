# FJSP-SMT2020

Flexible Job-shop Scheduling for Semiconductor Manufacturing with Hybrid ASP

This work proposes solving the semiconductor manufacturing scheduling problem using Answer Set Programming (ASP). We tested our work (in progress) with small examples derived from the SMT2020 dataset.

- The following features have been considered in this work:
   - Machine Maintenance
   - Machine Setup
   - Machine Assignment (Flexible/Fixed)
- Our main objective is to minimize the total completion time.

This work has been submitted in PADL 2023 (https://popl23.sigplan.org/home/PADL-2023). 

The directory consists of following files: 
<table>
<tr><th>File/Folder name</th><th>File description</th></tr>
<tr><td>instances</td><td>contains the instance files tested in the paper</td></tr>
<tr><td>encoding_mws.lp</td><td>a file contains the scheduler encoding</td></tr>
<tr><td>README.md</td><td>text version of this file</td></tr>
</table>

## Prerequisites

* [Python3](https://www.python.org/downloads/)
* [Clingo](https://potassco.org/clingo/)
* [Clingo-Dl](https://potassco.org/labs/clingodl/)


## Usage
* clingo-dl encoding_msw.lp .\instances\instance01.lp --minimize-variable=makespan --time-limit=600 --> (Fixed machine assignment)

* clingo-dl encoding_msw.lp .\instances\instance01.lp --minimize-variable=makespan --time-limit=600 --const flex=1 --> (Flexible machine assignment)

* clingo-dl encoding_msw.lp .\instances\instance02.lp --minimize-variable=makespan --time-limit=600 --const flex=1 --> (Flexible machine assignment)
