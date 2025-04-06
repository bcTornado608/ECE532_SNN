`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:48:32
// Design Name: 
// Module Name: label_mode_buffer
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


module label_mode_buffer
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
		input wire [7:0] swt,
		input wire under_label,
		
		//input wire [2:0] text_scale, // Scaling factor (1 = 8x8, 2 = 16x16, ... up to 8x)
		//
		input wire [$clog2(X_NUM*Y_NUM)-1:0] char_idx, // Output character index
		output reg [7:0] cur_char_ASCII // Output character index 128
	);


// ==== Text Buffer Memory ====
(* RAM_STYLE="BLOCK" *)
reg [7:0] REGMEM [0:999]; // 40 * 25 = 960


// Load initial text data from file
initial 
    $readmemh("All_only_pred.mem", REGMEM);
    
reg [14:0] baseIndex, baseIndex_1, baseIndex_2;


// Memory Read/Write Operation
//always @(posedge clk) 
//begin
//    if(enable) begin 
        
//        if (under_label) begin 
//            baseIndex <= 40*24;
//        end else begin
//            baseIndex_1 <= (swt>>1)<<4; // x*80
//            baseIndex_2 <= (swt>>1)<<6; 
//            baseIndex <= baseIndex_1+baseIndex_2;
//        end
        
        
//        if (under_label) 
//            cur_char_ASCII <= REGMEM[baseIndex+char_idx];
//        else if (char_idx<80)
//            cur_char_ASCII <= REGMEM[baseIndex+char_idx]; // Read stored character
//        else 
//            cur_char_ASCII <= 8'h20;
//    end
//end
always @(posedge clk) 
begin
    if(enable) begin 
        if (under_label) begin 
            baseIndex <= 40*24;  // label under circle, no change
        end else begin
            // ONLY use predicted label (2 bits: swt[2:1])
            baseIndex <= swt[2:1] * 80;
        end

        if (under_label) 
            cur_char_ASCII <= REGMEM[baseIndex + char_idx];
        else if (char_idx < 80)
            cur_char_ASCII <= REGMEM[baseIndex + char_idx];
        else 
            cur_char_ASCII <= 8'h20; // space
    end
end



endmodule