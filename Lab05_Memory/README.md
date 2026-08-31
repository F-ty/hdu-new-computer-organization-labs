# 实验 5：存储器设计

本实验实现数据 RAM 读写、按键控制和数码管显示；`mem/ram_init.coe` 是初始化数据文件。

## Vivado 操作

1. 新建 RTL Project，添加 `src` 下 Verilog 文件；顶层模块为 `top_exp5_hcs_a02`。
2. 添加 `constraints/hcs_a02_exp5.xdc`。
3. 如果使用 Block Memory Generator，请在 IP 配置中加载 `mem/ram_init.coe`；仿真可使用 `sim/RAM_B_sim_model.v`。
4. 添加 `sim/tb_Data_RAM.v` 后运行行为仿真。
5. 通过综合、实现和生成 bitstream 后下载到 HCS_A02。
