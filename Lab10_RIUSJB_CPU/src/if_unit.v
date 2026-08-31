`timescale 1ns / 1ps
module if_unit(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        PC_Write,
    input  wire        IR_Write,
    input  wire        PC0_Write,
    input  wire [1:0]  PC_s,
    input  wire [31:0] inst_code,
    input  wire [31:0] rel_target,
    input  wire [31:0] jalr_target,
    output reg  [31:0] PC,
    output reg  [31:0] PC0,
    output reg  [31:0] IR,
    output wire [5:0]  IM_Addr
);
    assign IM_Addr = PC[7:2];

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            PC  <= 32'h0000_0000;
            PC0 <= 32'h0000_0000;
            IR  <= 32'h0000_0000;
        end else begin
            if (PC0_Write)
                PC0 <= PC;
            if (IR_Write)
                IR <= inst_code;
            if (PC_Write) begin
                case (PC_s)
                    2'b00: PC <= PC + 32'd4;
                    2'b01: PC <= rel_target;
                    2'b10: PC <= {jalr_target[31:1], 1'b0};
                    default: PC <= PC + 32'd4;
                endcase
            end
        end
    end
endmodule
