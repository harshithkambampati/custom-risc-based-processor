`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2025 04:33:09
// Design Name: 
// Module Name: forward_unit
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
module forward_unit(
    input [4:0] R_t_exmem,
    input [4:0] R_d_exmem,
    input rd_exmem,
    input regwrite_exmem,
    input [4:0] R_t_memwb,
    input [4:0] R_d_memwb,
    input rd_memwb,
    input regwrite_memwb,    
    input [4:0] R_s_ex,
    input [4:0] R_t_ex,
    output reg[1:0] forward_A,
    output reg[1:0] forward_B
    );   
    wire [4:0]EX_MEM_Rd;wire [4:0]MEM_WB_Rd;
    assign EX_MEM_Rd = rd_exmem? R_d_exmem : R_t_exmem;
    assign MEM_WB_Rd = rd_memwb? R_d_memwb : R_t_memwb;
    always @(*) begin
    if(EX_MEM_Rd == R_s_ex && regwrite_exmem !=0 && EX_MEM_Rd != 5'b00000)
    begin
    forward_A <= 2'b01;
    end
    else if(MEM_WB_Rd == R_s_ex && regwrite_memwb !=0 && MEM_WB_Rd != 5'b00000)
    begin
    forward_A <= 2'b10;    
    end
    else begin forward_A = 2'b00; end    
    if(EX_MEM_Rd == R_t_ex && regwrite_exmem !=0 && EX_MEM_Rd != 5'b00000)
    begin
    forward_B <= 2'b01;
    end
    else if(MEM_WB_Rd == R_t_ex && regwrite_memwb !=0 && MEM_WB_Rd != 5'b00000)
    begin
    forward_B <= 2'b10;    
    end
    else begin forward_B = 2'b00; end
    end
endmodule


