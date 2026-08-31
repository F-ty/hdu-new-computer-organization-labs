module DISPLAY (
    input clk,
    input [31:0] data,
    output reg [7:0] which,
    output reg [7:0] seg
);

    reg [19:0] cnt;
    reg [2:0] scan;
    reg [3:0] hex;

    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    always @(*) begin
        scan = cnt[16:14];

        case (scan)
            3'd0: hex = data[3:0];
            3'd1: hex = data[7:4];
            3'd2: hex = data[11:8];
            3'd3: hex = data[15:12];
            3'd4: hex = data[19:16];
            3'd5: hex = data[23:20];
            3'd6: hex = data[27:24];
            3'd7: hex = data[31:28];
            default: hex = 4'h0;
        endcase

        which = ~(8'b0000_0001 << scan);

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