`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:32:37
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_opcode,
    output reg [31:0] ALU_out,
    output reg ALU_zero
    );
    
    always @(*)
        begin 
            case (ALU_opcode)
                4'b0110:// subtract
                    ALU_out = A-B;
                4'b0010:
                    ALU_out = ~(A & B);
                4'b0000:
                    ALU_out = A+B;
            endcase
        if(ALU_out == 32'b0)
        begin ALU_zero =1'b1; end
        else begin ALU_zero = 1'b0; end
        end
endmodule
