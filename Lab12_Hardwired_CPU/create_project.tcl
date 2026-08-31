# Vivado Tcl Console 中执行：source create_project.tcl
set proj_name exp12_hardwired_cpu
set proj_dir  [file normalize ./vivado_project]
create_project $proj_name $proj_dir -part xc7a100tcsg324-2L -force

add_files [glob ./rtl/*.v]
add_files -fileset sim_1 ./sim/tb_hardwired_cpu.v
add_files -fileset constrs_1 ./constraints/hcs_a02_exp12.xdc

set_property top board_top [current_fileset]
set_property top tb_hardwired_cpu [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Project created at: $proj_dir"
puts "Synthesis top: board_top"
puts "Simulation top: tb_hardwired_cpu"
