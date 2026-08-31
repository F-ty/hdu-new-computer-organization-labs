`timescale 1ns / 1ps
module alu(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALU_OP,
    output reg  [31:0] F,
    output wire [3:0]  FR
);
    reg cf;
    reg of;
    wire [32:0] add_ext = {1'b0, A} + {1'b0, B};
    wire [32:0] sub_ext = {1'b0, A} - {1'b0, B};

    always @(*) begin
        F  = 32'h0000_0000;
        cf = 1'b0;
        of = 1'b0;
        case (ALU_OP)
            4'b0000: begin
                F  = A + B;
                cf = add_ext[32];
                of = (~(A[31] ^ B[31])) & (F[31] ^ A[31]);
            end
            4'b1000: begin
                F  = A - B;
                cf = sub_ext[32];
                of = (A[31] ^ B[31]) & (F[31] ^ A[31]);
            end
            4'b0001: F = A << B[4:0];
            4'b0010: F = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            4'b0011: F = (A < B) ? 32'd1 : 32'd0;
            4'b0100: F = A ^ B;
            4'b0101: F = A >> B[4:0];
            4'b1101: F = $signed(A) >>> B[4:0];
            4'b0110: F = A | B;
            4'b0111: F = A & B;
            default: F = 32'h0000_0000;
        endcase
    end

    assign FR[3] = (F == 32'h0000_0000);  // ZF
    assign FR[2] = cf;                    // CF
    assign FR[1] = of;                    // OF
    assign FR[0] = F[31];                 // SF
endmodule
