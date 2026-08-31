module sevenseg_hex8(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] value,
    output reg  [7:0]  an,
    output reg  [7:0]  seg
);
    reg [18:0] refresh_cnt;
    wire [2:0] scan = refresh_cnt[18:16];
    reg  [3:0] hex;
    reg  [6:0] seg7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            refresh_cnt <= 19'b0;
        else
            refresh_cnt <= refresh_cnt + 19'd1;
    end

    always @(*) begin
        case (scan)
            3'd0: hex = value[3:0];
            3'd1: hex = value[7:4];
            3'd2: hex = value[11:8];
            3'd3: hex = value[15:12];
            3'd4: hex = value[19:16];
            3'd5: hex = value[23:20];
            3'd6: hex = value[27:24];
            default: hex = value[31:28];
        endcase

        an = ~(8'b00000001 << scan); // 共阳极，位选低有效

        // seg7 顺序为 gfedcba，低电平点亮
        case (hex)
            4'h0: seg7 = 7'b1000000;
            4'h1: seg7 = 7'b1111001;
            4'h2: seg7 = 7'b0100100;
            4'h3: seg7 = 7'b0110000;
            4'h4: seg7 = 7'b0011001;
            4'h5: seg7 = 7'b0010010;
            4'h6: seg7 = 7'b0000010;
            4'h7: seg7 = 7'b1111000;
            4'h8: seg7 = 7'b0000000;
            4'h9: seg7 = 7'b0010000;
            4'hA: seg7 = 7'b0001000;
            4'hB: seg7 = 7'b0000011;
            4'hC: seg7 = 7'b1000110;
            4'hD: seg7 = 7'b0100001;
            4'hE: seg7 = 7'b0000110;
            default: seg7 = 7'b0001110;
        endcase

        // seg[7:0] = {DP,G,F,E,D,C,B,A}
        seg = {1'b1, seg7};
    end
endmodule
