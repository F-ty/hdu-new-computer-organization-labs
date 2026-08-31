`timescale 1ns / 1ps

module tb_riu_cpu;
    reg clk;
    reg rst_n;
    reg step_en;

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

    riu_cpu dut(
        .clk(clk),
        .rst_n(rst_n),
        .step_en(step_en),
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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task do_step;
        begin
            @(negedge clk);
            step_en = 1'b1;
            @(negedge clk);
            step_en = 1'b0;
            #1;
            $display("step=%0d ST=%0d PC=%08h IR=%08h A=%08h B=%08h F=%08h W_Data=%08h FR=%b", 
                     step_count, ST, PC, IR, A, B, F, W_Data, FR);
            step_count = step_count + 1;
        end
    endtask

    integer step_count;

    initial begin
        step_count = 0;
        step_en = 1'b0;
        rst_n = 1'b0;
        #30;
        rst_n = 1'b1;
        #20;
        repeat (90) begin
            do_step;
        end
        $display("x01=%08h x02=%08h x03=%08h x04=%08h", dut.U_REGS.rf[1], dut.U_REGS.rf[2], dut.U_REGS.rf[3], dut.U_REGS.rf[4]);
        $display("x05=%08h x06=%08h x07=%08h x08=%08h", dut.U_REGS.rf[5], dut.U_REGS.rf[6], dut.U_REGS.rf[7], dut.U_REGS.rf[8]);
        $display("x09=%08h x10=%08h x11=%08h x12=%08h", dut.U_REGS.rf[9], dut.U_REGS.rf[10], dut.U_REGS.rf[11], dut.U_REGS.rf[12]);
        $display("x13=%08h x14=%08h x15=%08h x16=%08h", dut.U_REGS.rf[13], dut.U_REGS.rf[14], dut.U_REGS.rf[15], dut.U_REGS.rf[16]);
        $display("x17=%08h x18=%08h x19=%08h x20=%08h x21=%08h", dut.U_REGS.rf[17], dut.U_REGS.rf[18], dut.U_REGS.rf[19], dut.U_REGS.rf[20], dut.U_REGS.rf[21]);
        $finish;
    end
endmodule
