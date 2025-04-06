`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:51:22
// Design Name: 
// Module Name: draw_circle
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


module draw_circle(
		input wire clk,
		input wire rst,
		input wire enable,

		//input wire [7:0] cur_char_ASCII,
		input wire [9 : 0] pixel_y,
		output reg [640-1:0] cur_char_row // 32 rows of 16-bit data each
		
);

(* RAM_STYLE="BLOCK" *)
reg [640-1:0] REGMEM [0:480-1];
//wire [$clog2(256*WORD_Y)-1:0] font_mem_address;
//assign font_mem_address = (cur_char_ASCII << 5) + pixel_in_char_y;

initial 
    $readmemb("circle_display.mem", REGMEM);


always @(posedge clk) 
    begin
        if(enable) cur_char_row <= REGMEM[pixel_y];
       

    end


endmodule