module exp7_board_top(
    input  wire        clk100,
    input  wire        rst_btn,
    input  wire        step_btn,
    input  wire [4:0]  sw,
    output wire [35:0] led,
    output wire [7:0]  an,
    output wire [7:0]  seg
);
    wire rst_n;
    wire step_pulse;

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

    reg  [31:0] disp_data;

    assign rst_n = ~rst_btn;

    btn_edge u_btn_edge (
        .clk   (clk100),
        .rst_n (rst_n),
        .btn   (step_btn),
        .pulse (step_pulse)
    );

    if_id_core u_if_id_core (
        .clk        (clk100),
        .rst_n      (rst_n),
        .step       (step_pulse),
        .PC_Write   (sw[0]),
        .IR_Write   (sw[1]),
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

    always @(*) begin
        case (sw[4:3])
            2'b00: disp_data = pc_ir;
            2'b01: disp_data = inst;
            2'b10: disp_data = imm32;
            2'b11: disp_data = field_pack;
            default: disp_data = 32'b0;
        endcase
    end

    assign led[31:0]  = sw[2] ? imm32 : inst;
    assign led[34:32] = inst_type;
    assign led[35]    = valid & ~busy;

    seg8_scan u_seg8_scan (
        .clk   (clk100),
        .rst_n (rst_n),
        .data  (disp_data),
        .an    (an),
        .seg   (seg)
    );
endmodule