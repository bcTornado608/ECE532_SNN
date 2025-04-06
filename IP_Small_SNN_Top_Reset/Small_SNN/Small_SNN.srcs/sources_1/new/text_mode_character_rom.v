`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:49:46
// Design Name: 
// Module Name: text_mode_character_rom
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


module text_mode_character_rom
#
(
        parameter WORD_X = 16,
        parameter WORD_Y = 32,
        parameter X_NUM = 40,
        parameter Y_NUM = 15
)
(
		input wire clk,
		input wire rst,
		input wire enable,

		input wire [7:0] cur_char_ASCII,
		input wire [$clog2(WORD_Y)-1 : 0] pixel_in_char_y,
		output reg [WORD_X-1:0] cur_char_row // 32 rows of 16-bit data each
		
);

(* RAM_STYLE="BLOCK" *)
reg [WORD_X -1:0] REGMEM [0:(256*WORD_Y)-1];
wire [$clog2(256*WORD_Y)-1:0] font_mem_address;
assign font_mem_address = (cur_char_ASCII << 5) + pixel_in_char_y;

initial 
    $readmemb("font_16x32.mem", REGMEM);


always @(posedge clk) 
    begin
        if(enable) cur_char_row <= REGMEM[font_mem_address];
       

    end

endmodule
