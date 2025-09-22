set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.0 -name sys_clk -waveform {0.0 5.0} [get_ports clk]

set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN J1 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

set_property PACKAGE_PIN U16 [get_ports {data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[0]}]

set_property PACKAGE_PIN E19 [get_ports {data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[1]}]

set_property PACKAGE_PIN U19 [get_ports {data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[2]}]

set_property PACKAGE_PIN V19 [get_ports {data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[3]}]

set_property PACKAGE_PIN W18 [get_ports {data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[4]}]

set_property PACKAGE_PIN U15 [get_ports {data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[5]}]

set_property PACKAGE_PIN U14 [get_ports {data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[6]}]

set_property PACKAGE_PIN V14 [get_ports {data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports seg[0]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[1]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[2]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[3]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[4]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[5]]
set_property IOSTANDARD LVCMOS33 [get_ports seg[6]]

set_property PACKAGE_PIN U7 [get_ports seg[0]]
set_property PACKAGE_PIN V5 [get_ports seg[1]]
set_property PACKAGE_PIN U5 [get_ports seg[2]]
set_property PACKAGE_PIN V8 [get_ports seg[3]]
set_property PACKAGE_PIN U8 [get_ports seg[4]]
set_property PACKAGE_PIN W6 [get_ports seg[5]]
set_property PACKAGE_PIN W7 [get_ports seg[6]]

set_property IOSTANDARD LVCMOS33 [get_ports ade[0]]
set_property IOSTANDARD LVCMOS33 [get_ports ade[1]]
set_property IOSTANDARD LVCMOS33 [get_ports ade[2]]
set_property IOSTANDARD LVCMOS33 [get_ports ade[3]]

set_property PACKAGE_PIN U2 [get_ports ade[0]]
set_property PACKAGE_PIN U4 [get_ports ade[1]]
set_property PACKAGE_PIN V4 [get_ports ade[2]]
set_property PACKAGE_PIN W4 [get_ports ade[3]]
