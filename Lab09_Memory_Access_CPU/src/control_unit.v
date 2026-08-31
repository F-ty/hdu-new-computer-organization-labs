`timescale 1ns / 1ps

// Multi-cycle control unit for Experiment 9.
// Control outputs are decoded from next_state, matching the three-section
// FSM method shown in the course material. Each step pulse completes one
// micro-operation and enters the corresponding displayed state.
module control_unit (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       step_en,
    input  wire       is_r,
    input  wire       is_imm,
    input  wire       is_lui,
    input  wire       is_lw,
    input  wire       is_sw,
    input  wire       valid,
    input  wire [3:0] alu_op_i,

    output reg        pc_write,
    output reg        ir_write,
    output reg        ab_write,
    output reg        f_write,
    output reg        fr_write,
    output reg        mdr_write,
    output reg        reg_write,
    output reg        mem_write,
    output reg        rs2_imm_s,
    output reg [1:0]  w_data_s,
    output reg [3:0]  alu_op_o,
    output reg [3:0]  state,
    output reg [3:0]  next_state
);
    localparam IDLE = 4'd0;
    localparam S1   = 4'd1;  // IF
    localparam S2   = 4'd2;  // ID and read registers
    localparam S3   = 4'd3;  // R-type execute
    localparam S4   = 4'd4;  // arithmetic write-back
    localparam S5   = 4'd5;  // I-type execute
    localparam S6   = 4'd6;  // lui write-back
    localparam S7   = 4'd7;  // effective address calculation
    localparam S8   = 4'd8;  // memory read into MDR
    localparam S9   = 4'd9;  // lw write-back
    localparam S10  = 4'd10; // sw memory write

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else if (step_en)
            state <= next_state;
    end

    always @(*) begin
        next_state = S1;
        case (state)
            IDLE: next_state = S1;

            S1: begin
                if (is_lui)
                    next_state = S6;
                else if (is_r || is_imm || is_lw || is_sw)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (is_r)
                    next_state = S3;
                else if (is_imm)
                    next_state = S5;
                else if (is_lw || is_sw)
                    next_state = S7;
                else
                    next_state = S1;
            end

            S3:  next_state = S4;
            S4:  next_state = S1;
            S5:  next_state = S4;
            S6:  next_state = S1;

            S7: begin
                if (is_lw)
                    next_state = S8;
                else if (is_sw)
                    next_state = S10;
                else
                    next_state = S1;
            end

            S8:  next_state = S9;
            S9:  next_state = S1;
            S10: next_state = S1;
            default: next_state = S1;
        endcase
    end

    always @(*) begin
        pc_write  = 1'b0;
        ir_write  = 1'b0;
        ab_write  = 1'b0;
        f_write   = 1'b0;
        fr_write  = 1'b0;
        mdr_write = 1'b0;
        reg_write = 1'b0;
        mem_write = 1'b0;
        rs2_imm_s = 1'b0;
        w_data_s  = 2'b00;
        alu_op_o  = alu_op_i;

        case (next_state)
            S1: begin
                pc_write = 1'b1;
                ir_write = 1'b1;
            end

            S2: begin
                ab_write = 1'b1;
            end

            S3: begin
                f_write   = 1'b1;
                fr_write  = 1'b1;
                rs2_imm_s = 1'b0;
                alu_op_o  = alu_op_i;
            end

            S4: begin
                reg_write = 1'b1;
                w_data_s  = 2'b00; // F -> rd
            end

            S5: begin
                f_write   = 1'b1;
                fr_write  = 1'b1;
                rs2_imm_s = 1'b1;
                alu_op_o  = alu_op_i;
            end

            S6: begin
                reg_write = 1'b1;
                w_data_s  = 2'b01; // imm32 -> rd
            end

            S7: begin
                f_write   = 1'b1;
                fr_write  = 1'b1;
                rs2_imm_s = 1'b1;
                alu_op_o  = 4'b0000; // EA = A + imm32
            end

            S8: begin
                mdr_write = 1'b1;
            end

            S9: begin
                reg_write = 1'b1;
                w_data_s  = 2'b10; // MDR -> rd
            end

            S10: begin
                mem_write = 1'b1;
            end

            default: begin
                // keep defaults
            end
        endcase
    end
endmodule
