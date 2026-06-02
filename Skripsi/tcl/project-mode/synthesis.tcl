
source tcl/set_variables.tcl

set path_project $dir_origin/$dir_build_project_mode/$dir_project
set path_report $dir_origin/$dir_build_project_mode/$dir_report
# Open project
open_project $path_project/${project_name}.xpr

# Launch Synthesis
launch_runs synth_1
wait_on_run synth_1

if {![file isdirectory $path_report]} {
    file mkdir $path_report
}

open_run synth_1 -name netlist_1

# Generate a timing and power reports and write to disk
# Can create custom reports as required
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose \
-max_paths 10 -input_pins -file $path_report/syn_timing.rpt
report_power -file $path_report/syn_power.rpt

# Close the design
close_design

