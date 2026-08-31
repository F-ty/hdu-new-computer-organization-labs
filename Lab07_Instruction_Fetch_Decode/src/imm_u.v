module imm_u(
    input  wire [31:0] inst,
    output reg  [31:0] imm32
);
    localparam OP_LOAD   = 7'b0000011;
    localparam OP_IMM    = 7'b0010011;
    localparam OP_AUIPC  = 7'b0010111;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_REG    = 7'b0110011;
    localparam OP_LUI    = 7'b0110111;
    localparam OP_BRANCH = 7'b1100011;
    localparam OP_JALR   = 7'b1100111;
    localparam OP_JAL    = 7'b1101111;

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];

    wire is_shift_imm;
    assign is_shift_imm = (opcode == OP_IMM) &&
                          ((funct3 == 3'b001) || (funct3 == 3'b101));

    always @(*) begin
        case (opcode)
            OP_LUI, OP_AUIPC:
                imm32 = {inst[31:12], 12'b0};

            OP_JAL:
                imm32 = {{11{inst[31]}}, inst[31], inst[19:12],
                         inst[20], inst[30:21], 1'b0};

            OP_BRANCH:
                imm32 = {{19{inst[31]}}, inst[31], inst[7],
                         inst[30:25], inst[11:8], 1'b0};

            OP_STORE:
                imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            OP_LOAD, OP_JALR, OP_IMM:
                if (is_shift_imm)
                    imm32 = {27'b0, inst[24:20]};
                else
                    imm32 = {{20{inst[31]}}, inst[31:20]};

            OP_REG:
                imm32 = 32'b0;

            default:
                imm32 = 32'b0;
        endcase
    end
endmodule