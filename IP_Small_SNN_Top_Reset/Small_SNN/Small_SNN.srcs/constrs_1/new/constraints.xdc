## Set the 100 MHz System Clock (Nexys4 DDR)
set_property PACKAGE_PIN E3 [get_ports clk_100M]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100M]
create_clock -period 10.000 [get_ports clk_100M]

# Reset (BTN1)
set_property PACKAGE_PIN N17 [get_ports rst_n_btn]   
set_property IOSTANDARD LVCMOS33 [get_ports rst_n_btn]

# Button BTN0 → Start
set_property PACKAGE_PIN P18 [get_ports start_btn]
set_property IOSTANDARD LVCMOS33 [get_ports start_btn]

# === Pmod JA debug 输出 ===
set_property PACKAGE_PIN C17 [get_ports rst_n_btn_out]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n_btn_out]

set_property PACKAGE_PIN D18 [get_ports rst_n_out]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n_out]

set_property PACKAGE_PIN E18 [get_ports start_btn_out]
set_property IOSTANDARD LVCMOS33 [get_ports start_btn_out]

set_property PACKAGE_PIN G17 [get_ports start_out]
set_property IOSTANDARD LVCMOS33 [get_ports start_out]

set_property PACKAGE_PIN D17 [get_ports start_debug]
set_property IOSTANDARD LVCMOS33 [get_ports start_debug]

# Output (classification_result[1:0]) 绑定到 LED（比如 LED0 和 LED1）
set_property PACKAGE_PIN H17 [get_ports {classification_result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {classification_result[0]}]

set_property PACKAGE_PIN K15 [get_ports {classification_result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {classification_result[1]}]

# 数码管位选（an[7:0]）
set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# 七段段选（seg[6:0]）: CA~CG
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