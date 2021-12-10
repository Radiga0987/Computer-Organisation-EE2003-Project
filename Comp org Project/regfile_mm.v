module regfile_mm (	 input [1:0] rd_rf,      // write address 
					 input we_rf,            // write enable
					 input clk,           // clock
					 input reset,         // reset
					 input [255:0] wdata_mm,  // write data
					 output [255:0] a,    // input A
				     output [255:0] b,    // input B
				     output [255:0] c     // input C
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
			
		end
    end
	
	//Assigning outputs a,b,c appropriately
	assign a = regs[0];
	assign b = regs[1];
	assign c = regs[2];

endmodule