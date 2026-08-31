from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
words = [int(x,16) for x in (ROOT/'mem/program.mem').read_text().split()]
mem = bytearray(int(x,16) for x in (ROOT/'mem/data.mem').read_text().split())
regs=[0]*32
pc=0
trace=[]
steps=0

def sx(v,bits):
    v &= (1<<bits)-1
    return v-(1<<bits) if v>>(bits-1) else v

def u32(v): return v & 0xffffffff

def imm_i(i): return sx(i>>20,12)
def imm_s(i): return sx(((i>>25)<<5)|((i>>7)&0x1f),12)
def imm_b(i):
    v=((i>>31)&1)<<12|((i>>7)&1)<<11|((i>>25)&0x3f)<<5|((i>>8)&0xf)<<1
    return sx(v,13)
def imm_u(i): return i & 0xfffff000
def imm_j(i):
    v=((i>>31)&1)<<20|((i>>12)&0xff)<<12|((i>>20)&1)<<11|((i>>21)&0x3ff)<<1
    return sx(v,21)

def s32(v): return sx(v,32)

def load(addr,size,unsigned):
    if size==1:
        v=mem[addr&0xff]
        return v if unsigned else u32(sx(v,8))
    if size==2:
        a=addr&0xff; v=mem[a]|(mem[(a+1)&0xff]<<8)
        return v if unsigned else u32(sx(v,16))
    a=addr&0xff
    return mem[a]|(mem[(a+1)&0xff]<<8)|(mem[(a+2)&0xff]<<16)|(mem[(a+3)&0xff]<<24)

def store(addr,size,v):
    a=addr&0xff
    for k in range(size): mem[(a+k)&0xff]=(v>>(8*k))&0xff

# Stop after reaching done loop several times.
done_hits=0
while steps<500:
    ins=words[(pc>>2)&0x3f]
    oldpc=pc
    opcode=ins&0x7f; rd=(ins>>7)&31; f3=(ins>>12)&7; rs1=(ins>>15)&31; rs2=(ins>>20)&31; f7=(ins>>25)&0x7f
    a=regs[rs1]; b=regs[rs2]; npc=u32(pc+4); w=None; mnemonic=''
    states=['FETCH','DECODE']
    if opcode==0x33:
        states += ['EXEC_ALU','WB_ALU']
        if f3==0 and f7==0: w=u32(a+b); mnemonic='add'
        elif f3==0 and f7==0x20: w=u32(a-b); mnemonic='sub'
        elif f3==1: w=u32(a<<(b&31)); mnemonic='sll'
        elif f3==2: w=int(s32(a)<s32(b)); mnemonic='slt'
        elif f3==3: w=int(a<b); mnemonic='sltu'
        elif f3==4: w=a^b; mnemonic='xor'
        elif f3==5 and f7==0: w=a>>(b&31); mnemonic='srl'
        elif f3==5 and f7==0x20: w=u32(s32(a)>>(b&31)); mnemonic='sra'
        elif f3==6: w=a|b; mnemonic='or'
        elif f3==7: w=a&b; mnemonic='and'
    elif opcode==0x13:
        states += ['EXEC_ALU','WB_ALU']; im=imm_i(ins)
        if f3==0: w=u32(a+im); mnemonic='addi'
        elif f3==2: w=int(s32(a)<im); mnemonic='slti'
        elif f3==3: w=int(a<u32(im)); mnemonic='sltiu'
        elif f3==4: w=a^u32(im); mnemonic='xori'
        elif f3==6: w=a|u32(im); mnemonic='ori'
        elif f3==7: w=a&u32(im); mnemonic='andi'
        elif f3==1: w=u32(a<<((ins>>20)&31)); mnemonic='slli'
        elif f3==5 and ((ins>>30)&1)==0: w=a>>((ins>>20)&31); mnemonic='srli'
        elif f3==5: w=u32(s32(a)>>((ins>>20)&31)); mnemonic='srai'
    elif opcode==0x37:
        states += ['WB_LUI']; w=imm_u(ins); mnemonic='lui'
    elif opcode==0x17:
        states += ['WB_AUIPC']; w=u32(oldpc+imm_u(ins)); mnemonic='auipc'
    elif opcode==0x03:
        states += ['EXEC_ADDR','MEM_RD','WB_LOAD']; addr=u32(a+imm_i(ins));
        if f3==0: w=load(addr,1,False); mnemonic='lb'
        elif f3==1: w=load(addr,2,False); mnemonic='lh'
        elif f3==2: w=load(addr,4,False); mnemonic='lw'
        elif f3==4: w=load(addr,1,True); mnemonic='lbu'
        elif f3==5: w=load(addr,2,True); mnemonic='lhu'
    elif opcode==0x23:
        states += ['EXEC_ADDR','MEM_WR']; addr=u32(a+imm_s(ins));
        if f3==0: store(addr,1,b); mnemonic='sb'
        elif f3==1: store(addr,2,b); mnemonic='sh'
        elif f3==2: store(addr,4,b); mnemonic='sw'
    elif opcode==0x63:
        states += ['BRANCH']; im=imm_b(ins); take=False
        if f3==0: take=a==b; mnemonic='beq'
        elif f3==1: take=a!=b; mnemonic='bne'
        elif f3==4: take=s32(a)<s32(b); mnemonic='blt'
        elif f3==5: take=s32(a)>=s32(b); mnemonic='bge'
        elif f3==6: take=a<b; mnemonic='bltu'
        elif f3==7: take=a>=b; mnemonic='bgeu'
        if take: npc=u32(oldpc+im)
    elif opcode==0x6f:
        states += ['JAL']; w=u32(oldpc+4); npc=u32(oldpc+imm_j(ins)); mnemonic='jal'
    elif opcode==0x67:
        states += ['EXEC_ADDR','JALR']; w=u32(oldpc+4); npc=u32((a+imm_i(ins))&~1); mnemonic='jalr'
    else:
        raise RuntimeError(hex(ins))
    if w is not None and rd!=0: regs[rd]=u32(w)
    regs[0]=0
    pc=npc
    trace.append({'step':steps,'pc':f'{oldpc:08X}','inst':f'{ins:08X}','mnemonic':mnemonic,'next_pc':f'{pc:08X}','rd':rd,'wdata':f'{(w if w is not None else 0)&0xffffffff:08X}','states':'/'.join(states)})
    steps+=1
    if oldpc==0xE0:
        done_hits+=1
        if done_hits>=3: break

checks={
13:0x12345000,14:0x1090,18:0x55,19:0x33,20:0x42,
21:2,22:8,23:0xA0,24:1,25:0,26:0xFFFFFFF8,27:0x07FFFFFF,
28:0xFFFFFFFF,29:0xFFFFFFFD,30:5,31:0x98
}
for r,e in checks.items():
    assert regs[r]==e,(r,hex(regs[r]),hex(e))
for a in [0x44,0x46,0x47,0x48,0x49,0x4a,0x4b]: assert mem[a]==0xff,(a,mem[a])

with (ROOT/'sim/reference_trace.csv').open('w',newline='',encoding='utf-8-sig') as f:
    writer=csv.DictWriter(f,fieldnames=trace[0].keys())
    writer.writeheader();writer.writerows(trace)
(ROOT/'sim/reference_result.txt').write_text(
    'Reference model PASS\n' + '\n'.join(f'x{r} = {regs[r]:08X}' for r in sorted(checks)) +
    '\nMemory 44,46,47,48,49,4A,4B = FF\n',encoding='utf-8')
print('PASS',steps,'instructions')
print((ROOT/'sim/reference_result.txt').read_text())
