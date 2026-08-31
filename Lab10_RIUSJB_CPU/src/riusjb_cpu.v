`timescale 1ns / 1ps
module riusjb_cpu(
    input  wire        clk,
    input  wire        rst_n,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_pc0,
    output wire [31:0] debug_ir,
    output wire [31:0] debug_w_data,
    output wire [31:0] debug_mdr,
    output wire [31:0] debug_f,
    output wire [31:0] debug_a,
    output wire [31:0] debug_b,
    output wire [3:0]  debug_fr,
    output wire [3:0]  debug_st
);
    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [5:0]  im_addr;
    wire [31:0] inst_code;
    wire [31:0] dec_inst;

    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [31:0] imm32;

    wire is_r;
    wire is_imm;
    wire is_lui;
    wire is_lw;
    wire is_sw;
    wire is_beq;
    wire is_jal;
    wire is_jalr;
    wire [3:0] alu_op;

    wire reg_write;
    wire rs2_imm_s;
    wire [1:0] w_data_s;
    wire mem_write;
    wire pc_write;
    wire ir_write;
    wire pc0_write;
    wire [1:0] pc_s;
    wire [3:0] alu_op_o;

    wire [31:0] r_data_a;
    wire [31:0] r_data_b;
    wire [31:0] alu_b;
    wire [31:0] alu_f;
    wire [3:0]  alu_fr;
    wire [31:0] dm_r_data;
    wire [31:0] w_data;
    wire [31:0] rel_target;

    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] F;
    reg [31:0] MDR;
    reg [3:0]  FR;

    assign dec_inst = (debug_st == 4'd1) ? inst_code : ir;
    assign rel_target = pc0 + imm32;

    instr_mem u_im(
        .addr(im_addr),
        .inst(inst_code)
    );

    if_unit u_if(
        .clk(clk),
        .rst_n(rst_n),
        .PC_Write(pc_write),
        .IR_Write(ir_write),
        .PC0_Write(pc0_write),
        .PC_s(pc_s),
        .inst_code(inst_code),
        .rel_target(rel_target),
        .jalr_target(F),
        .PC(pc),
        .PC0(pc0),
        .IR(ir),
        .IM_Addr(im_addr)
    );

    id1 u_id1(
        .inst(dec_inst),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm32(imm32)
    );

    id2_riusjb u_id2(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(is_r),
        .IS_IMM(is_imm),
        .IS_LUI(is_lui),
        .IS_LW(is_lw),
        .IS_SW(is_sw),
        .IS_BEQ(is_beq),
        .IS_JAL(is_jal),
        .IS_JALR(is_jalr),
        .ALU_OP(alu_op)
    );

    cu_riusjb u_cu(
        .clk(clk),
        .rst_n(rst_n),
        .IS_R(is_r),
        .IS_IMM(is_imm),
        .IS_LUI(is_lui),
        .IS_LW(is_lw),
        .IS_SW(is_sw),
        .IS_BEQ(is_beq),
        .IS_JAL(is_jal),
        .IS_JALR(is_jalr),
        .ALU_OP(alu_op),
        .ZF(FR[3]),
        .Reg_Write(reg_write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .Mem_Write(mem_write),
        .PC_Write(pc_write),
        .IR_Write(ir_write),
        .PC0_Write(pc0_write),
        .PC_s(pc_s),
        .ALU_OP_o(alu_op_o),
        .ST(debug_st)
    );

    regs u_regs(
        .clk(clk),
        .rst_n(rst_n),
        .Reg_Write(reg_write),
        .R_Addr_A(rs1),
        .R_Addr_B(rs2),
        .W_Addr(rd),
        .W_Data(w_data),
        .R_Data_A(r_data_a),
        .R_Data_B(r_data_b)
    );

    assign alu_b = rs2_imm_s ? imm32 : B;

    alu u_alu(
        .A(A),
        .B(alu_b),
        .ALU_OP(alu_op_o),
        .F(alu_f),
        .FR(alu_fr)
    );

    data_mem u_dm(
        .clk(clk),
        .Mem_Write(mem_write),
        .addr(F[7:2]),
        .wdata(B),
        .rdata(dm_r_data)
    );

    assign w_data = (w_data_s == 2'b00) ? F :
                    (w_data_s == 2'b01) ? imm32 :
                    (w_data_s == 2'b10) ? MDR : pc;

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            A   <= 32'h0000_0000;
            B   <= 32'h0000_0000;
            F   <= 32'h0000_0000;
            MDR <= 32'h0000_0000;
            FR  <= 4'b0000;
        end else begin
            if (debug_st == 4'd2) begin
                A <= r_data_a;
                B <= r_data_b;
            end
            if ((debug_st == 4'd3) || (debug_st == 4'd5) ||
                (debug_st == 4'd7) || (debug_st == 4'd13)) begin
                F  <= alu_f;
                FR <= alu_fr;
            end
            if (debug_st == 4'd8)
                MDR <= dm_r_data;
        end
    end

    assign debug_pc     = pc;
    assign debug_pc0    = pc0;
    assign debug_ir     = ir;
    assign debug_w_data = w_data;
    assign debug_mdr    = MDR;
    assign debug_f      = F;
    assign debug_a      = A;
    assign debug_b      = B;
    assign debug_fr     = FR;
endmodule
