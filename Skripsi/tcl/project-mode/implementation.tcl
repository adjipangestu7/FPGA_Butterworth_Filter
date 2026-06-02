
source tcl/set_variables.tcl

set path_project $dir_origin/$dir_build_project_mode/$dir_project
set path_report $dir_origin/$dir_build_project_mode/$dir_report

# Open project
open_project $path_project/${project_name}.xpr

if {![file isdirectory $path_report]} {
    file mkdir $path_report
}

# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# Generate a timing and power reports and write to disk
# comment out the open_run for batch mode
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained \
-check_timing_verbose -max_paths 10 -input_pins -file $path_report/imp_timing.rpt
report_power -file $path_report/imp_power.rpt

# Close the design
close_design
