module id1_decode(
    input  wire [31:0] inst,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [6:0]  opcode,
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    output reg  [31:0] imm32
);
    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    always @(*) begin
        case (opcode)
            7'b0010011, // I 型运算
            7'b0000011, // lw
            7'b1100111: // jalr
                imm32 = {{20{inst[31]}}, inst[31:20]};

            7'b0100011: // sw
                imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            7'b1100011: // beq
                imm32 = {{19{inst[31]}}, inst[31], inst[7],
                         inst[30:25], inst[11:8], 1'b0};

            7'b0110111: // lui
                imm32 = {inst[31:12], 12'b0};

            7'b1101111: // jal
                imm32 = {{11{inst[31]}}, inst[31], inst[19:12],
                         inst[20], inst[30:21], 1'b0};

            default:
                imm32 = 32'b0;
        endcase
    end
endmodule
