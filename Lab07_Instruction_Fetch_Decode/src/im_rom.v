module im_rom(
    input  wire        clk,
    input  wire [5:0]  addr,
    output wire [31:0] inst_code
);
    ROM_B u_rom_b (
        .clka  (clk),
        .addra (addr),
        .douta (inst_code)
    );
endmodule