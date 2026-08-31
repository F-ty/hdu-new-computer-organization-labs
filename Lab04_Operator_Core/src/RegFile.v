`timescale 1ns / 1ps

module RegFile(
    input clk,
    input rst,
    input wb_en,
    input Reg_Write,
    input [4:0] R_Addr_A,
    input [4:0] R_Addr_B,
    input [4:0] W_Addr,
    input [31:0] W_Data,
    output [31:0] R_Data_A,
    output [31:0] R_Data_B
);

    reg [31:0] REG_Files [0:31];
    integer i;

    assign R_Data_A = (R_Addr_A == 5'd0) ? 32'h0000_0000 : REG_Files[R_Addr_A];
    assign R_Data_B = (R_Addr_B == 5'd0) ? 32'h0000_0000 : REG_Files[R_Addr_B];

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                REG_Files[i] <= 32'h0000_0000;
            end

            REG_Files[1]  <= 32'h0000_0001;
            REG_Files[2]  <= 32'h0000_0002;
            REG_Files[3]  <= 32'h0000_0004;
            REG_Files[4]  <= 32'h0000_0008;
            REG_Files[5]  <= 32'h0000_0010;
            REG_Files[6]  <= 32'h0000_000F;
            REG_Files[7]  <= 32'h1234_5678;
            REG_Files[8]  <= 32'h3333_2222;
            REG_Files[9]  <= 32'h7FFF_FFFF;
            REG_Files[10] <= 32'h8000_0000;
            REG_Files[11] <= 32'hFFFF_FFFF;
            REG_Files[12] <= 32'h0000_00FF;
            REG_Files[13] <= 32'h0000_FF00;
            REG_Files[14] <= 32'hAAAA_AAAA;
            REG_Files[15] <= 32'h5555_5555;
        end
        else begin
            if (wb_en && Reg_Write && W_Addr != 5'd0) begin
                REG_Files[W_Addr] <= W_Data;
            end
        end
    end

endmodule