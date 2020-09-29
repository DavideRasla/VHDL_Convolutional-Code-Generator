create_clock -period 2.271 -name clk125 -waveform {0.000 1.135} [get_ports clk]


set_property PACKAGE_PIN L16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports ck_outGen]
set_property IOSTANDARD LVCMOS33 [get_ports ak_OutpuTgen]
set_property IOSTANDARD LVCMOS33 [get_ports ak_inputGen]
set_property PACKAGE_PIN R18 [get_ports reset]
set_property PACKAGE_PIN M15 [get_ports ak_inputGen]
set_property PACKAGE_PIN N16 [get_ports ak_OutpuTgen]
set_property PACKAGE_PIN N20 [get_ports ck_outGen]


