`timescale 1ns / 1ps

module tb_if_id_core;
    reg clk;
    reg rst_n;
    reg step;
    reg PC_Write;
    reg IR_Write;

    wire [31:0] pc_next;
    wire [31:0] pc_ir;
    wire [31:0] inst;
    wire [31:0] inst_code;
    wire [31:0] imm32;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [2:0]  inst_type;
    wire        valid;
    wire [31:0] field_pack;
    wire        busy;

    if_id_core dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .step       (step),
        .PC_Write   (PC_Write),
        .IR_Write   (IR_Write),
        .pc_next    (pc_next),
        .pc_ir      (pc_ir),
        .inst       (inst),
        .inst_code  (inst_code),
        .imm32      (imm32),
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7     (funct7),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .inst_type  (inst_type),
        .valid      (valid),
        .field_pack (field_pack),
        .busy       (busy)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task do_step;
    begin
        @(posedge clk);
        step = 1'b1;
        @(posedge clk);
        step = 1'b0;
        repeat (3) @(posedge clk);
        $display("pc_ir=%h pc_next=%h inst=%h imm32=%h op=%h f3=%h f7=%h rs1=%0d rs2=%0d rd=%0d type=%b valid=%b",
                 pc_ir, pc_next, inst, imm32, opcode, funct3, funct7,
                 rs1, rs2, rd, inst_type, valid);
    end
    endtask

    integer k;

    initial begin
        rst_n = 1'b0;
        step = 1'b0;
        PC_Write = 1'b1;
        IR_Write = 1'b1;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        for (k = 0; k < 12; k = k + 1)
            do_step();

        $finish;
    end
endmodule