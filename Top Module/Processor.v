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
// Module Name: Processor
// Description: Top level of the 6-stage pipelined RISC processor.
//              Stages: IF -> ID -> RR -> EX -> MEM -> WB.
//              This file drives the stage registers on posedge clk and uses
//              only combinational always blocks for muxing; no data signal is
//              ever used as a clock.
//////////////////////////////////////////////////////////////////////////////////

module Processor(
    input clk,
    input rst
    );

    // --------------------------------------------------------------------
    // Pipeline registers
    // --------------------------------------------------------------------
    // ID_RR layout [49:0]:
    //   [49:45] R_s    [44:40] R_t    [39:35] R_d     [34:19] offset
    //   [18:13] func   [12:8]  shamt  [7:6]   ALUOp   [5] ALU_Src
    //   [4] MemRead    [3] MemWrite   [2] MemtoReg    [1] RegWrite  [0] RegDst
    //
    // RR_EX layout [129:0]:
    //   [129:125] R_s              [124:93] Reg_Data_1
    //   [92:61]  Reg_Data_2         [60:29]  immediate
    //   [28:23]  func   [22:18] shamt [17:16] ALUOp
    //   [15] ALU_Src  [14] MemRead [13] MemWrite [12] MemtoReg
    //   [11] RegWrite [10] RegDst  [9:5] R_t  [4:0] R_d
    //
    // EX_MEM layout [78:0]:
    //   [78:47] Reg_Data_2 (store data)
    //   [46:15] ALU_out    (address / R-type result)
    //   [14] MemRead [13] MemWrite [12] MemtoReg [11] RegWrite [10] RegDst
    //   [9:5]  R_t   [4:0]  R_d
    //
    // MEM_WB layout [76:0]:
    //   [76:45] ALU_out  [44:13] Data_out
    //   [12] MemtoReg [11] RegWrite [10] RegDst [9:5] R_t [4:0] R_d
    // --------------------------------------------------------------------
    reg [31:0]  IF_ID;
    reg [49:0]  ID_RR;
    reg [129:0] RR_EX;
    reg [78:0]  EX_MEM;
    reg [76:0]  MEM_WB;
    reg [31:0]  PC;

    // --------------------------------------------------------------------
    // IF stage
    // --------------------------------------------------------------------
    wire [31:0] instruction;
    wire [31:0] j_address;
    wire [31:0] PC_1;

    wire [5:0]  opcode;
    wire [4:0]  R_s, R_t, R_d, shamt;
    wire [15:0] offset;
    wire [5:0]  func_code;
    wire [25:0] address;

    wire RegWrite, ALU_Src, MemRead, MemWrite, MemtoReg, PCSrc, RegDst;
    wire [1:0]  ALUOp;
    wire [31:0] immediate_data;

    jump_address ja(IF_ID, address, j_address);
    assign PC_1 = PCSrc ? j_address : PC;
    Instruction_memory im(clk, rst, PC_1, instruction);

    // --------------------------------------------------------------------
    // ID stage
    // --------------------------------------------------------------------
    Instruction_Decode id(IF_ID, opcode, R_s, R_t, R_d, offset, shamt,
                          func_code, address);
    Control_Unit cu(opcode, RegWrite, ALU_Src, ALUOp,
                    MemRead, MemWrite, MemtoReg, PCSrc, RegDst);

    // --------------------------------------------------------------------
    // RR stage
    // --------------------------------------------------------------------
    wire [4:0]  rs_rr = ID_RR[49:45];
    wire [4:0]  rt_rr = ID_RR[44:40];

    wire        wb_RegWrite = MEM_WB[11];
    wire        wb_RegDst   = MEM_WB[10];
    wire [4:0]  R_Dest      = wb_RegDst ? MEM_WB[4:0] : MEM_WB[9:5];

    wire [31:0] Reg_Data_1;
    wire [31:0] Reg_Data_2;
    wire [31:0] result;

    Register_File rf(rst, clk, rs_rr, rt_rr, R_Dest, result, wb_RegWrite,
                     Reg_Data_1, Reg_Data_2);
    Sign_extend se(ID_RR[34:19], immediate_data);

    // --------------------------------------------------------------------
    // EX stage
    // --------------------------------------------------------------------
    wire [1:0]  aluop_ex  = RR_EX[17:16];
    wire [5:0]  fc_ex     = RR_EX[28:23];
    wire        alusrc_ex = RR_EX[15];

    wire [3:0]  ALU_Control;
    wire [1:0]  forward_A;
    wire [1:0]  forward_B;
    wire        ALU_zero;
    wire [31:0] ALU_out;

    reg  [31:0] ALU_Input_1;
    reg  [31:0] B_rf;
    wire [31:0] ALU_Input_2 = alusrc_ex ? RR_EX[60:29] : B_rf;

    forward_unit fu(
        EX_MEM[9:5],   EX_MEM[4:0], EX_MEM[10], EX_MEM[11],
        MEM_WB[9:5],   MEM_WB[4:0], MEM_WB[10], MEM_WB[11],
        RR_EX[129:125], RR_EX[9:5],
        forward_A, forward_B);

    ALU_control alu_c(aluop_ex, fc_ex, ALU_Control);
    ALU alu(ALU_Input_1, ALU_Input_2, ALU_Control, ALU_out, ALU_zero);

    always @(*) begin
        case (forward_A)
            2'b00:   ALU_Input_1 = RR_EX[124:93];
            2'b01:   ALU_Input_1 = EX_MEM[46:15];
            2'b10:   ALU_Input_1 = MEM_WB[12] ? MEM_WB[76:45] : MEM_WB[44:13];
            default: ALU_Input_1 = RR_EX[124:93];
        endcase

        case (forward_B)
            2'b00:   B_rf = RR_EX[92:61];
            2'b01:   B_rf = EX_MEM[46:15];
            2'b10:   B_rf = MEM_WB[12] ? MEM_WB[76:45] : MEM_WB[44:13];
            default: B_rf = RR_EX[92:61];
        endcase
    end

    // --------------------------------------------------------------------
    // MEM stage
    // --------------------------------------------------------------------
    wire        memread_mem  = EX_MEM[14];
    wire        memwrite_mem = EX_MEM[13];
    wire [31:0] writedata    = EX_MEM[78:47];
    wire [31:0] addr         = EX_MEM[46:15];
    wire [31:0] Data_out;

    Data_Memory data_mem(clk, rst, memread_mem, memwrite_mem,
                         addr, writedata, Data_out);

    // --------------------------------------------------------------------
    // WB stage
    // --------------------------------------------------------------------
    assign result = MEM_WB[12] ? MEM_WB[76:45] : MEM_WB[44:13];

    // --------------------------------------------------------------------
    // Sequential: advance pipeline registers on posedge clk
    // --------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            PC     <= 32'b0;
            IF_ID  <= 32'b0;
            ID_RR  <= 50'b0;
            RR_EX  <= 130'b0;
            EX_MEM <= 79'b0;
            MEM_WB <= 77'b0;
        end
        else begin
            PC     <= PC + 32'd1;
            IF_ID  <= instruction;
            ID_RR  <= {R_s, R_t, R_d, offset, func_code, shamt, ALUOp,
                       ALU_Src, MemRead, MemWrite, MemtoReg, RegWrite, RegDst};
            RR_EX  <= {ID_RR[49:45], Reg_Data_1, Reg_Data_2, immediate_data,
                       ID_RR[18:0], ID_RR[44:35]};
            EX_MEM <= {RR_EX[92:61], ALU_out, RR_EX[14:0]};
            MEM_WB <= {EX_MEM[46:15], Data_out, EX_MEM[12:0]};
        end
    end

endmodule