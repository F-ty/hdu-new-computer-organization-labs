`timescale 1ns / 1ps

// Synchronizes a push-button signal and emits one system-clock pulse
// for each rising edge. The HCS-A02 buttons are already hardware-debounced.
module button_onepulse (
    input  wire clk,
    input  wire rst_n,
    input  wire button_in,
    output wire pulse_out
);
    reg sync0;
    reg sync1;
    reg sync1_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync0   <= 1'b0;
            sync1   <= 1'b0;
            sync1_d <= 1'b0;
        end
        else begin
            sync0   <= button_in;
            sync1   <= sync0;
            sync1_d <= sync1;
        end
    end

    assign pulse_out = sync1 & ~sync1_d;
endmodule
