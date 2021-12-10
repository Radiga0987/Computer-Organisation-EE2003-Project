module cpu_mm(       
	input clk,				//clk
    input reset,			//reset
	input operation_en,		// Enable for accelerator to do its job
    input [255:0] mm_drdata,	//Load values of matrices A and B from Dmem
	output active,				//active = 0 => module disabled, = 1 => module enabled
	output [255:0] mm_dwdata,	//Store values of matric C to Dmem
    output mm_dwe,			//Dmem write enable
	output [31:0] mm_daddr	//Dmem address

);
	wire mm_en;
    wire [31:0] dmem_addr;
	wire [255:0] a,b,c,co;
    reg active, dim_we, we_rf, stc,mm_dwe; 
	wire [31:0] dimensions;		//route from control_mm - addr_bnk[3]
    wire mm_complete;
	reg [12:0] counter;
    reg [5:0] mm_opcounter;	
	reg [2:0] inst;				//Sent to control_mm as inst
	reg [1:0] rd_rf;
    reg [255:0] rf_wdata,mm_dwdata;

	//Instantiation of Modules
	control_mm cntr_mm(
		.inst(inst),
		.mm_en(mm_en),
		.reset(reset),
		.dim(mm_drdata),
		.dim_we(dim_we),
        .mm_complete(mm_complete),
		.dimensions(dimensions),
		.dmem_addr(dmem_addr)
	);

	regfile_mm rf_mm(
		.rd_rf(rd_rf),
		.we_rf(we_rf),
		.clk(clk),
		.reset(reset),
		.wdata_mm(rf_wdata),
		.stc(stc),
		.a(a),
		.b(b),
		.c(c)
	);

	matrix_ops mm_ops(
		.mm_en(mm_en),
		.mm_op(mm_opcounter),
		.a(a),
		.b(b),
		.cin(c),
		.co(co)
	);

	

	assign mm_daddr = dmem_addr;

	//Initialise to default values
	initial begin
		inst=5;
		counter=0;
		mm_opcounter=0;
		stc = 0;
		mm_dwdata = 0;
		mm_dwe = 0;
        active = 0;
    end	

    always @(posedge clk) begin
        if (operation_en == 1) active <= 1;
        else if (mm_complete == 1) active <= 0;
		//else if (reset) active = 0;
	end

	always @(posedge clk) begin
		if (active == 0)  begin		//Module inactive
			inst <= 5;
			counter <= 0;
			mm_opcounter <= 0;
			stc <= 0;
			rd_rf <=0;
			we_rf <=0;
			dim_we <=0;
			mm_dwdata <= 0;
			mm_dwe <= 0;
		end
		else begin
			if (counter == 0) begin		//Reading the dimension of matrix A and B
				inst<=0;
				dim_we<=1;
				stc <= 0;
				rd_rf <=0;	
				we_rf <=0;
				mm_dwdata <= 0;
				mm_dwe <= 0;
				counter <= counter+1;
			end
            else if (counter == 17*dimensions[21:11]/8+1) begin		//STORE C
				inst <= 3;
				counter <= counter+1;
				we_rf <= 0;
				dim_we <=0;
				stc <= 0;
				rd_rf <=0;
				mm_dwdata <= 0;
				mm_dwe <= 0;
			end
            else if (counter == 17*dimensions[21:11]/8+2) begin		//Flushing regfile to compute next 8 elements of C
                inst <= 5;
				counter <= 1;
				we_rf <= 1;
				dim_we <=0;
				stc <= 1;
				rd_rf <=2;
				mm_dwdata <= c;
				mm_dwe <= 1;
            end
            else if ((counter % 17) == 1) begin 	//Load 8 elements of matrix A
				inst<=1;	
				we_rf <=1;
				rd_rf <=0;
				stc <= 0;
				dim_we <=0;
				mm_dwdata <= 0;
				mm_dwe <= 0;
				counter <= counter+1;
			end
            else if ((counter % 18) % 2 == 0) begin		//Load 8 elements of a row of matrix B
				inst <= 2;	
				we_rf <=1;
				rd_rf <=1;
				stc <= 0;
				dim_we <=0;
				mm_dwdata <= 0;
				mm_dwe <= 0;
				counter <= counter+1;
			end 
            else if((counter % 18) % 2 == 1) begin		//Matrix Multiply
				inst <= 4;		
				we_rf <=1;
				rd_rf <=2;
				stc <= 0;
				dim_we <=0;
				mm_dwdata <= 0;
				mm_dwe <= 0;
				counter <= counter+1;
				if (mm_opcounter == 8) mm_opcounter <= 1;		//Decipher which element of A to be used for matrix multiply(mm_op)
				else mm_opcounter <= mm_opcounter + 1;
			end 
			
		end
 	end

	//Updating Register file with the appropriate value
    always @(co or mm_drdata or inst or stc) begin
        if (stc==0) begin
            if (inst == 4) rf_wdata = co;
            else rf_wdata = mm_drdata;
        end
        else rf_wdata = 0;
	end
endmodule