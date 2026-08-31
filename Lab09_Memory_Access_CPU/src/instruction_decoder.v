`timescale 1ns / 1ps

// First-level instruction decoder and immediate generator.
module instruction_decoder (
    input  wire [31:0] inst,
    output wire [6:0]  opcode,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [6:0]  funct7,
    output reg  [31:0] imm32
);
    wire [31:0] imm_i;
    wire [31:0] imm_s;
    wire [31:0] imm_u;

    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    assign imm_i = {{20{inst[31]}}, inst[31:20]};
    assign imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};
    assign imm_u = {inst[31:12], 12'b0};

    always @(*) begin
        case (opcode)
            7'b0010011, // I-type arithmetic
            7'b0000011: imm32 = imm_i; // lw
            7'b0100011: imm32 = imm_s; // sw
            7'b0110111: imm32 = imm_u; // lui
            default:    imm32 = 32'b0;
        endcase
    end
endmodule
