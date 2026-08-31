# 实验11：支持37条RV32I指令的多周期CPU

适用器件：XC7A100TCSG324-2L  
开发工具：Vivado  
实验板：HCS-A02  
顶层模块：`lab11_top`

## 1. 本工程完成的37条指令

R型运算指令共10条：`add、sub、sll、slt、sltu、xor、srl、sra、or、and`。

I型运算指令共9条：`addi、slti、sltiu、xori、ori、andi、slli、srli、srai`。

U型指令共2条：`lui、auipc`。

取数指令共5条：`lb、lh、lw、lbu、lhu`。

存数指令共3条：`sb、sh、sw`。

条件分支指令共6条：`beq、bne、blt、bge、bltu、bgeu`。

跳转指令共2条：`jal、jalr`。

合计37条。

## 2. 工程模块划分

| 文件 | 作用 |
|---|---|
| `rv32i_defs.vh` | ALU功能码、状态码、MUX选择码 |
| `rv32i_alu.v` | 32位ALU及N、Z、C、V标志生成 |
| `rv32i_regfile.v` | 32个32位通用寄存器，x0恒为0 |
| `rv32i_imm_gen.v` | I、S、B、U、J五类立即数生成 |
| `rv32i_decoder.v` | 37条指令分类译码、ALU控制、访存尺寸控制 |
| `rv32i_branch_cond.v` | 六类条件分支的cc判断 |
| `rv32i_imem.v` | 64乘32位指令存储器 |
| `rv32i_dmem.v` | 256字节数据存储器，支持字节、半字、字访问 |
| `rv32i_controller.v` | 多周期有限状态机控制器 |
| `rv32i_cpu.v` | CPU数据通路连接 |
| `button_onepulse.v` | 单步按键同步与单脉冲产生 |
| `auto_tick.v` | 自动运行时产生低速使能脉冲 |
| `hex7seg8.v` | 8位数码管动态扫描与十六进制显示 |
| `lab11_top.v` | 板级顶层模块 |
| `tb_rv32i_cpu.v` | CPU仿真测试平台 |

## 3. Vivado工程创建步骤

### 第一步：新建工程

1. 打开Vivado，选择`Create Project`。
2. 工程名称建议填写`lab11_rv32i37_cpu`。
3. 选择`RTL Project`，勾选暂不添加源文件也可以。
4. 在器件选择页直接搜索`xc7a100tcsg324-2L`。
5. 确认Part一栏为`xc7a100tcsg324-2L`后完成工程创建。

### 第二步：添加设计源文件

选择`Add Sources`，再选择`Add or Create Design Sources`，添加`src`目录中的全部`.v`文件及`rv32i_defs.vh`。

在Sources窗口中右键`lab11_top`，选择`Set as Top`。

### 第三步：添加存储器初始化文件

选择`Add Sources`，再选择`Add or Create Design Sources`，添加：

1. `mem/program.mem`
2. `mem/data.mem`

若Vivado没有自动识别`.mem`文件，可在添加文件窗口中把文件类型切换为`All Files`。这两个文件必须保留在工程中，否则仿真时会出现`$readmemh`找不到文件的警告，IR也可能显示为X。

### 第四步：添加约束文件

选择`Add Sources`，再选择`Add or Create Constraints`，添加：

`constraints/HCS_A02_lab11.xdc`

本约束按照HCS-A02板卡引脚表编写，使用100MHz时钟E3、BT3单步、BT2复位、SW3自动运行、SW2至SW0显示选择、8位数码管及LD11至LD0。

### 第五步：添加仿真文件

选择`Add Sources`，再选择`Add or Create Simulation Sources`，添加：

`sim/tb_rv32i_cpu.v`

在Simulation Sources中将`tb_rv32i_cpu`设为仿真顶层。

## 4. 仿真操作

1. 点击`Run Simulation`。
2. 选择`Run Behavioral Simulation`。
3. 在波形窗口中添加以下信号：
   `pc、pc0、ir、state、a_reg、b_reg、aluout、mdr、wdata、flags、reg_write、mem_write`。
4. 点击运行，运行时间设置为`6 us`。
5. 打开Tcl Console或仿真输出窗口，检查是否出现`ALL TESTS PASSED`。

重点检查：

| 验证项目 | 预期值 |
|---|---|
| `lb x5,0(x1)` | `FFFFFF80` |
| `lbu x6,0(x1)` | `00000080` |
| `lh x7,2(x1)` | `00001234` |
| `lhu x8,0(x1)` | `00007F80` |
| `lw x9,0(x1)` | `12347F80` |
| `auipc x14,0x1` | `00001090` |
| 分支综合结果x20 | `00000042` |
| 子程序标志x19 | `00000033` |
| 返回后标志x18 | `00000055` |
| 链接寄存器x31 | `00000098` |

程序进入`done`循环后，PC会在取指时短暂显示`000000E4`，执行`jal x0,done`后回到`000000E0`。PC0保持当前IR对应的指令地址，因此验收时用SW选择PC0和IR更容易一一对应。

