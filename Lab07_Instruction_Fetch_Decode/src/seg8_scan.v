module seg8_scan(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] data,
    output reg  [7:0]  an,
    output wire [7:0]  seg
);
    reg [16:0] cnt;
    reg [3:0]  hex;

    wire [2:0] idx;
    assign idx = cnt[16:14];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 17'b0;
        else
            cnt <= cnt + 17'd1;
    end

    always @(*) begin
        case (idx)
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
    end

    always @(*) begin
        an = 8'hFF;
        an[idx] = 1'b0;
    end

    hex7seg u_hex7seg (
        .hex (hex),
        .seg (seg)
    );
endmodule