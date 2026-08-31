`timescale 1ns/1ps

module lab11_top(
    input  wire        clk100,
    input  wire        btn_step,
    input  wire        btn_reset,
    input  wire        sw_auto,
    input  wire [2:0]  sw_sel,
    output wire [7:0]  an,
    output wire [7:0]  seg,
    output wire [11:0] led
);
    wire rst_n = ~btn_reset;
    wire step_pulse;
    wire auto_pulse;
    wire cpu_ce;

    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [31:0] a_reg;
    wire [31:0] b_reg;
    wire [31:0] aluout;
    wire [31:0] mdr;
    wire [31:0] wdata;
    wire [3:0]  flags;
    wire [4:0]  state;
    wire reg_write;
    wire mem_write;
    reg  [31:0] display_data;

    button_onepulse u_step_pulse (
        .clk(clk100),
        .rst_n(rst_n),
        .button_in(btn_step),
        .pulse_out(step_pulse)
    );

    auto_tick #(.COUNT_MAX(50_000_000)) u_auto_tick (
        .clk(clk100),
        .rst_n(rst_n),
        .tick(auto_pulse)
    );

    assign cpu_ce = sw_auto ? auto_pulse : step_pulse;

    rv32i_cpu #(
        .IMEM_FILE("program.mem"),
        .DMEM_FILE("data.mem")
    ) u_cpu (
        .clk(clk100),
        .rst_n(rst_n),
        .ce(cpu_ce),
        .debug_pc(pc),
        .debug_pc0(pc0),
        .debug_ir(ir),
        .debug_a(a_reg),
        .debug_b(b_reg),
        .debug_aluout(aluout),
        .debug_mdr(mdr),
        .debug_wdata(wdata),
        .debug_flags(flags),
        .debug_state(state),
        .debug_reg_write(reg_write),
        .debug_mem_write(mem_write)
    );

    always @(*) begin
        case (sw_sel)
            3'd0: display_data = pc;
            3'd1: display_data = pc0;
            3'd2: display_data = ir;
            3'd3: display_data = wdata;
            3'd4: display_data = mdr;
            3'd5: display_data = a_reg;
            3'd6: display_data = b_reg;
            default: display_data = aluout;
        endcase
    end

    hex7seg8 u_hex7seg8 (
        .clk(clk100),
        .rst_n(rst_n),
        .data(display_data),
        .an(an),
        .seg(seg)
    );

    assign led[4:0]  = state;
    assign led[8:5]  = flags;
    assign led[9]    = reg_write;
    assign led[10]   = mem_write;
    assign led[11]   = cpu_ce;
endmodule
