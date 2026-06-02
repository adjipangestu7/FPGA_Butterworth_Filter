
source tcl/set_variables.tcl

set path_project $dir_origin/$dir_build_project_mode/$dir_project
set path_bitstream $dir_origin/$dir_build_project_mode/$dir_bitstream

# Open project
open_project $path_project/${project_name}.xpr

open_run impl_1

if {![file isdirectory $path_bitstream]} {
    file mkdir $path_bitstream
}

# Generate the bitstream
write_bitstream -force -file "$path_bitstream/$filename_bitstream"

# Close the design
close_design

