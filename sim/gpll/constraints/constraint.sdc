set device "LAV-AT-E30"
set device_int "ap6a160ce"
set package "CBG484"
set package_int "CBG484"
set speed "1"
set speed_int "1"
set operation "Commercial"
set family "LAV-AT"
set architecture "ap6a00b"
set partnumber "LAV-AT-E30-1CBG484C"
set WRAPPER_INST "lscc_pll_inst"
set DEVICE_NAME "LAV-AT-E30"
set VCO_FREQ 4000.000000
set REFCLK_FREQ 50.000000
set REFCLK_SEL 0
set FBKSEL_CLKOUT 0
set EXT_FBK_DELAY 3
set EN_USR_FBKCLK 0
set EN_EXT_CLKDIV 1
set EN_SYNC_CLK0 0
set WAIT_FOR_LOCK 0
set EN_FAST_LOCK 0
set EN_LOCK_DETECT 1
set EN_PLL_RST 1
set EN_CLK0_OUT 1
set EN_CLK1_OUT 0
set EN_CLK2_OUT 0
set EN_CLK3_OUT 0
set EN_CLK4_OUT 0
set EN_CLK5_OUT 0
set EN_CLK6_OUT 0
set EN_CLK7_OUT 0
set EN_CLK0_CLKEN 0
set EN_CLK1_CLKEN 0
set EN_CLK2_CLKEN 0
set EN_CLK3_CLKEN 0
set EN_CLK4_CLKEN 0
set EN_CLK5_CLKEN 0
set EN_CLK6_CLKEN 0
set EN_CLK7_CLKEN 0
set CLK0_BYP 0
set CLK1_BYP 0
set CLK2_BYP 0
set CLK3_BYP 0
set CLK4_BYP 0
set CLK5_BYP 0
set CLK6_BYP 0
set CLK7_BYP 0
set PHASE_SHIFT_TYPE 0
set CLK0_PHI 1
set CLK1_PHI 1
set CLK2_PHI 1
set CLK3_PHI 1
set CLK4_PHI 1
set CLK5_PHI 1
set CLK6_PHI 1
set CLK7_PHI 1
set CLK0_DEL 20
set CLK1_DEL 1
set CLK2_DEL 1
set CLK3_DEL 1
set CLK4_DEL 1
set CLK5_DEL 1
set CLK6_DEL 1
set CLK7_DEL 1
set PLL_SSEN 0
set PLL_DITHEN 0
set PLL_ENSAT 1
set PLL_INTFBK 1
set PLL_CLKR "6'h00"
set PLL_CLKF "26'h0140000"
set PLL_CLKV "26'h0000000"
set PLL_CLKS "12'h000"
set PLL_BWADJ "12'h013"
set PLL_CLKOD0 "11'h013"
set PLL_CLKOD1 "11'h000"
set PLL_CLKOD2 "11'h000"
set PLL_CLKOD3 "11'h000"
set PLL_CLKOD4 "11'h000"
set PLL_CLKOD5 "11'h000"
set PLL_CLKOD6 "11'h000"
set PLL_CLKOD7 "11'h013"
set REG_INTERFACE "None"
set REG_MAPPING 0


### This should be in top level constraint
#set CLK_PERIOD [expr {double(round(1000000/$REFCLK_FREQ))/1000}]
#create_clock -name {clki_i} -period $CLK_PERIOD [get_ports clki_i]



if { $radiant(stage) == "presyn" } {
  set_false_path -to   [get_pins -hierarchical {lscc_pll_inst/gen_ext_outclkdiv.u_pll/RESET}]
} elseif { $radiant(stage) == "premap" } {

  # constraint to force the CLKRES signal to use a local clock
  ldc_set_attribute USE_PRIMARY=FALSE [get_nets lscc_pll_inst/lmmi_clk_w]

  set_false_path -to [get_pins -hierarchical {lscc_pll_inst/u_pll_init_bw/gen_bw_init.u_rst_n_sync/sync_reg*/CD}]
  set_false_path -to [get_pins -hierarchical {lscc_pll_inst/u_pll_init_bw/gen_bw_init.u_lock_sync/sync_reg*/D}]
  set_false_path -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]

  set_max_delay  -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.dly_wait_cntr*/D}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.init_request*/Q}]        -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREQUEST}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.init_request*/Q}]        -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWRRDN}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.wdata*/Q}]               -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWDATA*}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWDATA*}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIOFFSET*}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWRRDN}] -datapath_only 6
  set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREQUEST}] -datapath_only 6

  if { $radiant(synthesis) == "lse" } {
    ldc_set_attribute USE_PRIMARY=FALSE [get_nets lscc_pll_inst/init_clk_i]
  } else {
    ldc_set_attribute USE_PRIMARY=FALSE [get_nets lscc_pll_inst/clkout_testclk_o]
  }


  if { $REG_INTERFACE == "APB" || $REG_INTERFACE == "LMMI"} {
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/Q}]       -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.wdata*/D}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.nf_usr_regval*/Q}]       -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.wdata*/D}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.nf_usr_regval*/SP}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/SP}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.nf_usr_regval*/D}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/D}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/Q}]       -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWDATA*}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.nf_usr_regval*/SP}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/SP}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.nf_usr_regval*/D}] -datapath_only 6
    set_max_delay  -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}]         -to [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.bw_usr_regval*/D}] -datapath_only 6
  }

  if { $REG_INTERFACE == "APB" } {
    if { $radiant(synthesis) == "lse" } {
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*bus_sm_cs*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wr_rdn_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wr_rdn_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_request_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_request_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*bus_sm_cs*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATA*}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATA*}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wdata_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWDATA*}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_request_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREQUEST}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_offset_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIOFFSET*}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wr_rdn_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWRRDN}] -datapath_only 6

      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_request_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_request_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wr_rdn_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*lmmi_wr_rdn_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*bus_sm_cs*/D}] -datapath_only 6
    } else {
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.bus_sm_cs*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wr_rdn_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wr_rdn_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_request_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREADY}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_request_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATAVALID}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.bus_sm_cs*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATA*}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIRDATA*}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wdata_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWDATA*}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_request_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIREQUEST}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_offset_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIOFFSET*}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wr_rdn_o*/Q}] -to [get_pins {lscc_pll_inst/gen_ext_outclkdiv.u_pll.PLLC_MODE_inst/LMMIWRRDN}] -datapath_only 6

      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pready_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_prdata_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_request_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_request_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wr_rdn_o*/SP}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.lmmi_wr_rdn_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.apb_pslverr_o*/D}] -datapath_only 6
      set_max_delay -from [get_pins {lscc_pll_inst/u_pll_init_bw/gen_bw_init.en_usr_lmmi*/Q}] -to [get_pins {lscc_pll_inst/gen_apb.u_apb/*.bus_sm_cs*/D}] -datapath_only 6
    }
  }

}
