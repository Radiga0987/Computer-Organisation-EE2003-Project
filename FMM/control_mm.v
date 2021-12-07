//Module for all control signals of the accelerator
module control_mm(       
	input inst,
	input reset,
	input [31:0]a1_addr,
	input [31:0]b1_addr,
	input [31:0]c1_addr,
	input [31:0]dim_addr,
	input we,
	output [31:0]a_addr,
	output [31:0]b_addr,
	output [31:0]c_addr
);

reg [31:0] address_bank [0:3];
reg [31:0] a_addr,b_addr,c_addr;

// initialising registers to 0
    integer i;
    initial begin
		for (i=0;i<4;i=i+1)
			address_bank[i] = 32'b0;
    end	

	always @(posedge clk) begin
		if (reset)  //All registers set to 0 if reset=1
			for (i=0;i<4;i=i+1)
				address_bank[i] <= 32'b0;
		else begin
			if (we == 1'b1) begin  // if write enable is 1 then write
				address_bank[0] <= a1_addr;
				address_bank[1] <= b1_addr;
				address_bank[2] <= c1_addr;
				address_bank[3] <= dim_addr;
			end
		end
	end