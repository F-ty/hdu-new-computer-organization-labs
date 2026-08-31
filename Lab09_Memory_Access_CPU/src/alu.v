`timescale 1ns / 1ps

// RV32I ALU used by Experiment 9.
// ALU_OP mapping follows the course material:
// 0000 ADD, 1000 SUB, 0001 SLL, 0010 SLT, 0011 SLTU,
// 0100 XOR, 0101 SRL, 1101 SRA, 0110 OR, 0111 AND.
module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] y,
    output reg          zf,
    output reg          sf,
    output reg          cf,
    output reg          of
);
    reg [32:0] ext;

    always @(*) begin
        y   = 32'b0;
        ext = 33'b0;
        cf  = 1'b0;
        of  = 1'b0;

        case (alu_op)
            4'b0000: begin // ADD
                ext = {1'b0, a} + {1'b0, b};
                y   = ext[31:0];
                cf  = ext[32];
                of  = (~(a[31] ^ b[31])) & (y[31] ^ a[31]);
            end

            4'b1000: begin // SUB
                ext = {1'b0, a} + {1'b0, ~b} + 33'b1;
                y   = ext[31:0];
                cf  = ext[32]; // 1 means no unsigned borrow
                of  = (a[31] ^ b[31]) & (y[31] ^ a[31]);
            end

            4'b0001: y = a << b[4:0];
            4'b0010: y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'b0011: y = (a < b) ? 32'd1 : 32'd0;
            4'b0100: y = a ^ b;
            4'b0101: y = a >> b[4:0];
            4'b1101: y = $signed(a) >>> b[4:0];
            4'b0110: y = a | b;
            4'b0111: y = a & b;
            default: y = 32'b0;
        endcase

        zf = (y == 32'b0);
        sf = y[31];
    end
endmodule
