
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name DSDProject -dir "E:/6th Semester/DSD/DSD Lab/DSDProject/planAhead_run_1" -part xc7a100tcsg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "stopwatchuptoseconds.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {stopwatchuptoseconds.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top stopwatchuptoseconds $srcset
add_files [list {stopwatchuptoseconds.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc7a100tcsg324-3
