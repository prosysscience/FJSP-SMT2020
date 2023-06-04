
#include "parsing.lp".
#include "machine_selection.lp".

#const flex = 0.

step_pro(L, P, S, Prio, A, G, Pro_t) :- stephas_setup((L, P, S, Prio), A, G, Setup_n),
                                        operation_step(P, S, A, G, Pro_t, Setup_t, Setup_n).

stephas_setup((L, P, S, Prio), A, G, Setup_n)  :- operation_step(P, S, A, G, Pro_t, Setup_t, Setup_n),
                                                  wip(L, P, Cur_s, Prio, W, R, D),
                                                  step_prio(L, P, Prio), S >= Cur_s.

lot(L, P, Prio, W, R, D) :- wip(L, P, Cur_s, Prio, W, R, D).

step_prio(L, P, Prio)   :- lot(L, P, Prio, W, R, D). 
lot_release(L, R)       :- lot(L, P, Prio, W, R, D). 
num_wafer(L, W)         :- lot(L, P, Prio, W, R, D). 

step_lot(L, P, S, Prio) :- step_pro(L, P, S, Prio, A, G, Pro_t). 
pro(P, S, Pro_t)        :- step_pro(L, P, S, Prio, A, G, Pro_t). 

tool_grp(G, M) :- tool(A, G, M),
                  not tool(A, G, M + 1).

step_index(L, P, S, Prio, G, I) :- step_pro(L, P, S, Prio, A, G, Pro_t),
                                       step_prio(L, P, Prio), 
                                       lot_release(L, R),
                                       I = #count{L1, P1, S1 : 
                                                    step_pro(L1, P1, S1, Prio1, A1, G, Pro_t1),
                                                    step_prio(L1, P1, Prio1), 
                                                    lot_release(L1, R1),
                                                        (R1, Prio, S1, Pro_t1, P1, L1) < 
                                                             (R, Prio1, S, Pro_t, P, L)}.
% *************************************** assign the steps to machines ***************************************
{mach_assign(L, P, S, Prio, G, M): tool(G, M)} = 1 :- step_index(L, P, S, Prio, G, I), flex = 1.


mach_assign(L, P, S, Prio, G, M) :- step_index(L, P, S, Prio, G, I),
                                    consider_machine(G, Num_machines),
                                    M = (I \ Num_machines) + 1,
                                    flex = 0.


same_tool(G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2), Pro_t1, Pro_t2) :- mach_assign(L1, P1, S1, Prio1, G, M),
                                                                          mach_assign(L2, P2, S2, Prio2, G, M),
                                                                          pro(P1, S1, Pro_t1),
                                                                          pro(P2, S2, Pro_t2),
                                                                          (L1, P1, Prio1) < (L2, P2, Prio2).

{diff_order(O1, O2, Pro_t1)} :- same_tool(G, O1, O2, Pro_t1, Pro_t2).
 diff_order(O2, O1, Pro_t2)  :- same_tool(G, O1, O2, Pro_t1, Pro_t2),
                                not diff_order(O1, O2, Pro_t1).

order(O1, O2, Pro_t1) :- diff_order(O1, O2, Pro_t1).

% ************************************ order steps belong to same product ************************************
order((L, P, S1, Prio), (L, P, S2, Prio), Pro_t1) :- step_lot(L, P, S1, Prio),
                                                     step_lot(L, P, S2, Prio),
                                                     pro(P, S1, Pro_t1),
                                                     S2 = S1 + 1.

% ***************************************** Handling the Maintenance *****************************************
same_tool(G, (L, P, S1, Prio), (L, P, S2, Prio), Pro_t1) :- pm(E, G, Type, Max, Dur, Min),
                                                            mach_assign(L, P, S1, Prio, G, M),
                                                            mach_assign(L, P, S2, Prio, G, M),
                                                            pro(P, S1, Pro_t1),
                                                            S1 < S2.

pair(G, O1, O2, Pro_t1) :- same_tool(G, O1, O2, Pro_t1).
pair(G, O1, O2, Pro_t1) :- same_tool(G, O1, O2, Pro_t1, Pro_t2),
                           pm(E, G, Type, Max, Dur, Min).
pair(G, O2, O1, Pro_t2) :- same_tool(G, O1, O2, Pro_t1, Pro_t2),
                           pm(E, G, Type, Max, Dur, Min).
pair(G, O1, O2, Pro_t1) :- same_tool(G, O1, O2, Pro_t1, Pro_t2),
                           setup_change(G, Setup_n, Setup_t, Min_r).
pair(G, O2, O1, Pro_t2) :- same_tool(G, O1, O2, Pro_t1, Pro_t2),
                           setup_change(G, Setup_n, Setup_t, Min_r).

tool_order(O1, O2, Pro_t1) :- same_tool(G, O1, O2, Pro_t1).
tool_order(O1, O2, Pro_t1) :- pair(G, O1, O2, Pro_t1), diff_order(O1, O2, Pro_t1).

