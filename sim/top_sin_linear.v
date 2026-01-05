// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED 
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement. 
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02 
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------

// Fmax test module

module top_sin_linear
#(
	parameter OUTPUT_WIDTH = 32 // maximum 48
)
(
	input        clk50,
	input [31:0] phase_i,
	output [OUTPUT_WIDTH-1:0] result_o,
	input valid_i,
	output valid_o
);

wire resetn;
wire clk;

gpll gpll_i (
	.clki_i	(clk50),
	.rstn_i	(1'b1),
	.lock_o	(resetn),
	.clkop_o	(clk)
);


// 4 clocks
reg [31:0] phase_0;
reg [31:0] phase_1;
reg [31:0] phase_2;
reg [31:0] phase_3;
reg  valid_i_0;
reg  valid_i_1;
reg  valid_i_2;
reg  valid_i_3;

// 4 clocks
wire [OUTPUT_WIDTH-1:0] result_0;
reg [OUTPUT_WIDTH-1:0] result_1;
reg [OUTPUT_WIDTH-1:0] result_2;
reg [OUTPUT_WIDTH-1:0] result_3;
wire valid_o_0;
reg  valid_o_1;
reg  valid_o_2;
reg  valid_o_3;
assign valid_o = valid_o_3;
assign result_o = result_3;

always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		phase_0   <= 0;
		phase_1   <= 0;
		phase_2   <= 0;
		phase_3   <= 0;
		valid_i_0 <= 0;
		valid_i_1 <= 0;
		valid_i_2 <= 0;
		valid_i_3 <= 0;
		result_1 <= 0;
		result_2 <= 0;
		result_3 <= 0;
		valid_o_1 <= 0;
		valid_o_2 <= 0;
		valid_o_3 <= 0;
	end
	else begin
		phase_0 <= phase_i;
		phase_1 <= phase_0;
		phase_2 <= phase_1;
		phase_3 <= phase_2;
		valid_i_0 <= valid_i;
		valid_i_1 <= valid_i_0;
		valid_i_2 <= valid_i_1;
		valid_i_3 <= valid_i_2;
		result_1 <= result_0;
		result_2 <= result_1;
		result_3 <= result_2;
		valid_o_1 <= valid_o_0;
		valid_o_2 <= valid_o_1;
		valid_o_3 <= valid_o_2;
	end
end


sincos_linear #(.OUTPUT_WIDTH(OUTPUT_WIDTH)) dut (
	.clk	(clk),
	.resetn	(resetn),
	.mode_cos	(1'b0),
	.phase_i	(phase_3),
	.result_o	(result_0),
	.valid_i	(valid_i_3),
	.valid_o	(valid_o_0)
);

endmodule


