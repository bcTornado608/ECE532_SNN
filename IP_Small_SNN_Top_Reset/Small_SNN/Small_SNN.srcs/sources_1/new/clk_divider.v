`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24 02:09:57
// Design Name: 
// Module Name: clk_divider
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


module clk_divider (
    input wire clk,              
    output reg clk_out           
);
    parameter DIVIDE_COUNT = 4;  
 
    reg [31:0] counter;
 
    always @(posedge clk) begin
        if (counter == DIVIDE_COUNT - 1) begin
            counter <= 32'd0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
