# 实验 9：访存指令 CPU

本实验实现支持数据访存的 RIUS CPU。`mem` 目录包含程序和数据初始化文件。

## Vivado 操作

1. 添加 `src` 全部文件，顶层模块为 `top_exp9`。
2. 添加 `constraints/top_exp9_HCS_A02.xdc`。
3. 分别为指令存储器和数据存储器配置 `mem/RIUS_test.coe`、`mem/RIUS_data.coe`。
4. 添加 `sim/tb_rius_cpu.v`，运行行为仿真。
5. 完成综合、实现和 bitstream 生成后下载到开发板。
