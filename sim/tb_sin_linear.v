
`timescale 1ns/1ps

module tb_sin_linear;
parameter TEST_BITS = 16;

GSRA GSR_INST  (.GSR_N(1'b1));

  reg clk = 1'b0;
  wire rst_n;
  reg [3:0] rst_cnt = 3'b001;
  assign rst_n = rst_cnt[3];
  always #5 clk = ~clk;
  always @(posedge clk) if(!rst_n) rst_cnt<=rst_cnt <<< 1;

  reg                  valid_in;
  reg  [31: 0]         phase;
  wire                 valid_out;
  wire [31:0]    y_out;

  sin_linear dut (
    .clk(clk), .resetn(rst_n),
    .valid_i(valid_in),
    .phase_i(phase),
    .valid_o(valid_out),
    .result_o(y_out)
  );

  reg [31:0] idx;


// FIFO to align inputs with outputs regardless of DUT latency
localparam integer FIFO_DEPTH = 16;
reg [31:0] fifo_phase  [0:FIFO_DEPTH-1];
reg [31:0] fifo_idx    [0:FIFO_DEPTH-1];
reg [3:0] fifo_waddr;
reg [3:0] fifo_raddr;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		fifo_waddr <= 0;
	end
	else if(valid_in) begin
		fifo_phase[fifo_waddr] <= phase;
		fifo_idx  [fifo_waddr] <= idx;
		fifo_waddr <= fifo_waddr + 1;
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		fifo_raddr <= 0;
	end
	else if(valid_out) begin
		fifo_raddr <= fifo_raddr + 1;
	end
end


  integer fd;
  initial begin
    fd = $fopen("sim_full_output.csv", "w");
    if (fd == 0) begin $display("ERROR: cannot open CSV"); $finish; end
    $fwrite(fd, "idx,phase_hex,y_out_hex\n");
  end
  reg valid_out_d;
  always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		idx <= 0;
		valid_in <= 0;
		phase <= 0;
		valid_out_d <= 0;
    		$display("TB done. CSV=sim_full_output.csv");
	end
	else if(valid_out_d & (~valid_out)) begin
    		$fclose(fd);
		valid_in <= 0;
		$stop;
	end
	else begin
		idx <= idx + 1;
		valid_in <= ~(&phase[31: 32-TEST_BITS]);
		valid_out_d <= valid_out;
		phase[31: 32-TEST_BITS] <= phase[31: 32-TEST_BITS] + 1;
      		if (valid_out) begin
      		  $fwrite(fd, "%0d,%0h,%0h\n", fifo_idx[fifo_raddr], fifo_phase[fifo_raddr] , y_out);
      		end
	end
  end

endmodule

