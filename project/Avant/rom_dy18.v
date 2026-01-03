// Verilog netlist produced by program LSE 
// Netlist written on Sat Jan  3 19:57:27 2026
// Source file index table: 
// Object locations will have the form @<file_index>(<first_ line>[<left_column>],<last_line>[<right_column>])
// file 0 "/usr/local/lscc/radiant/2025.2/ip/LFMXO4/ram_dp/rtl/lscc_lfmxo4_ram_dp.v"
// file 1 "/usr/local/lscc/radiant/2025.2/ip/LFMXO4/ram_dp_true/rtl/lscc_lfmxo4_ram_dp_true.v"
// file 2 "/usr/local/lscc/radiant/2025.2/ip/LFMXO4/ram_dq/rtl/lscc_lfmxo4_ram_dq.v"
// file 3 "/usr/local/lscc/radiant/2025.2/ip/common/adder/rtl/lscc_adder.v"
// file 4 "/usr/local/lscc/radiant/2025.2/ip/common/adder_subtractor/rtl/lscc_add_sub.v"
// file 5 "/usr/local/lscc/radiant/2025.2/ip/common/complex_mult/rtl/lscc_complex_mult.v"
// file 6 "/usr/local/lscc/radiant/2025.2/ip/common/counter/rtl/lscc_cntr.v"
// file 7 "/usr/local/lscc/radiant/2025.2/ip/common/distributed_dpram/rtl/lscc_distributed_dpram.v"
// file 8 "/usr/local/lscc/radiant/2025.2/ip/common/distributed_rom/rtl/lscc_distributed_rom.v"
// file 9 "/usr/local/lscc/radiant/2025.2/ip/common/distributed_spram/rtl/lscc_distributed_spram.v"
// file 10 "/usr/local/lscc/radiant/2025.2/ip/common/fifo/rtl/lscc_fifo.v"
// file 11 "/usr/local/lscc/radiant/2025.2/ip/common/fifo_dc/rtl/lscc_fifo_dc.v"
// file 12 "/usr/local/lscc/radiant/2025.2/ip/common/mult_accumulate/rtl/lscc_mult_accumulate.v"
// file 13 "/usr/local/lscc/radiant/2025.2/ip/common/mult_add_sub/rtl/lscc_mult_add_sub.v"
// file 14 "/usr/local/lscc/radiant/2025.2/ip/common/mult_add_sub_sum/rtl/lscc_mult_add_sub_sum.v"
// file 15 "/usr/local/lscc/radiant/2025.2/ip/common/multiplier/rtl/lscc_multiplier.v"
// file 16 "/usr/local/lscc/radiant/2025.2/ip/common/ram_dp/rtl/lscc_ram_dp.v"
// file 17 "/usr/local/lscc/radiant/2025.2/ip/common/ram_dp_true/rtl/lscc_ram_dp_true.v"
// file 18 "/usr/local/lscc/radiant/2025.2/ip/common/ram_dq/rtl/lscc_ram_dq.v"
// file 19 "/usr/local/lscc/radiant/2025.2/ip/common/ram_shift_reg/rtl/lscc_shift_register.v"
// file 20 "/usr/local/lscc/radiant/2025.2/ip/common/rom/rtl/lscc_rom.v"
// file 21 "/usr/local/lscc/radiant/2025.2/ip/common/subtractor/rtl/lscc_subtractor.v"
// file 22 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_add.v"
// file 23 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_addsub.v"
// file 24 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_complex_mult.v"
// file 25 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_counter.v"
// file 26 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_distributed_dpram.v"
// file 27 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_distributed_rom.v"
// file 28 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_distributed_shift_reg.v"
// file 29 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_distributed_spram.v"
// file 30 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_fifo.v"
// file 31 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_fifo_dc.v"
// file 32 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_mac.v"
// file 33 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_mult.v"
// file 34 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_multaddsub.v"
// file 35 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_multaddsubsum.v"
// file 36 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_ram_dp.v"
// file 37 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_ram_dp_be.v"
// file 38 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_ram_dp_true.v"
// file 39 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_ram_dq.v"
// file 40 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_ram_dq_be.v"
// file 41 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_rom.v"
// file 42 "/usr/local/lscc/radiant/2025.2/ip/pmi/pmi_sub.v"
// file 43 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/DPR16X4A.v"
// file 44 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/DPR32X2.v"
// file 45 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/SPR16X4A.v"
// file 46 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/SPR32X2.v"
// file 47 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/WIDEFN9.v"
// file 48 "/usr/local/lscc/radiant/2025.2/cae_library/simulation/verilog/applatform/io_specialprim.v"

//
// Verilog Description of module rom_dy18
// module wrapper written out since it is a black-box. 
//

//

module rom_dy18 (rd_clk_i, rst_i, rd_en_i, rd_clk_en_i, rd_addr_i, 
            rd_data_o) /* synthesis ORIG_MODULE_NAME="rom_dy18", LATTICE_IP_GENERATED="1", cpe_box=1 */ ;
    input rd_clk_i;
    input rst_i;
    input rd_en_i;
    input rd_clk_en_i;
    input [11:0]rd_addr_i;
    output [17:0]rd_data_o;
    
    
    
endmodule
