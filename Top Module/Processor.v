`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:32:37
// Design Name: 
// Module Name: Processor
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


module Processor(
    input clk,
    input rst
    );
    
    
    reg [31:0]IF_ID;reg [49:0]ID_RR;reg [129:0]RR_EX;reg [78:0]EX_MEM;reg [76:0]MEM_WB; // Stage Registers
    
    reg [31:0]PC =32'h0;wire rst_pin;
    wire [31:0] instruction;wire [5:0]opcode;
    wire [4:0]R_s;wire [4:0]R_t;wire [4:0]R_d;wire [15:0]offset;wire [31:0]immediate_data;
    wire RegWrite;wire ALU_Src; wire[1:0]ALUOp;wire memread;wire memwrite;wire memtoreg;
    wire PCSrc;wire regDst; wire [31:0]instr_out;
    
    wire [4:0]shamt;wire[25:0]address;wire [5:0]func_code;wire [31:0] PC_1;
    // Instruction Fetch Stage
    wire [31:0]j_address;
    jump_address ja(IF_ID,address,j_address);
    assign PC_1 = PCSrc ? j_address : PC;
    Instruction_memory im(clk,rst,PC_1,instruction);
    
    
    // Instruction Decode Stage    

    assign instr_out = IF_ID;
    Instruction_Decode id(instr_out,opcode,R_s,R_t,R_d,offset,shamt,func_code,address);    
    Control_Unit c_u(opcode,RegWrite,ALU_Src,ALUOp,memread,memwrite,memtoreg,PCSrc,regDst);
    
    // Register Read Stage
    wire [31:0]Reg_Data_1;wire [31:0]Reg_Data_2; wire [4:0]R_Dest;wire [31:0]result; wire [15:0]off;wire [5:0]rs;wire [5:0]rt;wire rw;wire rd;
    
    assign rs = ID_RR[49:45];
    assign rt = ID_RR[44:40];
    assign off = ID_RR[34:19];
    assign rw = MEM_WB[11];
    assign rd = MEM_WB[10]; //regdst signal to select between rt and rd at write back stage
    wire rt1; assign rt1 = MEM_WB[9:5];
    assign R_Dest = rd ? MEM_WB[4:0] :MEM_WB[9:5];
    //assign result = MEM_WB[12]? MEM_WB[76:45] : MEM_WB[44:13]; 
    Register_File r_f(rst,clk,rs,rt,R_Dest,result,rw,Reg_Data_1,Reg_Data_2);
    Sign_extend se(ID_RR[34:19],immediate_data);
    
    // Execute stage
    wire [3:0]ALU_Control; wire [1:0]aluop;
    wire [5:0]fc;
    assign aluop = RR_EX[17:16];
    assign fc = RR_EX[28:23];
    wire [1:0]forward_A;
    wire [1:0]forward_B;
    forward_unit fu(
    EX_MEM[9:5],
    EX_MEM[4:0],
    EX_MEM[10],
    EX_MEM[11],
    MEM_WB[9:5],
    MEM_WB[4:0],
    MEM_WB[10],
    MEM_WB[11],
    RR_EX[129:125],
    RR_EX[9:5],
    forward_A,forward_B);
    ALU_control alu_c(aluop,fc,ALU_Control);    
    reg [31:0]ALU_Input_1;wire [31:0]ALU_Input_2;wire [31:0]ALU_out;wire ALU_zero;
    wire [31:0]Data_out;reg [31:0] B_rf;
    //assign ALU_Input_1 = RR_EX[124:93]; 
    assign ALU_Input_2 = RR_EX[15] ? RR_EX[60:29] : B_rf;
    ALU alu(ALU_Input_1,ALU_Input_2,ALU_Control,ALU_out,ALU_zero);    
    //Memory Stage
    wire [31:0]addr ; wire memw =EX_MEM[14];wire memr = EX_MEM[13];wire [31:0]writedata;
    assign writedata = EX_MEM[78:47];
    assign addr = EX_MEM[46:15];
    Data_Memory data_mem(rst,memr,memw,addr,writedata,Data_out);
        
    // Write Back Stage
    assign result = MEM_WB[12] ?MEM_WB[76:45] : MEM_WB[44:13];
    
    always @(posedge clk)
    begin
    if(rst) begin PC = 32'b0;end//IF_ID=32'b0;ID_RR=50'b0;RR_EX =130'b0;EX_MEM=79'b0;MEM_WB=77'b0; end
    //if(PCSrc)begin PC <= PC_1;end
    PC <=PC+1;
    IF_ID <= instruction;
    ID_RR <= {R_s,R_t,R_d,offset,func_code,shamt,ALUOp,ALU_Src,memread,memwrite,memtoreg,RegWrite,regDst};
    RR_EX <= {ID_RR[49:45],Reg_Data_1,Reg_Data_2,immediate_data ,ID_RR[18:0],ID_RR[44:35]};
//RR_EX :{Reg_Data_1,Reg_Data_2,immediate_data ,func_code,shamt,ALUOp,ALU_Src,memread,memwrite,memtoreg,RegWrite,regDst,R_t,R_d}Rt,Rd needed for forwarding
    EX_MEM <= {RR_EX[92:61],ALU_out,RR_EX[14:0]};
    
    MEM_WB <= {EX_MEM[46:15],Data_out,EX_MEM[12:0]};
    end
    
    always @(posedge PCSrc)begin PC<= PC_1;end
    
    always @(*)begin
    case(forward_A)
    2'b00:
        ALU_Input_1 <= RR_EX[124:93];
    2'b01: 
        ALU_Input_1 <= EX_MEM[46:15];
    2'b10:
        case(MEM_WB[12])
        1'b0: ALU_Input_1 <= MEM_WB[44:13];
        1'b1:ALU_Input_1 <= MEM_WB[76:45];        
    endcase
    endcase
    case(forward_B)
    2'b00:
        B_rf <= RR_EX[92:61];
    2'b01: 
        B_rf <= EX_MEM[46:15];
    2'b10:
        case(MEM_WB[12])
        1'b0: B_rf <= MEM_WB[44:13];
        1'b1: B_rf <= MEM_WB[76:45];
        endcase
    endcase
    end
endmodule
