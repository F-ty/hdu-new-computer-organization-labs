# 实验12完整指令类型测试程序，共覆盖25种目标指令
main:
    addi x1,  x0, 5
    addi x2,  x0, 3
    add  x3,  x1, x2
    sub  x4,  x1, x2
    sll  x5,  x1, x2
    slt  x6,  x2, x1
    sltu x7,  x1, x2
    xor  x8,  x1, x2
    srl  x9,  x5, x2
    sra  x10, x5, x2
    or   x11, x1, x2
    and  x12, x1, x2
    slli x13, x2, 4
    srli x14, x13, 2
    addi x15, x0, -16
    srai x16, x15, 2
    slti x17, x2, 4
    sltiu x18, x2, 2
    xori x19, x1, 0xF
    ori  x20, x2, 8
    andi x21, x20, 7
    lui  x22, 0x12345
    sw   x3, 0(x0)
    lw   x23, 0(x0)
    beq  x23, x3, branch_ok
    addi x24, x0, 0x7EE       # 分支正确时应跳过
branch_ok:
    jal  x25, subroutine
    addi x26, x0, 0x55
    jal  x0, done
subroutine:
    addi x27, x0, 0x66
    jalr x0, 0(x25)
done:
    jal  x0, done
