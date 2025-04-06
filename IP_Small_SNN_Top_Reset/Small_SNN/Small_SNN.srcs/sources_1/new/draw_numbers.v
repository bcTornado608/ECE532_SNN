`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:50:30
// Design Name: 
// Module Name: draw_numbers
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


module draw_numbers (
    input wire clk,
    input wire rst,
    input wire [9:0] pixel_x,  // VGA X position (0-639)
    input wire [9:0] pixel_y,  // VGA Y position (0-479)
    input wire [11:0] num_DF,    // 3-digit number input (BCD or binary)
    input wire [11:0] num_PF,    // 3-digit number input
    input wire [11:0] num_HP,    // 3-digit number input
    output reg num_pixel_on        // Pixel output (1 = draw, 0 = background)
);

    localparam CIRCLE1_X = 110, CIRCLE1_Y = 200;
    localparam CIRCLE2_X = 320, CIRCLE2_Y = 200;
    localparam CIRCLE3_X = 530, CIRCLE3_Y = 200;
    
    localparam DF_x = 60, DF_y = 170;
    localparam PF_x = 270, PF_y = 170;
    localparam HP_x = 480, HP_y = 170;
    
    wire [3:0] hundreds_DF = num_DF/100; // 100s place digit
    wire [3:0] tens_DF = (num_DF % 100) / 10;     // 10s place digit
    wire [3:0] ones_DF = num_DF % 10;     // 1s place digit
    
    wire [3:0] hundreds_PF = num_PF / 100; // 100s place digit
    wire [3:0] tens_PF = (num_PF % 100) / 10;     // 10s place digit
    wire [3:0] ones_PF = num_PF % 10;    // 1s place digit
    
    wire [3:0] hundreds_HP = num_HP / 100;// 100s place digit
    wire [3:0] tens_HP = (num_HP % 100) / 10;     // 10s place digit
    wire [3:0] ones_HP = num_HP % 10;     // 1s place digit
    
    (* RAM_STYLE="BLOCK" *)
    reg [32-1:0] REGMEM [0:(10*64)-1];
    reg [32-1:0] cur_number_row;
//   assign font_mem_address = (cur_char_ASCII << 6) + pixel_in_char_y;
    
    initial 
        $readmemb("font_32x64.mem", REGMEM);
    
    
//    always @(posedge clk) 
//        begin
//            if(enable) cur_char_row <= REGMEM[font_mem_address];
           
    
//        end
   reg [$clog2(10*64)-1:0] font_mem_address;
   wire [$clog2(64)-1 : 0] pixel_in_char_y = (pixel_y >= 170) ? (pixel_y - 170) : 0;
   
    
    always @(posedge clk) begin
        if (pixel_y >= 170 && pixel_y < 234) begin
            if(pixel_x >= DF_x && pixel_x < DF_x+96)begin
                if(pixel_x >= DF_x && pixel_x < DF_x+32)begin
                    font_mem_address = (hundreds_DF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-DF_x)];
                    
                
                end else if(pixel_x >= DF_x+32 && pixel_x < DF_x+64)begin
                    font_mem_address = (tens_DF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(DF_x+32))];
                
                end if(pixel_x >= DF_x+64 && pixel_x < DF_x+96)begin
                    font_mem_address = (ones_DF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(DF_x+64))];
                
                end
            end else if(pixel_x >= PF_x && pixel_x < PF_x+96)begin
                if(pixel_x >= PF_x && pixel_x < PF_x+32)begin
                    font_mem_address = (hundreds_PF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-PF_x)];
                
                end else if(pixel_x >= PF_x+32 && pixel_x < PF_x+64)begin
                    font_mem_address = (tens_PF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(PF_x+32))];
                
                end if(pixel_x >= PF_x+64 && pixel_x < PF_x+96)begin
                    font_mem_address = (ones_PF << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(PF_x+64))];
                
                end
            
            end else if(pixel_x >= HP_x && pixel_x < HP_x+96)begin
                if(pixel_x >= HP_x && pixel_x < HP_x+32)begin
                    font_mem_address = (hundreds_HP << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-HP_x)];
                
                end else if(pixel_x >= HP_x+32 && pixel_x < HP_x+64)begin
                    font_mem_address = (tens_HP << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(HP_x+32))];
                
                end if(pixel_x >= HP_x+64 && pixel_x < HP_x+96)begin
                    font_mem_address = (ones_HP << 6) + pixel_in_char_y;
                    cur_number_row <= REGMEM[font_mem_address];
                    num_pixel_on <= cur_number_row[32-(pixel_x-(HP_x+64))];
                
                end
            
            end else num_pixel_on = 0;
    
        end
    end 
    

    
    
    

endmodule
