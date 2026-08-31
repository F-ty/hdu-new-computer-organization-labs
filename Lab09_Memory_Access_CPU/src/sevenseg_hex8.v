`timescale 1ns / 1ps

// Eight-digit common-anode hexadecimal display driver for HCS-A02.
// seg = {CA,CB,CC,CD,CE,CF,CG,DP}; 0 lights a segment.
module sevenseg_hex8 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] value,
    output reg  [7:0]  an,
    output reg  [7:0]  seg
);
    reg [16:0] refresh_cnt;
    wire [2:0] scan_index = refresh_cnt[16:14];
    reg [3:0] nibble;
    reg [6:0] seg7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            refresh_cnt <= 17'b0;
        else
            refresh_cnt <= refresh_cnt + 17'd1;
    end

    always @(*) begin
        an = 8'hFF;
        case (scan_index)
            3'd0: begin an[0] = 1'b0; nibble = value[3:0];   end
            3'd1: begin an[1] = 1'b0; nibble = value[7:4];   end
            3'd2: begin an[2] = 1'b0; nibble = value[11:8];  end
            3'd3: begin an[3] = 1'b0; nibble = value[15:12]; end
            3'd4: begin an[4] = 1'b0; nibble = value[19:16]; end
            3'd5: begin an[5] = 1'b0; nibble = value[23:20]; end
            3'd6: begin an[6] = 1'b0; nibble = value[27:24]; end
            default: begin an[7] = 1'b0; nibble = value[31:28]; end
        endcase

        case (nibble)
            4'h0: seg7 = 7'b0000001;
            4'h1: seg7 = 7'b1001111;
            4'h2: seg7 = 7'b0010010;
            4'h3: seg7 = 7'b0000110;
            4'h4: seg7 = 7'b1001100;
            4'h5: seg7 = 7'b0100100;
            4'h6: seg7 = 7'b0100000;
            4'h7: seg7 = 7'b0001111;
            4'h8: seg7 = 7'b0000000;
            4'h9: seg7 = 7'b0000100;
            4'hA: seg7 = 7'b0001000;
            4'hB: seg7 = 7'b1100000;
            4'hC: seg7 = 7'b0110001;
            4'hD: seg7 = 7'b1000010;
            4'hE: seg7 = 7'b0110000;
            default: seg7 = 7'b0111000;
        endcase

        seg = {seg7, 1'b1}; // decimal point off
    end
endmodule
