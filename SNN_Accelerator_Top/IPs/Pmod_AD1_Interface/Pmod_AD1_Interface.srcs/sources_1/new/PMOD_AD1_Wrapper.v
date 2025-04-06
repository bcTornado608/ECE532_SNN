`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 05:45:27 PM
// Design Name: 
// Module Name: PMOD_AD1_Wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//PMOD_AD1 top module
// Read data from ADC and store data into a memory
module PMOD_AD1_Wrapper #
(
    parameter integer BRAM_MAX_ADDR	= 32'h00002000,
    
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH	= 32,
    parameter integer C_S00_AXI_ADDR_WIDTH	= 4,
    
    // Parameters of Axi Master Bus Interface M00_AXI
    parameter  C_M00_AXI_START_DATA_VALUE	= 32'h00000000,
    parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h00000000,
    parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
    parameter integer C_M00_AXI_DATA_WIDTH	= 32,
    parameter integer C_M00_AXI_TRANSACTIONS_NUM	= 1
)(
    input wire clk_100MH,
    input wire resetn, //active low reset
    
    //interface for PMOD_AD1
    input wire ADC_input_A,
    input wire ADC_input_B,
    output wire CS,
    output wire SCLK,
    output wire [11:0] dataA,
    output wire [11:0] dataB,
    
    
    input aclk,
    input aresetn,
    
    output reg [31:0] Output_Addr,
    input sd_valid,
    input [7:0] sd_data,
    input muxsel,
    output wire [31:0] data_mux,
    output wire data_valid_mux,
    input rd_en,
    
    // BRAM
    output [31:0] dout,
    input bramen,
    input [15:0] addr,
    input clkb
    );
 
    
    wire resetp = !resetn; // convert active low reset to active high
    wire data_valid;
    wire clk_20mhz;
    wire TX_done;
    
    // clock divider from 100MHz to 20MHz
    clock_divider_20MHz clk_divider(
        .clk_100MHz(clk_100MH),
        .rst(resetp),
        .clk_20MHz(clk_20mhz)
    );
    
    // SPI PMOD_AD1 interface
    PMOD_AD1_Interface PMOD_AD1 (
        .clk_20mhz  (clk_20mhz),
        .reset      (resetp),
        .sdataA     (ADC_input_A),
        .sdataB     (ADC_input_B),
        .cs         (CS),
        .sclk       (SCLK),
        .dataA      (dataA),
        .dataB      (dataB),
        .data_valid (data_valid)
    );
    
    
    //generate output address
    //Start from address 0, increment by 4 for each sample
    //reset to 0 if 
    reg [63:0] output_addr_shift;
    
    always @(posedge clk_100MH) begin
        output_addr_shift <= {output_addr_shift[31:0], Output_Addr};
        
        if (!rd_en) begin
            Output_Addr <= 32'h0000_0000;
        end

        else if (data_valid_mux) begin
            if (Output_Addr < BRAM_MAX_ADDR-1) begin
                Output_Addr <= Output_Addr + 1;
            end
            else begin
                Output_Addr <= 32'h0000_0000;
            end
        end
    end
   
   
   // Data from two channels (12 bit each are combined into a 32-bit, 4-byte wide word) are stored in a memory using AXI master interface. 
   wire [31:0] DATA_AB = {12'b0, dataB, dataA};
   wire [31:0] sd_data_ext = {24'd0, sd_data};
   
    reg sd_valid_oc;      // Register to store the one-cycle pulse
    reg sd_valid_d; // Delayed version of sd_valid_cnt
    
    always @(posedge clk_100MH) begin
        sd_valid_d <= sd_valid;
    
        if (sd_valid == 1'b1 && sd_valid_d == 1'b0) begin
            sd_valid_oc <= 1'b1;
        end else begin
            sd_valid_oc <= 1'b0;
        end
    end
    
   // Process and concat sd data
   reg [31:0] sd_data_concat;
   always @(posedge clk_100MH) begin
    if(!rd_en)
        sd_data_concat <= 32'd0;
    else if(sd_valid_oc)
        sd_data_concat <= {sd_data_concat[23:0], sd_data};
    else
        sd_data_concat <= sd_data_concat;
   end
   
   // counter for new sd valid
   reg [1:0] sd_valid_cnt;
   reg init;
   always @(posedge clk_100MH or negedge rd_en) begin
        if (!rd_en) begin
            init          <= 1'b0;
            sd_valid_cnt  <= 2'b00;
        end 
        else if (sd_valid_oc) begin
            if (!init) begin
                init         <= 1'b1;
                sd_valid_cnt <= 2'b00;
            end 
            else if (sd_valid_cnt >= 2'b11) begin
                sd_valid_cnt <= 2'b00;
            end 
            else begin
                sd_valid_cnt <= sd_valid_cnt + 1;
            end
        end
    end
       
    reg sd_valid_concat;      // Register to store the one-cycle pulse
    reg [1:0] sd_valid_cnt_d; // Delayed version of sd_valid_cnt
    
    always @(posedge clk_100MH) begin
        sd_valid_cnt_d <= sd_valid_cnt; // Store previous value of sd_valid_cnt
    
        // Generate a one-cycle pulse when sd_valid_cnt transitions to 2'b11
        if (sd_valid_cnt == 2'b11 && sd_valid_cnt_d != 2'b11) begin
            sd_valid_concat <= 1'b1;
        end else begin
            sd_valid_concat <= 1'b0;
        end
    end
    
    /* Mux input signals with data from sd card */
    data_input_mux32 u_data_input_mux32 (
        .data_validA(sd_valid_concat),
        .data_validB(data_valid),
        .dataA(sd_data_concat),
        .dataB(DATA_AB),
        .muxsel(muxsel),
        .dataout(data_mux),
        .data_validout(data_valid_mux)
    );
    
    blk_mem_gen_0 bram1 (
      .clka(clk_100MH),    // input wire clka
      .ena(sd_valid_concat),      // input wire ena
      .wea(1'b1),      // input wire [0 : 0] wea
      .addra(Output_Addr[15:0]),  // input wire [15 : 0] addra
      .dina(sd_data_concat),    // input wire [31 : 0] dina
      .clkb(clkb),    // input wire clkb
      .enb(bramen),      // input wire enb
      .addrb(addr),  // input wire [15 : 0] addrb
      .doutb(dout)  // output wire [31 : 0] doutb
    );
    
    
endmodule
