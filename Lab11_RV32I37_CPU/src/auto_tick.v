`timescale 1ns/1ps

module auto_tick #(
    parameter COUNT_MAX = 50_000_000
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);
    reg [31:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 32'd0;
            tick  <= 1'b0;
        end else if (count == COUNT_MAX - 1) begin
            count <= 32'd0;
            tick  <= 1'b1;
        end else begin
            count <= count + 32'd1;
            tick  <= 1'b0;
        end
    end
endmodule
