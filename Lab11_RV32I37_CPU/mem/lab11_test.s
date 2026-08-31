    lui x1,0x0
    addi x1,x1,0x40
    lb x5,0(x1)
    lbu x6,0(x1)
    lh x7,2(x1)
    lhu x8,0(x1)
    lw x9,0(x1)
    addi x10,x0,-1
    sb x10,4(x1)
    sh x10,6(x1)
    sw x10,8(x1)
    lbu x11,4(x1)
    lhu x12,6(x1)
    lw x13,8(x1)
    addi x2,x0,5
    addi x3,x0,-3
    add x21,x2,x3
    sub x22,x2,x3
    sll x23,x2,x2
    slt x24,x3,x2
    sltu x25,x3,x2
    xor x26,x2,x3
    srl x27,x3,x2
    sra x28,x3,x2
    or x29,x2,x3
    and x30,x2,x3
    addi x4,x2,7
    slti x5,x3,0
    sltiu x6,x3,1
    xori x7,x2,0xF
    ori x8,x2,0x10
    andi x9,x3,0xF
    slli x10,x2,3
    srli x11,x3,4
    srai x12,x3,4
    lui x13,0x12345
    auipc x14,0x1
    jal x31,subroutine
    addi x18,x0,0x55
    addi x15,x0,5
    addi x16,x0,5
    addi x20,x0,0
    beq x15,x16,L1
    addi x20,x20,1
L1:
    bne x15,x16,ERR
    addi x20,x20,2
    addi x17,x0,-1
    blt x17,x15,L3
    addi x20,x20,4
L3:
    bge x15,x17,L4
    addi x20,x20,8
L4:
    bltu x15,x17,L5
    addi x20,x20,16
L5:
    bgeu x17,x15,L6
    addi x20,x20,32
L6:
    addi x20,x20,64
done:
    jal x0,done
ERR:
    addi x20,x0,0xEE
    jal x0,done
subroutine:
    addi x19,x0,0x33
    jalr x0,0(x31)
