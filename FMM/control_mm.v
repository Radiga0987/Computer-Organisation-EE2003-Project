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
	output we_rf,
	output [31:0]dmem_addr
);

reg [31:0] addr_bnk [0:6];
reg [31:0] dmem_addr;
reg we_rf;

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
	// A= mxn dim[0:10]xdim[11:20], B=nxo dim[11:20]xdim[21:31]
    always @(inst) begin
		case(inst)
			1: begin
				dmem_addr=addr_bnk[0]+addr_bnk[4]; //load next a
				addr_bnk[4]=addr_bnk[4]+32; // By default address increments to next 8 words
				if(addr_bnk[5]<4*addr_bnk[3][21:31])begin	// If address of b_counter< 4*o  & >0 --> then reset a_counter to beginning of row
					if(addr_bnk[5]!=0)begin
						addr_bnk[4]=addr_bnk[4]-4*addr_bnk[3][11:20];
					end
				end
				we_rf=1;
				end
			2:begin
				dmem_addr=addr_bnk[1]+addr_bnk[5]; //load next b
				addr_bnk[5]=addr_bnk[5]+4*addr_bnk[3][21:31];   	 //IMP-Change
				if(addr_bnk[5]>=4*addr_bnk[3][11:20]*addr_bnk[3][21:31])begin
					if(addr_bnk[5]==4*(addr_bnk[3][11:20]+1)*addr_bnk[3][21:31]-32)begin
						addr_bnk[5]=0;
					end else begin
						addr_bnk[5]=addr_bnk[5]-4*addr_bnk[3][11:20]*addr_bnk[3][21:31]+32;
					end	
				end
				we_rf=1;
				end	
			3:begin
				dmem_addr=addr_bnk[2]+addr_bnk[6]; //store next c
				addr_bnk[6]=addr_bnk[6]+32;
				if(addr_bnk[6]==4*addr_bnk[3][0:10]*addr_bnk[3][21:31])begin
					mm_complete=1;
				end
				we_rf=0;
				end

			4:  
			5:
			6:

			7://for matrix multiply enable
		default:

		endcase

	end

