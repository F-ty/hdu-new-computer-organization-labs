`timescale 1ns / 1ps

// Second-level decoder. It classifies the 22 supported instructions
// and produces the ALU function code for R/I arithmetic instructions.
module instruction_type_decoder (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg         is_r,
    output reg         is_imm,
    output reg         is_lui,
    output reg         is_lw,
    output reg         is_sw,
    output reg         valid,
    output reg  [3:0]  alu_op
);
    always @(*) begin
        is_r    = 1'b0;
        is_imm  = 1'b0;
        is_lui  = 1'b0;
        is_lw   = 1'b0;
        is_sw   = 1'b0;
        valid   = 1'b0;
        alu_op  = 4'b0000;

        case (opcode)
            7'b0110011: begin // R-type arithmetic
                is_r   = 1'b1;
                valid  = 1'b1;
                alu_op = {funct7[5], funct3};
            end

            7'b0010011: begin // I-type arithmetic
                is_imm = 1'b1;
                valid  = 1'b1;
                if (funct3 == 3'b101)
                    alu_op = {funct7[5], funct3};
                else
                    alu_op = {1'b0, funct3};
            end

            7'b0110111: begin // lui
                is_lui = 1'b1;
                valid  = 1'b1;
            end

            7'b0000011: begin // lw only
                if (funct3 == 3'b010) begin
                    is_lw = 1'b1;
                    valid = 1'b1;
                end
            end

            7'b0100011: begin // sw only
                if (funct3 == 3'b010) begin
                    is_sw = 1'b1;
                    valid = 1'b1;
                end
            end

            default: begin
                valid = 1'b0;
            end
        endcase
    end
endmodule
