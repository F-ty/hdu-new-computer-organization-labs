module hardwired_cu(
    input  wire [4:0] m,
    input  wire       is_r,
    input  wire       is_imm,
    input  wire       is_lui,
    input  wire       is_lw,
    input  wire       is_sw,
    input  wire       is_beq,
    input  wire       is_jal,
    input  wire       is_jalr,
    input  wire       zf,
    input  wire [3:0] alu_op_i,
    output wire       pc_write,
    output wire       pc0_write,
    output wire       ir_write,
    output wire       reg_write,
    output wire       mem_write,
    output wire       rs2_imm_s,
    output wire [1:0] w_data_s,
    output wire [1:0] pc_s,
    output wire [3:0] alu_op_o
);
    wire m0 = m[0];
    wire m2 = m[2];
    wire m3 = m[3];
    wire m4 = m[4];

    // 写使能信号的多积项逻辑函数
    assign pc_write  = m0 |
                       (m4 & is_jal) |
                       (m4 & is_jalr) |
                       (m4 & is_beq & zf);
    assign pc0_write = m0;
    assign ir_write  = m0;
    assign reg_write = m4 & (is_r | is_imm | is_lui | is_lw | is_jal | is_jalr);
    assign mem_write = m3 & is_sw;

    // 多路选择器控制信号
    assign rs2_imm_s = m2 & (is_imm | is_lw | is_sw | is_jalr);

    // W_Data: 00=F, 01=imm32, 10=MDR, 11=PC(即 PC0+4)
    assign w_data_s[1] = m4 & (is_lw | is_jal | is_jalr);
    assign w_data_s[0] = m4 & (is_lui | is_jal | is_jalr);

    // PC: 00=PC+4, 01=PC0+imm32, 10=F。M0 必须保持 00。
    assign pc_s[1] = m4 & is_jalr;
    assign pc_s[0] = m4 & (is_jal | (is_beq & zf));

    assign alu_op_o = alu_op_i;
endmodule
