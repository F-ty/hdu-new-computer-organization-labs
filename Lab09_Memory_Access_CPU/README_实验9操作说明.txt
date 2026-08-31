实验9：实现访存指令的多周期CPU
目标器件：xc7a100tcsg324-2L
板卡：HCS-A02
Vivado顶层：top_exp9
仿真顶层：tb_rius_cpu

一、文件结构
src/         设计源代码，各模块分开
sim/         仿真代码
constraints/ HCS-A02管脚约束
mem/         汇编测试程序与COE初始化文件
figures/     报告使用的结构图、状态图和参考波形

二、Vivado新建工程
1. Create Project，项目名 exp9_rius_cpu。
2. 选择 RTL Project，勾选 Do not specify sources at this time。
3. Parts 中输入 xc7a100tcsg324-2L 并选择该器件。
4. Add Sources -> Add or Create Design Sources，加入 src 目录全部 .v 文件。
5. Add Sources -> Add or Create Simulation Sources，加入 sim/tb_rius_cpu.v。
6. Add Sources -> Add or Create Constraints，加入 constraints/top_exp9_HCS_A02.xdc。
7. Sources窗口中右键 top_exp9，Set as Top。

三、先做仿真
1. Flow Navigator -> Simulation -> Run Simulation -> Run Behavioral Simulation。
2. 仿真顶层应为 tb_rius_cpu。
3. 建议加入信号：state、next_state、pc、ir、a_reg、b_reg、f_reg、mdr、w_data、mem_write、reg_write。
4. Run For 700 ns。
5. Tcl Console应出现：EXP9 PASS。
6. 重点检查：
   - lw流程：S1 -> S2 -> S7 -> S8 -> S9 -> S1。
   - sw流程：S1 -> S2 -> S7 -> S10 -> S1。
   - 最终x26=22222222，x27=11111111，x28=33333333，x29=33333333。
   - 最终DM[16]=33333333，DM[20]=11111111。

四、综合与上板
1. Run Synthesis。
2. 检查无ERROR后 Run Implementation。
3. Generate Bitstream。
4. Open Hardware Manager -> Open Target -> Auto Connect。
5. Program Device，选择生成的 .bit 文件。

五、板上操作
BT0：每按一次执行一个微操作。
BT1：按住复位，松开后开始。
SW2 SW1 SW0选择数码管显示：
000 PC
001 IR
010 W_Data
011 A
100 B
101 F
110 MDR
111 高位显示state，低位显示next_state和FR
LED7..LED4：当前状态二进制码
LED3..LED0：ZF、SF、CF、OF

六、最简验收顺序
1. 按BT1复位，SW=000，看到PC=00000000。
2. 松开BT1，按BT0一次，完成第一条取指，PC=00000004，IR=01000F93，状态S1。
3. 再按三次，完成addi，写入x31=00000010。
4. 第二条lw执行到S8后，SW=110可见MDR=11111111；到S9后，SW=010可见W_Data=11111111。
5. 第三条lw可见MDR=22222222。
6. 两条sw执行到S10时，LED高四位显示1010。
7. 后续两条lw读回，验证x26=22222222、x27=11111111。
8. add后W_Data=33333333。
9. 最后一条lw在S8看到MDR=33333333，在S9看到W_Data=33333333。

七、常见问题
1. 数码管全灭：检查top是否为top_exp9，XDC是否启用，seg/an端口名是否一致。
2. 数码管乱码：确认seg定义为{CA,CB,CC,CD,CE,CF,CG,DP}且低电平点亮。
3. 按BT0无变化：确认BT0管脚D15；按键是上升沿触发，按下后需松开再按。
4. 波形全X：仿真顶层应设为tb_rius_cpu，rst_n必须先为0后变1。
5. PC与IR看似错位：取指时IR保存旧PC对应指令，同时PC已经加4，因此PC指向下一条指令。
6. 重新复位后数据存储器未恢复：当前数据存储器初始化值在配置FPGA时装入；重新下载bit或断电重启可恢复初值。
