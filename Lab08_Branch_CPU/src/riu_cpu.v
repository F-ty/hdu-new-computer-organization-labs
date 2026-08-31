`timescale 1ns / 1ps

module riu_cpu(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step_en,
    output reg  [31:0] PC,
    output reg  [31:0] IR,
    output wire [31:0] W_Data,
    output reg  [31:0] A,
    output reg  [31:0] B,
    output reg  [31:0] F,
    output reg  [3:0]  FR,
    output wire [2:0]  ST,
    output wire [31:0] imm32_dbg,
    output wire [3:0]  ALU_OP_dbg
);
    wire [31:0] inst_code;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [31:0] imm32;
    wire        IS_R;
    wire        IS_IMM;
    wire        IS_LUI;
    wire [3:0]  ALU_OP;
    wire [3:0]  ALU_OP_o;
    wire        PC_Write;
    wire        IR_Write;
    wire        A_Write;
    wire        B_Write;
    wire        F_Write;
    wire        FR_Write;
    wire        Reg_Write;
    wire        rs2_imm_s;
    wire        w_data_s;
    wire [31:0] R_Data_A;
    wire [31:0] R_Data_B;
    wire [31:0] ALU_B;
    wire [31:0] F_next;
    wire [3:0]  FR_next;

    assign imm32_dbg  = imm32;
    assign ALU_OP_dbg = ALU_OP_o;
    assign ALU_B      = rs2_imm_s ? imm32 : B;
    assign W_Data     = w_data_s ? imm32 : F;

    riu_rom U_IM(
        .addr(PC[7:2]),
        .inst(inst_code)
    );

    id1 U_ID1(
        .inst(IR),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .imm32(imm32)
    );

    id2 U_ID2(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP)
    );

    cu_riu U_CU(
        .clk(clk),
        .rst_n(rst_n),
        .step_en(step_en),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .IR_Write(IR_Write),
        .A_Write(A_Write),
        .B_Write(B_Write),
        .F_Write(F_Write),
        .FR_Write(FR_Write),
        .Reg_Write(Reg_Write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .ALU_OP_o(ALU_OP_o),
        .ST(ST)
    );

    regs U_REGS(
        .clk(clk),
        .rst_n(rst_n),
        .step_en(step_en),
        .Reg_Write(Reg_Write),
        .R_Addr_A(rs1),
        .R_Addr_B(rs2),
        .W_Addr(rd),
        .W_Data(W_Data),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );

    alu U_ALU(
        .A(A),
        .B(ALU_B),
        .ALU_OP(ALU_OP_o),
        .F(F_next),
        .FR(FR_next)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC <= 32'h0000_0000;
            IR <= 32'h0000_0000;
            A  <= 32'h0000_0000;
            B  <= 32'h0000_0000;
            F  <= 32'h0000_0000;
            FR <= 4'b0000;
        end else if (step_en) begin
            if (PC_Write) begin
                PC <= PC + 32'd4;
            end
            if (IR_Write) begin
                IR <= inst_code;
            end
            if (A_Write) begin
                A <= R_Data_A;
            end
            if (B_Write) begin
                B <= R_Data_B;
            end
            if (F_Write) begin
                F <= F_next;
            end
            if (FR_Write) begin
                FR <= FR_next;
            end
        end
    end
endmodule
