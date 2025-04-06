`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 05:44:53 PM
// Design Name: 
// Module Name: clock_divider_20MHz
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


module clock_divider_20MHz (
    input wire clk_100MHz,  // Input 100 MHz clock
    input wire rst,         // Reset signal
    output reg clk_20MHz    // Output 20 MHz clock
);

    reg [2:0] counter;  // 3-bit counter: counts 0 to 4

    // Count from 0 to 4 at each 100 MHz clock cycle
    always @(posedge clk_100MHz or posedge rst) begin
        if (rst)
            counter <= 3'd0;
        else if (counter == 3'd4)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Generate a 20MHz clock:
    //   High for counter values 0-1 (2 cycles) and low for 2-4 (3 cycles)
    always @(*) begin
        if (counter < 3'd2)
            clk_20MHz = 1'b1;
        else
            clk_20MHz = 1'b0;
    end

endmodule

