# 实验 3：多功能 ALU

本实验实现带寄存器的算术逻辑单元与数码管显示。

## Vivado 操作

1. 创建 RTL Project，器件选择与 HCS_A02 开发板一致。
2. 将 `src` 中全部 Verilog 文件添加为 Design Sources；顶层模块为 `TOP`。
3. 将 `constraints/TOP_HCS_A02.xdc` 添加为 Constraints。
4. 将 `sim/tb_ALU_REG.v` 添加为 Simulation Sources，运行 Behavioral Simulation。
5. 仿真无误后运行 Synthesis、Implementation、Generate Bitstream，再通过 Hardware Manager 下载到开发板。
