module instruction_rom(
    input  wire [31:0] addr,
    output reg  [31:0] data
);
    // 64 x 32 位组合读 ROM。测试程序覆盖实验 12 的全部 25 条指令类型。
    always @(*) begin
        case (addr[7:2])
            6'd0:  data = 32'h00500093; // addi x1,x0,5
            6'd1:  data = 32'h00300113; // addi x2,x0,3
            6'd2:  data = 32'h002081B3; // add x3,x1,x2
            6'd3:  data = 32'h40208233; // sub x4,x1,x2
            6'd4:  data = 32'h002092B3; // sll x5,x1,x2
            6'd5:  data = 32'h00112333; // slt x6,x2,x1
            6'd6:  data = 32'h0020B3B3; // sltu x7,x1,x2
            6'd7:  data = 32'h0020C433; // xor x8,x1,x2
            6'd8:  data = 32'h0022D4B3; // srl x9,x5,x2
            6'd9:  data = 32'h4022D533; // sra x10,x5,x2
            6'd10: data = 32'h0020E5B3; // or x11,x1,x2
            6'd11: data = 32'h0020F633; // and x12,x1,x2
            6'd12: data = 32'h00411693; // slli x13,x2,4
            6'd13: data = 32'h0026D713; // srli x14,x13,2
            6'd14: data = 32'hFF000793; // addi x15,x0,-16
            6'd15: data = 32'h4027D813; // srai x16,x15,2
            6'd16: data = 32'h00412893; // slti x17,x2,4
            6'd17: data = 32'h00213913; // sltiu x18,x2,2
            6'd18: data = 32'h00F0C993; // xori x19,x1,0xF
            6'd19: data = 32'h00816A13; // ori x20,x2,8
            6'd20: data = 32'h007A7A93; // andi x21,x20,7
            6'd21: data = 32'h12345B37; // lui x22,0x12345
            6'd22: data = 32'h00302023; // sw x3,0(x0)
            6'd23: data = 32'h00002B83; // lw x23,0(x0)
            6'd24: data = 32'h003B8463; // beq x23,x3,branch_ok
            6'd25: data = 32'h7EE00C13; // addi x24,x0,0x7EE，应被跳过
            6'd26: data = 32'h00C00CEF; // jal x25,subroutine
            6'd27: data = 32'h05500D13; // addi x26,x0,0x55
            6'd28: data = 32'h00C0006F; // jal x0,done
            6'd29: data = 32'h06600D93; // subroutine: addi x27,x0,0x66
            6'd30: data = 32'h000C8067; // jalr x0,0(x25)
            6'd31: data = 32'h0000006F; // done: jal x0,done
            default: data = 32'h00000013; // nop = addi x0,x0,0
        endcase
    end
endmodule
