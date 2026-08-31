`timescale 1ns / 1ps

module cu_riu(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       step_en,
    input  wire       IS_R,
    input  wire       IS_IMM,
    input  wire       IS_LUI,
    input  wire [3:0] ALU_OP,
    output reg        PC_Write,
    output reg        IR_Write,
    output reg        A_Write,
    output reg        B_Write,
    output reg        F_Write,
    output reg        FR_Write,
    output reg        Reg_Write,
    output reg        rs2_imm_s,
    output reg        w_data_s,
    output reg  [3:0] ALU_OP_o,
    output reg  [2:0] ST
);
    localparam Idle = 3'd0;
    localparam S1   = 3'd1; // IF: IMem[PC] -> IR, PC+4 -> PC
    localparam S2   = 3'd2; // ID: Reg[rs1] -> A, Reg[rs2] -> B
    localparam S3   = 3'd3; // EX_R: A op B -> F/FR
    localparam S4   = 3'd4; // WB: F -> Reg[rd]
    localparam S5   = 3'd5; // EX_I: A op imm32 -> F/FR
    localparam S6   = 3'd6; // LUI_WB: imm32 -> Reg[rd]

    reg [2:0] Next_ST;

    always @(*) begin
        Next_ST = S1;
        case (ST)
            Idle: Next_ST = S1;
            S1: begin
                if (IS_LUI) begin
                    Next_ST = S6;
                end else begin
                    Next_ST = S2;
                end
            end
            S2: begin
                if (IS_R) begin
                    Next_ST = S3;
                end else if (IS_IMM) begin
                    Next_ST = S5;
                end else begin
                    Next_ST = S1;
                end
            end
            S3: Next_ST = S4;
            S5: Next_ST = S4;
            S4: Next_ST = S1;
            S6: Next_ST = S1;
            default: Next_ST = S1;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ST <= Idle;
        end else if (step_en) begin
            ST <= Next_ST;
        end
    end

    always @(*) begin
        PC_Write  = 1'b0;
        IR_Write  = 1'b0;
        A_Write   = 1'b0;
        B_Write   = 1'b0;
        F_Write   = 1'b0;
        FR_Write  = 1'b0;
        Reg_Write = 1'b0;
        rs2_imm_s = 1'b0;
        w_data_s  = 1'b0;
        ALU_OP_o  = ALU_OP;

        case (Next_ST)
            S1: begin
                PC_Write = 1'b1;
                IR_Write = 1'b1;
            end
            S2: begin
                A_Write = 1'b1;
                B_Write = 1'b1;
            end
            S3: begin
                F_Write   = 1'b1;
                FR_Write  = 1'b1;
                rs2_imm_s = 1'b0;
                ALU_OP_o  = ALU_OP;
            end
            S4: begin
                Reg_Write = 1'b1;
                w_data_s  = 1'b0;
            end
            S5: begin
                F_Write   = 1'b1;
                FR_Write  = 1'b1;
                rs2_imm_s = 1'b1;
                ALU_OP_o  = ALU_OP;
            end
            S6: begin
                Reg_Write = 1'b1;
                w_data_s  = 1'b1;
            end
            default: begin
            end
        endcase
    end
endmodule
