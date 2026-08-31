`timescale 1ns / 1ps

module tb_id1;
    reg  [31:0] inst;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [31:0] imm32;
    wire [2:0]  inst_type;
    wire        valid;

    id1 dut (
        .inst      (inst),
        .opcode    (opcode),
        .funct3    (funct3),
        .funct7    (funct7),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (rd),
        .imm32     (imm32),
        .inst_type (inst_type),
        .valid     (valid)
    );

    initial begin
        inst = 32'h123450B7; #10;
        $display("lui   inst=%h opcode=%h rd=%0d imm32=%h type=%b valid=%b",
                 inst, opcode, rd, imm32, inst_type, valid);

        inst = 32'h00A00193; #10;
        $display("addi  inst=%h opcode=%h rd=%0d rs1=%0d imm32=%h type=%b valid=%b",
                 inst, opcode, rd, rs1, imm32, inst_type, valid);

        inst = 32'h00219213; #10;
        $display("slli  inst=%h rd=%0d rs1=%0d shamt=%h imm32=%h",
                 inst, rd, rs1, inst[24:20], imm32);

        inst = 32'h4012D313; #10;
        $display("srai  inst=%h rd=%0d rs1=%0d shamt=%h imm32=%h funct7=%h",
                 inst, rd, rs1, inst[24:20], imm32, funct7);

        inst = 32'h004183B3; #10;
        $display("add   inst=%h rd=%0d rs1=%0d rs2=%0d funct7=%h type=%b",
                 inst, rd, rs1, rs2, funct7, inst_type);

        inst = 32'h00702023; #10;
        $display("sw    inst=%h rs1=%0d rs2=%0d imm32=%h type=%b",
                 inst, rs1, rs2, imm32, inst_type);

        inst = 32'h00748463; #10;
        $display("beq   inst=%h rs1=%0d rs2=%0d imm32=%h type=%b",
                 inst, rs1, rs2, imm32, inst_type);

        inst = 32'h00C0056F; #10;
        $display("jal   inst=%h rd=%0d imm32=%h type=%b",
                 inst, rd, imm32, inst_type);

        $finish;
    end
endmodule