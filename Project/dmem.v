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
    /* 
    always @(*) begin
        for (i=0;i<8;i=i+1)
            mm_drdata[i*32:i*32+31]={ mem3[b+i], mem2[b+i], mem1[b+i], mem0[b+i]};
    end   */
    
    assign mm_drdata[31:0]={ mem3[b], mem2[b], mem1[b], mem0[b]};
    assign mm_drdata[63:32]={ mem3[b+1], mem2[b+1], mem1[b+1], mem0[b+1]};
    assign mm_drdata[95:64]={ mem3[b+2], mem2[b+2], mem1[b+2], mem0[b+2]};
    assign mm_drdata[127:96]={ mem3[b+3], mem2[b+3], mem1[b+3], mem0[b+3]};
    assign mm_drdata[159:128]={ mem3[b+4], mem2[b+4], mem1[b+4], mem0[b+4]};
    assign mm_drdata[191:160]={ mem3[b+5], mem2[b+5], mem1[b+5], mem0[b+5]};
    assign mm_drdata[223:192]={ mem3[b+6], mem2[b+6], mem1[b+6], mem0[b+6]};
    assign mm_drdata[255:224]={ mem3[b+7], mem2[b+7], mem1[b+7], mem0[b+7]};

    
    always @(posedge clk) begin
        /*
        for (i=0;i<8;i=i+1)
            if (mm_dwe) begin
                mem3[b+i] = mm_dwdata[31+i*32:24+i*32];
                mem2[b+i] = mm_dwdata[23+i*32:16+i*32];
                mem1[b+i] = mm_dwdata[15+i*32: 8+i*32];
                mem0[b+i] = mm_dwdata[ 7+i*32: 0+i*32];
            end
        */
        
        if (mm_dwe) begin
            mem3[b] = mm_dwdata[31:24];
            mem2[b] = mm_dwdata[23:16];
            mem1[b] = mm_dwdata[15:8];
            mem0[b] = mm_dwdata[7:0];

            mem3[b+1] = mm_dwdata[63:56];
            mem2[b+1] = mm_dwdata[55:48];
            mem1[b+1] = mm_dwdata[47:40];
            mem0[b+1] = mm_dwdata[39:32];

            mem3[b+2] = mm_dwdata[95:88];
            mem2[b+2] = mm_dwdata[87:80];
            mem1[b+2] = mm_dwdata[79:72];
            mem0[b+2] = mm_dwdata[71:64];

            mem3[b+3] = mm_dwdata[127:120];
            mem2[b+3] = mm_dwdata[119:112];
            mem1[b+3] = mm_dwdata[111:104];
            mem0[b+3] = mm_dwdata[103:96];

            mem3[b+4] = mm_dwdata[159:152];
            mem2[b+4] = mm_dwdata[151:144];
            mem1[b+4] = mm_dwdata[143:136];
            mem0[b+4] = mm_dwdata[135:128];

            mem3[b+5] = mm_dwdata[191:184];
            mem2[b+5] = mm_dwdata[183:176];
            mem1[b+5] = mm_dwdata[175:168];
            mem0[b+5] = mm_dwdata[167:160];

            mem3[b+6] = mm_dwdata[223:216];
            mem2[b+6] = mm_dwdata[215:208];
            mem1[b+6] = mm_dwdata[207:200];
            mem0[b+6] = mm_dwdata[199:192];

            mem3[b+7] = mm_dwdata[255:248];
            mem2[b+7] = mm_dwdata[247:240];
            mem1[b+7] = mm_dwdata[239:232];
            mem0[b+7] = mm_dwdata[231:224];
        end
    end


endmodule