operation_step(P,S,A,G,Pro_t, Setup_t, Setup_n)  :- product(Product,Step_num,Area,Grp,Pro_t,Pro_unit,Cas_interval,Setup_t,Setup_n),
                                                    P=Product, S=Step_num,A=Area,G=Grp.
tool(A,G,M)                                      :- tool(Area,Grp,Machine_num,Cas,Loading,Un_Loading),
                                                    A=Area,G=Grp,M=Machine_num.
setup(G, Setup_n, Setup_t, Min_r)                :- setup_change(Grp, Setup_name, Setup_t, Min_runs), G=Grp, Setup_n=Setup_name, Min_r=Min_runs.
