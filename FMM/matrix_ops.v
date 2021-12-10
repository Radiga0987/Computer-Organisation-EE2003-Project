//Module for matrix operations.
module matrix_ops(  
	input mm_en,	// enable for the module to run
	input [5:0] mm_op, // operational code to select operation
	input [255:0] a,	// input 8 words of a
	input [255:0] b,	// input 8 words of b
	input [255:0] cin,	// input 8 words of c stored as an accumulator
	output [255:0] co // output value calculated to be stored in accumulator
);
	reg [255:0] co;
	always @(mm_op, a, b, cin, mm_en) begin
		if (mm_en) begin		// If enable is 1, execute
			case(mm_op)
				1: co=a[31:0]*b + cin;  			
					
				2: co=a[63:32]*b + cin;
				
				3: co=a[95:64]*b + cin;
					
				4: co=a[127:96]*b + cin;
					
				5: co=a[159:128]*b + cin;
					
				6: co=a[191:160]*b + cin;
					
				7: co=a[223:192]*b + cin;
				
				8: co=a[255:224]*b + cin;
							
				default: co=cin;
			endcase
		end
		else co=cin; // else give back the same input 
    end
endmodule				