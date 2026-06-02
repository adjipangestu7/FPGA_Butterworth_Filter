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
generate_target all [get_ips]

# Now import/copy the files into the project
import_files -force

# Update to set top and file compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
update_compile_order -fileset constrs_1


