`timescale 1ns/1ns 

// This test bench will run for a fixed 2000 clock cycles and then dump out the memory
// If the CPU continues after this point, it should not result in changes in data
// Safe to assume that imem contains only 0 after the last instruction

module cpu_tb ();
    
    reg  clk, reset;
    wire [31:0] iaddr, idata, daddr, drdata, dwdata;
    wire [3:0] dwe;
    wire [255:0] mm_wdata,mm_rdata;
    wire mm_we;
    integer i;

    // Instantiate the CPU
    cpu u1(
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe),
        .mm_dwdata(mm_wdata),
        .mm_dwe(mm_we),
        .mm_drdata(mm_rdata)
    );
    

    imem u2(
        .iaddr(iaddr),
        .idata(idata)
    );

    dmem u3(
        .clk(clk),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .dwe(dwe),
        .mm_dwdata(mm_wdata),
        .mm_dwe(mm_we),
        .mm_drdata(mm_rdata)
    );

    // Set up clock
    always #5 clk=~clk;

    initial begin
        clk = 1;
        reset = 1;   // This is active high reset
        #100         // At least 100 because Xilinx assumes 100ns reset in post-syn sim
        reset = 0;   // Reset removed - normal functioning resumes

        @(posedge clk);
        for (i=0; i<2000; i=i+1) begin
            @(posedge clk);
        end
        $finish;
    end
    
endmodule
