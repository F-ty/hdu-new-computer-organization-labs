`timescale 1ns / 1ps

// 32 x 32-bit register file. x0 is permanently zero.
module reg_file (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step_en,
    input  wire        we,
    input  wire [4:0]  raddr_a,
    input  wire [4:0]  raddr_b,
    input  wire [4:0]  waddr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata_a,
    output wire [31:0] rdata_b
);
    reg [31:0] regs [0:31];
    integer i;

    assign rdata_a = (raddr_a == 5'd0) ? 32'b0 : regs[raddr_a];
    assign rdata_b = (raddr_b == 5'd0) ? 32'b0 : regs[raddr_b];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (step_en) begin
            if (we && (waddr != 5'd0))
                regs[waddr] <= wdata;
            regs[0] <= 32'b0;
        end
    end
endmodule
