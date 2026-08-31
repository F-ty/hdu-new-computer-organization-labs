`timescale 1ns/1ps

module rv32i_imem #(
    parameter MEM_FILE = "program.mem"
)(
    input  wire [31:0] addr,
    output wire [31:0] rdata
);
    integer i;
    reg [31:0] mem [0:63];

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h00000013; // nop = addi x0,x0,0
        $readmemh(MEM_FILE, mem);
    end

    assign rdata = mem[addr[7:2]];
endmodule
