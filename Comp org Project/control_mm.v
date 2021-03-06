//Module for all control signals of the accelerator
module control_mm(   
    input [2:0]inst,    // Matrix Mul operation code
	input reset,        // Reset
	input [255:0]dim,	// Load of Dimensions of A and B 
	input dim_we,		// Comes from cpu_mm
	output mm_en,		// Enable for matrix Multiplication
	output [31:0]dimensions,	// Storing dimensions of A and B
    output [31:0]dmem_addr,		// Address to dmem for loading A,B and storing C
    output mm_complete		// Flag for completion of Matrix multiplication 
);

reg mm_en, mm_complete;
reg [31:0] addr_bnk [0:6];		// Storing initial address vals and the increment for new addresses
reg [31:0] dimensions;
reg [31:0] dmem_addr;
    

// initialising registers to 0
    integer i;
    initial begin
		for (i=3;i<7;i=i+1)
			addr_bnk[i] = 32'b0;
		addr_bnk[0] = 32'h0000_0000;		//0
		addr_bnk[1] = 32'h0000_1400;		//5120
		addr_bnk[2] = 32'h0000_2800;		//10240
		dimensions = 0;
    end	

	// Reset of Address bank
	always @(reset or dim_we or dim) begin
        if (reset) begin // All registers set to 0 if reset=1
			for (i=3;i<7;i=i+1)
				addr_bnk[i] = 32'b0;
			dimensions = 0;
        end
		else begin
			if (dim_we == 1'b1) begin  // If write enable is 1 then write
				addr_bnk[3] = dim[31:0];
				dimensions = dim[31:0];
			end
		end
	end

	// addr_bank[4] - a_counter, addr_bank[5] - b_counter, addr_bank[6] - c_counter  - counters to update address as per given instruction
	// Decoding inst for the operation to be performed
	// Legend => A= mxn dim[10:0]xdim[21:11], B=nxo dim[21:11]xdim[31:22]

    always @(inst) begin
		mm_en = 0;		// Enable for matrix multiplication unit
		case(inst)
			0: dmem_addr=32'h0000_3C00;	// Const value for dim_addr = 15360
			
			1: begin             							// Computing Address of element of A
                if(addr_bnk[5]<4*addr_bnk[3][31:22])begin	// If address of b_counter< 4*o  & >0 --> then reset a_counter to beginning of the same row of A
					if(addr_bnk[5]!=0)begin				 	// If address of b_counter == 0 ---> by default a_counter points to beginning of next row of A
						addr_bnk[4]=addr_bnk[4]-4*addr_bnk[3][21:11];
					end
				end
				dmem_addr=addr_bnk[0]+addr_bnk[4]; // Address of A to be loaded 
				addr_bnk[4]=addr_bnk[4]+32; // By default address increments to next 8 words
				
				end

			2:begin										// Computing Address of element of B
				dmem_addr=addr_bnk[1]+addr_bnk[5]; 		// Address of A to be loaded 
				addr_bnk[5]=addr_bnk[5]+4*addr_bnk[3][31:22];   	 // By default address increments to next row of B, to the element immediately below the previous element
				if(addr_bnk[5]>=4*addr_bnk[3][21:11]*addr_bnk[3][31:22])begin 	// If b_counter goes over all rows for a given 8 word block column
					if(addr_bnk[5]==4*(addr_bnk[3][21:11]+1)*addr_bnk[3][31:22]-32)begin	// If all elements of B were loaded already in previous cycles 
						addr_bnk[5]=0;		// Point b_counter to inital address - repeat load B process
					end else begin
						addr_bnk[5]=addr_bnk[5]-4*addr_bnk[3][21:11]*addr_bnk[3][31:22]+32; // Else point to the inital row of next 8 word block column of B
					end	
				end
				end	

			3:begin									// Computing Address for storing element of C in stall cycle
				dmem_addr=addr_bnk[2]+addr_bnk[6]; 	// Address of C to be stored 
				addr_bnk[6]=addr_bnk[6]+32;			// By default address increments to next 8 words
				if(addr_bnk[6]==4*addr_bnk[3][10:0]*addr_bnk[3][31:22])begin // When all of C is stored ---> matrix multiplication is complete 
					mm_complete=1;
				end
				end

			4:  mm_en = 1;		//Enable set for matrix multiplication
			5: dmem_addr = addr_bnk[2]+addr_bnk[6]; //For store C
		default:dmem_addr=0; //const value for dim_addr
		endcase
	end
endmodule

