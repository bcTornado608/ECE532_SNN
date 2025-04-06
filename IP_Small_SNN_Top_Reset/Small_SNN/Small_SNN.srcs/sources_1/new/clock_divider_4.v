`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:56:09
// Design Name: 
// Module Name: clock_divider_4
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


module clock_divider_4(
    input clk_in,        // 100 MHz clock
    output reg clk_out   // 25 MHz clock
);
    reg [1:0] count = 0;
    always @(posedge clk_in) begin
        count <= count + 1;
        clk_out <= (count == 0);
    end
endmodule
