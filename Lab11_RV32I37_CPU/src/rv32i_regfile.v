`timescale 1ns/1ps

module rv32i_regfile(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        ce,
    input  wire        we,
    input  wire [4:0]  raddr1,
    input  wire [4:0]  raddr2,
    input  wire [4:0]  waddr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata1,
    output wire [31:0] rdata2
);
    integer i;
    reg [31:0] regs [0:31];

    assign rdata1 = (raddr1 == 5'd0) ? 32'b0 : regs[raddr1];
    assign rdata2 = (raddr2 == 5'd0) ? 32'b0 : regs[raddr2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (ce && we && (waddr != 5'd0)) begin
            regs[waddr] <= wdata;
        end
    end
endmodule
