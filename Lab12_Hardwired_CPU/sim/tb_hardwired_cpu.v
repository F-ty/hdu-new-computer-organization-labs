`timescale 1ns/1ps

module tb_hardwired_cpu;
    reg clk;
    reg rst_n;
    reg pos_ce;
    reg neg_ce;
    reg [4:0] dbg_reg_addr;

    wire [31:0] dbg_reg_data;
    wire [31:0] dbg_mem0;
    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [31:0] a_latch;
    wire [31:0] b_latch;
    wire [31:0] f_latch;
    wire [31:0] mdr;
    wire [31:0] w_data;
    wire [3:0] fr;
    wire [4:0] m;

    reg [31:0] expected [0:27];
    integer i;
    integer errors;

    hardwired_cpu dut(
        .clk(clk), .rst_n(rst_n),
        .pos_ce(pos_ce), .neg_ce(neg_ce),
        .dbg_reg_addr(dbg_reg_addr), .dbg_reg_data(dbg_reg_data),
        .dbg_mem0(dbg_mem0),
        .pc_o(pc), .pc0_o(pc0), .ir_o(ir),
        .a_o(a_latch), .b_o(b_latch), .f_o(f_latch),
        .mdr_o(mdr), .w_data_o(w_data), .fr_o(fr), .m_o(m)
    );

    always #5 clk = ~clk;

    initial begin
        expected[0]  = 32'h00000000;
        expected[1]  = 32'h00000005;
        expected[2]  = 32'h00000003;
        expected[3]  = 32'h00000008;
        expected[4]  = 32'h00000002;
        expected[5]  = 32'h00000028;
        expected[6]  = 32'h00000001;
        expected[7]  = 32'h00000000;
        expected[8]  = 32'h00000006;
        expected[9]  = 32'h00000005;
        expected[10] = 32'h00000005;
        expected[11] = 32'h00000007;
        expected[12] = 32'h00000001;
        expected[13] = 32'h00000030;
        expected[14] = 32'h0000000C;
        expected[15] = 32'hFFFFFFF0;
        expected[16] = 32'hFFFFFFFC;
        expected[17] = 32'h00000001;
        expected[18] = 32'h00000000;
        expected[19] = 32'h0000000A;
        expected[20] = 32'h0000000B;
        expected[21] = 32'h00000003;
        expected[22] = 32'h12345000;
        expected[23] = 32'h00000008;
        expected[24] = 32'h00000000;
        expected[25] = 32'h0000006C;
        expected[26] = 32'h00000055;
        expected[27] = 32'h00000066;

        clk = 1'b0;
        rst_n = 1'b0;
        pos_ce = 1'b0;
        neg_ce = 1'b0;
        dbg_reg_addr = 5'd0;
        errors = 0;

        #30;
        rst_n = 1'b1;

        // 每次循环模拟一个完整 CPU 按键周期：先“上跳沿阶段”，再“下跳沿阶段”。
        for (i = 0; i < 150; i = i + 1) begin
            pos_ce = 1'b1;
            #10 pos_ce = 1'b0;
            neg_ce = 1'b1;
            #10 neg_ce = 1'b0;
        end

        $display("Final PC=%h PC0=%h IR=%h M=%b", pc, pc0, ir, m);

        for (i = 1; i <= 27; i = i + 1) begin
            dbg_reg_addr = i[4:0];
            #1;
            if (dbg_reg_data !== expected[i]) begin
                $display("ERROR: x%0d = %h, expected %h", i, dbg_reg_data, expected[i]);
                errors = errors + 1;
            end else begin
                $display("PASS : x%0d = %h", i, dbg_reg_data);
            end
        end

        if (dbg_mem0 !== 32'h00000008) begin
            $display("ERROR: DM[0] = %h, expected 00000008", dbg_mem0);
            errors = errors + 1;
        end else begin
            $display("PASS : DM[0] = %h", dbg_mem0);
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TEST FAILED, errors=%0d", errors);

        $finish;
    end
endmodule
