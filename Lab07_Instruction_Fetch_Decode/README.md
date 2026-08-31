# 实验 7：取指令及指令译码

本实验实现 PC、取指、指令寄存器、立即数生成和一级译码模块；`mem/exp7_test.coe` 为指令初始化文件。

## Vivado 操作

1. 新建 RTL Project，添加 `src` 全部文件，板级顶层模块为 `exp7_board_top`。
2. 添加 `constraints/exp7_hcs_a02.xdc`。
3. 配置或创建指令 ROM 时加载 `mem/exp7_test.coe`；仿真时可加入 `sim/ROM_B_sim.v`。
4. 添加 `sim/tb_id1.v` 或 `sim/tb_if_id_core.v` 运行模块仿真。
5. 仿真通过后生成 bitstream 并下载到开发板。
