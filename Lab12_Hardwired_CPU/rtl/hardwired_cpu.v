module hardwired_cpu(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        pos_ce,
    input  wire        neg_ce,
    input  wire [4:0]  dbg_reg_addr,
    output wire [31:0] dbg_reg_data,
    output wire [31:0] dbg_mem0,
    output wire [31:0] pc_o,
    output wire [31:0] pc0_o,
    output wire [31:0] ir_o,
    output wire [31:0] a_o,
    output wire [31:0] b_o,
    output wire [31:0] f_o,
    output wire [31:0] mdr_o,
    output wire [31:0] w_data_o,
    output wire [3:0]  fr_o,
    output wire [4:0]  m_o
);
    reg [31:0] pc;
    reg [31:0] pc0;
    reg [31:0] ir;
    reg [31:0] a_latch;
    reg [31:0] b_latch;
    reg [31:0] f_latch;
    reg [31:0] mdr;
    reg [3:0]  fr;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm32;

    wire is_r;
    wire is_imm;
    wire is_lui;
    wire is_lw;
    wire is_sw;
    wire is_beq;
    wire is_jal;
    wire is_jalr;
    wire [3:0] alu_op_dec;

    wire [4:0] m;
    wire pc_write;
    wire pc0_write;
    wire ir_write;
    wire reg_write;
    wire mem_write;
    wire rs2_imm_s;
    wire [1:0] w_data_s;
    wire [1:0] pc_s;
    wire [3:0] alu_op;

    wire [31:0] rom_data;
    wire [31:0] rdata_a;
    wire [31:0] rdata_b;
    wire [31:0] alu_b;
    wire [31:0] alu_y;
    wire [3:0]  alu_fr;
    wire [31:0] dm_rdata;
    wire [31:0] w_data;
    wire [31:0] pc_next;
    wire zf = fr[2];

    instruction_rom u_im(
        .addr(pc),
        .data(rom_data)
    );

    id1_decode u_id1(
        .inst(ir),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .imm32(imm32)
    );

    id2_decode u_id2(
        .opcode(opcode), .funct3(funct3), .funct7(funct7),
        .is_r(is_r), .is_imm(is_imm), .is_lui(is_lui),
        .is_lw(is_lw), .is_sw(is_sw), .is_beq(is_beq),
        .is_jal(is_jal), .is_jalr(is_jalr),
        .alu_op(alu_op_dec)
    );

    tsu u_tsu(
        .clk(clk), .rst_n(rst_n), .neg_ce(neg_ce),
        .is_lui(is_lui), .is_lw(is_lw), .is_sw(is_sw), .is_jal(is_jal),
        .m(m)
    );

    hardwired_cu u_cu(
        .m(m),
        .is_r(is_r), .is_imm(is_imm), .is_lui(is_lui),
        .is_lw(is_lw), .is_sw(is_sw), .is_beq(is_beq),
        .is_jal(is_jal), .is_jalr(is_jalr),
        .zf(zf), .alu_op_i(alu_op_dec),
        .pc_write(pc_write), .pc0_write(pc0_write), .ir_write(ir_write),
        .reg_write(reg_write), .mem_write(mem_write),
        .rs2_imm_s(rs2_imm_s), .w_data_s(w_data_s), .pc_s(pc_s),
        .alu_op_o(alu_op)
    );

    regfile32 u_regs(
        .clk(clk), .rst_n(rst_n),
        .we(pos_ce & reg_write),
        .raddr_a(rs1), .raddr_b(rs2),
        .waddr(rd), .wdata(w_data),
        .dbg_addr(dbg_reg_addr),
        .rdata_a(rdata_a), .rdata_b(rdata_b), .dbg_data(dbg_reg_data)
    );

    assign alu_b = rs2_imm_s ? imm32 : b_latch;

    alu32 u_alu(
        .a(a_latch), .b(alu_b), .alu_op(alu_op),
        .y(alu_y), .fr(alu_fr)
    );

    data_memory u_dm(
        .clk(clk),
        .we(pos_ce & mem_write),
        .addr(f_latch),
        .wdata(b_latch),
        .rdata(dm_rdata),
        .dbg_mem0(dbg_mem0)
    );

    // 写回数据选择
    assign w_data = (w_data_s == 2'b00) ? f_latch :
                    (w_data_s == 2'b01) ? imm32  :
                    (w_data_s == 2'b10) ? mdr    : pc;

    // PC 输入选择。jalr 按规范将最低位置 0。
    assign pc_next = (pc_s == 2'b00) ? (pc + 32'd4) :
                     (pc_s == 2'b01) ? (pc0 + imm32) :
                     (pc_s == 2'b10) ? {f_latch[31:1], 1'b0} : pc;

    // 模拟教材中的 CPU 时钟上跳沿操作。
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc      <= 32'b0;
            pc0     <= 32'b0;
            ir      <= 32'h00000013;
            a_latch <= 32'b0;
            b_latch <= 32'b0;
            f_latch <= 32'b0;
            fr      <= 4'b0;
        end else if (pos_ce) begin
            if (pc0_write)
                pc0 <= pc;
            if (ir_write)
                ir <= rom_data;
            if (pc_write)
                pc <= pc_next;

            if (m[1]) begin // M1：读寄存器并打入 A、B
                a_latch <= rdata_a;
                b_latch <= rdata_b;
            end

            if (m[2]) begin // M2：执行 ALU 运算并更新标志
                f_latch <= alu_y;
                fr      <= alu_fr;
            end
        end
    end

    // 模拟教材中的 CPU 时钟下跳沿操作：lw 的读数据打入 MDR。
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mdr <= 32'b0;
        else if (neg_ce && m[3] && is_lw)
            mdr <= dm_rdata;
    end

    assign pc_o     = pc;
    assign pc0_o    = pc0;
    assign ir_o     = ir;
    assign a_o      = a_latch;
    assign b_o      = b_latch;
    assign f_o      = f_latch;
    assign mdr_o    = mdr;
    assign w_data_o = w_data;
    assign fr_o     = fr;
    assign m_o      = m;
endmodule
