# Experiment 9 validation program
main:
    addi x31, x0, 16       # x31 = data base address 16
    lw   x26, 0(x31)       # x26 = 0x11111111
    lw   x27, 4(x31)       # x27 = 0x22222222
    sw   x27, 0(x31)       # DM[16] = 0x22222222
    sw   x26, 4(x31)       # DM[20] = 0x11111111
    lw   x26, 0(x31)       # x26 = 0x22222222
    lw   x27, 4(x31)       # x27 = 0x11111111
    add  x28, x26, x27     # x28 = 0x33333333
    sw   x28, 16(x0)       # DM[16] = 0x33333333
    lw   x29, 16(x0)       # x29 = 0x33333333
