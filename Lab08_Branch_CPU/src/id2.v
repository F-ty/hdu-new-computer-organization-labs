`timescale 1ns / 1ps

module id2(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire       IS_R,
    output wire       IS_IMM,
    output wire       IS_LUI,
    output reg  [3:0] ALU_OP
);
    assign IS_R   = (opcode == 7'b0110011);
    assign IS_IMM = (opcode == 7'b0010011);
    assign IS_LUI = (opcode == 7'b0110111);

    always @(*) begin
        if (IS_R) begin
            ALU_OP = {funct7[5], funct3};
        end else if (IS_IMM) begin
            if (funct3 == 3'b101) begin
                ALU_OP = {funct7[5], funct3};
            end else begin
                ALU_OP = {1'b0, funct3};
            end
        end else begin
            ALU_OP = 4'b0000;
        end
    end
endmodule
