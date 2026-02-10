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


module Control_Unit(
    input [5:0] opcode,
    output reg regWrite,
    output reg ALUSrc,
    output reg [1:0]ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg PCSrc,
    output reg RegDst
    );
   reg PCSrc =1'b0;
    always @(*)
    begin 
    if(opcode == 6'b100011) // lw
    begin
    PCSrc <= 1'b0;
    regWrite <= 1'b1;
    RegDst <= 1'b0;
    ALUSrc <= 1'b1;
    ALUOp <= 2'b00;
    MemRead <= 1'b1;
    MemWrite <= 1'b0;
    MemtoReg <= 1'b0;    
    end
    
    else if(opcode == 6'b101011) //sw
    begin
    PCSrc <= 1'b0;
    regWrite <= 1'b0;
    ALUSrc <= 1'b1;
    ALUOp <= 2'b00;
    MemRead <= 1'b0;
    MemWrite <= 1'b1;
    MemtoReg <= 1'bx;
    RegDst <= 1'b0;
    end
    
    else if(opcode == 6'b100010) // R type instructions: sub,add 
    begin
    PCSrc <= 1'b0;
    regWrite <= 1'b1;
    ALUSrc <= 1'b0;
    ALUOp <= 2'b10;
    MemRead <= 1'b0;
    MemWrite <= 1'b0;
    MemtoReg <= 1'b1;
    RegDst <= 1'b1;
    end
    
    else if(opcode == 6'b001110) // nandi
    begin
    PCSrc <= 1'b0;
    regWrite <= 1'b1;
    ALUSrc <= 1'b1;
    ALUOp <= 2'b01;
    MemRead <= 1'b0;
    MemWrite <= 1'b0;
    MemtoReg <= 1'b1;
    RegDst <= 1'b0;
    end
       
    else if(opcode == 6'b000010) // jump
    begin
    PCSrc <= 1'b1;
    regWrite <= 1'b0;
    RegDst <= 1'b0;
    ALUSrc <= 1'b0;
    ALUOp <= 2'b00;
    MemRead <= 1'b0;
    MemWrite <= 1'b0;
    MemtoReg <= 1'b0;
    end
    end
endmodule
