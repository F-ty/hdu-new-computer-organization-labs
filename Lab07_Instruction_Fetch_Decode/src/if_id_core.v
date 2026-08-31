module if_id_core(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step,
    input  wire        PC_Write,
    input  wire        IR_Write,
    output wire [31:0] pc_next,
    output wire [31:0] pc_ir,
    output wire [31:0] inst,
    output wire [31:0] inst_code,
    output wire [31:0] imm32,
    output wire [6:0]  opcode,
    output wire [2:0]  funct3,
    output wire [6:0]  funct7,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,
    output wire [2:0]  inst_type,
    output wire        valid,
    output wire [31:0] field_pack,
    output wire        busy
);
    wire [5:0] im_addr;

    fetch_if u_fetch_if (
        .clk       (clk),
        .rst_n     (rst_n),
        .step      (step),
        .PC_Write  (PC_Write),
        .IR_Write  (IR_Write),
        .pc_next   (pc_next),
        .pc_ir     (pc_ir),
        .inst      (inst),
        .inst_code (inst_code),
        .im_addr   (im_addr),
        .busy      (busy)
    );

    id1 u_id1 (
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

    assign field_pack = {opcode, funct3, funct7, rs1, rs2, rd};
endmodule