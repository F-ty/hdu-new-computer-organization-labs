from pathlib import Path

OUT = Path(__file__).resolve().parent

REG = {f'x{i}': i for i in range(32)}

def mask(v, bits):
    return v & ((1 << bits) - 1)

def r_type(f7, rs2, rs1, f3, rd, op=0b0110011):
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op

def i_type(imm, rs1, f3, rd, op):
    return (mask(imm, 12) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op

def s_type(imm, rs2, rs1, f3, op=0b0100011):
    imm = mask(imm, 12)
    return ((imm >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | ((imm & 0x1F) << 7) | op

def b_type(offset, rs2, rs1, f3, op=0b1100011):
    imm = mask(offset, 13)
    return (((imm >> 12) & 1) << 31) | (((imm >> 5) & 0x3F) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (((imm >> 1) & 0xF) << 8) | (((imm >> 11) & 1) << 7) | op

def u_type(imm20, rd, op):
    return (mask(imm20, 20) << 12) | (rd << 7) | op

def j_type(offset, rd, op=0b1101111):
    imm = mask(offset, 21)
    return (((imm >> 20) & 1) << 31) | (((imm >> 1) & 0x3FF) << 21) | (((imm >> 11) & 1) << 20) | (((imm >> 12) & 0xFF) << 12) | (rd << 7) | op

program = []
labels = {}
fixups = []

def label(name):
    labels[name] = len(program) * 4

def emit(text, code=None, fixup=None):
    idx = len(program)
    program.append({'pc': idx * 4, 'text': text, 'code': code})
    if fixup:
        fixups.append((idx, fixup))

# Memory and small-size access tests
emit('lui x1,0x0', u_type(0x0, 1, 0b0110111))
emit('addi x1,x1,0x40', i_type(0x40, 1, 0b000, 1, 0b0010011))
emit('lb x5,0(x1)', i_type(0, 1, 0b000, 5, 0b0000011))
emit('lbu x6,0(x1)', i_type(0, 1, 0b100, 6, 0b0000011))
emit('lh x7,2(x1)', i_type(2, 1, 0b001, 7, 0b0000011))
emit('lhu x8,0(x1)', i_type(0, 1, 0b101, 8, 0b0000011))
emit('lw x9,0(x1)', i_type(0, 1, 0b010, 9, 0b0000011))
emit('addi x10,x0,-1', i_type(-1, 0, 0b000, 10, 0b0010011))
emit('sb x10,4(x1)', s_type(4, 10, 1, 0b000))
emit('sh x10,6(x1)', s_type(6, 10, 1, 0b001))
emit('sw x10,8(x1)', s_type(8, 10, 1, 0b010))
emit('lbu x11,4(x1)', i_type(4, 1, 0b100, 11, 0b0000011))
emit('lhu x12,6(x1)', i_type(6, 1, 0b101, 12, 0b0000011))
emit('lw x13,8(x1)', i_type(8, 1, 0b010, 13, 0b0000011))

# R-type tests
emit('addi x2,x0,5', i_type(5, 0, 0b000, 2, 0b0010011))
emit('addi x3,x0,-3', i_type(-3, 0, 0b000, 3, 0b0010011))
emit('add x21,x2,x3', r_type(0b0000000, 3, 2, 0b000, 21))
emit('sub x22,x2,x3', r_type(0b0100000, 3, 2, 0b000, 22))
emit('sll x23,x2,x2', r_type(0b0000000, 2, 2, 0b001, 23))
emit('slt x24,x3,x2', r_type(0b0000000, 2, 3, 0b010, 24))
emit('sltu x25,x3,x2', r_type(0b0000000, 2, 3, 0b011, 25))
emit('xor x26,x2,x3', r_type(0b0000000, 3, 2, 0b100, 26))
emit('srl x27,x3,x2', r_type(0b0000000, 2, 3, 0b101, 27))
emit('sra x28,x3,x2', r_type(0b0100000, 2, 3, 0b101, 28))
emit('or x29,x2,x3', r_type(0b0000000, 3, 2, 0b110, 29))
emit('and x30,x2,x3', r_type(0b0000000, 3, 2, 0b111, 30))

# I-type arithmetic tests
emit('addi x4,x2,7', i_type(7, 2, 0b000, 4, 0b0010011))
emit('slti x5,x3,0', i_type(0, 3, 0b010, 5, 0b0010011))
emit('sltiu x6,x3,1', i_type(1, 3, 0b011, 6, 0b0010011))
emit('xori x7,x2,0xF', i_type(0xF, 2, 0b100, 7, 0b0010011))
emit('ori x8,x2,0x10', i_type(0x10, 2, 0b110, 8, 0b0010011))
emit('andi x9,x3,0xF', i_type(0xF, 3, 0b111, 9, 0b0010011))
emit('slli x10,x2,3', i_type(3, 2, 0b001, 10, 0b0010011))
emit('srli x11,x3,4', i_type(4, 3, 0b101, 11, 0b0010011))
emit('srai x12,x3,4', i_type((0b0100000 << 5) | 4, 3, 0b101, 12, 0b0010011))
emit('lui x13,0x12345', u_type(0x12345, 13, 0b0110111))
emit('auipc x14,0x1', u_type(0x1, 14, 0b0010111))

# Jump and link tests
emit('jal x31,subroutine', fixup=('jal', 31, 'subroutine'))
emit('addi x18,x0,0x55', i_type(0x55, 0, 0b000, 18, 0b0010011))

# Six branch tests. Final x20 must be 0x42.
emit('addi x15,x0,5', i_type(5, 0, 0b000, 15, 0b0010011))
emit('addi x16,x0,5', i_type(5, 0, 0b000, 16, 0b0010011))
emit('addi x20,x0,0', i_type(0, 0, 0b000, 20, 0b0010011))
emit('beq x15,x16,L1', fixup=('branch', 0b000, 15, 16, 'L1'))
emit('addi x20,x20,1', i_type(1, 20, 0b000, 20, 0b0010011))
label('L1')
emit('bne x15,x16,ERR', fixup=('branch', 0b001, 15, 16, 'ERR'))
emit('addi x20,x20,2', i_type(2, 20, 0b000, 20, 0b0010011))
emit('addi x17,x0,-1', i_type(-1, 0, 0b000, 17, 0b0010011))
emit('blt x17,x15,L3', fixup=('branch', 0b100, 17, 15, 'L3'))
emit('addi x20,x20,4', i_type(4, 20, 0b000, 20, 0b0010011))
label('L3')
emit('bge x15,x17,L4', fixup=('branch', 0b101, 15, 17, 'L4'))
emit('addi x20,x20,8', i_type(8, 20, 0b000, 20, 0b0010011))
label('L4')
emit('bltu x15,x17,L5', fixup=('branch', 0b110, 15, 17, 'L5'))
emit('addi x20,x20,16', i_type(16, 20, 0b000, 20, 0b0010011))
label('L5')
emit('bgeu x17,x15,L6', fixup=('branch', 0b111, 17, 15, 'L6'))
emit('addi x20,x20,32', i_type(32, 20, 0b000, 20, 0b0010011))
label('L6')
emit('addi x20,x20,64', i_type(64, 20, 0b000, 20, 0b0010011))
label('done')
emit('jal x0,done', fixup=('jal', 0, 'done'))
label('ERR')
emit('addi x20,x0,0xEE', i_type(0xEE, 0, 0b000, 20, 0b0010011))
emit('jal x0,done', fixup=('jal', 0, 'done'))
label('subroutine')
emit('addi x19,x0,0x33', i_type(0x33, 0, 0b000, 19, 0b0010011))
emit('jalr x0,0(x31)', i_type(0, 31, 0b000, 0, 0b1100111))

for idx, f in fixups:
    pc = idx * 4
    kind = f[0]
    if kind == 'jal':
        _, rd, target = f
        offset = labels[target] - pc
        program[idx]['code'] = j_type(offset, rd)
    elif kind == 'branch':
        _, f3, rs1, rs2, target = f
        offset = labels[target] - pc
        program[idx]['code'] = b_type(offset, rs2, rs1, f3)

assert len(program) <= 64
assert all(item['code'] is not None for item in program)

(OUT / 'program.mem').write_text('\n'.join(f"{item['code']:08x}" for item in program) + '\n', encoding='ascii')

asm_lines = []
for name, addr in sorted(labels.items(), key=lambda x: x[1]):
    pass
# Reconstruct assembly with labels placed before matching PCs.
labels_by_pc = {}
for name, addr in labels.items():
    labels_by_pc.setdefault(addr, []).append(name)
for item in program:
    if item['pc'] in labels_by_pc:
        for name in labels_by_pc[item['pc']]:
            asm_lines.append(f'{name}:')
    asm_lines.append(f"    {item['text']}")
(OUT / 'lab11_test.s').write_text('\n'.join(asm_lines) + '\n', encoding='utf-8')

rows = ['序号\tPC\t机器码\t汇编指令']
for i, item in enumerate(program):
    rows.append(f"{i}\t{item['pc']:08X}\t{item['code']:08X}\t{item['text']}")
(OUT / 'program_disassembly.txt').write_text('\n'.join(rows) + '\n', encoding='utf-8')

# Byte-addressed data memory. The four bytes at 0x40 form 0x12347F80 in little endian.
data = [0] * 256
data[0x40:0x44] = [0x80, 0x7F, 0x34, 0x12]
(OUT / 'data.mem').write_text('\n'.join(f'{b:02x}' for b in data) + '\n', encoding='ascii')

print(f'Generated {len(program)} instructions')
print(f"auipc pc = 0x{36*4:08X}, expected x14 = 0x{36*4 + 0x1000:08X}")
