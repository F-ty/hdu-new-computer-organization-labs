`timescale 1ns/1ps

module rv32i_branch_cond(
    input  wire [2:0] funct3,
    input  wire       n_flag,
    input  wire       z_flag,
    input  wire       c_flag,
    input  wire       v_flag,
    output reg        condition_true
);
    always @(*) begin
        case (funct3)
            3'b000: condition_true = z_flag;                 // beq
            3'b001: condition_true = ~z_flag;                // bne
            3'b100: condition_true = n_flag ^ v_flag;        // blt
            3'b101: condition_true = ~(n_flag ^ v_flag);     // bge
            3'b110: condition_true = ~c_flag;                // bltu
            3'b111: condition_true = c_flag;                 // bgeu
            default: condition_true = 1'b0;
        endcase
    end
endmodule
