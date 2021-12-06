module regfile_mm (	 input [1:0] rd_mm,      // write address 
					 input we_mm,            // write enable
					 input clk,           // clock
					 input reset,         // reset
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
		if (reset)  //All registers set to 0 if reset=1
			for (i=0;i<3;i=i+1)
				regs[i] <= 256'b0;
		else begin
			if (we_mm == 1'b1) begin  // if write enable is 1 then write
				regs[rd_mm] <= wdata_mm;
			end
		end
    end
	//Assigning outputs r1 and r2 appropriately
	assign a = regs[0];
	assign b = regs[1];
	assign c = regs[2];