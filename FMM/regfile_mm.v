module regfile_mm (	 input [1:0] rd_rf,      // write address in regfile
					 input we_rf,            // write enable
					 input clk,           // clock
					 input reset,         // reset
					 input stc,				// Used to flush c in regfile everytime we store it in dmem
					 input [255:0] wdata_mm,  // write data from dmem and matrix_ops 
					 output [255:0] a,    // 8 words of a to be sent to matrix_ops.v
				     output [255:0] b,    // 8 words of b to be sent to matrix_ops.v
				     output [255:0] c     // 8 words of c be sent to matrix_ops.v
);
	
	reg [255:0] regs [0:2];

    // initialising registers to 0
    integer i;
    initial begin
		for (i=0;i<3;i=i+1)
			regs[i] = 256'b0;
    end	
	
    always @(posedge clk) begin
		if (reset)  begin	//All registers set to 0 if reset=1
			for (i=0;i<3;i=i+1)
				regs[i] <= 256'b0;
		end
		else begin
			if (we_rf == 1'b1) begin  // if write enable is 1 then write
				regs[rd_rf] <= wdata_mm;
			end
			if (stc) regs[2] <= 0;
		end
    end
	
	//Assigning outputs a, b and c appropriately
	assign a = regs[0];
	assign b = regs[1];
	assign c = regs[2];

endmodule