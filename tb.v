`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2025 04:31:08
// Design Name: 
// Module Name: tb
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


module tb(

    );    
reg rst;
reg clk;
Processor p(clk,rst);

initial begin #0 clk =0;#0 rst =1; #6 rst =0;end
initial begin 
repeat (26) #5 clk =~clk; $finish; end



endmodule
