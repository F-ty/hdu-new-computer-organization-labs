module board_top(
    input  wire       clk100mhz,
    input  wire       btn_step,
    input  wire       btn_reset,
    input  wire [2:0] disp_sel,
    output wire [7:0] an,
    output wire [7:0] seg,
    output wire [8:0] led
);
    wire rst_n = ~btn_reset;
    wire pos_ce;
    wire neg_ce;

    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [31:0] a_latch;
    wire [31:0] b_latch;
    wire [31:0] f_latch;
    wire [31:0] mdr;
    wire [31:0] w_data;
    wire [3:0]  fr;
    wire [4:0]  m;
    wire [31:0] unused_dbg_reg;
    wire [31:0] unused_dbg_mem;
    reg  [31:0] display_data;

    step_phase u_step(
        .clk(clk100mhz), .rst_n(rst_n), .step_btn(btn_step),
        .pos_ce(pos_ce), .neg_ce(neg_ce)
    );

    hardwired_cpu u_cpu(
        .clk(clk100mhz), .rst_n(rst_n),
        .pos_ce(pos_ce), .neg_ce(neg_ce),
        .dbg_reg_addr(5'd0), .dbg_reg_data(unused_dbg_reg),
        .dbg_mem0(unused_dbg_mem),
        .pc_o(pc), .pc0_o(pc0), .ir_o(ir),
        .a_o(a_latch), .b_o(b_latch), .f_o(f_latch),
        .mdr_o(mdr), .w_data_o(w_data), .fr_o(fr), .m_o(m)
    );

    always @(*) begin
        case (disp_sel)
            3'b000: display_data = pc;
            3'b001: display_data = ir;
            3'b010: display_data = w_data;
            3'b011: display_data = mdr;
            3'b100: display_data = a_latch;
            3'b101: display_data = b_latch;
            3'b110: display_data = f_latch;
            default: display_data = {23'b0, m, fr};
        endcase
    end

    sevenseg_hex8 u_disp(
        .clk(clk100mhz), .rst_n(rst_n), .value(display_data),
        .an(an), .seg(seg)
    );

    // LD8~LD4 显示 M4~M0，LD3~LD0 显示 {CF,ZF,SF,OF}
    assign led[8:4] = m;
    assign led[3:0] = fr;
endmodule