no_first(O2)      :- tool_order(O1, O2, Pro_t1).

no_consecutive(O1, O2) :- pair(G, O1, O2, Pro_t1),
                          tool_order(O1, O, Pro_t1),
                          tool_order(O, O2, Pro_t).

% ************************* Determining the ignored operations *************************
ignore(E, G, O1, O2)  :- pair(G, O1, O2, Pro_t1),
                         assign_m_s(E, G, O),
                         tool_order(O1, O, Pro_t1),
                         tool_order(O, O2, Pro_t).

ignore(E, G, O1, O2)  :- pair(G, O1, O2, Pro_t1),
                         assign_m_s(E, G, O2).

ignore(E, G, O1, O2)  :- pair(G, O1, O2, Pro_t1),
                         pm(E, G, Type, Max, Dur, Min),
                         not tool_order(O1, O2, Pro_t1).

ignore(setup, G, O1, O2) :- pair(G, O1, O2, Pro_t1),
                            stephas_setup(O1, A, G, S1),
                            stephas_setup(O2, A, G, S2),
                            not tool_order(O1, O2, Pro_t1).

no_last(E, G, O1) :- assign_m_s(E, G, O2),
                     tool_order(O1, O2, Pro_t1).

no_last(G, O1) :- assign_setup(Setup_n, G, O2),
                  tool_order(O1, O2, Pro_t1).

% ************************* Assigning the maintenance and setup ************************
{assign(E, G, (L, P, S, Prio))} :- pm(E, G, Type, Max, Dur, Min),
                                   mach_assign(L, P, S, Prio, G, M).

assign_setup(Setup_n2, G, O2) :- pair(G, O1, O2, Pro_t1), 
                                 not no_consecutive(O1, O2),
                                 tool_order(O1, O2, Pro_t1),
                                 use_setup(O1, Setup_n1),
                                 use_setup(O2, Setup_n2),
                                 Setup_n1 != Setup_n2,
                                 Setup_n2 != 0.

assign_setup(Setup_n1, G, O1) :- not no_first(O1),
                                 use_setup(O1, Setup_n1),
                                 stephas_setup(O1, A, G, Setup_n1).

% ******************** Merging the maintenance and setup in one atom *******************
assign_m_s(E, G, O) :- assign(E, G, O).
assign_m_s(setup, G, O) :- assign_setup(S, G, O).

% ************************ Handling the maintenance constraints ************************
pm_typ(E, G, Type) :- pm(E, G, Type, Max, Dur, Min).

:- pm(E, G, Type, Max, Dur, Min), mach_assign(L, P, S, Prio, G, M),
   not no_first((L, P, S, Prio)), not assign_m_s(E, G, (L, P, S, Prio)).

:- pm(E, G, counter_based, Max, Dur, Min), mach_assign(L1, P1, S1, Prio1, G, M), num_wafer(L1, W1),
   #sum{W, L2, P2, S2, Prio2 : pair(G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2), Pro_t1), 
                               num_wafer(L2, W),
                               not ignore(E, G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2))} > Max-W1.

:- pm(E, G, counter_based, Max, Dur, Min), assign_m_s(E, G, (L1, P1, S1, Prio1)), num_wafer(L1, W1),
   no_last(E, G, (L1, P1, S1, Prio1)),
   #sum{W, L2, P2, S2, Prio2 : pair(G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2), Pro_t1),
                               num_wafer(L2, W),
                               not ignore(E, G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2))} < Min-W1.

:- pm(E, G, time_based, Max, Dur, Min), mach_assign(L1, P1, S1, Prio1, G, M), pro(P1, S1, Pro_t1),
   #sum{Pro_t2, L2, P2, S2, Prio2 : pair(G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2), Pro_t1), 
                                    pro(P2, S2, Pro_t2),
                                    not ignore(E, G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2))} > Max-Pro_t1.

:- pm(E, G, time_based, Max, Dur, Min), assign_m_s(E, G, (L1, P1, S1, Prio1)), pro(P1, S1, Pro_t1),
   no_last(E, G, (L1, P1, S1, Prio1)),
   #sum{Pro_t2, L2, P2, S2, Prio2 : pair(G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2), Pro_t1),
                                    pro(P2, S2, Pro_t2),
                                    not ignore(E, G, (L1, P1, S1, Prio1), (L2, P2, S2, Prio2))} < Min-Pro_t1.


pm_index(E, G, Dur, I) :- pm(E, G, Type, Max, Dur, Min), 0 < Dur,
                            I = #count{E' : pm(E', G, Type', Max', Dur', Min'),
                                            0 < Dur', (Dur,E) <= (Dur',E')}.

% ****************** Handling two maintenances occur at the same time ******************
pm_duration(O, I, Dur) :- pm_index(E, G, Dur, I), assign_m_s(E, G, O).
pm_duration(O, I, Dur) :- pm_index(E, G, Dur1, I), assign_m_s(E, G, O),
                          pm_duration(O, I + 1, Dur2), Dur = Dur1 + Dur2.
