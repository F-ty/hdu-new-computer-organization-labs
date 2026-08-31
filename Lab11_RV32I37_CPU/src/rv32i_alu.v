`timescale 1ns/1ps
`include "rv32i_defs.vh"

module rv32i_alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] result,
    output reg         n_flag,
    output reg         z_flag,
    output reg         c_flag,
    output reg         v_flag
);
    reg [32:0] temp;

    always @(*) begin
        result = 32'b0;
        temp   = 33'b0;
        c_flag = 1'b0;
        v_flag = 1'b0;

        case (alu_op)
            `ALU_ADD: begin
                temp   = {1'b0, a} + {1'b0, b};
                result = temp[31:0];
                c_flag = temp[32];
                v_flag = (~(a[31] ^ b[31])) & (result[31] ^ a[31]);
            end
            `ALU_SUB: begin
                // A + (~B) + 1. C=1 means no unsigned borrow.
                temp   = {1'b0, a} + {1'b0, ~b} + 33'd1;
                result = temp[31:0];
                c_flag = temp[32];
                v_flag = (a[31] ^ b[31]) & (result[31] ^ a[31]);
            end
            `ALU_SLL:  result = a << b[4:0];
            `ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            `ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
            `ALU_XOR:  result = a ^ b;
            `ALU_SRL:  result = a >> b[4:0];
            `ALU_SRA:  result = $signed(a) >>> b[4:0];
            `ALU_OR:   result = a | b;
            `ALU_AND:  result = a & b;
            default:   result = 32'b0;
        endcase

        n_flag = result[31];
        z_flag = (result == 32'b0);
    end
endmodule
