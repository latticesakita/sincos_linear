if {[catch {

# define run engine funtion
source [file join {/usr/local/lscc/radiant/2025.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "/home/kanmei/src/sincos_linear/project"
if {![file exists {/home/kanmei/src/sincos_linear/project/Avant}]} {
  file mkdir {/home/kanmei/src/sincos_linear/project/Avant}
}
cd {/home/kanmei/src/sincos_linear/project/Avant}
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- sincos_linear_Avant_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn synpro -f "sincos_linear_Avant.cprj" "rom_y36.cprj" "rom_dy18.cprj" "gpll.cprj" -a "LAV-AT"  -o sincos_linear_Avant_cpe.ldc
# synthesize top design
file delete -force -- sincos_linear_Avant.vm sincos_linear_Avant.ldc
if {[file normalize "/home/kanmei/src/sincos_linear/project/Avant/sincos_linear_Avant_synplify.tcl"] != [file normalize "./sincos_linear_Avant_synplify.tcl"]} {
  file copy -force "/home/kanmei/src/sincos_linear/project/Avant/sincos_linear_Avant_synplify.tcl" "./sincos_linear_Avant_synplify.tcl"
}
if {[ catch {::radiant::runengine::run_engine synpwrap -prj "sincos_linear_Avant_synplify.tcl" -log "sincos_linear_Avant.srf"} result options ]} {
    file delete -force -- sincos_linear_Avant.vm sincos_linear_Avant.ldc
    return -options $options $result
}
::radiant::runengine::run_postsyn [list -a LAV-AT -p LAV-AT-E30ES -t CBG484 -sp 1 -oc Commercial -top -ipsdc ipsdclist.txt -w -o sincos_linear_Avant_syn.udb sincos_linear_Avant.vm] [list sincos_linear_Avant.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
