%wip(index, product, current_step, priority, wafers, release_time, due_time).
wip(1,3,16,10,25,0,1638400).
wip(2,3,16,10,25,0,1638400).
wip(3,3,16,10,25,0,1638400).

wip(1,4,16,10,25,0,1638400).
wip(2,4,16,10,25,0,1638400).
wip(3,4,16,10,25,0,1638400).

%product(product_name, step_name, area_name, toolgrp_name, pro_time, pro_unit, cascading_interval, min_batch, max_batch, setup_time, setup_name).
product(3, 1,  implant, implant_128, 7,  wafer, 0, 0, 0).
product(3, 2,  litho, lithotrack_fe_95, 6,  wafer, 0, 0, su450_3).
product(3, 3,  implant, implant_128, 8,  wafer, 0, 0, 0).
product(3, 4,  litho, lithotrack_fe_95, 5,  wafer, 0, 0, 0).
product(3, 5,  implant, implant_128, 12, wafer, 0, 0, su128_1).
product(3, 6,  litho, lithotrack_fe_95, 10, wafer, 0, 0, 0).
product(3, 7,  implant, implant_128, 5,  wafer, 0, 0, su128_2).
product(3, 8,  implant, implant_128, 11, wafer, 0, 0, su128_1).
product(3, 9,  litho, lithotrack_fe_95, 13, wafer, 0, 0, su485_3).
product(3, 10, litho, lithotrack_fe_95, 8,  wafer, 0, 0, su450_3).
product(3, 11, implant, implant_128, 13, wafer, 0, 0, su128_2).
product(3, 12, implant, implant_128, 7,  wafer, 0, 0, su128_1).
product(3, 13, litho, lithotrack_fe_95, 11, wafer, 0, 0, 0).
product(3, 14, implant, implant_128, 13, wafer, 0, 0, su128_2).
product(3, 15, implant, implant_128, 8,  wafer, 0, 0, su128_1).
product(3, 16, litho, lithotrack_fe_95, 13, wafer, 0, 0, su494_3).
product(3, 17, litho, lithotrack_fe_95, 7,  wafer, 0, 0, 0).
product(3, 18, litho, lithotrack_fe_95, 8,  wafer, 0, 0, su494_3).
product(3, 19, implant, implant_128, 13, wafer, 0, 0, su128_2).
product(3, 20, implant, implant_128, 7,  wafer, 0, 0, su128_1).

product(4, 1,  implant, implant_128, 3,  wafer, 0, 0, 0).
product(4, 2,  implant, implant_128, 8,  wafer, 0, 0, su128_3).
product(4, 3,  litho, lithotrack_fe_95, 4,  wafer, 0, 0, su485_3).
product(4, 4,  litho, lithotrack_fe_95, 7,  wafer, 0, 0, 0).
product(4, 5,  implant, implant_128, 9, wafer, 0, 0, su128_1).
product(4, 6,  implant, implant_128, 6, wafer, 0, 0, 0).
product(4, 7,  litho, lithotrack_fe_95, 5,  wafer, 0, 0, su450_3).
product(4, 8,  implant, implant_128, 11, wafer, 0, 0, su128_1).
product(4, 9,  litho, lithotrack_fe_95, 13, wafer, 0, 0, su494_3).
product(4, 10, litho, lithotrack_fe_95, 8,  wafer, 0, 0, 0).
product(4, 11, implant, implant_128, 13, wafer, 0, 0, su128_3).
product(4, 12, implant, implant_128, 7,  wafer, 0, 0, su128_1).
product(4, 13, litho, lithotrack_fe_95, 3,  wafer, 0, 0, 0).
product(4, 14, litho, lithotrack_fe_95, 8,  wafer, 0, 0, su494_3).
product(4, 15, implant, implant_128, 4,  wafer, 0, 0, su128_1).
product(4, 16, litho, lithotrack_fe_95, 7,  wafer, 0, 0, 0).
product(4, 17, litho, lithotrack_fe_95, 9, wafer, 0, 0, su450_3).
product(4, 18, litho, lithotrack_fe_95, 6, wafer, 0, 0, 0).
product(4, 19, implant, implant_128, 5,  wafer, 0, 0, su128_3).
product(4, 20, implant, implant_128, 11, wafer, 0, 0, su128_1).

%tool(area_name, tool_grp_name, machine_number, cascading_tool, batching_tool, batch_unit, load_time, unload_time).
tool(implant, implant_128, 1, 1, 60, 60).
tool(implant, implant_128, 2, 1, 60, 60).

tool(litho, lithotrack_fe_95, 1, 1, 60, 60).
tool(litho, lithotrack_fe_95, 2, 1, 60, 60).

%pm(pm_event_name, group_name, pm_type, max, pm_duration, min).
pm(implant_128_mn, implant_128, counter_based, 100, 22, 75).
pm(implant_128_qt, implant_128, counter_based, 125, 30, 125).
pm(lithotrack_fe_95_wk, lithotrack_fe_95, time_based, 50, 23, 15).
pm(lithotrack_fe_95_mn, lithotrack_fe_95, time_based, 55, 25, 10).

setup_change(implant_128,su128_1,20,2).
setup_change(implant_128,su128_2,15,3).
setup_change(implant_128,su128_3,17,2).

setup_change(lithotrack_fe_95,su450_3,13,2).
setup_change(lithotrack_fe_95,su485_3,16,3).
setup_change(lithotrack_fe_95,su494_3,14,2).