pm_duration(O, I, Dur) :- pm_duration(O, I + 1, Dur), 0 < I.

% ***************************************** Handling Setup *****************************************
no_direct(O1, O2) :- pair(G, O1, O2, Pro_t1), 
                     tool_order(O1, O, Pro_t1),
                     tool_order(O, O2, Pro_t),
                     stephas_setup(O1, A, G, Setup_n1),
                     stephas_setup(O, A, G, Setup_n),
                     stephas_setup(O2, A, G, 0),
                     Setup_n1 != 0, Setup_n != 0, Setup_n1 != Setup_n.

reuse_setup(O2, Setup_n1) :- tool_order(O1, O2, Pro_t1), 
                             stephas_setup(O1, A, G, Setup_n1),
                             stephas_setup(O2, A, G, 0), 
                             not no_direct(O1, O2),
                             Setup_n1 != 0.

use_setup(O, 0)       :- stephas_setup(O, A, G, 0), not reuse_setup(O, _). % to handle that the first operation needs no setup
use_setup(O, Setup_n) :- stephas_setup(O, A, G, Setup_n), Setup_n != 0. % to handle that the current operation - either the first one or no - needs a setup
use_setup(O, Setup_n) :- reuse_setup(O, Setup_n). % to handle that the next operation needs setup zero


setup_duration(O, G, Setup_t) :- assign_setup(Setup, G, O),
                                 setup_change(G, Setup, Setup_t, Min_r).

% ********************* Same operation has a maintenance and setup *********************
pm_and_setup(O, Dur) :- setup_duration(O, G, Dur1),
                        pm_duration(O, 1, Dur2),
                        Dur = Dur1 + Dur2.

%consider(G, O1, O2) :- pair(G, O1, O2, Pro_t1), not ignore(_, G, O1, O2).

% *************** Merging the maintenance and setup (duration) in one atom *************

pm_setup(O, Dur) :- setup_duration(O, G, Dur).
pm_setup(O, Dur) :- pm_duration(O, 1, Dur).
pm_setup(O, Dur) :- pm_and_setup(O, Dur).

violation(O1, X) :- assign_setup(S1, G, O1), no_last(setup, G, O1),
                    setup_change(G, S1, T1, Min_r1),
                    X = #count{O2 : pair(G, O1, O2, Pro_t1), not ignore(setup, G, O1, O2)}, X < Min_r1 - 1.

:~ assign_setup(Setup_n1, G, O1), no_last(G, O1),
   setup_change(G, Setup_n1, Setup_t1, Min_r1),
    #count{O2 : pair(G, O1, O2, Pro_t1), not ignore(setup, G, O1, O2)}  < Min_r1 - 1 . [1@1, O1]


first_step((L, P, Cur_s, Prio), R) :- step_lot(L, P, Cur_s, Prio), lot_release(L, R), not setup_duration((L, P, Cur_s, Prio), _, _),
                                      wip(L, P, Cur_s, Prio, W, R, D).
first_step((L, P, Cur_s, Prio), R + Setup_t) :- lot_release(L, R), 
                                                step_lot(L, P, Cur_s, Prio), O = (L, P, Cur_s, Prio),
                                                setup_duration(O, G, Setup_t), 
                                                wip(L, P, Cur_s, Prio, W, R, D).

% ************************************ Difference logic for scheduling ************************************
&diff{0 - (L, P, S, Prio)} <= -T :- first_step((L, P, S, Prio), T).

&diff{0  -  O} <= -Setup_t :- tool_order(O, _, Pro_t), not no_first(O),
                              setup_duration(O, G, Setup_t).

&diff{O1 - O2} <= -Pro_t1 :- order(O1, O2, Pro_t1).

&diff{O1 - O2} <= -Pro_t1 - Dur :- tool_order(O1, O2, Pro_t1),
                                   pm_setup(O2, Dur).

&diff{(L, P, S, Prio) - makespan} <= -Pro_t :- pro(P, S, Pro_t),
                                               step_lot(L, P, S, Prio),
                                               not step_lot(L, P, S+1, Prio).


#show.
%#show mach_assign/6.
%#show step_index/5.
%#show assign_m_s/3.
%#show pm_setup/2.
%#show pm_and_setup/2.
%#show violation/2.
%#show pm_setup/2.
%#show setup_change/4.
%#show no_ignore/4.
%#show pair/4.
%#show ignore/4.
%#show no_last/3.
%#show assign/3.
%#show no_direct/2.
%#show stephas_setup/4.
%#show mach_assign/6.
%#show reuse_setup/2.
%#show use_setup/2.
%#show ignore/3.
%#show no_last/2.
%#show no_consecutive/2.
%#show consecutive/2.
%#show direct/2.
%#show ignore/3.
%#show tool_order/3.
%#show assign_setup/3.
%#show consider/3.
% #show pro/3.
% #show pm/5.