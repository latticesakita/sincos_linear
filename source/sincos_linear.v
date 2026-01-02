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


