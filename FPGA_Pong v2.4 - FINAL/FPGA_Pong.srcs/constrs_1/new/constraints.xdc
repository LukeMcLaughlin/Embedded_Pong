## Clock Signal
set_property -dict { PACKAGE_PIN R4    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_34 Sch=sysclk



## LEDs

set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS25 } [get_ports { led[0] }]; #IO_L15P_T2_DQS_13 Sch=led[0]

set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS25 } [get_ports { led[1] }]; #IO_L15N_T2_DQS_13 Sch=led[1]

set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS25 } [get_ports { led[2] }]; #IO_L17P_T2_13 Sch=led[2]

set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS25 } [get_ports { led[3] }]; #IO_L17N_T2_13 Sch=led[3]

set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS25 } [get_ports { led[4] }]; #IO_L14N_T2_SRCC_13 Sch=led[4]

set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS25 } [get_ports { led[5] }]; #IO_L16N_T2_13 Sch=led[5]

set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS25 } [get_ports { led[6] }]; #IO_L16P_T2_13 Sch=led[6]

set_property -dict { PACKAGE_PIN Y13   IOSTANDARD LVCMOS25 } [get_ports { led[7] }]; #IO_L5P_T0_13 Sch=led[7]




## Buttons

set_property -dict { PACKAGE_PIN B22 IOSTANDARD LVCMOS12 } [get_ports { ButtonInt }]; #IO_L20N_T3_16 Sch=btnc

#set_property -dict { PACKAGE_PIN D22 IOSTANDARD LVCMOS12 } [get_ports { Button3 }]; #IO_L22N_T3_16 Sch=btnd

set_property -dict { PACKAGE_PIN C22 IOSTANDARD LVCMOS12 } [get_ports { Button4 }]; #IO_L20P_T3_16 Sch=btnl

set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS12 } [get_ports { Button2 }]; #IO_L6P_T0_16 Sch=btnr

#set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS12 } [get_ports { Button1 }]; #IO_0_16 Sch=btnu

#set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS15 } [get_ports { cpu_resetn }]; #IO_L12N_T1_MRCC_35 Sch=cpu_resetn



## Configuration options, can be used for all designs

set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property CFGBVS VCCO [current_design]