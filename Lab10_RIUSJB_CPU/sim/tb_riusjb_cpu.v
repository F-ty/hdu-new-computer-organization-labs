`timescale 1ns / 1ps
module tb_riusjb_cpu;
    reg clk;
    reg rst_n;

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

    riusjb_cpu dut(
        .clk(clk),
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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_riusjb_cpu.vcd");
        $dumpvars(0, tb_riusjb_cpu);
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #2000;
        $display("x8  = %h, expected 00000015", dut.u_regs.regs[8]);
        $display("DM[12] = %h, expected 00000015", dut.u_dm.mem[12]);
        if ((dut.u_regs.regs[8] == 32'h0000_0015) && (dut.u_dm.mem[12] == 32'h0000_0015)) begin
            $display("PASS: beq, jal and jalr test program completed correctly.");
        end else begin
            $display("FAIL: check CPU datapath or control state transitions.");
        end
        $finish;
    end

    always @(posedge clk) begin
        if (rst_n) begin
            $display("t=%0t ST=%0d PC=%h PC0=%h IR=%h A=%h B=%h F=%h MDR=%h WD=%h FR=%b",
                     $time, st, pc, pc0, ir, a, b, f, mdr, w_data, fr);
        end
    end
endmodule
