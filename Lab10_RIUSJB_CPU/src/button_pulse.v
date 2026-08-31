`timescale 1ns / 1ps
module button_pulse(
    input  wire clk,
    input  wire rst_n,
    input  wire btn,
    output wire pulse
);
    reg btn_d0;
    reg btn_d1;
    reg btn_d2;

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            btn_d0 <= 1'b0;
            btn_d1 <= 1'b0;
            btn_d2 <= 1'b0;
        end else begin
            btn_d0 <= btn;
            btn_d1 <= btn_d0;
            btn_d2 <= btn_d1;
        end
    end

    assign pulse = btn_d1 & ~btn_d2;
endmodule
