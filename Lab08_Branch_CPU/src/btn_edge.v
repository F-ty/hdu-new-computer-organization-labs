`timescale 1ns / 1ps

module btn_edge(
    input  wire clk,
    input  wire rst_n,
    input  wire btn,
    output wire pulse
);
    reg btn_d0;
    reg btn_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_d0 <= 1'b0;
            btn_d1 <= 1'b0;
        end else begin
            btn_d0 <= btn;
            btn_d1 <= btn_d0;
        end
    end

    assign pulse = btn_d0 & ~btn_d1;
endmodule
