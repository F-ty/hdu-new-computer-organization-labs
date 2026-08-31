`timescale 1ns / 1ps

module tb_rius_cpu;
    reg clk;
    reg rst_n;
    reg step_en;

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

    integer cycle;
    integer j;

    rius_cpu dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .step_en      (step_en),
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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n   = 1'b0;
        step_en = 1'b0;
        cycle   = 0;
        #22;
        rst_n   = 1'b1;
        step_en = 1'b1;

        for (j = 0; j < 58; j = j + 1) begin
            @(posedge clk);
        end
        step_en = 1'b0;
        #2;

        if ((dut.u_regs.regs[26] == 32'h22222222) &&
            (dut.u_regs.regs[27] == 32'h11111111) &&
            (dut.u_regs.regs[28] == 32'h33333333) &&
            (dut.u_regs.regs[29] == 32'h33333333) &&
            (dut.u_dmem.mem[4]   == 32'h33333333) &&
            (dut.u_dmem.mem[5]   == 32'h11111111))
            $display("EXP9 PASS: lw/sw exchange, add, store-back and reload are correct.");
        else begin
            $display("EXP9 FAIL");
            $display("x26=%h x27=%h x28=%h x29=%h DM[16]=%h DM[20]=%h",
                dut.u_regs.regs[26], dut.u_regs.regs[27],
                dut.u_regs.regs[28], dut.u_regs.regs[29],
                dut.u_dmem.mem[4], dut.u_dmem.mem[5]);
        end

        $finish;
    end

    always @(posedge clk) begin
        if (rst_n && step_en) begin
            cycle = cycle + 1;
            #1;
            $display("cycle=%0d state=%0d next=%0d PC=%08h IR=%08h A=%08h B=%08h F=%08h MDR=%08h W=%08h MW=%b RW=%b",
                cycle, state, next_state, pc, ir, a_reg, b_reg,
                f_reg, mdr, w_data, mem_write, reg_write);
        end
    end
endmodule
