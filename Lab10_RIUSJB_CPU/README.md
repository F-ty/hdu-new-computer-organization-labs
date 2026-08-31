# 实验 10：RIUSJB CPU

本实验实现 RIUSJB CPU 与 HCS_A02 板级显示控制。`mem` 目录提供程序与数据的 `.coe`、`.mem` 初始化文件。

## Vivado 操作

1. 将 `src` 全部文件加入 Design Sources；顶层模块为 `top_riusjb_board`。
2. 添加 `constraints/hcs_a02_riusjb.xdc`。
3. 根据存储器实现，在 `mem` 中选择对应的指令和数据初始化文件。
4. 添加 `sim/tb_riusjb_cpu.v` 并运行行为仿真。
5. 综合、实现、生成 bitstream，连接开发板后在 Hardware Manager 下载。
