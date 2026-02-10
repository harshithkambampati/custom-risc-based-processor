`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:32:37
// Design Name: 
// Module Name: Register_File
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


module Register_File(input rst,input clk,
    input [4:0] Read_Reg_1,
    input [4:0] Read_Reg_2,
    input [4:0] Write_Reg,
    input [31:0] Write_Data,
    input Reg_Write,
    output reg[31:0] Read_Data_1,
    output reg[31:0] Read_Data_2
    );
    
    reg [31:0]registers[31:0];
    always @(*)
    begin 
        if(rst)
            begin
            registers[0] =32'h0;registers[1] =32'h4;registers[2] =32'h2;registers[3] =32'h3;
            registers[4] =32'h41;registers[5] =32'h5;registers[6] =32'h6;registers[7] =32'h7;
            registers[8] =32'h8;registers[9] =32'h9;registers[10] =32'ha;registers[11] =32'hb;
            registers[12] =32'hc;registers[13] =32'hd;registers[14] =32'he;registers[15] =32'hf;
            registers[16] =32'h10;registers[17] =32'h11;registers[18] =32'h12;registers[19] =32'h13;
            registers[20] =32'h14;registers[21] =32'h15;registers[22] =32'h16;registers[23] =32'h17;
            registers[24] =32'h18;registers[25] =32'h19;registers[26] =32'h1a;registers[27] =32'h1b;
            registers[28] =32'h1c;registers[29] =32'h1d;registers[30] =32'h1e;registers[31] =32'h1f;
            end
        
    end
    
    always @(posedge clk)begin 
    if(clk)begin
    if(Reg_Write)begin
    registers[Write_Reg] = Write_Data;
    end
     end
    
    
    end
     always @(negedge clk) begin
     Read_Data_1 = registers[Read_Reg_1];
     Read_Data_2 = registers[Read_Reg_2];
     end
     //assign Read_Data_1 = registers[Read_Reg_1];
     //assign Read_Data_2 = registers[Read_Reg_2];
     
endmodule
