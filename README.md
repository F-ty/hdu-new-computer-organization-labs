# HDU Computer Organization Labs

计算机组成原理 FPGA 实验 3–12 的源代码整理仓库，面向 Vivado 与 HCS_A02 开发板。仓库只保留 HDL 源码、仿真文件、约束文件和程序初始化文件；Word/PDF 报告、Vivado 缓存、综合实现结果与比特流均不纳入版本控制。

## 内容

| 实验 | 目录 | 状态 |
| --- | --- | --- |
| 实验 3：多功能 ALU | `Lab03_ALU` | 源码、仿真、约束 |
| 实验 4：运算器核心 | `Lab04_Operator_Core` | 源码、仿真、约束 |
| 实验 5：存储器设计 | `Lab05_Memory` | 源码、仿真、约束、初始化文件 |
| 实验 6：RISC-V 汇编器与模拟器 | `Lab06_RISCV_Assembler_Simulator` | 原始代码未找到，保留说明占位 |
| 实验 7：取指令及指令译码 | `Lab07_Instruction_Fetch_Decode` | 源码、仿真、约束、初始化文件 |
| 实验 8：转移指令 CPU | `Lab08_Branch_CPU` | 源码、仿真、约束、初始化文件 |
| 实验 9：访存指令 CPU | `Lab09_Memory_Access_CPU` | 源码、仿真、约束、初始化文件 |
| 实验 10：RIUSJB CPU | `Lab10_RIUSJB_CPU` | 源码、仿真、约束、初始化文件 |
| 实验 11：RV32I 37 条指令 CPU | `Lab11_RV32I37_CPU` | 源码、仿真、约束、初始化文件 |
| 实验 12：硬布线控制 CPU | `Lab12_Hardwired_CPU` | 源码、仿真、约束、初始化文件 |

## 使用方式

每个实验通常包含以下目录：

- `src` 或 `rtl`：Verilog 源码
- `sim`：测试平台与仿真辅助文件
- `constraints` 或 `xdc`：HCS_A02 管脚约束
- `mem` 或 `coe`：指令/数据初始化文件

在 Vivado 中新建 RTL Project，添加对应实验的 HDL 文件、约束文件与初始化文件，再按需要加入测试平台。实验 12 提供了 `create_project.tcl`，可在 Vivado Tcl Console 中运行以创建工程。

## 说明

- 这是课程实验代码归档，不含实验报告或验收材料。
- 实验 6 目前只有报告文件，未发现对应源码；找到后可直接补入其目录。
- 不同实验可能使用不同 Vivado 版本；打开工程时若提示升级 IP 或约束，请按当前安装版本重新生成。
