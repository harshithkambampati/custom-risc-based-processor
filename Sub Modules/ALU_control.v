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

//////////////////////////////////////////////////////////////////////////////////
// Module Name: ALU_control
// Description: Generates 4-bit ALU operation from 2-bit ALUOp plus 6-bit func.
//   ALUOp 2'b00 -> add            (lw/sw address calc)
//   ALUOp 2'b01 -> nand            (nandi)
//   ALUOp 2'b10 -> R-type decode   (func 000000 -> sub, 000001 -> add)
//   ALUOp 2'b11 -> add             (don't-care for jump)
//////////////////////////////////////////////////////////////////////////////////

module ALU_control(
    input  [1:0] ALU_Op,
    input  [5:0] func_code,
    output reg [3:0] ALUControl
    );

    always @(*) begin
        case (ALU_Op)
            2'b00: ALUControl = 4'b0000;
            2'b01: ALUControl = 4'b0010;
            2'b10: begin
                case (func_code)
                    6'b000000: ALUControl = 4'b0110;
                    6'b000001: ALUControl = 4'b0000;
                    default:   ALUControl = 4'b0000;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule