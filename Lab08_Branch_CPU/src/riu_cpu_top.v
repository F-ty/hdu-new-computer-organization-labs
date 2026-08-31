`timescale 1ns / 1ps

module riu_cpu_top(
    input  wire        CLK100MHZ,
    input  wire        BT0,
    input  wire        BT3,
    input  wire [2:0]  SW,
    output wire [7:0]  AN,
    output wire [7:0]  SEG,
    output wire [7:0]  LD
);
    wire rst_n;
    wire step_pulse;
    wire [31:0] PC;
    wire [31:0] IR;
    wire [31:0] W_Data;
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] F;
    wire [3:0]  FR;
    wire [2:0]  ST;
    wire [31:0] imm32_dbg;
    wire [3:0]  ALU_OP_dbg;
    reg  [31:0] disp_data;

    // HCS-A02 按键按下为 1。BT3 按下时复位，因此转换为低有效 rst_n。
    assign rst_n = ~BT3;

    btn_edge U_STEP_EDGE(
        .clk(CLK100MHZ),
        .rst_n(rst_n),
        .btn(BT0),
        .pulse(step_pulse)
    );

    riu_cpu U_CPU(
        .clk(CLK100MHZ),
        .rst_n(rst_n),
        .step_en(step_pulse),
        .PC(PC),
        .IR(IR),
        .W_Data(W_Data),
        .A(A),
        .B(B),
        .F(F),
        .FR(FR),
        .ST(ST),
        .imm32_dbg(imm32_dbg),
        .ALU_OP_dbg(ALU_OP_dbg)
    );

    always @(*) begin
        case (SW)
            3'b000: disp_data = PC;
            3'b001: disp_data = IR;
            3'b010: disp_data = W_Data;
            3'b011: disp_data = F;
            3'b100: disp_data = A;
            3'b101: disp_data = B;
            3'b110: disp_data = {28'h0, FR};
            3'b111: disp_data = {24'h0, 1'b0, ST, ALU_OP_dbg};
            default: disp_data = PC;
        endcase
    end

    seg7_hex8 U_SEG(
        .clk(CLK100MHZ),
        .rst_n(rst_n),
        .data(disp_data),
        .AN(AN),
        .SEG(SEG)
    );

    assign LD[3:0] = FR;
    assign LD[6:4] = ST;
    assign LD[7]   = step_pulse;
endmodule
