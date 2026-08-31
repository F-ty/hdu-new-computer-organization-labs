`timescale 1ns/1ps
`include "rv32i_defs.vh"

module rv32i_controller(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ce,
    input  wire       is_r,
    input  wire       is_imm,
    input  wire       is_lui,
    input  wire       is_auipc,
    input  wire       is_load,
    input  wire       is_store,
    input  wire       is_branch,
    input  wire       is_jal,
    input  wire       is_jalr,
    input  wire       valid,
    input  wire       branch_condition,
    input  wire [3:0] decoded_alu_op,
    output reg  [4:0] state,
    output reg        pc_write,
    output reg  [1:0] pc_sel,
    output reg        pc0_write,
    output reg        ir_write,
    output reg        ab_write,
    output reg        aluout_write,
    output reg        mdr_write,
    output reg        reg_write,
    output reg        mem_write,
    output reg        flag_write,
    output reg        alu_src_imm,
    output reg  [3:0] alu_op_ctrl,
    output reg  [2:0] wdata_sel
);
    reg [4:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= `ST_FETCH;
        else if (ce)
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            `ST_FETCH: next_state = `ST_DECODE;

            `ST_DECODE: begin
                if (!valid)                 next_state = `ST_FETCH;
                else if (is_r || is_imm)    next_state = `ST_EXEC_ALU;
                else if (is_lui)            next_state = `ST_WB_LUI;
                else if (is_auipc)          next_state = `ST_WB_AUIPC;
                else if (is_load || is_store || is_jalr)
                                            next_state = `ST_EXEC_ADDR;
                else if (is_branch)         next_state = `ST_BRANCH;
                else if (is_jal)            next_state = `ST_JAL;
                else                        next_state = `ST_FETCH;
            end

            `ST_EXEC_ALU:  next_state = `ST_WB_ALU;
            `ST_WB_ALU:    next_state = `ST_FETCH;
            `ST_WB_LUI:    next_state = `ST_FETCH;
            `ST_WB_AUIPC:  next_state = `ST_FETCH;

            `ST_EXEC_ADDR: begin
                if (is_load)       next_state = `ST_MEM_RD;
                else if (is_store) next_state = `ST_MEM_WR;
                else if (is_jalr)  next_state = `ST_JALR;
                else               next_state = `ST_FETCH;
            end

            `ST_MEM_RD:   next_state = `ST_WB_LOAD;
            `ST_WB_LOAD: next_state = `ST_FETCH;
            `ST_MEM_WR:  next_state = `ST_FETCH;
            `ST_JAL:     next_state = `ST_FETCH;
            `ST_JALR:    next_state = `ST_FETCH;
            `ST_BRANCH:  next_state = `ST_FETCH;
            default:     next_state = `ST_FETCH;
        endcase
    end

    always @(*) begin
        pc_write     = 1'b0;
        pc_sel       = `PC_PLUS4;
        pc0_write    = 1'b0;
        ir_write     = 1'b0;
        ab_write     = 1'b0;
        aluout_write = 1'b0;
        mdr_write    = 1'b0;
        reg_write    = 1'b0;
        mem_write    = 1'b0;
        flag_write   = 1'b0;
        alu_src_imm  = 1'b0;
        alu_op_ctrl  = decoded_alu_op;
        wdata_sel    = `WDATA_ALUOUT;

        case (state)
            `ST_FETCH: begin
                pc_write  = 1'b1;
                pc_sel    = `PC_PLUS4;
                pc0_write = 1'b1;
                ir_write  = 1'b1;
            end

            `ST_DECODE: begin
                ab_write = 1'b1;
            end

            `ST_EXEC_ALU: begin
                aluout_write = 1'b1;
                flag_write   = 1'b1;
                alu_src_imm  = is_imm;
                alu_op_ctrl  = decoded_alu_op;
            end

            `ST_WB_ALU: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_ALUOUT;
            end

            `ST_WB_LUI: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_IMMU;
            end

            `ST_WB_AUIPC: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_AUIPC;
            end

            `ST_EXEC_ADDR: begin
                aluout_write = 1'b1;
                alu_src_imm  = 1'b1;
                alu_op_ctrl  = `ALU_ADD;
            end

            `ST_MEM_RD: begin
                mdr_write = 1'b1;
            end

            `ST_WB_LOAD: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_MDR;
            end

            `ST_MEM_WR: begin
                mem_write = 1'b1;
            end

            `ST_JAL: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_PC;
                pc_write  = 1'b1;
                pc_sel    = `PC_RELATIVE;
            end

            `ST_JALR: begin
                reg_write = 1'b1;
                wdata_sel = `WDATA_PC;
                pc_write  = 1'b1;
                pc_sel    = `PC_ALUOUT;
            end

            `ST_BRANCH: begin
                alu_op_ctrl = `ALU_SUB;
                flag_write  = 1'b1;
                pc_write    = branch_condition;
                pc_sel      = `PC_RELATIVE;
            end

            default: ;
        endcase
    end
endmodule
