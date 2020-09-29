create_clock -period 1.575 -name clc_125 -waveform {0.000 0.788} [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports ak_inputGen]
set_property IOSTANDARD LVCMOS33 [get_ports ak_OutpuTgen]
set_property IOSTANDARD LVCMOS33 [get_ports ck_outGen]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset]






set_property PACKAGE_PIN L16 [get_ports clk]
set_property PACKAGE_PIN R18 [get_ports reset]





set_property PACKAGE_PIN D18 [get_ports ck_outGen]

