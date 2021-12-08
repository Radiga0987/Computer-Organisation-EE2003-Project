module cpu_mm(       
	input clk,
    input reset,
    input addr_we_i, // write enable from control.v
    //output addr_we_o,   // write enable to control_mm.v (delaying clk cycle)
    input [31:0]dim_addr,
    output [5:0]opcode
);
    reg [255:0] a_addr,b_addr,c_addr;
    reg [31:0] dim_addr_mem;
    integer i;
    initial begin
			dim_addr_mem = 32'b0;
    end	

	always @(posedge clk) begin
		if (reset)  //All registers set to 0 if reset=1
			dim_addr_mem <= 32'b0;
		else begin
			if (addr_we_i == 1'b1) begin  // if write enable is 1 then write
				dim_addr_mem <= dim_addr;
			end
		end
	end