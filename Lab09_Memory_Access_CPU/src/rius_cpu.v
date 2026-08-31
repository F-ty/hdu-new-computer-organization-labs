`timescale 1ns / 1ps

// Experiment 9 CPU core: 10 R-type + 9 I-type arithmetic + lui + lw + sw.
module rius_cpu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step_en,

    output wire [31:0] pc_o,
    output wire [31:0] ir_o,
    output wire [31:0] w_data_o,
    output wire [31:0] a_o,
    output wire [31:0] b_o,
    output wire [31:0] f_o,
    output wire [31:0] mdr_o,
    output wire [3:0]  fr_o,
    output wire [3:0]  state_o,
    output wire [3:0]  next_state_o,
    output wire        mem_write_o,
    output wire        reg_write_o
);
    reg [31:0] pc;
    reg [31:0] ir;
    reg [31:0] a_reg;
    reg [31:0] b_reg;
    reg [31:0] f_reg;
    reg [31:0] mdr_reg;
    reg [3:0]  fr_reg;

    wire [31:0] inst_code;
    wire [31:0] reg_rdata_a;
    wire [31:0] reg_rdata_b;
    wire [31:0] dm_rdata;

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    wire [31:0] imm32;

    wire is_r;
    wire is_imm;
    wire is_lui;
    wire is_lw;
    wire is_sw;
    wire valid;
    wire [3:0] alu_op_dec;

    wire pc_write;
    wire ir_write;
    wire ab_write;
    wire f_write;
    wire fr_write;
    wire mdr_write;
    wire reg_write;
    wire mem_write;
    wire rs2_imm_s;
    wire [1:0] w_data_s;
    wire [3:0] alu_op_ctl;
    wire [3:0] state;
    wire [3:0] next_state;

    wire [31:0] alu_b;
    wire [31:0] alu_y;
    wire alu_zf;
    wire alu_sf;
    wire alu_cf;
    wire alu_of;
    reg  [31:0] w_data;

    instruction_memory u_imem (
        .addr  (pc),
        .rdata (inst_code)
    );

    instruction_decoder u_id1 (
        .inst   (ir),
        .opcode (opcode),
        .rd     (rd),
        .funct3 (funct3),
        .rs1    (rs1),
        .rs2    (rs2),
        .funct7 (funct7),
        .imm32  (imm32)
    );

    instruction_type_decoder u_id2 (
        .opcode (opcode),
        .funct3 (funct3),
        .funct7 (funct7),
        .is_r   (is_r),
        .is_imm (is_imm),
        .is_lui (is_lui),
        .is_lw  (is_lw),
        .is_sw  (is_sw),
        .valid  (valid),
        .alu_op (alu_op_dec)
    );

    control_unit u_cu (
        .clk          (clk),
        .rst_n        (rst_n),
        .step_en      (step_en),
        .is_r         (is_r),
        .is_imm       (is_imm),
        .is_lui       (is_lui),
        .is_lw        (is_lw),
        .is_sw        (is_sw),
        .valid        (valid),
        .alu_op_i     (alu_op_dec),
        .pc_write     (pc_write),
        .ir_write     (ir_write),
        .ab_write     (ab_write),
        .f_write      (f_write),
        .fr_write     (fr_write),
        .mdr_write    (mdr_write),
        .reg_write    (reg_write),
        .mem_write    (mem_write),
        .rs2_imm_s    (rs2_imm_s),
        .w_data_s     (w_data_s),
        .alu_op_o     (alu_op_ctl),
        .state        (state),
        .next_state   (next_state)
    );

    reg_file u_regs (
        .clk     (clk),
        .rst_n   (rst_n),
        .step_en (step_en),
        .we      (reg_write),
        .raddr_a (rs1),
        .raddr_b (rs2),
        .waddr   (rd),
        .wdata   (w_data),
        .rdata_a (reg_rdata_a),
        .rdata_b (reg_rdata_b)
    );

    assign alu_b = rs2_imm_s ? imm32 : b_reg;

    alu u_alu (
        .a      (a_reg),
        .b      (alu_b),
        .alu_op (alu_op_ctl),
        .y      (alu_y),
        .zf     (alu_zf),
        .sf     (alu_sf),
        .cf     (alu_cf),
        .of     (alu_of)
    );

    data_memory u_dmem (
        .clk     (clk),
        .step_en (step_en),
        .we      (mem_write),
        .addr    (f_reg),
        .wdata   (b_reg),
        .rdata   (dm_rdata)
    );

    always @(*) begin
        case (w_data_s)
            2'b00: w_data = f_reg;
            2'b01: w_data = imm32;
            2'b10: w_data = mdr_reg;
            default: w_data = 32'b0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc      <= 32'b0;
            ir      <= 32'b0;
            a_reg   <= 32'b0;
            b_reg   <= 32'b0;
            f_reg   <= 32'b0;
            mdr_reg <= 32'b0;
            fr_reg  <= 4'b0;
        end
        else if (step_en) begin
            if (pc_write)
                pc <= pc + 32'd4;
            if (ir_write)
                ir <= inst_code;
            if (ab_write) begin
                a_reg <= reg_rdata_a;
                b_reg <= reg_rdata_b;
            end
            if (f_write)
                f_reg <= alu_y;
            if (fr_write)
                fr_reg <= {alu_zf, alu_sf, alu_cf, alu_of};
            if (mdr_write)
                mdr_reg <= dm_rdata;
        end
    end

    assign pc_o         = pc;
    assign ir_o         = ir;
    assign w_data_o     = w_data;
    assign a_o          = a_reg;
    assign b_o          = b_reg;
    assign f_o          = f_reg;
    assign mdr_o        = mdr_reg;
    assign fr_o         = fr_reg;
    assign state_o      = state;
    assign next_state_o = next_state;
    assign mem_write_o  = mem_write;
    assign reg_write_o  = reg_write;
endmodule
