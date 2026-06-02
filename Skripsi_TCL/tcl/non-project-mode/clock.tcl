source tcl/set_variables.tcl

# Set directory
if {![file isdirectory $dir_ip]} {
    file mkdir $dir_ip
}
set dir_ip "$dir_origin/ip"

# Temporary project folder
set ip_project_dir "$dir_ip/ip_project"

# Create temporary project
create_project -force ip_project \
$ip_project_dir \
-part $fpga_part

# Create Clock Wizard IP
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name $clk_module_name -dir $dir_ip -force

# Configure Clock Wizard
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ $clk_in_freq \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ $clk_out1_freq \
    CONFIG.RESET_TYPE {ACTIVE_HIGH} \
    CONFIG.USE_LOCKED {true} \
] [get_ips $clk_module_name]

# Generate outputs
generate_target all [get_ips $clk_module_name]

# Synthesize IP
#create_ip_run [get_ips $clk_module_name]
synth_ip [get_ips $clk_module_name]
#wait_on_run ${clk_module_name}

puts "Clock Wizard Generated Successfully"