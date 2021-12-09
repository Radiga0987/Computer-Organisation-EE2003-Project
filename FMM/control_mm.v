//Module for all control signals of the accelerator
module control_mm(   
	input [2:0]inst,
	input reset,
	input [255:0]dim,
	input dim_we,		//Comes from cpu_mm
	output [31:0]dimensions;
	output [31:0]dmem_addr
);

reg [31:0] addr_bnk [0:6];
reg [31:0] dimensions;
reg [31:0] dmem_addr;

// initialising registers to 0
    integer i;
    initial begin
		for (i=3;i<7;i=i+1)
			addr_bnk[i] = 32'b0;
		addr_bnk[0] = 32'h0000_0000;		//0
		addr_bnk[1] = 32'h0000_0500;		//1280
		addr_bnk[2] = 32'h0000_0A00;		//2560
		dimensions = 0;
    end	

	always @(reset or dim_we or dim) begin
		if (reset)  //All registers set to 0 if reset=1
			for (i=3;i<7;i=i+1)
				addr_bnk[i] <= 32'b0;
			dimensions <= 0;
		else begin
			if (dim_we == 1'b1) begin  // if write enable is 1 then write
				addr_bnk[3] = dim[31:0];
				dimensions = dim[31:0];
			end
		end
	end
	// A= mxn dim[10:0]xdim[21:11], B=nxo dim[21:11]xdim[31:22]
    always @(inst) begin
		case(inst)
			0: dmem_addr=//const value for dim_addr
			
			1: begin
				dmem_addr=addr_bnk[0]+addr_bnk[4]; //load next a
				addr_bnk[4]=addr_bnk[4]+32; // By default address increments to next 8 words
				if(addr_bnk[5]<4*addr_bnk[3][31:22])begin	// If address of b_counter< 4*o  & >0 --> then reset a_counter to beginning of row
					if(addr_bnk[5]!=0)begin
						addr_bnk[4]=addr_bnk[4]-4*addr_bnk[3][21:11];
					end
				end
				end
			2:begin
				dmem_addr=addr_bnk[1]+addr_bnk[5]; //load next b
				addr_bnk[5]=addr_bnk[5]+4*addr_bnk[3][31:22];   	 //IMP-Change
				if(addr_bnk[5]>=4*addr_bnk[3][21:11]*addr_bnk[3][31:22])begin
					if(addr_bnk[5]==4*(addr_bnk[3][21:11]+1)*addr_bnk[3][31:22]-32)begin
						addr_bnk[5]=0;
					end else begin
						addr_bnk[5]=addr_bnk[5]-4*addr_bnk[3][21:11]*addr_bnk[3][31:22]+32;
					end	
				end
				end	
			3:begin
				dmem_addr=addr_bnk[2]+addr_bnk[6]; //store next c
				addr_bnk[6]=addr_bnk[6]+32;
				if(addr_bnk[6]==4*addr_bnk[3][10:0]*addr_bnk[3][31:22])begin
					mm_complete=1;
				end
				end

			4:  //for matrix multiply enable

		default:dmem_addr=//const value for dim_addr

		endcase

	end

