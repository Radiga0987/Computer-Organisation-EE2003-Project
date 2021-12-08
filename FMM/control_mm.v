//Module for all control signals of the accelerator
module control_mm(   
	input clk,    
	input [2:0]inst,
	input reset,
	input [31:0]a1_addr,
	input [31:0]b1_addr,
	input [31:0]c1_addr,
	input [31:0]dim,
	input we,
	output [31:0]dmem_addr
);

reg [31:0] addr_bnk [0:6];
reg [31:0] a_addr,b_addr,c_addr;

// initialising registers to 0
    integer i;
    initial begin
		for (i=0;i<7;i=i+1)
			addr_bnk[i] = 32'b0;
    end	

	always @(posedge clk) begin
		if (reset)  //All registers set to 0 if reset=1
			for (i=0;i<7;i=i+1)
				addr_bnk[i] <= 32'b0;
		else begin
			if (we == 1'b1) begin  // if write enable is 1 then write
				addr_bnk[0] <= a1_addr;
				addr_bnk[1] <= b1_addr;
				addr_bnk[2] <= c1_addr;
				addr_bnk[3] <= dim;
			end
		end
	end

    always @(inst) begin
		case(inst)
			1: begin
				dmem_addr=addr_bnk[0]+addr_bnk[4]; //load next a
				addr_bnk[4]=addr_bnk[4]+32;
				end
			2:begin
				dmem_addr=addr_bnk[1]+addr_bnk[5]; //load next b
				if (addr_bnk[5]-addr_bnk[1]>= dim[10:20]
				addr_bnk[5]=addr_bnk[5]+32;   	   //IMP-Change
				end	
			3:begin
				dmem_addr=addr_bnk[2]+addr_bnk[6]; //store next c
				addr_bnk[6]=addr_bnk[6]+32;
				end

			4:  
			5:
			6:

			7://for matrix multiply enable
		default:

		endcase

	end

