`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 22:05:04
// Design Name: 
// Module Name: jump_address
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


module jump_address(input [31:0]pc,
    input [25:0] in_address,
    output [31:0] out_address
    );
    
    assign out_address = {pc[31:28],in_address,1'b0,1'b0};
endmodule
