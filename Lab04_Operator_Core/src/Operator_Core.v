`timescale 1ns / 1ps

module Operator_Core(
    input clk,
    input rst,
    input rr_en,
    input f_en,
    input wb_en,
    input Reg_Write,
    input [4:0] R_Addr_A,
    input [4:0] R_Addr_B,
    input [4:0] W_Addr,
    input [3:0] ALU_OP,
    output reg [31:0] A,
    output reg [31:0] B,
    output reg [31:0] F,
    output reg [3:0] FR,
    output [31:0] R_Data_A_live,
    output [31:0] R_Data_B_live
);

    wire [31:0] R_Data_A;
    wire [31:0] R_Data_B;
    wire [31:0] ALU_F;
    wire ZF;
    wire SF;
    wire CF;
    wire OF;

    assign R_Data_A_live = R_Data_A;
    assign R_Data_B_live = R_Data_B;

    RegFile u_regs(
        .clk(clk),
        .rst(rst),
        .wb_en(wb_en),
        .Reg_Write(Reg_Write),
        .R_Addr_A(R_Addr_A),
        .R_Addr_B(R_Addr_B),
        .W_Addr(W_Addr),
        .W_Data(F),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );

    ALU u_alu(
        .ALU_A(A),
        .ALU_B(B),
        .ALU_OP(ALU_OP),
        .ALU_F(ALU_F),
        .ZF(ZF),
        .SF(SF),
        .CF(CF),
        .OF(OF)
    );

    always @(posedge clk) begin
        if (rst) begin
            A <= 32'h0000_0000;
            B <= 32'h0000_0000;
            F <= 32'h0000_0000;
            FR <= 4'b0000;
        end
        else begin
            if (rr_en) begin
                A <= R_Data_A;
                B <= R_Data_B;
            end

            if (f_en) begin
                F <= ALU_F;
                FR <= {ZF, SF, CF, OF};
            end
        end
    end

endmodule