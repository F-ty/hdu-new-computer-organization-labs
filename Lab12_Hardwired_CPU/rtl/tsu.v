module tsu(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       neg_ce,
    input  wire       is_lui,
    input  wire       is_lw,
    input  wire       is_sw,
    input  wire       is_jal,
    output reg  [4:0] m
);
    localparam M0 = 5'b00001;
    localparam M1 = 5'b00010;
    localparam M2 = 5'b00100;
    localparam M3 = 5'b01000;
    localparam M4 = 5'b10000;

    reg [4:0] next_m;

    // 独热码机器周期发生器。复位后直接进入 M0，使第一次按键完成取指。
    always @(*) begin
        case (m)
            M0: next_m = M1;
            M1: next_m = (is_lui || is_jal) ? M4 : M2;
            M2: next_m = (is_lw || is_sw) ? M3 : M4;
            M3: next_m = is_lw ? M4 : M0; // sw 在 M3 写存储器后结束
            M4: next_m = M0;
            default: next_m = M0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            m <= M0;
        else if (neg_ce)
            m <= next_m;
    end
endmodule
