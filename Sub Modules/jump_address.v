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

//////////////////////////////////////////////////////////////////////////////////
// Module Name: jump_address
// Description: Constructs a 32-bit jump target: {PC[31:28], address, 2'b00}.
//////////////////////////////////////////////////////////////////////////////////

module jump_address(
    input  [31:0] pc,
    input  [25:0] in_address,
    output [31:0] out_address
    );

    assign out_address = {pc[31:28], in_address, 2'b00};

endmodule