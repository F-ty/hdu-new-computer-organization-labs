`timescale 1ns/1ps
`include "rv32i_defs.vh"

module rv32i_decoder(
    input  wire [31:0] inst,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    output reg          is_r,
    output reg          is_imm,
    output reg          is_lui,
    output reg          is_auipc,
    output reg          is_load,
    output reg          is_store,
    output reg          is_branch,
    output reg          is_jal,
    output reg          is_jalr,
    output reg  [3:0]   alu_op,
    output reg  [1:0]   mem_size,
    output reg          load_unsigned,
    output reg          valid
);
    wire [6:0] opcode = inst[6:0];

    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    always @(*) begin
        is_r          = 1'b0;
        is_imm        = 1'b0;
        is_lui        = 1'b0;
        is_auipc      = 1'b0;
        is_load       = 1'b0;
        is_store      = 1'b0;
        is_branch     = 1'b0;
        is_jal        = 1'b0;
        is_jalr       = 1'b0;
        alu_op        = `ALU_ADD;
        mem_size      = 2'b10;
        load_unsigned = 1'b0;
        valid         = 1'b1;

        case (opcode)
            7'b0110011: begin
                is_r = 1'b1;
                case (funct3)
                    3'b000: alu_op = funct7[5] ? `ALU_SUB : `ALU_ADD;
                    3'b001: alu_op = `ALU_SLL;
                    3'b010: alu_op = `ALU_SLT;
                    3'b011: alu_op = `ALU_SLTU;
                    3'b100: alu_op = `ALU_XOR;
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;
                    3'b110: alu_op = `ALU_OR;
                    3'b111: alu_op = `ALU_AND;
                    default: begin alu_op = `ALU_ADD; valid = 1'b0; end
                endcase
            end

            7'b0010011: begin
                is_imm = 1'b1;
                case (funct3)
                    3'b000: alu_op = `ALU_ADD;
                    3'b001: alu_op = `ALU_SLL;
                    3'b010: alu_op = `ALU_SLT;
                    3'b011: alu_op = `ALU_SLTU;
                    3'b100: alu_op = `ALU_XOR;
                    3'b101: alu_op = inst[30] ? `ALU_SRA : `ALU_SRL;
                    3'b110: alu_op = `ALU_OR;
                    3'b111: alu_op = `ALU_AND;
                    default: begin alu_op = `ALU_ADD; valid = 1'b0; end
                endcase
            end

            7'b0110111: is_lui   = 1'b1;
            7'b0010111: is_auipc = 1'b1;

            7'b0000011: begin
                is_load = 1'b1;
                case (funct3)
                    3'b000: begin mem_size = 2'b00; load_unsigned = 1'b0; end // lb
                    3'b001: begin mem_size = 2'b01; load_unsigned = 1'b0; end // lh
                    3'b010: begin mem_size = 2'b10; load_unsigned = 1'b0; end // lw
                    3'b100: begin mem_size = 2'b00; load_unsigned = 1'b1; end // lbu
                    3'b101: begin mem_size = 2'b01; load_unsigned = 1'b1; end // lhu
                    default: begin mem_size = 2'b10; valid = 1'b0; end
                endcase
            end

            7'b0100011: begin
                is_store = 1'b1;
                case (funct3)
                    3'b000: mem_size = 2'b00; // sb
                    3'b001: mem_size = 2'b01; // sh
                    3'b010: mem_size = 2'b10; // sw
                    default: begin mem_size = 2'b10; valid = 1'b0; end
                endcase
            end

            7'b1100011: begin
                is_branch = 1'b1;
                case (funct3)
                    3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111: ;
                    default: valid = 1'b0;
                endcase
            end

            7'b1101111: is_jal = 1'b1;

            7'b1100111: begin
                is_jalr = (funct3 == 3'b000);
                valid   = (funct3 == 3'b000);
            end

            default: valid = 1'b0;
        endcase
    end
endmodule
