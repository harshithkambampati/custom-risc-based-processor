`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:32:37
// Design Name: 
// Module Name: Instruction_memory
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


//////////////////////////////////////////////////////////////////////////////////
// Module Name: Instruction_memory
// Description: 256-word ROM holding the program image. Pre-loaded in an
//              `initial` block so it is inferred as a synchronous ROM.
//////////////////////////////////////////////////////////////////////////////////

module Instruction_memory(
    input clk,
    input rst,
    input  [31:0] PC,
    output [31:0] instruction
    );

    reg [31:0] imem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            imem[i] = 32'h00000000;
        imem[0]  = 32'h39030008;
        imem[1]  = 32'h88C63000;
        imem[2]  = 32'h8C22000C;
        imem[3]  = 32'h88672800;
        imem[4]  = 32'h88452001;
        imem[5]  = 32'h08000006;
        imem[6]  = 32'h88832800;
        imem[7]  = 32'h08000000;
        imem[24] = 32'h884A0800;
    end

    assign instruction = imem[PC[7:0]];

endmodule