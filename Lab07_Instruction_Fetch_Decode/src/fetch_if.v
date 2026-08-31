module fetch_if(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step,
    input  wire        PC_Write,
    input  wire        IR_Write,
    output wire [31:0] pc_next,
    output wire [31:0] pc_ir,
    output wire [31:0] inst,
    output wire [31:0] inst_code,
    output wire [5:0]  im_addr,
    output wire        busy
);
    localparam S_IDLE    = 1'b0;
    localparam S_CAPTURE = 1'b1;

    reg state;

    assign im_addr = pc_next[7:2];

    im_rom u_im_rom (
        .clk       (clk),
        .addr      (im_addr),
        .inst_code (inst_code)
    );

    pc_reg u_pc (
        .clk     (clk),
        .rst_n   (rst_n),
        .load_en (state == S_CAPTURE && PC_Write),
        .d       (pc_next + 32'd4),
        .q       (pc_next)
    );

    ir_reg u_ir (
        .clk     (clk),
        .rst_n   (rst_n),
        .load_en (state == S_CAPTURE && IR_Write),
        .d       (inst_code),
        .q       (inst)
    );

    pc_reg u_ir_pc (
        .clk     (clk),
        .rst_n   (rst_n),
        .load_en (state == S_CAPTURE && IR_Write),
        .d       (pc_next),
        .q       (pc_ir)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_IDLE;
        else begin
            case (state)
                S_IDLE:
                    if (step)
                        state <= S_CAPTURE;
                S_CAPTURE:
                    state <= S_IDLE;
                default:
                    state <= S_IDLE;
            endcase
        end
    end

    assign busy = state;
endmodule