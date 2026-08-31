# 实验 8：转移指令 CPU

本实验在 RIU CPU 基础上实现转移相关指令。`coe/RIU_test.coe` 与 `coe/RIU_test.s` 为测试程序。

## Vivado 操作

1. 添加 `src` 中全部文件，板级顶层模块为 `riu_cpu_top`。
2. 添加 `xdc/HCS_A02_exp8.xdc`。
3. 在指令 ROM 初始化配置中使用 `coe/RIU_test.coe`。
4. 将 `sim/tb_riu_cpu.v` 加入 Simulation Sources，运行行为仿真。
5. 综合、实现、生成 bitstream，并在 Hardware Manager 下载。
