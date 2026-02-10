`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 02:31:19
// Design Name: 
// Module Name: ALU_control
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


module ALU_control(
    input [1:0] ALU_Op,input [5:0] func_code,
    output reg [3:0] ALUControl
    );
    always@(*)begin 
        case (ALU_Op)
            2'b00: //For lw and sw
                ALUControl <=4'b0000;
            2'b01://For nandi
                ALUControl <=4'b0010;
            2'b10: // For R-type instructions (add,sub)
                case(func_code) 
                6'b000000: 
                    ALUControl <= 4'b0110;// Subtract
                6'b000001:
                    ALUControl <= 4'b0000; // Add
                endcase
            2'b11: //For jump
                ALUControl <= 4'bxxxx;
        endcase
        end    
endmodule