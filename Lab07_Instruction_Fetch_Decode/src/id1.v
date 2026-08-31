module id1(
    input  wire [31:0] inst,
    output wire [6:0]  opcode,
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [31:0] imm32,
    output reg  [2:0]  inst_type,
    output reg         valid
);
    localparam TYPE_R = 3'b000;
    localparam TYPE_I = 3'b001;
    localparam TYPE_S = 3'b010;
    localparam TYPE_B = 3'b011;
    localparam TYPE_U = 3'b100;
    localparam TYPE_J = 3'b101;
    localparam TYPE_N = 3'b111;

    localparam OP_LOAD   = 7'b0000011;
    localparam OP_IMM    = 7'b0010011;
    localparam OP_AUIPC  = 7'b0010111;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_REG    = 7'b0110011;
    localparam OP_LUI    = 7'b0110111;
    localparam OP_BRANCH = 7'b1100011;
    localparam OP_JALR   = 7'b1100111;
    localparam OP_JAL    = 7'b1101111;

    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    imm_u u_imm_u (
        .inst  (inst),
        .imm32 (imm32)
    );

    always @(*) begin
        valid = 1'b1;
        case (opcode)
            OP_REG:
                inst_type = TYPE_R;

            OP_LOAD, OP_IMM, OP_JALR:
                inst_type = TYPE_I;

            OP_STORE:
                inst_type = TYPE_S;

            OP_BRANCH:
                inst_type = TYPE_B;

            OP_LUI, OP_AUIPC:
                inst_type = TYPE_U;

            OP_JAL:
                inst_type = TYPE_J;

            default: begin
                inst_type = TYPE_N;
                valid = 1'b0;
            end
        endcase
    end
endmodule