`timescale 1ns / 1ps
module top_riusjb_board(
    input  wire        clk_100mhz,
    input  wire        rst_btn,
    input  wire        step_btn,
    input  wire [2:0]  sw,
    output wire [7:0]  an,
    output wire [7:0]  seg,
    output wire [7:0]  led
);
    wire rst_n = ~rst_btn;
    wire step_pulse;

    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [31:0] w_data;
    wire [31:0] mdr;
    wire [31:0] f;
    wire [31:0] a;
    wire [31:0] b;
    wire [3:0]  fr;
    wire [3:0]  st;
    reg  [31:0] show_data;

    button_pulse u_step_pulse(
        .clk(clk_100mhz),
        .rst_n(rst_n),
        .btn(step_btn),
        .pulse(step_pulse)
    );

    riusjb_cpu u_cpu(
        .clk(step_pulse),
        .rst_n(rst_n),
        .debug_pc(pc),
        .debug_pc0(pc0),
        .debug_ir(ir),
        .debug_w_data(w_data),
        .debug_mdr(mdr),
        .debug_f(f),
        .debug_a(a),
        .debug_b(b),
        .debug_fr(fr),
        .debug_st(st)
    );

    always @(*) begin
        case (sw)
            3'b000: show_data = pc;
            3'b001: show_data = ir;
            3'b010: show_data = w_data;
            3'b011: show_data = f;
            3'b100: show_data = a;
            3'b101: show_data = b;
            3'b110: show_data = mdr;
            3'b111: show_data = {24'h000000, st, fr};
            default: show_data = pc;
        endcase
    end

    seg7_scan u_seg7_scan(
        .clk(clk_100mhz),
        .rst_n(rst_n),
        .data_hex(show_data),
        .an(an),
        .seg(seg)
    );

    assign led[3:0] = fr;
    assign led[7:4] = st;
endmodule
