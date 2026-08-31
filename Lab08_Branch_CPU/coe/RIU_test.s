# 实验8 RIU_CPU 测试程序
# 覆盖 10 条 R 型运算指令、9 条 I 型运算指令、1 条 U 型 lui 指令

main:
    lui  x1, 0x00001       # x1  = 0x00001000
    addi x1, x1, 5         # x1  = 0x00001005
    addi x2, x0, 4         # x2  = 0x00000004
    add  x3, x1, x2        # x3  = 0x00001009
    sub  x4, x1, x2        # x4  = 0x00001001
    sll  x5, x1, x2        # x5  = 0x00010050
    slt  x6, x1, x2        # x6  = 0x00000000
    sltu x7, x1, x2        # x7  = 0x00000000
    xor  x8, x1, x2        # x8  = 0x00001001
    srl  x9, x1, x2        # x9  = 0x00000100
    sra  x10, x1, x2       # x10 = 0x00000100
    or   x11, x1, x2       # x11 = 0x00001005
    and  x12, x1, x2       # x12 = 0x00000004
    addi x13, x0, -1       # x13 = 0xFFFFFFFF
    slli x14, x13, 3       # x14 = 0xFFFFFFF8
    srli x15, x13, 4       # x15 = 0x0FFFFFFF
    srai x16, x13, 4       # x16 = 0xFFFFFFFF
    slti x17, x13, 1       # x17 = 0x00000001
    sltiu x18, x13, 1      # x18 = 0x00000000
    xori x19, x13, 0x0ff   # x19 = 0xFFFFFF00
    ori  x20, x13, 0x0ff   # x20 = 0xFFFFFFFF
    andi x21, x13, 0x0ff   # x21 = 0x000000FF
