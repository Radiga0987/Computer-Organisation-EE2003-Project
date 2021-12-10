//Module for matrix operations.
module matrix_ops(  
	input mm_en,			// Enable for matrix multiply
	input [5:0] mm_op,		// Operational code to decipher which element of A to be used
	input [255:0] a,		// 8 elements of a row of A
	input [255:0] b,		// 8 elements of a row of B
	input [255:0] cin,		// Input 8 elements of C stored in an accumulator
	output [255:0] co		// Output value calculated to be stored in the accumulator
);
	reg [255:0] co;

    always @(mm_op,a,b,mm_en) begin
		if (mm_en) begin
			case(mm_op)			// If enable is 1, execute
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
		else co=cin;		// else give back the same input 
    end
endmodule				