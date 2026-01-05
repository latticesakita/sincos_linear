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

// this is wrapping module

module sincos_linear
#(
	parameter OUTPUT_WIDTH = 32 // maximum 48
)
(
	input clk,
	input resetn,
	input mode_cos,
	input [31:0] phase_i,
	input        valid_i,
	output [OUTPUT_WIDTH-1:0] result_o,
	output        valid_o
);

// cos(x) = sin(x+pi/2)
// this is phase input, upper 2 bits are quadrant.
wire [31:0] phase;
assign phase[31:30] = phase_i[31:30] + {1'b0,mode_cos};
assign phase[29: 0] = phase_i[29: 0];


sin_linear sin_linear_i (
	.clk		(clk),
	.resetn		(resetn),
	.phase_i	(phase),
	.result_o	(result_o),
	.valid_i	(valid_i),
	.valid_o	(valid_o)
);

endmodule


