#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology LAV-AT
set_option -part LAV_AT_E30ES
set_option -package CBG484C
set_option -speed_grade -1
#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog standard option
set_option -vlog_std v2001

#map options
set_option -frequency 200
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0


set_option -default_enum_encoding default

#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 0
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


set_option -rw_check_on_ram 0
set_option -seqshift_no_replicate 0
set_option -automatic_compile_point 1

#-- set any command lines input by customer

set_option -dup false
set_option -disable_io_insertion false
add_file -constraint {/usr/local/lscc/radiant/2025.2/scripts/tcl/flow/radiant_synplify_vars.tcl}
add_file -constraint {sincos_linear_Avant_cpe.ldc}
add_file -verilog {/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_lav-at.v}
add_file -vhdl -lib pmi {/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_lav-at.vhd}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/mult18x18p48.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/sincos_linear.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/sin_linear.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/top_sin_linear.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/rom_y36/rtl/rom_y36.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/rom_dy18/rtl/rom_dy18.v}
add_file -verilog -vlog_std v2001 {/home/kanmei/src/sincos_linear/source/gpll/rtl/gpll.v}
#-- top module name
set_option -top_module top_sin_linear
set_option -include_path {/home/kanmei/src/sincos_linear/project}
set_option -include_path {/home/kanmei/src/sincos_linear/source/gpll}
set_option -include_path {/home/kanmei/src/sincos_linear/source/rom_dy18}
set_option -include_path {/home/kanmei/src/sincos_linear/source/rom_y36}

#-- set result format/file last
project -result_format "vm"
project -result_file "./sincos_linear_Avant.vm"

#-- error message log file
project -log_file {sincos_linear_Avant.srf}

project -run -clean
