`timescale 1ns/1ps
`define DMEM_N_FILE(x,y) {x,y,".mem"}

module dmem (
    input clk,
    input [31:0] daddr,
    input [31:0] dwdata,
    input [3:0] dwe,
    output [31:0] drdata,
    input [255:0] mm_dwdata,
    input mm_dwe,
    output [255:0] mm_drdata
);
    // 4K location, 16KB total, split in 4 banks
    reg [7:0] mem0[0:4095];  
    reg [7:0] mem1[0:4095];  
    reg [7:0] mem2[0:4095];  
    reg [7:0] mem3[0:4095];  

    wire [29:0] a;
    wire [29:0] b;
    integer i;
    

    initial begin 
        $readmemh("data_mem/data0.mem", mem0); 
        $readmemh("data_mem/data1.mem", mem1); 
        $readmemh("data_mem/data2.mem", mem2); 
        $readmemh("data_mem/data3.mem", mem3); 
    end

    assign a = daddr[31:2];
    
    // Selecting bytes to be done inside CPU
    assign drdata = { mem3[a], mem2[a], mem1[a], mem0[a]};  

    always @(posedge clk) begin
        if (dwe[3]) mem3[a] = dwdata[31:24];
        if (dwe[2]) mem2[a] = dwdata[23:16];
        if (dwe[1]) mem1[a] = dwdata[15: 8];
        if (dwe[0]) mem0[a] = dwdata[ 7: 0];
    end


    assign b = daddr[31:2];
    always @(*) begin
        for (i=0;i<8;i=i+1)
            mm_drdata[i*32:i*32+31]={ mem3[b+i], mem2[b+i], mem1[b+i], mem0[b+i]};
    end
    

    always @(posedge clk) begin
        for (i=0;i<8;i=i+1)
            if (mm_dwe) begin
                mem3[b+i] = mm_dwdata[31+i*32:24+i*32];
                mem2[b+i] = mm_dwdata[23+i*32:16+i*32];
                mem1[b+i] = mm_dwdata[15+i*32: 8+i*32];
                mem0[b+i] = mm_dwdata[ 7+i*32: 0+i*32];
            end
    end


endmodule