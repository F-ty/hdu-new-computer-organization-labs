## HCS-A02 / XC7A100T-CSG324 实验5管脚约束
## 顶层模块：top_exp5_hcs_a02
## I/O 标准
set_property IOSTANDARD LVCMOS33 [get_ports clk_100m]
set_property IOSTANDARD LVCMOS33 [get_ports btn_op]
set_property IOSTANDARD LVCMOS33 [get_ports btn_rst]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## 100MHz 时钟源
set_property PACKAGE_PIN E3 [get_ports clk_100m]
create_clock -period 10.000 -name clk_100m [get_ports clk_100m]

## 按键：BT0 执行读/写，BT1 复位显示/消抖
set_property PACKAGE_PIN D15 [get_ports btn_op]   ;# BT0
set_property PACKAGE_PIN C10 [get_ports btn_rst]  ;# BT1

## 拨动开关
## sw[7:0] = DM_Addr[7:0]
## sw[8]   = Mem_Write，0读，1写
## sw[10:9]= M_W_Data_s，选择写入常数
set_property PACKAGE_PIN P17 [get_ports {sw[0]}]  ;# SW0
set_property PACKAGE_PIN T18 [get_ports {sw[1]}]  ;# SW1
set_property PACKAGE_PIN U17 [get_ports {sw[2]}]  ;# SW2
set_property PACKAGE_PIN U16 [get_ports {sw[3]}]  ;# SW3
set_property PACKAGE_PIN V14 [get_ports {sw[4]}]  ;# SW4
set_property PACKAGE_PIN U13 [get_ports {sw[5]}]  ;# SW5
set_property PACKAGE_PIN U12 [get_ports {sw[6]}]  ;# SW6
set_property PACKAGE_PIN U11 [get_ports {sw[7]}]  ;# SW7
set_property PACKAGE_PIN U9  [get_ports {sw[8]}]  ;# SW8
set_property PACKAGE_PIN U7  [get_ports {sw[9]}]  ;# SW9
set_property PACKAGE_PIN U6  [get_ports {sw[10]}] ;# SW10

## LED：led[31:0] 显示 M_R_Data；led[35:32] 显示状态
set_property PACKAGE_PIN T14 [get_ports {led[0]}]  ;# LD0
set_property PACKAGE_PIN T15 [get_ports {led[1]}]  ;# LD1
set_property PACKAGE_PIN R15 [get_ports {led[2]}]  ;# LD2
set_property PACKAGE_PIN T16 [get_ports {led[3]}]  ;# LD3
set_property PACKAGE_PIN R16 [get_ports {led[4]}]  ;# LD4
set_property PACKAGE_PIN M16 [get_ports {led[5]}]  ;# LD5
set_property PACKAGE_PIN N16 [get_ports {led[6]}]  ;# LD6
set_property PACKAGE_PIN N15 [get_ports {led[7]}]  ;# LD7
set_property PACKAGE_PIN P15 [get_ports {led[8]}]  ;# LD8
set_property PACKAGE_PIN K16 [get_ports {led[9]}]  ;# LD9
set_property PACKAGE_PIN L18 [get_ports {led[10]}] ;# LD10
set_property PACKAGE_PIN N17 [get_ports {led[11]}] ;# LD11
set_property PACKAGE_PIN M17 [get_ports {led[12]}] ;# LD12
set_property PACKAGE_PIN M18 [get_ports {led[13]}] ;# LD13
set_property PACKAGE_PIN R17 [get_ports {led[14]}] ;# LD14
set_property PACKAGE_PIN U18 [get_ports {led[15]}] ;# LD15
set_property PACKAGE_PIN V10 [get_ports {led[16]}] ;# LD16
set_property PACKAGE_PIN R7  [get_ports {led[17]}] ;# LD17
set_property PACKAGE_PIN T6  [get_ports {led[18]}] ;# LD18
set_property PACKAGE_PIN R6  [get_ports {led[19]}] ;# LD19
set_property PACKAGE_PIN T5  [get_ports {led[20]}] ;# LD20
set_property PACKAGE_PIN R5  [get_ports {led[21]}] ;# LD21
set_property PACKAGE_PIN T4  [get_ports {led[22]}] ;# LD22
set_property PACKAGE_PIN T3  [get_ports {led[23]}] ;# LD23
set_property PACKAGE_PIN R3  [get_ports {led[24]}] ;# LD24
set_property PACKAGE_PIN P4  [get_ports {led[25]}] ;# LD25
set_property PACKAGE_PIN P3  [get_ports {led[26]}] ;# LD26
set_property PACKAGE_PIN N4  [get_ports {led[27]}] ;# LD27
set_property PACKAGE_PIN M4  [get_ports {led[28]}] ;# LD28
set_property PACKAGE_PIN M3  [get_ports {led[29]}] ;# LD29
set_property PACKAGE_PIN L4  [get_ports {led[30]}] ;# LD30
set_property PACKAGE_PIN L3  [get_ports {led[31]}] ;# LD31
set_property PACKAGE_PIN P14 [get_ports {led[32]}] ;# LD32
set_property PACKAGE_PIN R12 [get_ports {led[33]}] ;# LD33
set_property PACKAGE_PIN T13 [get_ports {led[34]}] ;# LD34
set_property PACKAGE_PIN R13 [get_ports {led[35]}] ;# LD35

## 8 位共阳极数码管位选，低电平有效
set_property PACKAGE_PIN A6 [get_ports {an[0]}] ;# AN0 / TB0
set_property PACKAGE_PIN B6 [get_ports {an[1]}] ;# AN1 / TB1
set_property PACKAGE_PIN A5 [get_ports {an[2]}] ;# AN2 / TB2
set_property PACKAGE_PIN A4 [get_ports {an[3]}] ;# AN3 / TB3
set_property PACKAGE_PIN B4 [get_ports {an[4]}] ;# AN4 / TB4
set_property PACKAGE_PIN A1 [get_ports {an[5]}] ;# AN5 / TB5
set_property PACKAGE_PIN B2 [get_ports {an[6]}] ;# AN6 / TB6
set_property PACKAGE_PIN G1 [get_ports {an[7]}] ;# AN7 / TB7

## 段选，低电平有效。seg[0]=CA, ..., seg[7]=DP
set_property PACKAGE_PIN E2 [get_ports {seg[0]}] ;# CA
set_property PACKAGE_PIN A3 [get_ports {seg[1]}] ;# CB
set_property PACKAGE_PIN B1 [get_ports {seg[2]}] ;# CC
set_property PACKAGE_PIN E1 [get_ports {seg[3]}] ;# CD
set_property PACKAGE_PIN F1 [get_ports {seg[4]}] ;# CE
set_property PACKAGE_PIN D2 [get_ports {seg[5]}] ;# CF
set_property PACKAGE_PIN B3 [get_ports {seg[6]}] ;# CG
set_property PACKAGE_PIN C1 [get_ports {seg[7]}] ;# DP
