`timescale 1ns / 1ps
module instr_mem(
    input  wire [5:0]  addr,
    output wire [31:0] inst
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h0000_0013;  // addi x0,x0,0

        mem[ 0] = 32'h0100_0513; // addi x10,x0,0x10
        mem[ 1] = 32'h0030_6593; // ori  x11,x0,3
        mem[ 2] = 32'h0300_4613; // xori x12,x0,0x30
        mem[ 3] = 32'h00c0_00ef; // jal  x1,BankSum  
        mem[ 4] = 32'h0006_2403; // lw   x8,0(x12)
        mem[ 5] = 32'h0300_006f; // jal  x0,End
        mem[ 6] = 32'h0005_02b3; // add  x5,x10,x0
        mem[ 7] = 32'h0005_e333; // or   x6,x11,x0
        mem[ 8] = 32'h0000_73b3; // and  x7,x0,x0
        mem[ 9] = 32'h0002_ae03; // lw   x28,0(x5)
        mem[10] = 32'h01c3_83b3; // add  x7,x7,x28  
        mem[11] = 32'h0042_8293; // addi x5,x5,4
        mem[12] = 32'hfff3_0313; // addi x6,x6,-1
        mem[13] = 32'h0003_0463; // beq  x6,x0,Exit
        mem[14] = 32'hfedf_f06f; // jal  x0,Loop
        mem[15] = 32'h0076_2023; // sw   x7,0(x12)
        mem[16] = 32'h0000_8067; // jalr x0,0(x1)
        mem[17] = 32'h0000_006f; // jal  x0,End
    end

    assign inst = mem[addr];
endmodule
