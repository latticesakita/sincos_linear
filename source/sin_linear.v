// calculate sin()
// 32bits phase input
//    radian / (2*pi) * (1<<32)
// 32bits Q2.30 output
//    b31: negative
//    b30: real
//    b29-b0: fractional
// sin() value is calculated from the 4096 table / 36bits entry of pi/2 range
// expected accuracy: max error: 1.97e-8, ave error: 8.27e-9, sigma error: 5.42e-9 for 32bits input / 32bits output
// this is more than single precision of floating point accuracy 1.2e-7.

module sin_linear #(
	parameter OUTPUT_WIDTH = 32 // maximum 48
)(
	input clk,
	input resetn,
	input [31:0] phase_i,
	output reg [OUTPUT_WIDTH-1:0] result_o,
	input valid_i,
	output reg valid_o
);

localparam DY_SHIFT = 12; // shift amount when generating dy

// ************************************
// stage 0 : preparation
// ************************************
wire [1:0] s0_quadrant = phase_i[31:30];
wire       s0_valid = valid_i;
wire [11:0] s0_addr = phase_i[30] ? ~phase_i[29:18] : phase_i[29:18];
wire [17:0] s0_frac = phase_i[30] ? ~phase_i[17: 0] : phase_i[17: 0];

// ************************************
// stage 1 : get data from mem
// ************************************
reg [1:0] s1_quadrant;
reg       s1_valid;
reg  [17:0] s1_frac;
wire [35:0] s1_y0;
wire [17:0] s1_dy;

always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		s1_quadrant <= 0;
                s1_valid    <= 0;
		s1_frac     <= 0;
	end
	else begin
		s1_quadrant <= s0_quadrant ;
                s1_valid    <= s0_valid    ;
		s1_frac     <= s0_frac     ;
	end
end

rom_y36   rom_y0_i (.rst_i(~resetn), .rd_clk_i(clk), .rd_clk_en_i(1'b1), .rd_en_i(1'b1), .rd_addr_i(s0_addr), .rd_data_o(s1_y0));
rom_dy18  rom_dy_i (.rst_i(~resetn), .rd_clk_i(clk), .rd_clk_en_i(1'b1), .rd_en_i(1'b1), .rd_addr_i(s0_addr), .rd_data_o(s1_dy));


// ************************************
// stage 2, last stage : linear interpolation
// ************************************
wire [47:0] dsp_Z; // = dy * frac + y0

mult18x18p48 #(
	.ASIGNED	("UNSIGNED"),
	.BSIGNED	("UNSIGNED"),
	//.REGINPUTA	("REGISTERED_ONCE"),
	.REGINPUTB	("REGISTERED_ONCE"),
	//.REGINPUTC	("REGISTERED_ONCE"),
	.REGOUTPUT	("REGISTERED")
) mult18x18p48_i (
	.clk(clk),	.resetn(resetn),
	.A(s1_dy), .B(s1_frac), .C({s1_y0, {DY_SHIFT{1'b0}}}),
	.Z(dsp_Z));

reg s2_valid;
reg s3_valid;
reg [1:0] s2_quadrant;
reg [1:0] s3_quadrant;
always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		valid_o <= 0;
		s2_valid <= 0;
		s3_valid <= 0;
		result_o <= 0;
		s2_quadrant <= 0;
		s3_quadrant <= 0;
	end
	else begin
		s2_quadrant <= s1_quadrant ;
		s3_quadrant <= s2_quadrant ;
		s2_valid   <= s1_valid;
		s3_valid   <= s2_valid;
		valid_o    <= s3_valid;
		result_o <= s3_quadrant[1] ? ~dsp_Z[36+DY_SHIFT-1 :36+DY_SHIFT-OUTPUT_WIDTH] : dsp_Z[36+DY_SHIFT-1 :36+DY_SHIFT-OUTPUT_WIDTH];
	end
end

endmodule

