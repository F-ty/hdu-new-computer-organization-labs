`timescale 1ns/1ps

module hex7seg8(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] data,
    output reg  [7:0]  an,
    output reg  [7:0]  seg
);
    reg [16:0] refresh_count;
    wire [2:0] digit_index = refresh_count[16:14];
    reg [3:0] hex_digit;
    reg [6:0] seg7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            refresh_count <= 17'd0;
        else
            refresh_count <= refresh_count + 17'd1;
    end

    always @(*) begin
        case (digit_index)
            3'd0: hex_digit = data[3:0];
            3'd1: hex_digit = data[7:4];
            3'd2: hex_digit = data[11:8];
            3'd3: hex_digit = data[15:12];
            3'd4: hex_digit = data[19:16];
            3'd5: hex_digit = data[23:20];
            3'd6: hex_digit = data[27:24];
            default: hex_digit = data[31:28];
        endcase

        an = 8'hFF;
        an[digit_index] = 1'b0;

        case (hex_digit)
            // seg7[6:0] = {G,F,E,D,C,B,A}, all active low.
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

        // seg[0]..seg[6] correspond to CA..CG. seg[7] is DP.
        seg[6:0] = seg7;
        seg[7]   = 1'b1;
    end
endmodule
