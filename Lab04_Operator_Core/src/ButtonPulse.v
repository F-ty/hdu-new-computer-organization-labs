`timescale 1ns / 1ps

module ButtonPulse(
    input clk,
    input btn,
    output pulse
);

    reg btn_d0 = 1'b0;
    reg btn_d1 = 1'b0;
    reg btn_d2 = 1'b0;

    always @(posedge clk) begin
        btn_d0 <= btn;
        btn_d1 <= btn_d0;
        btn_d2 <= btn_d1;
    end

    assign pulse = btn_d1 & ~btn_d2;

endmodule