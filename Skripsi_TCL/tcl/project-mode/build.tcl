source tcl/set_variables.tcl

set path_project $dir_origin/$dir_build_project_mode/$dir_project

# Create the project and directory structure
create_project -force $project_name $path_project -part $fpga_part

# Add various sources to the project
add_files [glob "$dir_origin/$dir_rtl/*.v"]
add_files -fileset sim_1 $dir_origin/$dir_tb/$top_level_tb
add_files -fileset constrs_1 "$dir_origin/$dir_xdc/$filename_xdc"
add_files [glob "$dir_origin/ip/*.xci"]

# Generate IP output products
upgrade_ip [get_ips]
generate_target all [get_ips]

# Now import/copy the files into the project
import_files -force

# Update to set top and file compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
update_compile_order -fileset constrs_1


# Launch Synthesis
launch_runs synth_1
wait_on_run synth_1

set path_report $dir_origin/$dir_build_project_mode/$dir_report

if {![file isdirectory $path_report]} {
    file mkdir $path_report
}

open_run synth_1 -name netlist_1

# Generate a timing and power reports and write to disk
# Can create custom reports as required
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose \
-max_paths 10 -input_pins -file $path_report/syn_timing.rpt
report_power -file $path_report/syn_power.rpt

# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# Generate a timing and power reports and write to disk
# comment out the open_run for batch mode
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained \
-check_timing_verbose -max_paths 10 -input_pins -file $path_report/imp_timing.rpt
report_power -file $path_report/imp_power.rpt

set path_bitstream $dir_origin/$dir_build_project_mode/$dir_bitstream
if {![file isdirectory $path_bitstream]} {
    file mkdir $path_bitstream
}

# Generate the bitstream
write_bitstream -force -file "$path_bitstream/$filename_bitstream"

# Close the design
close_design
