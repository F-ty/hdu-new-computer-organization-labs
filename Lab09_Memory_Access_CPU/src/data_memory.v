`timescale 1ns / 1ps

// 64 x 32-bit data memory, word access through byte addresses.
// Address 16 initially holds 0x11111111; address 20 holds 0x22222222.
module data_memory (
    input  wire        clk,
    input  wire        step_en,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'b0;

        mem[4] = 32'h11111111; // byte address 16
        mem[5] = 32'h22222222; // byte address 20
    end

    assign rdata = mem[addr[7:2]];

    always @(posedge clk) begin
        if (step_en && we)
            mem[addr[7:2]] <= wdata;
    end
endmodule
