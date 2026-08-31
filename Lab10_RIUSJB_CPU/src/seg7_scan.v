`timescale 1ns / 1ps
module seg7_scan(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] data_hex,
    output reg  [7:0]  an,
    output wire [7:0]  seg
);
    reg [16:0] div_cnt;
    wire [2:0] scan_sel = div_cnt[16:14];
    reg [3:0] hex_now;
    wire [6:0] seg7_now;

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n)
            div_cnt <= 17'd0;
        else
            div_cnt <= div_cnt + 17'd1;
    end

    always @(*) begin
        an = 8'b1111_1111;
        an[scan_sel] = 1'b0;
        case (scan_sel)
            3'd0: hex_now = data_hex[3:0];
            3'd1: hex_now = data_hex[7:4];
            3'd2: hex_now = data_hex[11:8];
            3'd3: hex_now = data_hex[15:12];
            3'd4: hex_now = data_hex[19:16];
            3'd5: hex_now = data_hex[23:20];
            3'd6: hex_now = data_hex[27:24];
            3'd7: hex_now = data_hex[31:28];
            default: hex_now = 4'h0;
        endcase
    end

    seg7_hex u_seg7_hex(.hex(hex_now), .seg(seg7_now));
    assign seg = {1'b1, seg7_now};
endmodule
