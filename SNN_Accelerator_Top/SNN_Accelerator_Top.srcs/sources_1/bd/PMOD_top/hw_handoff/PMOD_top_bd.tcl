
################################################################
# This is a generated script based on design: PMOD_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source PMOD_top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-1
   set_property BOARD_PART digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name PMOD_top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set ADC_Enable_0 [ create_bd_port -dir I ADC_Enable_0 ]
  set ADC_input_A_0 [ create_bd_port -dir I ADC_input_A_0 ]
  set ADC_input_B_0 [ create_bd_port -dir I ADC_input_B_0 ]
  set CS_0 [ create_bd_port -dir O CS_0 ]
  set SCLK_0 [ create_bd_port -dir O SCLK_0 ]
  set an [ create_bd_port -dir O -from 7 -to 0 an ]
  set b [ create_bd_port -dir O -from 3 -to 0 b ]
  set clk_100MHz [ create_bd_port -dir I -type clk clk_100MHz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $clk_100MHz
  set g [ create_bd_port -dir O -from 3 -to 0 g ]
  set hsync [ create_bd_port -dir O hsync ]
  set muxsel_0 [ create_bd_port -dir I muxsel_0 ]
  set r [ create_bd_port -dir O -from 3 -to 0 r ]
  set rd_en [ create_bd_port -dir I rd_en ]
  set resetn [ create_bd_port -dir I resetn ]
  set rst_n_btn [ create_bd_port -dir I rst_n_btn ]
  set sd_data_0 [ create_bd_port -dir I -from 7 -to 0 sd_data_0 ]
  set sd_valid_0 [ create_bd_port -dir I sd_valid_0 ]
  set seg [ create_bd_port -dir O -from 6 -to 0 seg ]
  set start_btn [ create_bd_port -dir I start_btn ]
  set vsync [ create_bd_port -dir O vsync ]

  # Create instance: PMOD_AD1_Wrapper_0, and set properties
  set PMOD_AD1_Wrapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:PMOD_AD1_Wrapper:1.0 PMOD_AD1_Wrapper_0 ]
  set_property -dict [ list \
   CONFIG.BRAM_MAX_ADDR {0xffffffff} \
 ] $PMOD_AD1_Wrapper_0

  # Create instance: Top_0, and set properties
  set Top_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:Top:1.0 Top_0 ]

  # Create instance: integrate_ila, and set properties
  set integrate_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 integrate_ila ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {8192} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {9} \
   CONFIG.C_PROBE0_WIDTH {32} \
   CONFIG.C_PROBE1_WIDTH {32} \
   CONFIG.C_PROBE3_WIDTH {8} \
   CONFIG.C_PROBE5_WIDTH {32} \
   CONFIG.C_PROBE7_WIDTH {16} \
 ] $integrate_ila

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create port connections
  connect_bd_net -net ADC_input_A_0_1 [get_bd_ports ADC_input_A_0] [get_bd_pins PMOD_AD1_Wrapper_0/ADC_input_A]
  connect_bd_net -net ADC_input_B_0_1 [get_bd_ports ADC_input_B_0] [get_bd_pins PMOD_AD1_Wrapper_0/ADC_input_B]
  connect_bd_net -net PMOD_AD1_Wrapper_0_CS [get_bd_ports CS_0] [get_bd_pins PMOD_AD1_Wrapper_0/CS]
  connect_bd_net -net PMOD_AD1_Wrapper_0_Output_Addr [get_bd_pins PMOD_AD1_Wrapper_0/Output_Addr] [get_bd_pins integrate_ila/probe0]
  connect_bd_net -net PMOD_AD1_Wrapper_0_SCLK [get_bd_ports SCLK_0] [get_bd_pins PMOD_AD1_Wrapper_0/SCLK]
  connect_bd_net -net PMOD_AD1_Wrapper_0_data_mux [get_bd_pins PMOD_AD1_Wrapper_0/data_mux] [get_bd_pins integrate_ila/probe1]
  connect_bd_net -net PMOD_AD1_Wrapper_0_data_valid_mux [get_bd_pins PMOD_AD1_Wrapper_0/data_valid_mux] [get_bd_pins integrate_ila/probe2]
  connect_bd_net -net PMOD_AD1_Wrapper_0_dout [get_bd_pins PMOD_AD1_Wrapper_0/dout] [get_bd_pins Top_0/bram_data_out] [get_bd_pins integrate_ila/probe5]
  connect_bd_net -net Top_0_an [get_bd_ports an] [get_bd_pins Top_0/an]
  connect_bd_net -net Top_0_b [get_bd_ports b] [get_bd_pins Top_0/b]
  connect_bd_net -net Top_0_bram_addr [get_bd_pins PMOD_AD1_Wrapper_0/addr] [get_bd_pins Top_0/bram_addr] [get_bd_pins integrate_ila/probe7]
  connect_bd_net -net Top_0_clk_divided [get_bd_pins PMOD_AD1_Wrapper_0/clkb] [get_bd_pins Top_0/clk_divided] [get_bd_pins integrate_ila/probe8]
  connect_bd_net -net Top_0_g [get_bd_ports g] [get_bd_pins Top_0/g]
  connect_bd_net -net Top_0_hsync [get_bd_ports hsync] [get_bd_pins Top_0/hsync]
  connect_bd_net -net Top_0_r [get_bd_ports r] [get_bd_pins Top_0/r]
  connect_bd_net -net Top_0_seg [get_bd_ports seg] [get_bd_pins Top_0/seg]
  connect_bd_net -net Top_0_vsync [get_bd_ports vsync] [get_bd_pins Top_0/vsync]
  connect_bd_net -net clk_wiz_clk_out2 [get_bd_ports clk_100MHz] [get_bd_pins PMOD_AD1_Wrapper_0/aclk] [get_bd_pins PMOD_AD1_Wrapper_0/clk_100MH] [get_bd_pins Top_0/clk_100M] [get_bd_pins integrate_ila/clk]
  connect_bd_net -net muxsel_0_1 [get_bd_ports muxsel_0] [get_bd_pins PMOD_AD1_Wrapper_0/muxsel]
  connect_bd_net -net rd_en_0_1 [get_bd_ports rd_en] [get_bd_pins PMOD_AD1_Wrapper_0/rd_en] [get_bd_pins integrate_ila/probe6]
  connect_bd_net -net resetn_1 [get_bd_ports resetn] [get_bd_pins PMOD_AD1_Wrapper_0/aresetn] [get_bd_pins PMOD_AD1_Wrapper_0/resetn]
  connect_bd_net -net rst_n_btn_0_1 [get_bd_ports rst_n_btn] [get_bd_pins Top_0/rst_n_btn]
  connect_bd_net -net sd_data_0_1 [get_bd_ports sd_data_0] [get_bd_pins PMOD_AD1_Wrapper_0/sd_data] [get_bd_pins integrate_ila/probe3]
  connect_bd_net -net sd_valid_0_1 [get_bd_ports sd_valid_0] [get_bd_pins PMOD_AD1_Wrapper_0/sd_valid] [get_bd_pins integrate_ila/probe4]
  connect_bd_net -net start_btn_0_1 [get_bd_ports start_btn] [get_bd_pins Top_0/start_btn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins PMOD_AD1_Wrapper_0/bramen] [get_bd_pins xlconstant_0/dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


