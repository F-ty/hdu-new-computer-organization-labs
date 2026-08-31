`timescale 1ns / 1ps
module data_mem(
    input  wire        clk,
    input  wire        Mem_Write,
    input  wire [5:0]  addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h0000_0000;
        mem[4]  = 32'h0000_0005; // byte address 0x10
        mem[5]  = 32'h0000_0007; // byte address 0x14
        mem[6]  = 32'h0000_0009; // byte address 0x18
        mem[12] = 32'h0000_0000; // byte address 0x30, result
    end

    assign rdata = mem[addr];

    always @(posedge clk) begin
        if (Mem_Write)
            mem[addr] <= wdata;
    end
endmodule
