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
// Module Name: forward_unit
// Description: Selects forwarding source for each ALU input.
//   forward_X == 2'b00 -> value from RR/ID stage register
//   forward_X == 2'b01 -> value from EX/MEM stage (ALU result)
//   forward_X == 2'b10 -> value from MEM/WB stage (ALU result or memory)
//////////////////////////////////////////////////////////////////////////////////

module forward_unit(
    input  [4:0] R_t_exmem,
    input  [4:0] R_d_exmem,
    input  rd_exmem,
    input  regwrite_exmem,
    input  [4:0] R_t_memwb,
    input  [4:0] R_d_memwb,
    input  rd_memwb,
    input  regwrite_memwb,
    input  [4:0] R_s_ex,
    input  [4:0] R_t_ex,
    output reg [1:0] forward_A,
    output reg [1:0] forward_B
    );

    wire [4:0] EX_MEM_Rd = rd_exmem ? R_d_exmem : R_t_exmem;
    wire [4:0] MEM_WB_Rd = rd_memwb ? R_d_memwb : R_t_memwb;

    always @(*) begin
        if (regwrite_exmem && (EX_MEM_Rd != 5'b00000) && (EX_MEM_Rd == R_s_ex))
            forward_A = 2'b01;
        else if (regwrite_memwb && (MEM_WB_Rd != 5'b00000) && (MEM_WB_Rd == R_s_ex))
            forward_A = 2'b10;
        else
            forward_A = 2'b00;

        if (regwrite_exmem && (EX_MEM_Rd != 5'b00000) && (EX_MEM_Rd == R_t_ex))
            forward_B = 2'b01;
        else if (regwrite_memwb && (MEM_WB_Rd != 5'b00000) && (MEM_WB_Rd == R_t_ex))
            forward_B = 2'b10;
        else
            forward_B = 2'b00;
    end

endmodule

