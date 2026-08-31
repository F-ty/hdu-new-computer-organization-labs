`timescale 1ns / 1ps
module regs(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        Reg_Write,
    input  wire [4:0]  R_Addr_A,
    input  wire [4:0]  R_Addr_B,
    input  wire [4:0]  W_Addr,
    input  wire [31:0] W_Data,
    output wire [31:0] R_Data_A,
    output wire [31:0] R_Data_B
);
    reg [31:0] regs [0:31];
    integer i;

    assign R_Data_A = (R_Addr_A == 5'd0) ? 32'h0000_0000 : regs[R_Addr_A];
    assign R_Data_B = (R_Addr_B == 5'd0) ? 32'h0000_0000 : regs[R_Addr_B];

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'h0000_0000;
        end else begin
            regs[0] <= 32'h0000_0000;
            if (Reg_Write && (W_Addr != 5'd0))
                regs[W_Addr] <= W_Data;
        end
    end
endmodule
