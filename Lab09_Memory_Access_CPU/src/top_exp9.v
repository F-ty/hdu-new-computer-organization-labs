`timescale 1ns / 1ps

// HCS-A02 board-level top module for Experiment 9.
// BT0: execute one micro-operation
// BT1: reset while pressed
// SW2..SW0: select displayed internal value
// LED3..LED0: ZF, SF, CF, OF
// LED7..LED4: current state code
module top_exp9 (
    input  wire       clk_100m,
    input  wire       btn_step,
    input  wire       btn_reset,
    input  wire [2:0] sw_sel,
    output wire [7:0] led,
    output wire [7:0] an,
    output wire [7:0] seg
);
    wire rst_n = ~btn_reset;
    wire step_pulse;

    wire [31:0] pc;
    wire [31:0] ir;
    wire [31:0] w_data;
    wire [31:0] a_reg;
    wire [31:0] b_reg;
    wire [31:0] f_reg;
    wire [31:0] mdr;
    wire [3:0] fr;
    wire [3:0] state;
    wire [3:0] next_state;
    wire mem_write;
    wire reg_write;
    reg  [31:0] display_value;

    button_onepulse u_step (
        .clk       (clk_100m),
        .rst_n     (rst_n),
        .button_in (btn_step),
        .pulse_out (step_pulse)
    );

    rius_cpu u_cpu (
        .clk          (clk_100m),
        .rst_n        (rst_n),
        .step_en      (step_pulse),
        .pc_o         (pc),
        .ir_o         (ir),
        .w_data_o     (w_data),
        .a_o          (a_reg),
        .b_o          (b_reg),
        .f_o          (f_reg),
        .mdr_o        (mdr),
        .fr_o         (fr),
        .state_o      (state),
        .next_state_o (next_state),
        .mem_write_o  (mem_write),
        .reg_write_o  (reg_write)
    );

    always @(*) begin
        case (sw_sel)
            3'b000: display_value = pc;
            3'b001: display_value = ir;
            3'b010: display_value = w_data;
            3'b011: display_value = a_reg;
            3'b100: display_value = b_reg;
            3'b101: display_value = f_reg;
            3'b110: display_value = mdr;
            default: display_value = {20'b0, state, next_state, fr};
        endcase
    end

    assign led[3:0] = fr;      // LD3=ZF, LD2=SF, LD1=CF, LD0=OF
    assign led[7:4] = state;   // binary current-state code

    sevenseg_hex8 u_display (
        .clk   (clk_100m),
        .rst_n (rst_n),
        .value (display_value),
        .an    (an),
        .seg   (seg)
    );
endmodule
