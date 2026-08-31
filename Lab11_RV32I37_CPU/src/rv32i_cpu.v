`timescale 1ns/1ps
`include "rv32i_defs.vh"

module rv32i_cpu #(
    parameter IMEM_FILE = "program.mem",
    parameter DMEM_FILE = "data.mem"
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        ce,
    output wire [31:0] debug_pc,
    output wire [31:0] debug_pc0,
    output wire [31:0] debug_ir,
    output wire [31:0] debug_a,
    output wire [31:0] debug_b,
    output wire [31:0] debug_aluout,
    output wire [31:0] debug_mdr,
    output wire [31:0] debug_wdata,
    output wire [3:0]  debug_flags,
    output wire [4:0]  debug_state,
    output wire        debug_reg_write,
    output wire        debug_mem_write
);
    reg [31:0] pc;
    reg [31:0] pc0;
    reg [31:0] ir;
    reg [31:0] a_reg;
    reg [31:0] b_reg;
    reg [31:0] aluout_reg;
    reg [31:0] mdr_reg;
    reg [3:0]  flags_reg; // {N,Z,C,V}

    wire [31:0] imem_rdata;
    wire [31:0] dmem_rdata;
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    wire is_r;
    wire is_imm;
    wire is_lui;
    wire is_auipc;
    wire is_load;
    wire is_store;
    wire is_branch;
    wire is_jal;
    wire is_jalr;
    wire [3:0] decoded_alu_op;
    wire [1:0] mem_size;
    wire load_unsigned;
    wire valid;

    wire [31:0] imm_i;
    wire [31:0] imm_s;
    wire [31:0] imm_b;
    wire [31:0] imm_u;
    wire [31:0] imm_j;

    wire [31:0] selected_imm;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire alu_n;
    wire alu_z;
    wire alu_c;
    wire alu_v;
    wire branch_condition;

    wire pc_write;
    wire [1:0] pc_sel;
    wire pc0_write;
    wire ir_write;
    wire ab_write;
    wire aluout_write;
    wire mdr_write;
    wire reg_write;
    wire mem_write;
    wire flag_write;
    wire alu_src_imm;
    wire [3:0] alu_op_ctrl;
    wire [2:0] wdata_sel;
    wire [4:0] state;

    reg [31:0] next_pc_value;
    reg [31:0] wdata;

    assign selected_imm = is_store ? imm_s : imm_i;
    assign alu_b = alu_src_imm ? selected_imm : b_reg;

    always @(*) begin
        case (pc_sel)
            `PC_PLUS4:    next_pc_value = pc + 32'd4;
            `PC_RELATIVE: next_pc_value = pc0 + (is_jal ? imm_j : imm_b);
            `PC_ALUOUT:   next_pc_value = {aluout_reg[31:1], 1'b0};
            default:      next_pc_value = pc + 32'd4;
        endcase
    end

    always @(*) begin
        case (wdata_sel)
            `WDATA_ALUOUT: wdata = aluout_reg;
            `WDATA_IMMU:   wdata = imm_u;
            `WDATA_MDR:    wdata = mdr_reg;
            `WDATA_PC:     wdata = pc;
            `WDATA_AUIPC:  wdata = pc0 + imm_u;
            default:       wdata = 32'b0;
        endcase
    end

    rv32i_imem #(.MEM_FILE(IMEM_FILE)) u_imem (
        .addr(pc),
        .rdata(imem_rdata)
    );

    rv32i_dmem #(.MEM_FILE(DMEM_FILE)) u_dmem (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .we(mem_write),
        .addr(aluout_reg),
        .wdata(b_reg),
        .size(mem_size),
        .load_unsigned(load_unsigned),
        .rdata(dmem_rdata)
    );

    rv32i_regfile u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .we(reg_write),
        .raddr1(rs1),
        .raddr2(rs2),
        .waddr(rd),
        .wdata(wdata),
        .rdata1(reg_rdata1),
        .rdata2(reg_rdata2)
    );

    rv32i_imm_gen u_imm_gen (
        .inst(ir),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b),
        .imm_u(imm_u),
        .imm_j(imm_j)
    );

    rv32i_decoder u_decoder (
        .inst(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .is_r(is_r),
        .is_imm(is_imm),
        .is_lui(is_lui),
        .is_auipc(is_auipc),
        .is_load(is_load),
        .is_store(is_store),
        .is_branch(is_branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .alu_op(decoded_alu_op),
        .mem_size(mem_size),
        .load_unsigned(load_unsigned),
        .valid(valid)
    );

    rv32i_alu u_alu (
        .a(a_reg),
        .b(alu_b),
        .alu_op(alu_op_ctrl),
        .result(alu_result),
        .n_flag(alu_n),
        .z_flag(alu_z),
        .c_flag(alu_c),
        .v_flag(alu_v)
    );

    rv32i_branch_cond u_branch_cond (
        .funct3(funct3),
        .n_flag(alu_n),
        .z_flag(alu_z),
        .c_flag(alu_c),
        .v_flag(alu_v),
        .condition_true(branch_condition)
    );

    rv32i_controller u_controller (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
        .is_r(is_r),
        .is_imm(is_imm),
        .is_lui(is_lui),
        .is_auipc(is_auipc),
        .is_load(is_load),
        .is_store(is_store),
        .is_branch(is_branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .valid(valid),
        .branch_condition(branch_condition),
        .decoded_alu_op(decoded_alu_op),
        .state(state),
        .pc_write(pc_write),
        .pc_sel(pc_sel),
        .pc0_write(pc0_write),
        .ir_write(ir_write),
        .ab_write(ab_write),
        .aluout_write(aluout_write),
        .mdr_write(mdr_write),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .flag_write(flag_write),
        .alu_src_imm(alu_src_imm),
        .alu_op_ctrl(alu_op_ctrl),
        .wdata_sel(wdata_sel)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc         <= 32'b0;
            pc0        <= 32'b0;
            ir         <= 32'h00000013;
            a_reg      <= 32'b0;
            b_reg      <= 32'b0;
            aluout_reg <= 32'b0;
            mdr_reg    <= 32'b0;
            flags_reg  <= 4'b0;
        end else if (ce) begin
            if (pc_write)
                pc <= next_pc_value;
            if (pc0_write)
                pc0 <= pc;
            if (ir_write)
                ir <= imem_rdata;
            if (ab_write) begin
                a_reg <= reg_rdata1;
                b_reg <= reg_rdata2;
            end
            if (aluout_write)
                aluout_reg <= alu_result;
            if (mdr_write)
                mdr_reg <= dmem_rdata;
            if (flag_write)
                flags_reg <= {alu_n, alu_z, alu_c, alu_v};
        end
    end

    assign debug_pc        = pc;
    assign debug_pc0       = pc0;
    assign debug_ir        = ir;
    assign debug_a         = a_reg;
    assign debug_b         = b_reg;
    assign debug_aluout    = aluout_reg;
    assign debug_mdr       = mdr_reg;
    assign debug_wdata     = wdata;
    assign debug_flags     = flags_reg;
    assign debug_state     = state;
    assign debug_reg_write = reg_write;
    assign debug_mem_write = mem_write;
endmodule
