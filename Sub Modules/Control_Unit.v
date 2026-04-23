`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:53:53
// Design Name: 
// Module Name: Control_Unit
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
// Module Name: Control_Unit
// Description: Decodes 6-bit opcode into control signals for the datapath.
//   100011 -> lw
//   101011 -> sw
//   100010 -> R-type (add/sub)
//   001110 -> nandi
//   000010 -> jump
//////////////////////////////////////////////////////////////////////////////////

module Control_Unit(
    input  [5:0] opcode,
    output reg regWrite,
    output reg ALUSrc,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg PCSrc,
    output reg RegDst
    );

    always @(*) begin
        regWrite = 1'b0;
        ALUSrc   = 1'b0;
        ALUOp    = 2'b00;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        PCSrc    = 1'b0;
        RegDst   = 1'b0;

        case (opcode)
            6'b100011: begin
                regWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
                MemRead  = 1'b1;
                MemtoReg = 1'b0;
            end
            6'b101011: begin
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
                MemWrite = 1'b1;
            end
            6'b100010: begin
                regWrite = 1'b1;
                ALUOp    = 2'b10;
                MemtoReg = 1'b1;
                RegDst   = 1'b1;
            end
            6'b001110: begin
                regWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b01;
                MemtoReg = 1'b1;
            end
            6'b000010: begin
                PCSrc    = 1'b1;
            end
            default: begin
                regWrite = 1'b0;
                ALUSrc   = 1'b0;
                ALUOp    = 2'b00;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                PCSrc    = 1'b0;
                RegDst   = 1'b0;
            end
        endcase
    end

endmodule
