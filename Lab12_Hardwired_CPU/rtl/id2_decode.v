module id2_decode(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire       is_r,
    output wire       is_imm,
    output wire       is_lui,
    output wire       is_lw,
    output wire       is_sw,
    output wire       is_beq,
    output wire       is_jal,
    output wire       is_jalr,
    output reg  [3:0] alu_op
);
    assign is_r    = (opcode == 7'b0110011);
    assign is_imm  = (opcode == 7'b0010011);
    assign is_lui  = (opcode == 7'b0110111);
    assign is_lw   = (opcode == 7'b0000011) && (funct3 == 3'b010);
    assign is_sw   = (opcode == 7'b0100011) && (funct3 == 3'b010);
    assign is_beq  = (opcode == 7'b1100011) && (funct3 == 3'b000);
    assign is_jal  = (opcode == 7'b1101111);
    assign is_jalr = (opcode == 7'b1100111) && (funct3 == 3'b000);

    // ALU_OP 编码与前序多功能 ALU 实验一致：
    // 0000 add, 1000 sub, 0001 sll, 0010 slt, 0011 sltu,
    // 0100 xor, 0101 srl, 1101 sra, 0110 or, 0111 and。
    always @(*) begin
        if (is_r)
            alu_op = {funct7[5], funct3};
        else if (is_imm)
            alu_op = (funct3 == 3'b101) ? {funct7[5], funct3}
                                        : {1'b0, funct3};
        else if (is_beq)
            alu_op = 4'b1000;
        else
            alu_op = 4'b0000; // lw、sw、jalr 均做地址加法
    end
endmodule
