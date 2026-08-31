`timescale 1ns / 1ps

module tb_Operator_Core;

    reg clk;
    reg rst;
    reg rr_en;
    reg f_en;
    reg wb_en;
    reg Reg_Write;

    reg [4:0] R_Addr_A;
    reg [4:0] R_Addr_B;
    reg [4:0] W_Addr;
    reg [3:0] ALU_OP;

    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] F;
    wire [3:0] FR;
    wire [31:0] R_Data_A_live;
    wire [31:0] R_Data_B_live;

    Operator_Core uut (
        .clk(clk),
        .rst(rst),
        .rr_en(rr_en),
        .f_en(f_en),
        .wb_en(wb_en),
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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;   // 100 MHz clock, period = 10 ns
    end

    task pulse_rr;
    begin
        @(negedge clk);
        rr_en = 1'b1;
        @(negedge clk);
        rr_en = 1'b0;
    end
    endtask

    task pulse_f;
    begin
        @(negedge clk);
        f_en = 1'b1;
        @(negedge clk);
        f_en = 1'b0;
    end
    endtask

    task pulse_wb;
    begin
        @(negedge clk);
        wb_en = 1'b1;
        @(negedge clk);
        wb_en = 1'b0;
    end
    endtask

    task check_op;
        input [4:0] ra;
        input [4:0] rb;
        input [4:0] wa;
        input [3:0] op;
        input [31:0] expected_f;
        input [3:0] expected_fr;
        input do_writeback;
    begin
        R_Addr_A = ra;
        R_Addr_B = rb;
        W_Addr   = wa;
        ALU_OP   = op;
        Reg_Write = do_writeback;

        pulse_rr;
        #1;

        pulse_f;
        #1;

        if (F !== expected_f) begin
            $display("ERROR: op=%b, ra=x%0d, rb=x%0d, F=%h, expected=%h",
                     op, ra, rb, F, expected_f);
        end
        else begin
            $display("PASS : op=%b, ra=x%0d, rb=x%0d, F=%h",
                     op, ra, rb, F);
        end

        if (FR !== expected_fr) begin
            $display("ERROR: FR=%b, expected=%b", FR, expected_fr);
        end
        else begin
            $display("PASS : FR=%b", FR);
        end

        if (do_writeback) begin
            pulse_wb;
            #1;

            R_Addr_A = wa;
            pulse_rr;
            #1;

            if (A !== expected_f) begin
                $display("ERROR: writeback failed, x%0d=%h, expected=%h",
                         wa, A, expected_f);
            end
            else begin
                $display("PASS : writeback success, x%0d=%h", wa, A);
            end
        end

        #20;
    end
    endtask

    initial begin
        rst = 1'b0;
        rr_en = 1'b0;
        f_en = 1'b0;
        wb_en = 1'b0;
        Reg_Write = 1'b0;
        R_Addr_A = 5'd0;
        R_Addr_B = 5'd0;
        W_Addr = 5'd0;
        ALU_OP = 4'b0000;

        // reset, initialize register file
        @(negedge clk);
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
        #20;

        // Test 1: x1 + x2 = 1 + 2 = 3, write to x5
        // FR = {ZF, SF, CF, OF} = 0000
        check_op(5'd1, 5'd2, 5'd5, 4'b0000, 32'h0000_0003, 4'b0000, 1'b1);

        // Test 2: read x5 and x2, x5 + x2 = 3 + 2 = 5
        check_op(5'd5, 5'd2, 5'd6, 4'b0000, 32'h0000_0005, 4'b0000, 1'b1);

        // Test 3: x4 - x2 = 8 - 2 = 6
        check_op(5'd4, 5'd2, 5'd7, 4'b1000, 32'h0000_0006, 4'b0000, 1'b1);

        // Test 4: x7 XOR x8 = 12345678 ^ 33332222 = 2107745A
        check_op(5'd7, 5'd8, 5'd9, 4'b0100, 32'h2107_745A, 4'b0000, 1'b0);

        // Test 5: x14 AND x15 = AAAAAAAA & 55555555 = 00000000
        // ZF = 1, FR = 1000
        check_op(5'd14, 5'd15, 5'd10, 4'b0111, 32'h0000_0000, 4'b1000, 1'b0);

        // Test 6: x14 OR x15 = FFFFFFFF
        // SF = 1, FR = 0100
        check_op(5'd14, 5'd15, 5'd10, 4'b0110, 32'hFFFF_FFFF, 4'b0100, 1'b0);

        // Test 7: signed less than
        // x10 = 80000000, x9 = 7FFFFFFF
        // signed: 80000000 < 7FFFFFFF, result = 1
        check_op(5'd10, 5'd9, 5'd11, 4'b0010, 32'h0000_0001, 4'b0000, 1'b0);

        // Test 8: unsigned less than
        // unsigned: 80000000 > 7FFFFFFF, result = 0
        check_op(5'd10, 5'd9, 5'd11, 4'b0011, 32'h0000_0000, 4'b1000, 1'b0);

        // Test 9: logical right shift
        // 80000000 >> 2 = 20000000
        check_op(5'd10, 5'd2, 5'd12, 4'b0101, 32'h2000_0000, 4'b0000, 1'b0);

        // Test 10: arithmetic right shift
        // signed 80000000 >>> 2 = E0000000
        check_op(5'd10, 5'd2, 5'd12, 4'b1101, 32'hE000_0000, 4'b0100, 1'b0);

        #50;
        $finish;
    end

endmodule