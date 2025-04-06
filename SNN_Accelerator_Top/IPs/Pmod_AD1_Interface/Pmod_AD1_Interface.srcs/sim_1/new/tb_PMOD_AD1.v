`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 05:09:27 PM
// Design Name: 
// Module Name: tb_PMOD_AD1
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


module tb_PMOD_AD1();

   // Testbench clock: 20 MHz => period 50 ns
    parameter CLK_PERIOD = 50;

    reg  clk_20mhz;
    reg  reset;
    wire cs;
    wire sclk;
    reg  sdataA;
    reg  sdataB;
    wire [11:0] dataA;
    wire [11:0] dataB;
    wire data_valid;

    // Instantiate the DUT
    PMOD_AD1_Interface DUT (
        .clk_20mhz  (clk_20mhz),
        .reset      (reset),
        .sdataA     (sdataA),
        .sdataB     (sdataB),
        .cs         (cs),
        .sclk       (sclk),
        .dataA      (dataA),
        .dataB      (dataB),
        .data_valid (data_valid)
    );

    // Clock generation: 20 MHz
    initial clk_20mhz = 1'b0;
    always #(CLK_PERIOD/2) clk_20mhz = ~clk_20mhz;

    // Simulated shift registers for each channel (16 bits: 4 zeros + 12 data)
    reg [15:0] shiftA = {4'b0000, 12'hABC}; // channel A
    reg [15:0] shiftB = {4'b0000, 12'h123}; // channel B

    // Load first bit when CS goes low
    always @(negedge cs) begin
        shiftA <= {shiftA[14:0], 1'b0};
        shiftB <= {shiftB[14:0], 1'b0};
        sdataA <= shiftA[15];
        sdataB <= shiftB[15];
    end

    // Shift data on SCLK falling edge while CS is low
    always @(negedge sclk) begin
        if (!cs) begin
            shiftA <= {shiftA[14:0], 1'b0};
            shiftB <= {shiftB[14:0], 1'b0};
            sdataA <= shiftA[15];
            sdataB <= shiftB[15];
        end else begin
            // If CS is high, drive high impedance
            sdataA <= 1'bZ;
            sdataB <= 1'bZ;
        end
    end

    initial begin
        // Initial conditions
        reset = 1'b1;
        sdataA = 1'bZ;
        sdataB = 1'bZ;

        // Release reset after a few cycles
        #(10*CLK_PERIOD);
        reset = 1'b0;

        // Let it run for a few samples
        #(50*CLK_PERIOD);

        // Display results whenever data_valid goes high
        forever begin
            @(posedge data_valid);
            $display("Time %t: dataA = 0x%0h, dataB = 0x%0h",
                     $time, dataA, dataB);
        end
    end

endmodule

