//Module for matrix operations.
module matrix_ops(  
	input [5:0] mm_op,
	input [255:0] a,
	input [255:0] b,
	input [255:0] cin,
	output [255:0] co
);
	reg [255:0] co;
	always @(mm_op, a, b) begin
		case(mm_op)
			0: co=a[31:0]*b + cin;
				
			1: co=a[63:32]*b + cin;
			
			2: co=a[95:64]*b + cin;
				   
			3: co=a[127:96]*b + cin;
				   
			4: co=a[159:128]*b + cin;
				   
			5: co=a[191:160]*b + cin;
				   
			6: co=a[223:192]*b + cin;
			
			7: co=a[255:224]*b + cin;
			
			8:
			default: co=cin;
		  endcase
		end
endmodule				