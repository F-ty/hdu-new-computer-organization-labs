module alu32(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] y,
    output reg  [3:0]  fr
);
    reg [32:0] ext;
    reg cf;
    reg of;

    always @(*) begin
        y   = 32'b0;
        ext = 33'b0;
        cf  = 1'b0;
        of  = 1'b0;

        case (alu_op)
            4'b0000: begin // add
                ext = {1'b0, a} + {1'b0, b};
                y   = ext[31:0];
                cf  = ext[32];
                of  = (~(a[31] ^ b[31])) & (y[31] ^ a[31]);
            end
            4'b1000: begin // sub
                ext = {1'b0, a} + {1'b0, ~b} + 33'd1;
                y   = ext[31:0];
                cf  = ext[32]; // 1 表示无借位
                of  = (a[31] ^ b[31]) & (y[31] ^ a[31]);
            end
            4'b0001: y = a << b[4:0];
            4'b0010: y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'b0011: y = (a < b) ? 32'd1 : 32'd0;
            4'b0100: y = a ^ b;
            4'b0101: y = a >> b[4:0];
            4'b1101: y = $signed(a) >>> b[4:0];
            4'b0110: y = a | b;
            4'b0111: y = a & b;
            default: y = 32'b0;
        endcase

        // FR[3:0] = {CF, ZF, SF, OF}
        fr = {cf, (y == 32'b0), y[31], of};
    end
endmodule
