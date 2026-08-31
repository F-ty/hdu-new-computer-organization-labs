`timescale 1ns/1ps

module tb_rv32i_cpu;
    reg clk;
    reg rst_n;
    reg ce;

    wire [31:0] pc;
    wire [31:0] pc0;
    wire [31:0] ir;
    wire [31:0] a_reg;
    wire [31:0] b_reg;
    wire [31:0] aluout;
    wire [31:0] mdr;
    wire [31:0] wdata;
    wire [3:0] flags;
    wire [4:0] state;
    wire reg_write;
    wire mem_write;

    integer errors;

    rv32i_cpu #(
        .IMEM_FILE("program.mem"),
        .DMEM_FILE("data.mem")
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .ce(ce),
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

    always #5 clk = ~clk;

    task check_reg;
        input [4:0] index;
        input [31:0] expected;
        begin
            if (dut.u_regfile.regs[index] !== expected) begin
                $display("ERROR x%0d expected=%h actual=%h", index, expected,
                         dut.u_regfile.regs[index]);
                errors = errors + 1;
            end else begin
                $display("PASS  x%0d = %h", index, expected);
            end
        end
    endtask

    task check_byte;
        input [7:0] address;
        input [7:0] expected;
        begin
            if (dut.u_dmem.mem[address] !== expected) begin
                $display("ERROR mem[%h] expected=%h actual=%h", address, expected,
                         dut.u_dmem.mem[address]);
                errors = errors + 1;
            end else begin
                $display("PASS  mem[%h] = %h", address, expected);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        ce = 1'b1;
        errors = 0;

        #30;
        rst_n = 1'b1;

        // 61 instructions, maximum 5 microcycles each, plus loop margin.
        #6000;

        check_reg(5'd13, 32'h12345000);
        check_reg(5'd14, 32'h00001090);
        check_reg(5'd18, 32'h00000055);
        check_reg(5'd19, 32'h00000033);
        check_reg(5'd20, 32'h00000042);
        check_reg(5'd21, 32'h00000002);
        check_reg(5'd22, 32'h00000008);
        check_reg(5'd23, 32'h000000A0);
        check_reg(5'd24, 32'h00000001);
        check_reg(5'd25, 32'h00000000);
        check_reg(5'd26, 32'hFFFFFFF8);
        check_reg(5'd27, 32'h07FFFFFF);
        check_reg(5'd28, 32'hFFFFFFFF);
        check_reg(5'd29, 32'hFFFFFFFD);
        check_reg(5'd30, 32'h00000005);
        check_reg(5'd31, 32'h00000098);

        check_byte(8'h44, 8'hFF);
        check_byte(8'h46, 8'hFF);
        check_byte(8'h47, 8'hFF);
        check_byte(8'h48, 8'hFF);
        check_byte(8'h49, 8'hFF);
        check_byte(8'h4A, 8'hFF);
        check_byte(8'h4B, 8'hFF);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TEST FAILED, errors=%0d", errors);

        $finish;
    end
endmodule
