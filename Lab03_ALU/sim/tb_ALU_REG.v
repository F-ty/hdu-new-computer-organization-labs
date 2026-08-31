`timescale 1ns / 1ps

module tb_ALU_REG;

    reg clk;
    reg rst;
    reg clk_A;
    reg clk_B;
    reg clk_F;
    reg [3:0] ALU_OP;
    reg [31:0] Data_A;
    reg [31:0] Data_B;

    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] F;
    wire [3:0] FR;

    ALU_REG uut (
        .clk(clk),
        .ALU_OP(ALU_OP),
        .Data_A(Data_A),
        .Data_B(Data_B),
        .rst(rst),
        .clk_A(clk_A),
        .clk_B(clk_B),
        .clk_F(clk_F),
        .A(A),
        .B(B),
        .F(F),
        .FR(FR)
    );

    always #5 clk = ~clk;

    task press_A;
    begin
        clk_A = 1'b1;
        #40;
        clk_A = 1'b0;
        #40;
    end
    endtask

    task press_B;
    begin
        clk_B = 1'b1;
        #40;
        clk_B = 1'b0;
        #40;
    end
    endtask

    task press_F;
    begin
        clk_F = 1'b1;
        #40;
        clk_F = 1'b0;
        #40;
    end
    endtask

    task test_one;
        input [31:0] a_in;
        input [31:0] b_in;
        input [3:0] op_in;
    begin
        Data_A = a_in;
        press_A;

        Data_B = b_in;
        press_B;

        ALU_OP = op_in;
        press_F;

        #40;
        $display("A=%h B=%h ALU_OP=%b F=%h FR=%b",
                 A, B, ALU_OP, F, FR);
    end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        clk_A = 1'b0;
        clk_B = 1'b0;
        clk_F = 1'b0;
        ALU_OP = 4'b0000;
        Data_A = 32'h0000_0000;
        Data_B = 32'h0000_0000;

        #20;
        rst = 1'b1;
        #40;
        rst = 1'b0;
        #40;

        test_one(32'h0000_0001, 32'h0000_0002, 4'b0000);
        test_one(32'h0000_0005, 32'h0000_0005, 4'b1000);
        test_one(32'hFFFF_FFFF, 32'h0000_0001, 4'b0010);
        test_one(32'hFFFF_FFFF, 32'h0000_0001, 4'b0011);
        test_one(32'h8000_0000, 32'h0000_0004, 4'b0101);
        test_one(32'h8000_0000, 32'h0000_0004, 4'b1101);
        test_one(32'hAAAA_5555, 32'hFFFF_0000, 4'b0100);
        test_one(32'hAAAA_5555, 32'hFFFF_0000, 4'b0110);
        test_one(32'hAAAA_5555, 32'hFFFF_0000, 4'b0111);

        #100;
        $finish;
    end

endmodule