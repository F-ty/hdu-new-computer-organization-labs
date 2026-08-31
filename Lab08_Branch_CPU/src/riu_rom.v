`timescale 1ns / 1ps

module riu_rom(
    input  wire [5:0]  addr,
    output reg  [31:0] inst
);
    always @(*) begin
        case (addr)
            6'd0:  inst = 32'h000010B7; // lui x1,0x00001
            6'd1:  inst = 32'h00508093; // addi x1,x1,5
            6'd2:  inst = 32'h00400113; // addi x2,x0,4
            6'd3:  inst = 32'h002081B3; // add x3,x1,x2
            6'd4:  inst = 32'h40208233; // sub x4,x1,x2
            6'd5:  inst = 32'h002092B3; // sll x5,x1,x2
            6'd6:  inst = 32'h0020A333; // slt x6,x1,x2
            6'd7:  inst = 32'h0020B3B3; // sltu x7,x1,x2
            6'd8:  inst = 32'h0020C433; // xor x8,x1,x2
            6'd9:  inst = 32'h0020D4B3; // srl x9,x1,x2
            6'd10: inst = 32'h4020D533; // sra x10,x1,x2
            6'd11: inst = 32'h0020E5B3; // or x11,x1,x2
            6'd12: inst = 32'h0020F633; // and x12,x1,x2
            6'd13: inst = 32'hFFF00693; // addi x13,x0,-1
            6'd14: inst = 32'h00369713; // slli x14,x13,3
            6'd15: inst = 32'h0046D793; // srli x15,x13,4
            6'd16: inst = 32'h4046D813; // srai x16,x13,4
            6'd17: inst = 32'h0016A893; // slti x17,x13,1
            6'd18: inst = 32'h0016B913; // sltiu x18,x13,1
            6'd19: inst = 32'h0FF6C993; // xori x19,x13,0x0ff
            6'd20: inst = 32'h0FF6EA13; // ori x20,x13,0x0ff
            6'd21: inst = 32'h0FF6FA93; // andi x21,x13,0x0ff
            default: inst = 32'h00000013; // addi x0,x0,0, NOP
        endcase
    end
endmodule
