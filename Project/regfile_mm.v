module regfile_mm (	 input [1:0] rd_rf,      // write address 
					 input we_rf,            // write enable
					 input clk,           // clock
					 input reset,         // reset
					 input stc,				//FLush C
					 input [255:0] wdata_mm,  // write data
					 output [255:0] a,    // First address read value
				     output [255:0] b,    // Second address read value
				     output [255:0] c     //
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
	
	//Assigning outputs r1 and r2 appropriately
	assign a = regs[0];
	assign b = regs[1];
	assign c = regs[2];

endmodule