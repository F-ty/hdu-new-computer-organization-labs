module data_memory(
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata,
    output wire [31:0] dbg_mem0
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'b0;
    end

    assign rdata    = mem[addr[7:2]];
    assign dbg_mem0 = mem[0];

    always @(posedge clk) begin
        if (we)
            mem[addr[7:2]] <= wdata;
    end
endmodule
