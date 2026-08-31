`timescale 1ns / 1ps
module id2_riusjb(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire       IS_R,
    output wire       IS_IMM,
    output wire       IS_LUI,
    output wire       IS_LW,
    output wire       IS_SW,
    output wire       IS_BEQ,
    output wire       IS_JAL,
    output wire       IS_JALR,
    output reg  [3:0] ALU_OP
);
    assign IS_R    = (opcode == 7'b0110011);
    assign IS_IMM  = (opcode == 7'b0010011);
    assign IS_LUI  = (opcode == 7'b0110111);
    assign IS_LW   = (opcode == 7'b0000011) && (funct3 == 3'b010);
    assign IS_SW   = (opcode == 7'b0100011) && (funct3 == 3'b010);
    assign IS_BEQ  = (opcode == 7'b1100011) && (funct3 == 3'b000);
    assign IS_JAL  = (opcode == 7'b1101111);
    assign IS_JALR = (opcode == 7'b1100111) && (funct3 == 3'b000);

    always @(*) begin
        if (IS_R) begin
            ALU_OP = {funct7[5], funct3};
        end else if (IS_IMM) begin
            if (funct3 == 3'b101)
                ALU_OP = {funct7[5], funct3};
            else
                ALU_OP = {1'b0, funct3};
        end else if (IS_BEQ) begin
            ALU_OP = 4'b1000;
        end else begin
            ALU_OP = 4'b0000;
        end
    end
endmodule
