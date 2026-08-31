`timescale 1ns / 1ps

module TOP(
    input clk,
    input [21:0] sw,
    input [3:0] btn,
    output [3:0] led,
    output [7:0] an,
    output [7:0] seg
);

    wire rst_pulse;
    wire rr_pulse;
    wire f_pulse;
    wire wb_pulse;

    wire [4:0] R_Addr_A;
    wire [4:0] R_Addr_B;
    wire [4:0] W_Addr;
    wire [3:0] ALU_OP;
    wire Reg_Write;
    wire [1:0] Out_Sel;

    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] F;
    wire [3:0] FR;
    wire [31:0] R_Data_A_live;
    wire [31:0] R_Data_B_live;

    reg [31:0] Display_Data;

    ButtonPulse u_btn0(
        .clk(clk),
        .btn(btn[0]),
        .pulse(rst_pulse)
    );

    ButtonPulse u_btn1(
        .clk(clk),
        .btn(btn[1]),
        .pulse(rr_pulse)
    );

    ButtonPulse u_btn2(
        .clk(clk),
        .btn(btn[2]),
        .pulse(f_pulse)
    );

    ButtonPulse u_btn3(
        .clk(clk),
        .btn(btn[3]),
        .pulse(wb_pulse)
    );

    assign R_Addr_A = sw[4:0];
    assign R_Addr_B = sw[9:5];
    assign W_Addr   = sw[14:10];
    assign ALU_OP   = sw[18:15];
    assign Reg_Write = sw[19];
    assign Out_Sel = sw[21:20];

    Operator_Core u_core(
        .clk(clk),
        .rst(rst_pulse),
        .rr_en(rr_pulse),
        .f_en(f_pulse),
        .wb_en(wb_pulse),
        .Reg_Write(Reg_Write),
        .R_Addr_A(R_Addr_A),
        .R_Addr_B(R_Addr_B),
        .W_Addr(W_Addr),
        .ALU_OP(ALU_OP),
        .A(A),
        .B(B),
        .F(F),
        .FR(FR),
        .R_Data_A_live(R_Data_A_live),
        .R_Data_B_live(R_Data_B_live)
    );

    always @(*) begin
        case (Out_Sel)
            2'b00: Display_Data = A;
            2'b01: Display_Data = B;
            2'b10: Display_Data = F;
            2'b11: Display_Data = R_Data_A_live;
            default: Display_Data = F;
        endcase
    end

    assign led = FR;

    SevenSeg8 u_display(
        .clk(clk),
        .data(Display_Data),
        .an(an),
        .seg(seg)
    );

endmodule