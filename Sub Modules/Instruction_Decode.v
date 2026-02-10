`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:42:46
// Design Name: 
// Module Name: Instruction_Decode
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


module Instruction_Decode(
    input [31:0] instruction_code,
    output [5:0] opcode,
    output [4:0] R_s,
    output [4:0] R_t,
    output [4:0] R_d,
    output [15:0] offset,
    output [4:0] shamt,
    output [5:0] function_code,
    output [25:0] address
    );
    
    
    assign opcode = instruction_code[31:26];
    assign R_s = instruction_code[25:21];
    assign R_t = instruction_code[20:16];
    assign R_d = instruction_code[15:11];
    assign offset = instruction_code[15:0];
    assign shamt = instruction_code[10:6];
    assign function_code  = instruction_code[5:0];
    assign address = instruction_code[25:0];
    
endmodule
