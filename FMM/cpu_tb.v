`timescale 1ns/1ns 

// This test bench will run for a fixed 1000 clock cycles and then dump out the memory
// Test cases are such that they should finish within this time
// If the CPU continues after this point, it should not result in changes in data
// Safe to assume that imem contains only 0 after the last instruction

// MACROS:
// A single parameter is passed into the code, 
// which is the path to the files imem.mem, dmem0-3.mem and expout.mem
// Test cases ensure the files are named appropriately
module cpu_tb ();
    
    reg  clk, reset;
    wire [31:0] iaddr, idata, daddr, drdata, dwdata;
    wire [3:0] dwe;
    wire [255:0] mm_wdata,mm_rdata;
    wire mm_we;

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
        for (i=0; i<1000; i=i+1) begin
            @(posedge clk);
        end
    end
    
endmodule
