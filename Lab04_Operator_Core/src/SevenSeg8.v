`timescale 1ns / 1ps

module SevenSeg8(
    input clk,
    input [31:0] data,
    output reg [7:0] an,
    output reg [7:0] seg
);

    reg [16:0] cnt = 17'd0;
    wire [2:0] scan;
    reg [3:0] hex;

    assign scan = cnt[16:14];

    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    always @(*) begin
        case (scan)
            3'd0: begin an = 8'b1111_1110; hex = data[3:0]; end
            3'd1: begin an = 8'b1111_1101; hex = data[7:4]; end
            3'd2: begin an = 8'b1111_1011; hex = data[11:8]; end
            3'd3: begin an = 8'b1111_0111; hex = data[15:12]; end
            3'd4: begin an = 8'b1110_1111; hex = data[19:16]; end
            3'd5: begin an = 8'b1101_1111; hex = data[23:20]; end
            3'd6: begin an = 8'b1011_1111; hex = data[27:24]; end
            3'd7: begin an = 8'b0111_1111; hex = data[31:28]; end
            default: begin an = 8'b1111_1111; hex = 4'h0; end
        endcase
    end

    always @(*) begin
        case (hex)
            4'h0: seg = 8'b1100_0000;
            4'h1: seg = 8'b1111_1001;
            4'h2: seg = 8'b1010_0100;
            4'h3: seg = 8'b1011_0000;
            4'h4: seg = 8'b1001_1001;
            4'h5: seg = 8'b1001_0010;
            4'h6: seg = 8'b1000_0010;
            4'h7: seg = 8'b1111_1000;
            4'h8: seg = 8'b1000_0000;
            4'h9: seg = 8'b1001_0000;
            4'hA: seg = 8'b1000_1000;
            4'hB: seg = 8'b1000_0011;
            4'hC: seg = 8'b1100_0110;
            4'hD: seg = 8'b1010_0001;
            4'hE: seg = 8'b1000_0110;
            4'hF: seg = 8'b1000_1110;
            default: seg = 8'b1111_1111;
        endcase
    end

endmodule