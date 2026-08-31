module ALU_REG (
    input         clk,
    input  [3:0]  ALU_OP,
    input  [31:0] Data_A,
    input  [31:0] Data_B,
    input         rst,
    input         clk_A,
    input         clk_B,
    input         clk_F,
    output reg [31:0] A,
    output reg [31:0] B,
    output reg [31:0] F,
    output reg [3:0]  FR
);

    reg [31:0] alu_f;
    reg zf;
    reg sf;
    reg cf;
    reg of;

    reg [32:0] add_tmp;
    reg [32:0] sub_tmp;

    reg rst_d0, rst_d1;
    reg clk_A_d0, clk_A_d1, clk_A_d2;
    reg clk_B_d0, clk_B_d1, clk_B_d2;
    reg clk_F_d0, clk_F_d1, clk_F_d2;

    wire rst_s;
    wire pulse_A;
    wire pulse_B;
    wire pulse_F;

    assign rst_s   = rst_d1;
    assign pulse_A = clk_A_d1 & ~clk_A_d2;
    assign pulse_B = clk_B_d1 & ~clk_B_d2;
    assign pulse_F = clk_F_d1 & ~clk_F_d2;

    always @(posedge clk) begin
        rst_d0 <= rst;
        rst_d1 <= rst_d0;

        clk_A_d0 <= clk_A;
        clk_A_d1 <= clk_A_d0;
        clk_A_d2 <= clk_A_d1;

        clk_B_d0 <= clk_B;
        clk_B_d1 <= clk_B_d0;
        clk_B_d2 <= clk_B_d1;

        clk_F_d0 <= clk_F;
        clk_F_d1 <= clk_F_d0;
        clk_F_d2 <= clk_F_d1;
    end

    always @(*) begin
        add_tmp = {1'b0, A} + {1'b0, B};
        sub_tmp = {1'b0, A} + {1'b0, ~B} + 33'd1;

        alu_f = 32'h0000_0000;
        cf = 1'b0;
        of = 1'b0;

        case (ALU_OP)
            4'b0000: begin
                alu_f = add_tmp[31:0];
                cf = add_tmp[32];
                of = (~(A[31] ^ B[31])) & (A[31] ^ alu_f[31]);
            end

            4'b0001: begin
                alu_f = A << B[4:0];
            end

            4'b0010: begin
                alu_f = ($signed(A) < $signed(B)) ? 32'h0000_0001 : 32'h0000_0000;
            end

            4'b0011: begin
                alu_f = (A < B) ? 32'h0000_0001 : 32'h0000_0000;
            end

            4'b0100: begin
                alu_f = A ^ B;
            end

            4'b0101: begin
                alu_f = A >> B[4:0];
            end

            4'b0110: begin
                alu_f = A | B;
            end

            4'b0111: begin
                alu_f = A & B;
            end

            4'b1000: begin
                alu_f = sub_tmp[31:0];
                cf = ~sub_tmp[32];
                of = (A[31] ^ B[31]) & (A[31] ^ alu_f[31]);
            end

            4'b1101: begin
                alu_f = $signed(A) >>> B[4:0];
            end

            default: begin
                alu_f = 32'h0000_0000;
            end
        endcase

        zf = (alu_f == 32'h0000_0000);
        sf = alu_f[31];
    end

    always @(posedge clk) begin
        if (rst_s) begin
            A  <= 32'h0000_0000;
            B  <= 32'h0000_0000;
            F  <= 32'h0000_0000;
            FR <= 4'b0000;
        end
        else begin
            if (pulse_A)
                A <= Data_A;

            if (pulse_B)
                B <= Data_B;

            if (pulse_F) begin
                F  <= alu_f;
                FR <= {zf, sf, cf, of};
            end
        end
    end

endmodule