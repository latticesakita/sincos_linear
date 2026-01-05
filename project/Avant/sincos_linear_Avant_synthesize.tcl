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
# synthesize top design
::radiant::runengine::run_postsyn [list -a LAV-AT -p LAV-AT-E30 -t CBG484 -sp 3 -oc Commercial -top -ipsdc ipsdclist.txt -w -o sincos_linear_Avant_syn.udb sincos_linear_Avant.vm] [list sincos_linear_Avant.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
