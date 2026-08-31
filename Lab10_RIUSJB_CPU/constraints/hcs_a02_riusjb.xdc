# HCS-A02, FPGA: xc7a100tcsg324-2L
# Top module: top_riusjb_board
# Buttons are active high on the board. rst_btn is converted to active-low rst_n in RTL.

set_property PACKAGE_PIN E3 [get_ports clk_100mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100mhz]
create_clock -period 10.000 -name clk_100mhz [get_ports clk_100mhz]

# Buttons: BT3 as reset, BT0 as manual step clock
set_property PACKAGE_PIN H16 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]
set_property PACKAGE_PIN D15 [get_ports step_btn]
set_property IOSTANDARD LVCMOS33 [get_ports step_btn]

# Switches: SW2..SW0 select data displayed on seven-segment tubes
set_property PACKAGE_PIN P17 [get_ports {sw[0]}]
set_property PACKAGE_PIN T18 [get_ports {sw[1]}]
set_property PACKAGE_PIN U17 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

# LEDs: LED[3:0]=FR, LED[7:4]=ST
set_property PACKAGE_PIN T14 [get_ports {led[0]}]
set_property PACKAGE_PIN T15 [get_ports {led[1]}]
set_property PACKAGE_PIN R15 [get_ports {led[2]}]
set_property PACKAGE_PIN T16 [get_ports {led[3]}]
set_property PACKAGE_PIN R16 [get_ports {led[4]}]
set_property PACKAGE_PIN M16 [get_ports {led[5]}]
set_property PACKAGE_PIN N16 [get_ports {led[6]}]
set_property PACKAGE_PIN N15 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# Seven-segment digit select, common-anode, active low
set_property PACKAGE_PIN A6 [get_ports {an[0]}]
set_property PACKAGE_PIN B6 [get_ports {an[1]}]
set_property PACKAGE_PIN A5 [get_ports {an[2]}]
set_property PACKAGE_PIN A4 [get_ports {an[3]}]
set_property PACKAGE_PIN B4 [get_ports {an[4]}]
set_property PACKAGE_PIN A1 [get_ports {an[5]}]
set_property PACKAGE_PIN B2 [get_ports {an[6]}]
set_property PACKAGE_PIN G1 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# Seven-segment segments: seg[0]=CA, seg[1]=CB, ..., seg[6]=CG, seg[7]=DP. Active low.
set_property PACKAGE_PIN E2 [get_ports {seg[0]}]
set_property PACKAGE_PIN A3 [get_ports {seg[1]}]
set_property PACKAGE_PIN B1 [get_ports {seg[2]}]
set_property PACKAGE_PIN E1 [get_ports {seg[3]}]
set_property PACKAGE_PIN F1 [get_ports {seg[4]}]
set_property PACKAGE_PIN D2 [get_ports {seg[5]}]
set_property PACKAGE_PIN B3 [get_ports {seg[6]}]
set_property PACKAGE_PIN C1 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]
