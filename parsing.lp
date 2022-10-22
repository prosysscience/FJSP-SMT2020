operation_step(P,S,A,G,Pro_t,Setup_t,Setup_n) :- product(P,S,A,G,Pro_t,Pro_unit,Cas_interval,Setup_t,Setup_n).
tool(A,G,M)                                   :- tool(A,G,M,Cas,Loading,Un_Loading).
setup(G,Setup_n,Setup_t,Min_runs)             :- setup_change(G,Setup_n,Setup_t,Min_runs).
