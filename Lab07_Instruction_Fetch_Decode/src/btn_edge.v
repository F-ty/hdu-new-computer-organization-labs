module btn_edge(
    input  wire clk,
    input  wire rst_n,
    input  wire btn,
    output wire pulse
);
    reg d0, d1, d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d0 <= 1'b0;
            d1 <= 1'b0;
            d2 <= 1'b0;
        end else begin
            d0 <= btn;
            d1 <= d0;
            d2 <= d1;
        end
    end

    assign pulse = d1 & ~d2;
endmodule