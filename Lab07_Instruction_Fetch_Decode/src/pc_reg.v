module pc_reg(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        load_en,
    input  wire [31:0] d,
    output reg  [31:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 32'b0;
        else if (load_en)
            q <= d;
    end
endmodule