## HCS-A02, XC7A100T-CSG324-2L
## 100 MHz system clock
set_property PACKAGE_PIN E3 [get_ports clk100mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk100mhz]
create_clock -add -name sys_clk -period 10.000 -waveform {0.000 5.000} [get_ports clk100mhz]

## Buttons: pressed = 1
## BT3: reset, BT2: single-step
set_property PACKAGE_PIN H16 [get_ports btn_reset]
set_property PACKAGE_PIN C11 [get_ports btn_step]
set_property IOSTANDARD LVCMOS33 [get_ports {btn_reset btn_step}]

## Display selector SW2, SW1, SW0
set_property PACKAGE_PIN U17 [get_ports {disp_sel[2]}]
set_property PACKAGE_PIN T18 [get_ports {disp_sel[1]}]
set_property PACKAGE_PIN P17 [get_ports {disp_sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_sel[*]}]

## Seven-segment digit enables AN0..AN7, active low
set_property PACKAGE_PIN A6 [get_ports {an[0]}]
set_property PACKAGE_PIN B6 [get_ports {an[1]}]
set_property PACKAGE_PIN A5 [get_ports {an[2]}]
set_property PACKAGE_PIN A4 [get_ports {an[3]}]
set_property PACKAGE_PIN B4 [get_ports {an[4]}]
set_property PACKAGE_PIN A1 [get_ports {an[5]}]
set_property PACKAGE_PIN B2 [get_ports {an[6]}]
set_property PACKAGE_PIN G1 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

## Seven-segment segments: seg[0]=A ... seg[6]=G, seg[7]=DP, active low
set_property PACKAGE_PIN E2 [get_ports {seg[0]}]
set_property PACKAGE_PIN A3 [get_ports {seg[1]}]
set_property PACKAGE_PIN B1 [get_ports {seg[2]}]
set_property PACKAGE_PIN E1 [get_ports {seg[3]}]
set_property PACKAGE_PIN F1 [get_ports {seg[4]}]
set_property PACKAGE_PIN D2 [get_ports {seg[5]}]
set_property PACKAGE_PIN B3 [get_ports {seg[6]}]
set_property PACKAGE_PIN C1 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## LEDs: LD0..LD8
set_property PACKAGE_PIN T14 [get_ports {led[0]}]
set_property PACKAGE_PIN T15 [get_ports {led[1]}]
set_property PACKAGE_PIN R15 [get_ports {led[2]}]
set_property PACKAGE_PIN T16 [get_ports {led[3]}]
set_property PACKAGE_PIN R16 [get_ports {led[4]}]
set_property PACKAGE_PIN M16 [get_ports {led[5]}]
set_property PACKAGE_PIN N16 [get_ports {led[6]}]
set_property PACKAGE_PIN N15 [get_ports {led[7]}]
set_property PACKAGE_PIN P15 [get_ports {led[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
