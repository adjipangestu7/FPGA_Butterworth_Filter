source tcl/set_variables.tcl

#Step 1: Reading RTL
set_part $fpga_part
read_verilog [glob "$dir_origin/$dir_rtl/*.v"]
read_ip [glob "$dir_origin/ip/*/*.xci"]

# Generate IP output products
upgrade_ip [get_ips]
generate_target all [get_ips]
synth_ip [get_ips]

if {![file isdirectory $dir_build_non_project_mode]} {
    file mkdir $dir_build_non_project_mode
}

set path_report $dir_origin/$dir_build_non_project_mode/$dir_report
if {![file isdirectory $path_report]} {
    file mkdir $path_report
}

set path_bitstream $dir_origin/$dir_build_non_project_mode/$dir_bitstream
if {![file isdirectory $path_bitstream]} {
    file mkdir $path_bitstream
}

#Running Synthesis
read_xdc "$dir_origin/$dir_xdc/$filename_xdc"
synth_design -top $top_level
write_checkpoint -force $dir_build_non_project_mode/post_synth.dcp
report_timing_summary -file $path_report/timing_syn.rpt


#Running Implementation
opt_design
place_design
write_checkpoint -force $dir_build_non_project_mode/post_place.dcp
report_timing -file $path_report/timing_place.rpt
phys_opt_design
route_design
write_checkpoint -force $dir_build_non_project_mode/post_route.dcp
report_timing_summary -file $path_report/timing_summary
report_utilization -file "$path_report/utilization_impl.rpt"
report_power -file "$path_report/power_impl.rpt"
report_clock_utilization -file "$path_report/clock_utilization.rpt"
write_bitstream -force $path_bitstream/$filename_bitstream