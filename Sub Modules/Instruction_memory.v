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


module Instruction_memory(
input clk,
input rst,
input [31:0] PC,
output [31:0] instruction
);
    
reg [31:0]imem[31:0];
always @(*)
begin
if(rst)
begin
imem[0] = 32'h39030008;
imem[1] = 32'h88C63000;
imem[2] = 32'h8C22000C;
imem[3] = 32'h88672800;
imem[4] = 32'h88452001;
imem[5] = 32'h08000006;
imem[6] = 32'h88832800;
imem[7] = 32'h08000000;
imem[24] = 32'h884A0800;

end

end
assign instruction = imem[PC];
endmodule
