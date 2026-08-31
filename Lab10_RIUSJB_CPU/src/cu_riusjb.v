`timescale 1ns / 1ps
module cu_riusjb(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       IS_R,
    input  wire       IS_IMM,
    input  wire       IS_LUI,
    input  wire       IS_LW,
    input  wire       IS_SW,
    input  wire       IS_BEQ,
    input  wire       IS_JAL,
    input  wire       IS_JALR,
    input  wire [3:0] ALU_OP,
    input  wire       ZF,
    output reg        Reg_Write,
    output reg        rs2_imm_s,
    output reg  [1:0] w_data_s,
    output reg        Mem_Write,
    output reg        PC_Write,
    output reg        IR_Write,
    output reg        PC0_Write,
    output reg  [1:0] PC_s,
    output reg  [3:0] ALU_OP_o,
    output reg  [3:0] ST
);
    localparam S1  = 4'd1;   // IF
    localparam S2  = 4'd2;   // ID
    localparam S3  = 4'd3;   // R EX
    localparam S4  = 4'd4;   // ALU WB
    localparam S5  = 4'd5;   // I EX
    localparam S6  = 4'd6;   // LUI WB
    localparam S7  = 4'd7;   // EA or JALR target
    localparam S8  = 4'd8;   // LW MEM
    localparam S9  = 4'd9;   // LW WB
    localparam S10 = 4'd10;  // SW MEM
    localparam S11 = 4'd11;  // JAL link and jump
    localparam S12 = 4'd12;  // JALR link and jump
    localparam S13 = 4'd13;  // BEQ compare
    localparam S14 = 4'd14;  // BEQ conditional PC write

    reg [3:0] Next_ST;

    always @(negedge rst_n or posedge clk) begin
        if (!rst_n)
            ST <= S1;
        else
            ST <= Next_ST;
    end

    always @(*) begin
        Next_ST = S1;
        case (ST)
            S1: begin
                if (IS_JAL)
                    Next_ST = S11;
                else if (IS_LUI)
                    Next_ST = S6;
                else
                    Next_ST = S2;
            end
            S2: begin
                if (IS_R)
                    Next_ST = S3;
                else if (IS_IMM)
                    Next_ST = S5;
                else if (IS_LW || IS_SW || IS_JALR)
                    Next_ST = S7;
                else if (IS_BEQ)
                    Next_ST = S13;
                else
                    Next_ST = S1;
            end
            S3:  Next_ST = S4;
            S4:  Next_ST = S1;
            S5:  Next_ST = S4;
            S6:  Next_ST = S1;
            S7: begin
                if (IS_LW)
                    Next_ST = S8;
                else if (IS_SW)
                    Next_ST = S10;
                else if (IS_JALR)
                    Next_ST = S12;
                else
                    Next_ST = S1;
            end
            S8:  Next_ST = S9;
            S9:  Next_ST = S1;
            S10: Next_ST = S1;
            S11: Next_ST = S1;
            S12: Next_ST = S1;
            S13: Next_ST = S14;
            S14: Next_ST = S1;
            default: Next_ST = S1;
        endcase
    end

    always @(*) begin
        Reg_Write = 1'b0;
        rs2_imm_s = 1'b0;
        w_data_s  = 2'b00;
        Mem_Write = 1'b0;
        PC_Write  = 1'b0;
        IR_Write  = 1'b0;
        PC0_Write = 1'b0;
        PC_s      = 2'b00;
        ALU_OP_o  = ALU_OP;

        case (ST)
            S1: begin
                PC_Write  = 1'b1;
                IR_Write  = 1'b1;
                PC0_Write = 1'b1;
                PC_s      = 2'b00;
            end
            S3: begin
                rs2_imm_s = 1'b0;
                ALU_OP_o  = ALU_OP;
            end
            S4: begin
                Reg_Write = 1'b1;
                w_data_s  = 2'b00;
            end
            S5: begin
                rs2_imm_s = 1'b1;
                ALU_OP_o  = ALU_OP;
            end
            S6: begin
                Reg_Write = 1'b1;
                w_data_s  = 2'b01;
            end
            S7: begin
                rs2_imm_s = 1'b1;
                ALU_OP_o  = 4'b0000;
            end
            S9: begin
                Reg_Write = 1'b1;
                w_data_s  = 2'b10;
            end
            S10: begin
                Mem_Write = 1'b1;
            end
            S11: begin
                Reg_Write = 1'b1;
                w_data_s  = 2'b11;
                PC_Write  = 1'b1;
                PC_s      = 2'b01;
            end
            S12: begin
                Reg_Write = 1'b1;
                w_data_s  = 2'b11;
                PC_Write  = 1'b1;
                PC_s      = 2'b10;
            end
            S13: begin
                rs2_imm_s = 1'b0;
                ALU_OP_o  = 4'b1000;
            end
            S14: begin
                PC_s      = 2'b01;
                PC_Write  = ZF;
            end
            default: begin
            end
        endcase
    end
endmodule
