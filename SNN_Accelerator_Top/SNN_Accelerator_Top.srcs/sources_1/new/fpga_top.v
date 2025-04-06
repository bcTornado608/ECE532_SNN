//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Tue Mar 11 00:40:04 2025
//Host        : Schwartz running 64-bit major release  (build 9200)
//Command     : generate_target design_2_wrapper.bd
//Design      : design_2_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module fpga_top (  
  input clk100mhz,
  output [15:0]led,
  input rd_en,
  input resetn,
  output sdcard_pwr_n,
  output sdclk,
  (* DONT_TOUCH = "true" *) inout sdcmd,
  input sddat0,
  output sddat1,
  output sddat2,
  output sddat3,
  input ADC_Enable_0,
  input ADC_input_A_0,
  input ADC_input_B_0,
  output CS_0,
  output SCLK_0,
  input muxsel,
  input rst_n_btn,
  input start_btn,
  output [7:0]an,
  output [3:0]b,
  output [3:0]g,
  output hsync,
  output [3:0]r,
  output [6:0]seg,
  output vsync
);

  wire rstn;
  wire clk50;
  wire outen;
  wire [7:0] outbyte;
  wire clk100;
  
    sd_read_file_top u_sd_read_file_top (
        .clk(clk50),
        .sdcard_pwr_n(sdcard_pwr_n),
        .sdclk(sdclk),
        .sdcmd(sdcmd),
        .sddat0(sddat0),
        .sddat1(sddat1),
        .sddat2(sddat2),
        .sddat3(sddat3),
        .led(led),
        .rd_en(rd_en),
        .rstn(rstn),
        .outen(outen),
        .outbyte(outbyte)
    );
    
    clk_wiz_0 uclk_wiz_0 (
    // Clock out ports
    .clk_out50(clk50),     // output clk_out1
    .clk_out100(clk100),
    // Status and control signals
    .resetn(resetn), // input resetn
    .locked(rstn),       // output locked
   // Clock in ports
    .clk_in1(clk100mhz));      // input clk_in1
    
    ila_0 uila_0 (
    .clk(clk100), // input wire clk


    .probe0(outen), // input wire [0:0]  probe0  
    .probe1(outbyte) // input wire [7:0]  probe1
    );

    PMOD_top_wrapper PMOD_top_inst (
        .clk_100MHz(clk100),
        .resetn(resetn),
        .rst_n_btn(rst_n_btn),
        .ADC_Enable_0(ADC_Enable_0),
        .ADC_input_A_0(ADC_input_A_0),
        .ADC_input_B_0(ADC_input_B_0),
        .muxsel_0(muxsel),
        .rd_en(rd_en),
        .sd_data_0(outbyte),
        .sd_valid_0(outen),
        .start_btn(start_btn),
        .CS_0(CS_0),
        .SCLK_0(SCLK_0),
        .an(an),
        .b(b),
        .g(g),
        .r(r),
        .seg(seg),
        .hsync(hsync),
        .vsync(vsync)
    );

//    blk_mem_gen_0 bram1 (
//      .clka(outen),    // input wire clka
//      .ena(ena),      // input wire ena
//      .wea(wea),      // input wire [0 : 0] wea
//      .addra(addra),  // input wire [11 : 0] addra
//      .dina(dina),    // input wire [31 : 0] dina
//      .douta(douta)  // output wire [31 : 0] douta
//    );
    
endmodule
