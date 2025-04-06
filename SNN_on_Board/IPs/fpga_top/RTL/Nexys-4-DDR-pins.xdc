
## Clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk100mhz }];     #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100mhz}];


set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { resetn  }]; #IO_L3P_T0_DQS_AD1P_15 Sch=cpu_resetn
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { rd_en }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
## LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { led[0]  }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { led[1]  }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { led[2]  }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { led[3]  }]; #IO_L8P_T1_D11_14 Sch=led[3]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { led[4]  }]; #IO_L7P_T1_D09_14 Sch=led[4]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { led[5]  }]; #IO_L18N_T2_A11_D27_14 Sch=led[5]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { led[6]  }]; #IO_L17P_T2_A14_D30_14 Sch=led[6]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { led[7]  }]; #IO_L18P_T2_A12_D28_14 Sch=led[7]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { led[8]  }]; #IO_L16N_T2_A15_D31_14 Sch=led[8]
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { led[9]  }]; #IO_L14N_T2_SRCC_14 Sch=led[9]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { led[10] }]; #IO_L22P_T3_A05_D21_14 Sch=led[10]
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { led[11] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=led[11]
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { led[12] }]; #IO_L16P_T2_CSI_B_14 Sch=led[12]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { led[13] }]; #IO_L22N_T3_A04_D20_14 Sch=led[13]
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { led[14] }]; #IO_L20N_T3_A07_D23_14 Sch=led[14]
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { led[15] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=led[15]

# SDcard
set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { sdcard_pwr_n }];   #IO_L14P_T2_SRCC_35 Sch=sd_resetn
#set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { sd_cd }];          #IO_L9N_T1_DQS_AD7N_35 Sch=sd_cd
set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { sdclk }];          #IO_L9P_T1_DQS_AD7P_35 Sch=sdclk
set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { sdcmd }];          #IO_L16N_T2_35 Sch=sdcmd
set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { sddat0 }];         #IO_L16P_T2_35 Sch=sd_dat[0]
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { sddat1 }];         #IO_L18N_T2_35 Sch=sd_dat[1]
set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { sddat2 }];         #IO_L18P_T2_35 Sch=sd_dat[2]
set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { sddat3 }];         #IO_L14N_T2_SRCC_35 Sch=sd_dat[3]
set_property IOB FALSE [get_ports sdcmd]
set_property PULLUP TRUE [get_ports {sdcmd}]


# PMOD_AD1_interface
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ADC_Enable_0 }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { CS_0 }]; #IO_L20N_T3_A19_15 Sch=ja[1]
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { ADC_input_A_0 }]; #IO_L21N_T3_DQS_A18_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { ADC_input_B_0 }]; #IO_L21P_T3_DQS_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { SCLK_0 }]; #IO_L18N_T2_A23_15 Sch=ja[4]


set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { muxsel }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]

# Reset (BTN1)
set_property PACKAGE_PIN N17 [get_ports rst_n_btn]   
set_property IOSTANDARD LVCMOS33 [get_ports rst_n_btn]

# Button BTN0 �� Start
set_property PACKAGE_PIN P18 [get_ports start_btn]
set_property IOSTANDARD LVCMOS33 [get_ports start_btn]

# === Pmod JA debug ��� ===
# set_property PACKAGE_PIN C17 [get_ports rst_n_btn_out]
# set_property IOSTANDARD LVCMOS33 [get_ports rst_n_btn_out]

# set_property PACKAGE_PIN D18 [get_ports rst_n_out]
# set_property IOSTANDARD LVCMOS33 [get_ports rst_n_out]

# set_property PACKAGE_PIN E18 [get_ports start_btn_out]
# set_property IOSTANDARD LVCMOS33 [get_ports start_btn_out]

# set_property PACKAGE_PIN G17 [get_ports start_out]
# set_property IOSTANDARD LVCMOS33 [get_ports start_out]

# set_property PACKAGE_PIN D17 [get_ports start_debug]
# set_property IOSTANDARD LVCMOS33 [get_ports start_debug]

# Output (classification_result[1:0]) �󶨵� LED������ LED0 �� LED1��
# set_property PACKAGE_PIN H17 [get_ports {classification_result[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {classification_result[0]}]

# set_property PACKAGE_PIN K15 [get_ports {classification_result[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {classification_result[1]}]

# �����λѡ��an[7:0]��
set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# �߶ζ�ѡ��seg[6:0]��: CA~CG
set_property PACKAGE_PIN T10 [get_ports {seg[0]}]
set_property PACKAGE_PIN R10 [get_ports {seg[1]}]
set_property PACKAGE_PIN K16 [get_ports {seg[2]}]
set_property PACKAGE_PIN K13 [get_ports {seg[3]}]
set_property PACKAGE_PIN P15 [get_ports {seg[4]}]
set_property PACKAGE_PIN T11 [get_ports {seg[5]}]
set_property PACKAGE_PIN L18 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## VGA Output (HSYNC, VSYNC)
set_property PACKAGE_PIN B11 [get_ports hsync]
set_property PACKAGE_PIN B12 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

## VGA Red (4-bit)
set_property PACKAGE_PIN A3 [get_ports {r[0]}]
set_property PACKAGE_PIN B4 [get_ports {r[1]}]
set_property PACKAGE_PIN C5 [get_ports {r[2]}]
set_property PACKAGE_PIN A4 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[*]}]

## VGA Green (4-bit)
set_property PACKAGE_PIN C6 [get_ports {g[0]}]
set_property PACKAGE_PIN A5 [get_ports {g[1]}]
set_property PACKAGE_PIN B6 [get_ports {g[2]}]
set_property PACKAGE_PIN A6 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[*]}]

## VGA Blue (4-bit)
set_property PACKAGE_PIN B7 [get_ports {b[0]}]
set_property PACKAGE_PIN C7 [get_ports {b[1]}]
set_property PACKAGE_PIN D7 [get_ports {b[2]}]
set_property PACKAGE_PIN D8 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[*]}]