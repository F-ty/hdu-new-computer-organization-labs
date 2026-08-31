`timescale 1ns / 1ps

module id1(
    input  wire [31:0] inst,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [6:0]  opcode,
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    output reg  [31:0] imm32
);
    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    always @(*) begin
        case (opcode)
            7'b0110111: imm32 = {inst[31:12], 12'b0};             // U 型 lui
            7'b0010011: imm32 = {{20{inst[31]}}, inst[31:20]};    // I 型运算
            default:    imm32 = 32'h0000_0000;
        endcase
    end
endmodule