## 5. 综合、实现和生成比特流

1. 将设计顶层恢复为`lab11_top`。
2. 点击`Run Synthesis`。
3. 综合完成后选择`Open Synthesized Design`，先检查是否有未约束端口。
4. 点击`Run Implementation`。
5. 点击`Generate Bitstream`。
6. 若出现`program.mem cannot be opened`，重新把两个`.mem`文件加入工程，并在Sources窗口中确认文件存在。
7. 若出现顶层端口未约束，检查顶层名是否为`lab11_top`，以及XDC端口名是否完全一致。

## 6. 上板操作

### 板卡输入

| 板上器件 | 功能 |
|---|---|
| BT2 | 复位，按下时CPU清零并回到取指状态 |
| BT3 | 单步，每按一次前进一个微操作状态 |
| SW3 | 0为手动单步，1为自动慢速运行 |
| SW2至SW0 | 选择数码管显示内容 |

### 数码管显示选择

| SW2 SW1 SW0 | 显示内容 |
|---|---|
| 000 | PC，下一取指地址或跳转后的地址 |
| 001 | PC0，当前IR对应的指令地址 |
| 010 | IR，当前指令机器码 |
| 011 | W_Data，寄存器堆写回数据 |
| 100 | MDR，数据存储器读出暂存值 |
| 101 | A暂存器 |
| 110 | B暂存器 |
| 111 | ALUOut，也就是F暂存器 |

### LED含义

| LED | 含义 |
|---|---|
| LD4至LD0 | 当前状态state[4:0] |
| LD8至LD5 | N、Z、C、V标志 |
| LD9 | Reg_Write |
| LD10 | Mem_Write |
| LD11 | 当前时刻产生CPU使能脉冲 |

### 推荐验收顺序

1. 将SW3拨到0，进入手动单步模式。
2. 按住BT2约1秒后松开。
3. SW2至SW0设为001，确认PC0为`00000000`。
4. SW2至SW0设为010，第一次按BT3后观察IR变为`000000B7`。
5. 继续按BT3，观察状态从取指、译码进入写回LUI，再回到取指。
6. 把显示切换为011，在写回状态观察W_Data。
7. 程序执行到字节和半字取数时，把显示切换为100观察MDR。
8. 程序执行到`auipc x14,0x1`时，写回值应为`00001090`。
9. 程序执行到六条分支测试后，最终x20的结果为`00000042`。板级顶层没有直接读取任意寄存器的选择端口，因此该结果可在仿真中直接检查，上板时可通过W_Data在对应写回周期观察。
10. 最后程序进入地址`000000E0`处的自循环。此时PC会在E0与E4之间按状态变化，PC0和IR保持当前循环指令的对应关系。

## 7. 状态编码

| 十进制 | 二进制 | 状态 |
|---:|---|---|
| 1 | 00001 | FETCH，取指并令PC加4 |
| 2 | 00010 | DECODE，译码并读取寄存器 |
| 3 | 00011 | EXEC_ALU，R型或I型运算 |
| 4 | 00100 | WB_ALU，运算结果写回 |
| 5 | 00101 | WB_LUI |
| 6 | 00110 | WB_AUIPC |
| 7 | 00111 | EXEC_ADDR，计算访存地址或jalr地址 |
| 8 | 01000 | MEM_RD，读数据并写入MDR |
| 9 | 01001 | WB_LOAD，MDR写回rd |
| 10 | 01010 | MEM_WR，执行sb、sh或sw |
| 11 | 01011 | JAL，写回链接地址并修改PC |
| 12 | 01100 | JALR，写回链接地址并修改PC |
| 13 | 01101 | BRANCH，减法比较并决定是否修改PC |

## 8. 常见故障排查

### 波形全部是X

优先检查`program.mem`和`data.mem`是否已经加入工程。然后检查仿真工作目录中是否能找到这两个文件。也可以在仿真设置中把`program.mem`和`data.mem`复制到仿真目录。

### 数码管全灭或显示方向异常

本板数码管为共阳极，位选和段选均为低电平有效。确认使用本工程提供的`hex7seg8.v`和XDC，不要把段选极性反过来。

### 按BT3一次跳过多个状态

HCS-A02按键具有硬件消抖，本工程还做了同步和上升沿检测。若仍有跳步，检查BT3是否绑定H16，检查是否误把SW3拨到自动运行位置。

### PC和IR看起来不匹配

PC在取指状态已经加4，IR保存刚取出的指令，因此PC通常指向下一条指令。PC0保存当前IR对应的地址。验收时同时查看PC0与IR即可得到严格对应关系。

### 重新按复位后数据存储器内容没有恢复

复位会清除CPU寄存器和状态。数据存储器中由store指令写入的内容会保留到重新下载比特流。测试程序每次都会把固定值写入0x44及之后的地址，因此重复运行仍可得到一致结果。
