module TOP (
    input rst,
    input clk,
    input clk_A,
    input clk_B,
    input clk_F,
    input [31:0] data,
    output [3:0] leds,
    output [7:0] which,
    output [7:0] seg
);

    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] F;
    wire [3:0] FR;

    ALU_REG u_alu_reg (
        .clk(clk),
        .ALU_OP(data[3:0]),
        .Data_A(data),
        .Data_B(data),
        .rst(rst),
        .clk_A(clk_A),
        .clk_B(clk_B),
        .clk_F(clk_F),
        .A(A),
        .B(B),
        .F(F),
        .FR(FR)
    );

    DISPLAY u_display (
        .clk(clk),
        .data(F),
        .which(which),
        .seg(seg)
    );

    assign leds = FR;

endmodule