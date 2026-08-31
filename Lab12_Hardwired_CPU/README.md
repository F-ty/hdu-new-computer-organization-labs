# 实验12 硬布线控制 CPU

目标器件：XC7A100T-CSG324-2L，HCS-A02 板卡。

## 目录
- `rtl/`：分模块 Verilog 源代码
- `sim/`：自检式仿真文件
- `constraints/`：HCS-A02 管脚约束
- `mem/`：可用于 Vivado Block Memory Generator 的 COE 文件
- `docs/`：测试汇编程序
- `create_project.tcl`：自动创建 Vivado 工程

## 板级操作
- BT3：复位，按下时清零
- BT2：单步机器周期
- SW2~SW0：数码管显示选择
  - 000 PC
  - 001 IR
  - 010 W_Data
  - 011 MDR
  - 100 A
  - 101 B
  - 110 F
  - 111 低9位显示 M4~M0 与 FR
- LD8~LD4：M4~M0
- LD3~LD0：CF、ZF、SF、OF

## Vivado 快速建立工程
1. 在 Tcl Console 切换到本目录。
2. 执行 `source create_project.tcl`。
3. Run Simulation，确认控制台出现 `ALL TESTS PASSED`。
4. Run Synthesis，Run Implementation，Generate Bitstream。
5. Open Hardware Manager，Program Device。
