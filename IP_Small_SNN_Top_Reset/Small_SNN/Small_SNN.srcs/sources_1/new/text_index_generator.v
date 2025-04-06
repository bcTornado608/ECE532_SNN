`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:47:22
// Design Name: 
// Module Name: text_index_generator
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


module text_index_generator
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
		input wire [9:0] pixel_x, // 640 pixels
		input wire [9:0] pixel_y, // 480 pixels
		input wire under_label,
		
		
		
		//input wire [2:0] text_scale, // Scaling factor (1 = 8x8, 2 = 16x16, ... up to 8x)
		//output wire [$clog2(WORD_X*WORD_Y)-1 : 0] pixel_in_char, // Pixel within the character (0-512)
		//output reg [7:0] cur_char_ASCII // Output character index 128
		output wire [$clog2(WORD_X)-1 : 0] pixel_in_char_x,
        output wire [$clog2(WORD_Y)-1 : 0] pixel_in_char_y,
		output wire [$clog2(X_NUM*Y_NUM)-1:0] char_idx // Output character index
	);
	
reg [9:0] pixel_x_ed; // 640 pixels
reg [9:0] pixel_y_ed; // 480 pixels

always @(posedge clk) begin
    if(under_label)
    begin
            pixel_x_ed = pixel_x - 308;
            pixel_y_ed = pixel_y;
    end else begin
            pixel_x_ed = pixel_x;
            pixel_y_ed = pixel_y;
    end
end 


// ==== Character Grid Position Calculation ====
wire [$clog2(X_NUM)-1 : 0] char_x; // 40 columns
wire [$clog2(Y_NUM)-1 : 0] char_y; // 15 rows


assign char_x = (pixel_x_ed >> $clog2(WORD_X)); // pixel_x / 16 
assign char_y = (pixel_y_ed >> $clog2(WORD_Y)); // pixel_y / 32


// Calculate character index (40x15 grid)
//wire [$clog2(X_NUM*Y_NUM)-1:0] char_idx;
//assign char_idx = (char_y << 6) + (char_y << 4) + char_x; // y * 80 + x
assign char_idx = (char_y << 5) + (char_y << 3) + char_x; // y * 40 + x

// ==== Character Pixel Calculation ====
//wire [$clog2(WORD_X)-1 : 0] pixel_in_char_x;
//wire [$clog2(WORD_Y)-1 : 0] pixel_in_char_y;

assign pixel_in_char_x = pixel_x_ed; 
assign pixel_in_char_y = pixel_y_ed; 
//assign pixel_in_char = (pixel_in_char_y << $clog2(WORD_X)) + pixel_in_char_x; // y * 16 + x




endmodule

