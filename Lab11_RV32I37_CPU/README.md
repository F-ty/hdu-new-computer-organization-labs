# 实验 11：RV32I 37 条指令 CPU

本实验实现支持 37 条 RV32I 指令的 CPU；程序、数据和生成脚本位于 `mem`，测试平台位于 `sim`。

## Vivado 操作

1. 添加 `src` 全部文件，顶层模块为 `lab11_top`。
2. 添加 `constraints/HCS_A02_lab11.xdc`。
3. 使用 `mem/build_program.py` 可重新生成程序初始化内容；默认使用 `program.mem` 与 `data.mem`。
4. 添加 `sim/tb_rv32i_cpu.v`，运行 Behavioral Simulation 验证指令执行。
5. 仿真通过后执行综合、实现、生成 bitstream 并下载。
