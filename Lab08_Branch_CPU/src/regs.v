`timescale 1ns / 1ps

module regs(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        step_en,
    input  wire        Reg_Write,
    input  wire [4:0]  R_Addr_A,
    input  wire [4:0]  R_Addr_B,
    input  wire [4:0]  W_Addr,
    input  wire [31:0] W_Data,
    output wire [31:0] R_Data_A,
    output wire [31:0] R_Data_B
);
    reg [31:0] rf [0:31];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf[i] <= 32'h0000_0000;
            end
        end else if (step_en && Reg_Write && (W_Addr != 5'd0)) begin
            rf[W_Addr] <= W_Data;
        end
    end

    assign R_Data_A = (R_Addr_A == 5'd0) ? 32'h0000_0000 : rf[R_Addr_A];
    assign R_Data_B = (R_Addr_B == 5'd0) ? 32'h0000_0000 : rf[R_Addr_B];
endmodule
