//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Mon Mar 31 23:06:34 2025
//Host        : Schwartz running 64-bit major release  (build 9200)
//Command     : generate_target PMOD_top.bd
//Design      : PMOD_top
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "PMOD_top,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=PMOD_top,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,da_bram_cntlr_cnt=4,da_clkrst_cnt=10,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "PMOD_top.hwdef" *) 
module PMOD_top
   (ADC_Enable_0,
    ADC_input_A_0,
    ADC_input_B_0,
    CS_0,
    SCLK_0,
    an,
    b,
    clk_100MHz,
    g,
    hsync,
    muxsel_0,
    r,
    rd_en,
    resetn,
    rst_n_btn,
    sd_data_0,
    sd_valid_0,
    seg,
    start_btn,
    vsync);
  input ADC_Enable_0;
  input ADC_input_A_0;
  input ADC_input_B_0;
  output CS_0;
  output SCLK_0;
  output [7:0]an;
  output [3:0]b;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_RESET resetn, CLK_DOMAIN PMOD_top_clk_100MHz, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_100MHz;
  output [3:0]g;
  output hsync;
  input muxsel_0;
  output [3:0]r;
  input rd_en;
  input resetn;
  input rst_n_btn;
  input [7:0]sd_data_0;
  input sd_valid_0;
  output [6:0]seg;
  input start_btn;
  output vsync;

  wire ADC_input_A_0_1;
  wire ADC_input_B_0_1;
  wire PMOD_AD1_Wrapper_0_CS;
  wire [31:0]PMOD_AD1_Wrapper_0_Output_Addr;
  wire PMOD_AD1_Wrapper_0_SCLK;
  wire [31:0]PMOD_AD1_Wrapper_0_data_mux;
  wire PMOD_AD1_Wrapper_0_data_valid_mux;
  wire [31:0]PMOD_AD1_Wrapper_0_dout;
  wire [7:0]Top_0_an;
  wire [3:0]Top_0_b;
  wire [15:0]Top_0_bram_addr;
  wire Top_0_clk_divided;
  wire [3:0]Top_0_g;
  wire Top_0_hsync;
  wire [3:0]Top_0_r;
  wire [6:0]Top_0_seg;
  wire Top_0_vsync;
  wire clk_wiz_clk_out2;
  wire muxsel_0_1;
  wire rd_en_0_1;
  wire resetn_1;
  wire rst_n_btn_0_1;
  wire [7:0]sd_data_0_1;
  wire sd_valid_0_1;
  wire start_btn_0_1;
  wire [0:0]xlconstant_0_dout;

  assign ADC_input_A_0_1 = ADC_input_A_0;
  assign ADC_input_B_0_1 = ADC_input_B_0;
  assign CS_0 = PMOD_AD1_Wrapper_0_CS;
  assign SCLK_0 = PMOD_AD1_Wrapper_0_SCLK;
  assign an[7:0] = Top_0_an;
  assign b[3:0] = Top_0_b;
  assign clk_wiz_clk_out2 = clk_100MHz;
  assign g[3:0] = Top_0_g;
  assign hsync = Top_0_hsync;
  assign muxsel_0_1 = muxsel_0;
  assign r[3:0] = Top_0_r;
  assign rd_en_0_1 = rd_en;
  assign resetn_1 = resetn;
  assign rst_n_btn_0_1 = rst_n_btn;
  assign sd_data_0_1 = sd_data_0[7:0];
  assign sd_valid_0_1 = sd_valid_0;
  assign seg[6:0] = Top_0_seg;
  assign start_btn_0_1 = start_btn;
  assign vsync = Top_0_vsync;
  PMOD_top_PMOD_AD1_Wrapper_0_0 PMOD_AD1_Wrapper_0
       (.ADC_input_A(ADC_input_A_0_1),
        .ADC_input_B(ADC_input_B_0_1),
        .CS(PMOD_AD1_Wrapper_0_CS),
        .Output_Addr(PMOD_AD1_Wrapper_0_Output_Addr),
        .SCLK(PMOD_AD1_Wrapper_0_SCLK),
        .aclk(clk_wiz_clk_out2),
        .addr(Top_0_bram_addr),
        .aresetn(resetn_1),
        .bramen(xlconstant_0_dout),
        .clk_100MH(clk_wiz_clk_out2),
        .clkb(Top_0_clk_divided),
        .data_mux(PMOD_AD1_Wrapper_0_data_mux),
        .data_valid_mux(PMOD_AD1_Wrapper_0_data_valid_mux),
        .dout(PMOD_AD1_Wrapper_0_dout),
        .muxsel(muxsel_0_1),
        .rd_en(rd_en_0_1),
        .resetn(resetn_1),
        .sd_data(sd_data_0_1),
        .sd_valid(sd_valid_0_1));
  PMOD_top_Top_0_0 Top_0
       (.an(Top_0_an),
        .b(Top_0_b),
        .bram_addr(Top_0_bram_addr),
        .bram_data_out(PMOD_AD1_Wrapper_0_dout),
        .clk_100M(clk_wiz_clk_out2),
        .clk_divided(Top_0_clk_divided),
        .g(Top_0_g),
        .hsync(Top_0_hsync),
        .r(Top_0_r),
        .rst_n_btn(rst_n_btn_0_1),
        .seg(Top_0_seg),
        .start_btn(start_btn_0_1),
        .vsync(Top_0_vsync));
  PMOD_top_ila_0_0 integrate_ila
       (.clk(clk_wiz_clk_out2),
        .probe0(PMOD_AD1_Wrapper_0_Output_Addr),
        .probe1(PMOD_AD1_Wrapper_0_data_mux),
        .probe2(PMOD_AD1_Wrapper_0_data_valid_mux),
        .probe3(sd_data_0_1),
        .probe4(sd_valid_0_1),
        .probe5(PMOD_AD1_Wrapper_0_dout),
        .probe6(rd_en_0_1),
        .probe7(Top_0_bram_addr),
        .probe8(Top_0_clk_divided));
  PMOD_top_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
endmodule
