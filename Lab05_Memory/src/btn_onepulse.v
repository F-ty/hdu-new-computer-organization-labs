// 按键消抖 + 上升沿单脉冲
// HCS-A02 的按键按下为 1，松开为 0。
module btn_onepulse #(
    parameter integer CNT_MAX = 20'd999_999   // 100MHz 下约 10ms
)(
    input  wire clk,
    input  wire rst,       // 高电平复位
    input  wire btn_in,
    output reg  pulse
);
    reg [2:0]  sync_ff;
    reg        stable;
    reg [19:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            sync_ff <= 3'b000;
            stable  <= 1'b0;
            cnt     <= 20'd0;
            pulse   <= 1'b0;
        end else begin
            sync_ff <= {sync_ff[1:0], btn_in};
            pulse   <= 1'b0;

            if (sync_ff[2] == stable) begin
                cnt <= 20'd0;
            end else begin
                if (cnt == CNT_MAX) begin
                    stable <= sync_ff[2];
                    cnt    <= 20'd0;
                    if (sync_ff[2])
                        pulse <= 1'b1;  // 只在“确认按下”时输出一个时钟周期脉冲
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end
endmodule
