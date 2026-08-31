# 实验 12：硬布线控制 CPU

本实验实现硬布线控制 CPU。RTL 在 `rtl`，测试平台在 `sim`，存储器初始化文件在 `mem`。

## Vivado 操作

推荐在 Vivado Tcl Console 中执行 `create_project.tcl` 创建工程；脚本无法使用时可手动操作：

1. 新建 RTL Project，添加 `rtl` 下全部 Verilog 文件，顶层模块为 `board_top`。
2. 添加 `constraints/hcs_a02_exp12.xdc`。
3. 在指令/数据存储器配置中加入 `mem/exp12_program.coe` 与 `mem/exp12_data.coe`。
4. 添加 `sim/tb_hardwired_cpu.v`，运行行为仿真。
5. 依次综合、实现、生成 bitstream，并用 Hardware Manager 下载。
