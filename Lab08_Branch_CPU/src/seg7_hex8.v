`timescale 1ns / 1ps

module seg7_hex8(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] data,
    output reg  [7:0]  AN,
    output reg  [7:0]  SEG
);
    reg [16:0] div_cnt;
    reg [2:0]  scan_sel;
    reg [3:0]  hex;
    reg [6:0]  seg_a_to_g;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_cnt  <= 17'd0;
            scan_sel <= 3'd0;
        end else begin
            div_cnt <= div_cnt + 17'd1;
            if (div_cnt == 17'd0) begin
                scan_sel <= scan_sel + 3'd1;
            end
        end
    end

    always @(*) begin
        case (scan_sel)
            3'd0: begin AN = 8'b1111_1110; hex = data[3:0];   end
            3'd1: begin AN = 8'b1111_1101; hex = data[7:4];   end
            3'd2: begin AN = 8'b1111_1011; hex = data[11:8];  end
            3'd3: begin AN = 8'b1111_0111; hex = data[15:12]; end
            3'd4: begin AN = 8'b1110_1111; hex = data[19:16]; end
            3'd5: begin AN = 8'b1101_1111; hex = data[23:20]; end
            3'd6: begin AN = 8'b1011_1111; hex = data[27:24]; end
            3'd7: begin AN = 8'b0111_1111; hex = data[31:28]; end
            default: begin AN = 8'b1111_1111; hex = 4'h0; end
        endcase
    end

    always @(*) begin
        case (hex)
            4'h0: seg_a_to_g = 7'b1000000;
            4'h1: seg_a_to_g = 7'b1111001;
            4'h2: seg_a_to_g = 7'b0100100;
            4'h3: seg_a_to_g = 7'b0110000;
            4'h4: seg_a_to_g = 7'b0011001;
            4'h5: seg_a_to_g = 7'b0010010;
            4'h6: seg_a_to_g = 7'b0000010;
            4'h7: seg_a_to_g = 7'b1111000;
            4'h8: seg_a_to_g = 7'b0000000;
            4'h9: seg_a_to_g = 7'b0010000;
            4'hA: seg_a_to_g = 7'b0001000;
            4'hB: seg_a_to_g = 7'b0000011;
            4'hC: seg_a_to_g = 7'b1000110;
            4'hD: seg_a_to_g = 7'b0100001;
            4'hE: seg_a_to_g = 7'b0000110;
            4'hF: seg_a_to_g = 7'b0001110;
            default: seg_a_to_g = 7'b1111111;
        endcase
        SEG[6:0] = seg_a_to_g;
        SEG[7]   = 1'b1; // DP 熄灭
    end
endmodule
