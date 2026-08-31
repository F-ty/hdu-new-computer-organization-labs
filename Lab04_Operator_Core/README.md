# 实验 4：运算器核心

本实验包含 ALU、寄存器堆、按键单脉冲和八位数码管显示的运算器核心。

## Vivado 操作

1. 新建 RTL Project，将 `src` 全部加入 Design Sources；顶层模块为 `TOP`。
2. 添加 `constraints/TOP.xdc` 作为约束文件。
3. 将 `sim/tb_Operator_Core.v` 加入 Simulation Sources，运行行为仿真。
4. 通过后依次综合、实现、生成 bitstream，并在 Hardware Manager 中下载。
