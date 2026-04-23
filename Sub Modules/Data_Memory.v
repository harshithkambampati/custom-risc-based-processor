`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:32:37
// Design Name: 
// Module Name: Data_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Data_Memory
// Description: Byte-addressable data memory (1 KiB), synchronous write,
//              combinational read. Initialized via initial block.
//////////////////////////////////////////////////////////////////////////////////

module Data_Memory(
    input  clk,
    input  rst,
    input  Mem_Read,
    input  Mem_Write,
    input  [31:0] Address,
    input  [31:0] Write_Data,
    output reg [31:0] Data_Out
    );

    reg [7:0] data_mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            data_mem[i] = 8'h00;
        data_mem[0]  = 8'h00; data_mem[1]  = 8'h01;
        data_mem[2]  = 8'h02; data_mem[3]  = 8'h03;
        data_mem[4]  = 8'h04; data_mem[5]  = 8'h05;
        data_mem[6]  = 8'h06; data_mem[7]  = 8'h07;
        data_mem[8]  = 8'h08; data_mem[9]  = 8'h09;
        data_mem[10] = 8'h5A; data_mem[11] = 8'h3A;
        data_mem[12] = 8'h1A; data_mem[13] = 8'h2A;
        data_mem[14] = 8'hAA; data_mem[15] = 8'h0F;
        data_mem[16] = 8'h0B; data_mem[17] = 8'h0C;
        data_mem[18] = 8'h0D; data_mem[19] = 8'h1D;
        data_mem[20] = 8'h2D;
    end

    wire [9:0] addr = Address[9:0];

    always @(posedge clk) begin
        if (Mem_Write) begin
            data_mem[addr]     <= Write_Data[31:24];
            data_mem[addr + 1] <= Write_Data[23:16];
            data_mem[addr + 2] <= Write_Data[15:8];
            data_mem[addr + 3] <= Write_Data[7:0];
        end
    end

    always @(*) begin
        if (Mem_Read)
            Data_Out = {data_mem[addr], data_mem[addr + 1],
                        data_mem[addr + 2], data_mem[addr + 3]};
        else
            Data_Out = 32'b0;
    end

endmodule