`timescale 1ns / 1ps

// 64 x 32-bit instruction memory, byte-addressed externally.
// The initialization program validates lw, sw and one R-type add.
module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] rdata
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h00000013; // nop = addi x0,x0,0

        mem[0] = 32'h01000F93; // addi x31,x0,16
        mem[1] = 32'h000FAD03; // lw   x26,0(x31)
        mem[2] = 32'h004FAD83; // lw   x27,4(x31)
        mem[3] = 32'h01BFA023; // sw   x27,0(x31)
        mem[4] = 32'h01AFA223; // sw   x26,4(x31)
        mem[5] = 32'h000FAD03; // lw   x26,0(x31)
        mem[6] = 32'h004FAD83; // lw   x27,4(x31)
        mem[7] = 32'h01BD0E33; // add  x28,x26,x27
        mem[8] = 32'h01C02823; // sw   x28,16(x0)
        mem[9] = 32'h01002E83; // lw   x29,16(x0)
    end

    assign rdata = mem[addr[7:2]];
endmodule
