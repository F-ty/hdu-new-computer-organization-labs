## HCS-A02, XC7A100TCSG324-2L, Experiment 8 RIU_CPU
## 顶层端口: CLK100MHZ, BT0, BT3, SW[2:0], AN[7:0], SEG[7:0], LD[7:0]

## Clock: 100 MHz, E3
set_property PACKAGE_PIN E3 [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports CLK100MHZ]

## Buttons. HCS-A02 按下为 1。
## BT0: 单步执行键
set_property PACKAGE_PIN D15 [get_ports BT0]
set_property IOSTANDARD LVCMOS33 [get_ports BT0]
## BT3: 复位键
set_property PACKAGE_PIN H16 [get_ports BT3]
set_property IOSTANDARD LVCMOS33 [get_ports BT3]

## Switches: SW[2:0] 选择数码管显示内容
## 000 PC, 001 IR, 010 W_Data, 011 F, 100 A, 101 B, 110 FR, 111 {ST,ALU_OP}
set_property PACKAGE_PIN P17 [get_ports {SW[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN T18 [get_ports {SW[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]
set_property PACKAGE_PIN U17 [get_ports {SW[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW[2]}]

## LEDs: LD[3:0]=FR, LD[6:4]=ST, LD[7]=step pulse
set_property PACKAGE_PIN T14 [get_ports {LD[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[0]}]
set_property PACKAGE_PIN T15 [get_ports {LD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[1]}]
set_property PACKAGE_PIN R15 [get_ports {LD[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[2]}]
set_property PACKAGE_PIN T16 [get_ports {LD[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[3]}]
set_property PACKAGE_PIN R16 [get_ports {LD[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[4]}]
set_property PACKAGE_PIN M16 [get_ports {LD[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[5]}]
set_property PACKAGE_PIN N16 [get_ports {LD[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[6]}]
set_property PACKAGE_PIN N15 [get_ports {LD[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD[7]}]

## Seven segment anodes, active low. AN[7] is leftmost, AN[0] is rightmost.
set_property PACKAGE_PIN A6 [get_ports {AN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN B6 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN A5 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN A4 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]
set_property PACKAGE_PIN B4 [get_ports {AN[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[4]}]
set_property PACKAGE_PIN A1 [get_ports {AN[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[5]}]
set_property PACKAGE_PIN B2 [get_ports {AN[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[6]}]
set_property PACKAGE_PIN G1 [get_ports {AN[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[7]}]

## Seven segment cathodes, active low. SEG[0]=CA, SEG[1]=CB, ..., SEG[6]=CG, SEG[7]=DP.
set_property PACKAGE_PIN E2 [get_ports {SEG[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[0]}]
set_property PACKAGE_PIN A3 [get_ports {SEG[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[1]}]
set_property PACKAGE_PIN B1 [get_ports {SEG[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[2]}]
set_property PACKAGE_PIN E1 [get_ports {SEG[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[3]}]
set_property PACKAGE_PIN F1 [get_ports {SEG[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[4]}]
set_property PACKAGE_PIN D2 [get_ports {SEG[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[5]}]
set_property PACKAGE_PIN B3 [get_ports {SEG[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[6]}]
set_property PACKAGE_PIN C1 [get_ports {SEG[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[7]}]
