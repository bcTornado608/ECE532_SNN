//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Mon Mar 31 23:06:34 2025
//Host        : Schwartz running 64-bit major release  (build 9200)
//Command     : generate_target PMOD_top_wrapper.bd
//Design      : PMOD_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module PMOD_top_wrapper
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
  input clk_100MHz;
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

  wire ADC_Enable_0;
  wire ADC_input_A_0;
  wire ADC_input_B_0;
  wire CS_0;
  wire SCLK_0;
  wire [7:0]an;
  wire [3:0]b;
  wire clk_100MHz;
  wire [3:0]g;
  wire hsync;
  wire muxsel_0;
  wire [3:0]r;
  wire rd_en;
  wire resetn;
  wire rst_n_btn;
  wire [7:0]sd_data_0;
  wire sd_valid_0;
  wire [6:0]seg;
  wire start_btn;
  wire vsync;

  PMOD_top PMOD_top_i
       (.ADC_Enable_0(ADC_Enable_0),
        .ADC_input_A_0(ADC_input_A_0),
        .ADC_input_B_0(ADC_input_B_0),
        .CS_0(CS_0),
        .SCLK_0(SCLK_0),
        .an(an),
        .b(b),
        .clk_100MHz(clk_100MHz),
        .g(g),
        .hsync(hsync),
        .muxsel_0(muxsel_0),
        .r(r),
        .rd_en(rd_en),
        .resetn(resetn),
        .rst_n_btn(rst_n_btn),
        .sd_data_0(sd_data_0),
        .sd_valid_0(sd_valid_0),
        .seg(seg),
        .start_btn(start_btn),
        .vsync(vsync));
endmodule
