`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 04:59:30 PM
// Design Name: 
// Module Name: PMOD_AD1_Interface
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


module PMOD_AD1_Interface (
    input  wire        clk_20mhz,   // 20 MHz clock (from PLL or external)
    input  wire        reset,       // Synchronous reset
    input  wire        sdataA,      // Data from ADC channel A
    input  wire        sdataB,      // Data from ADC channel B
    output reg         cs,          // Chip Select (active low)
    output wire        sclk,        // Serial clock to ADC
    output reg [11:0]  dataA,       // 12-bit result (channel A)
    output reg [11:0]  dataB,       // 12-bit result (channel B)
    output reg         data_valid   // Strobe: high for 1 cycle when new data is ready
);

    // Use a 5-bit counter to count 20 cycles:
    //  - 16 cycles for shifting data (4 leading zeros + 12 data bits)
    //  - 4 cycles idle for a total period of 1 us (at 20 MHz = 50 ns per cycle)
    reg [4:0] bitCount;
    
    // Shift registers to capture the 16-bit word from the ADC
    reg [15:0] shiftRegA;
    reg [15:0] shiftRegB;

    // For simplicity, we drive sclk directly from the 20 MHz input.
    assign sclk = clk_20mhz;

    // --------------------------------------------------------------------------
    // Control Logic on the Rising Edge of clk_20mhz
    // --------------------------------------------------------------------------
    always @(posedge clk_20mhz or posedge reset) begin
        if (reset) begin
            bitCount    <= 5'd0;
            cs          <= 1'b1;      // Idle high
            dataA       <= 12'd0;
            dataB       <= 12'd0;
            data_valid  <= 1'b0;
        end else begin
            // Data capture phase: 16 cycles (bitCount 0 to 15)
            if (bitCount < 16) begin
                cs <= 1'b0; // ADC is selected
                bitCount <= bitCount + 1;
            end
            // Idle phase: remaining 4 cycles (bitCount 16 to 19)
            else begin
                bitCount <= bitCount + 1;
                if (bitCount == 19) begin
                    bitCount <= 0; // Restart conversion cycle
                end
                cs <= 1'b1;  // ADC idle
                // When we've captured the 16th bit (i.e. at bitCount == 16)
                if (bitCount == 16) begin
                    dataA <= shiftRegA[11:0]; // Latch lower 12 bits
                    dataB <= shiftRegB[11:0];
                    
                end
                //data valid is asset when data is ready
                else if (bitCount == 17) begin
                    data_valid <= 1'b1;
                end
                else begin
                    data_valid <= 1'b0;
                end
            end
        end
    end

    // --------------------------------------------------------------------------
    // Sampling Logic on the Falling Edge of clk_20mhz (i.e. sclk falling edge)
    // --------------------------------------------------------------------------
    always @(negedge clk_20mhz or posedge reset) begin
        if (reset) begin
            shiftRegA <= 16'd0;
            shiftRegB <= 16'd0;
        end else begin
            // Only sample data when cs is low
            if (cs == 1'b0) begin
                shiftRegA <= {shiftRegA[14:0], sdataA};
                shiftRegB <= {shiftRegB[14:0], sdataB};
            end
        end
    end


endmodule


