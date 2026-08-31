`timescale 1ns / 1ps

module ALU(
    input [31:0] ALU_A,
    input [31:0] ALU_B,
    input [3:0] ALU_OP,
    output reg [31:0] ALU_F,
    output reg ZF,
    output reg SF,
    output reg CF,
    output reg OF
);

    reg [32:0] temp;

    always @(*) begin
        temp = 33'h0;
        ALU_F = 32'h0000_0000;
        CF = 1'b0;
        OF = 1'b0;

        case (ALU_OP)
            4'b0000: begin
                temp = {1'b0, ALU_A} + {1'b0, ALU_B};
                ALU_F = temp[31:0];
                CF = temp[32];
                OF = (ALU_A[31] == ALU_B[31]) && (ALU_F[31] != ALU_A[31]);
            end

            4'b0001: begin
                ALU_F = ALU_A << ALU_B[4:0];
            end

            4'b0010: begin
                ALU_F = ($signed(ALU_A) < $signed(ALU_B)) ? 32'h0000_0001 : 32'h0000_0000;
            end

            4'b0011: begin
                ALU_F = (ALU_A < ALU_B) ? 32'h0000_0001 : 32'h0000_0000;
            end

            4'b0100: begin
                ALU_F = ALU_A ^ ALU_B;
            end

            4'b0101: begin
                ALU_F = ALU_A >> ALU_B[4:0];
            end

            4'b0110: begin
                ALU_F = ALU_A | ALU_B;
            end

            4'b0111: begin
                ALU_F = ALU_A & ALU_B;
            end

            4'b1000: begin
                temp = {1'b0, ALU_A} - {1'b0, ALU_B};
                ALU_F = temp[31:0];
                CF = (ALU_A < ALU_B);
                OF = (ALU_A[31] != ALU_B[31]) && (ALU_F[31] != ALU_A[31]);
            end

            4'b1101: begin
                ALU_F = $signed(ALU_A) >>> ALU_B[4:0];
            end

            default: begin
                ALU_F = 32'h0000_0000;
            end
        endcase

        ZF = (ALU_F == 32'h0000_0000);
        SF = ALU_F[31];
    end

endmodule