`timescale 1ns / 1ps

module alu(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALU_OP,
    output reg  [31:0] F,
    output wire [3:0]  FR
);
    wire [32:0] add_ext;
    wire [32:0] sub_ext;
    wire add_ov;
    wire sub_ov;

    assign add_ext = {1'b0, A} + {1'b0, B};
    assign sub_ext = {1'b0, A} - {1'b0, B};
    assign add_ov = (A[31] == B[31]) && (F[31] != A[31]);
    assign sub_ov = (A[31] != B[31]) && (F[31] != A[31]);

    always @(*) begin
        case (ALU_OP)
            4'b0000: F = A + B;                                  // add, addi
            4'b1000: F = A - B;                                  // sub
            4'b0001: F = A << B[4:0];                            // sll, slli
            4'b0010: F = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // slt, slti
            4'b0011: F = (A < B) ? 32'd1 : 32'd0;                // sltu, sltiu
            4'b0100: F = A ^ B;                                  // xor, xori
            4'b0101: F = A >> B[4:0];                            // srl, srli
            4'b1101: F = $signed(A) >>> B[4:0];                  // sra, srai
            4'b0110: F = A | B;                                  // or, ori
            4'b0111: F = A & B;                                  // and, andi
            default: F = 32'h0000_0000;
        endcase
    end

    // FR[3:0] = {ZF, SF, CF, OF}
    assign FR[3] = (F == 32'h0000_0000);
    assign FR[2] = F[31];
    assign FR[1] = (ALU_OP == 4'b1000) ? ~sub_ext[32] : add_ext[32];
    assign FR[0] = (ALU_OP == 4'b1000) ? sub_ov : add_ov;
endmodule
