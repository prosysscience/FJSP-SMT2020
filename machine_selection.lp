% ****************************** Strategy to select limited number of machines *****************************************************************
                     

available_grp(A, G, M) :- tool(Area, Grp, Machine_num, Cas, Loading, Un_Loading),
                          A = Area, G = Grp, M = Machine_num.

total_tool_grp(Total_grp) :- Total_grp = #count{G : available_grp(A, G, M)}.

% ******************* count number of machines in each tool group  **************************************
num_machine(G, Machine) :- available_grp(A, G, M), 
                          Machine = #count{M1: available_grp(A, G, M1)}.

% calculate machine load: average process time per step/batchsize:-no of machines in group, 

remain_steps(G, T) :- available_grp(A, G, M),
                       T = #count{S1, L1, P1, Prio1 : wip(L1, P1, Cur_s1, Prio1, W1, R1, D1), operation_step(P1, S1, A, G, Pro_t1, Setup_t1, Setup_n1),
                              S1 >= Cur_s1} > 0.

step_mac_ratio(G, Num_steps, Machine) :- num_machine(G, Machine), remain_steps(G, Num_steps).
consider_machine(G, Num_steps ) :- step_mac_ratio(G, Num_steps, Machine), Machine > Num_steps.
consider_machine(G, Machine)   :- step_mac_ratio(G, Num_steps, Machine), Machine <= Num_steps.
tool(G, 1..Machine) :- consider_machine(G, Machine).
total_steps_machines(Steps,Machines) :-  Steps = #count{S, L, P, Prio : wip(L, P, Cur_s, Prio, W, R, D), 
                                                   operation_step(P, S, A, G, Pro_t, Setup_t, Setup_n),
                                                                 S >= Cur_s}>0,
                                           Machines = #sum{Machine, G: consider_machine(G, Machine)}>0.                                 

%#show available_grp/3.
%#show total_tool_grp/1.
%#show num_machine/2.
%#show remain_steps/2.
%#show step_mac_ratio/3.
%#show consider_machine/2.
%#show tool/2.
#show total_steps_machines/2.