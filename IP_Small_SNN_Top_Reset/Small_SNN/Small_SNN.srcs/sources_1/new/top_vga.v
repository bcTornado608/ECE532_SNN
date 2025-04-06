`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/11 14:02:41
// Design Name: 
// Module Name: top_vga
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


module top_vga (
    input wire clk_100MHz,  // 100MHz FPGA clock
    input wire rst, 
    input wire [1:0] true_label, //input 
                                //or can delete and use swt[4:3]       
    //input wire [7:0] swt, // Switch input mapping:
                          // [4:3] = TrueLabel
                          // [2:1] = PredLabel
                          // [0]   = Test flag (1 = show red/green/blue, 0=label display)
                          //
                          // Label encoding:
                          //   00 - dorsiflexion
                          //   01 - plantarflexion
                          //   10 - heel priking
                          //   11 - (empty) only show predicted label

    input wire complete, //1: complete -- to show the pred label by nums
    input wire [9:0] num_DF,  // DF counter 0-999)dorsiflexion
    input wire [9:0] num_PF,  // PF counter (0-999)plantarflexion
    input wire [9:0] num_HP,  // HP counter (0-999)heel priking
    
    output wire hsync,      // VGA 
    output wire vsync,      // VGA 
    output reg [3:0] r,    // red
    output reg [3:0] g,    // green
    output reg [3:0] b     // blue
);
    
    wire draw;
    //output reg [11:0] rgb,
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire clk_25MHz;
    
    vga_module vga_inst (
        .clk_100MHz(clk_100MHz),
        .rst(rst),
        .hsync(hsync),
        .vsync(vsync),
        .draw(draw),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .clk_25MHz(clk_25MHz)
//        .r(r),
//        .g(g),
//        .b(b)
    );
    
    parameter WORD_X = 16;
    parameter WORD_Y = 32;
    parameter X_NUM = 40;
    parameter Y_NUM = 15;
    wire [$clog2(WORD_X*WORD_Y)-1 : 0] pixel_in_char; // Pixel within the character (0-512)
    wire [$clog2(WORD_X)-1 : 0] pixel_in_char_x;
    wire [$clog2(WORD_Y)-1 : 0] pixel_in_char_y;
	wire [7:0] cur_char_ASCII; // Output character index 128
	wire [$clog2(X_NUM*Y_NUM)-1:0] char_idx;
	//wire [12:0] char_idx;
	wire enable = 1;
	wire under_label = 0;
	wire num_pixel_on;


    reg [1:0] state = 0;  // Counter selector state (00 = DF, 01 = PF, 10 = HP)
    reg stop_flag = 0;     // Stop flag

    // 1 Hz Clock Divider (25 Million counts for 1 second)
    reg [24:0] clk_div = 0;  // 25-bit counter for 1-second pulse
    reg one_sec_pulse = 0;

   //get the index of label
    text_index_generator label_index(
        .clk(clk_25MHz),
		.rst(rst),
        .enable(enable),
		.pixel_x(pixel_x),
        .pixel_y(pixel_y), // 480 pixels
		
        .under_label(under_label),
		.pixel_in_char_x(pixel_in_char_x), // Pixel within the character (0-63)
		.pixel_in_char_y(pixel_in_char_y), 
		.char_idx(char_idx)
		//output reg [63:0]cur_char_data // Output character index
    );
    
    //assign true label
    reg [1:0]pred_label;
    //if use switch[4:3] inputfor true_label
    //wire [1:0] true_label;  
    //assign true_label = swt[4:3];
    reg [7:0] label;  // 8-bit label storage
    //label[4:3] = true_label;
    always @(posedge clk_25MHz) begin
        if (rst) begin
            stop_flag <= 0;
        end 
        else if (complete) begin
            stop_flag <= 1;  // Set stop flag when button is pressed
        end
    end

    // compare the number between 3 classes
    always @(posedge clk_25MHz) begin
        if(stop_flag)begin
            if (num_DF > num_PF && num_DF > num_HP) pred_label = 0;
            else if (num_DF < num_PF && num_PF > num_HP) pred_label = 1;
            else if (num_HP > num_PF && num_DF < num_HP) pred_label = 2;
            label = 8'b00000000;  // Initialize to 0
            label[4:3] = true_label;  // Store true_label in bits [4:3]
            label[2:1] = pred_label;  // Store pred_label in bits [2:1]
            label[0] = 0;  // Store 0 in bit [0]
            stop_flag = 1;
        end else begin
            label = 8'b00000000; 
            pred_label = 3;
            label[4:3] = true_label;  // Store true_label in bits [4:3]
            label[2:1] = pred_label;  // Store pred_label in bits [2:1]
            label[0] = 0;  // Store 0 in bit [0]
        end 
    
    end
    
    //get the char font.
    label_mode_buffer label_buffer(
		.clk(clk_25MHz),
		.rst(rst),
        .swt(label),
        .enable(enable),
		
		
		//input wire [2:0] text_scale, // Scaling factor (1 = 8x8, 2 = 16x16, ... up to 8x)

	   .under_label(under_label),
		.char_idx(char_idx),
		.cur_char_ASCII(cur_char_ASCII)
		//output reg [63:0]cur_char_data // Output character index
	);
	
	wire [15:0] cur_char_row; // 32 rows of 16-bit data each
	//get the current char display row
	text_mode_character_rom vga_rom(
		.clk(clk_25MHz),
		.rst(rst),
		.enable(enable),

		.cur_char_ASCII(cur_char_ASCII),
		.pixel_in_char_y(pixel_in_char_y),
		.cur_char_row(cur_char_row)
	);
	
/* auto counter	

    always @(posedge clk_25MHz) begin
        if (rst) begin
            clk_div <= 0;
            one_sec_pulse <= 0;
        end else if (clk_div == 25_000_000 - 1) begin
            clk_div <= 0;
            one_sec_pulse <= 1;  // Generate a 1-cycle pulse every second
        end else begin
            clk_div <= clk_div + 1;
            one_sec_pulse <= 0;
        end
    end

    // Counter logic, triggered by the 1-second pulse
    
        else if (!stop_flag && one_sec_pulse) begin  // Increment only when 1-second pulse is high
            case (state)
                2'b00: if (num_DF < 999) num_DF <= num_DF + 1;
                2'b01: if (num_PF < 999) num_PF <= num_PF + 1;
                2'b10: if (num_HP < 999) num_HP <= num_HP + 1;
            endcase
            state <= state + 1;  // Rotate between DF ? PF ? HP
        end
    end
*/

    // Instantiate draw_numbers module
    draw_numbers draw_inst (
        .clk(clk_25MHz),
        .rst(rst),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .num_DF(num_DF),
        .num_PF(num_PF),
        .num_HP(num_HP),
        .num_pixel_on(num_pixel_on)
    );

	
	wire [640-1:0] cur_circle_row;
	//draw the circle and lebel under circle
	draw_circle circle_display(
	.clk(clk_25MHz),
		.rst(rst),
		.enable(enable),

		.pixel_y(pixel_y),
		.cur_char_row(cur_circle_row)
            
    );
    
    wire cur_label_pixel = cur_char_row[15-pixel_in_char_x];
    wire cur_circle_pixel = cur_circle_row[640 - pixel_x];
    
     reg pixel_memory [0:307199]; // 1-bit per pixel, 640x480 = 307200 bits
    
    always @(posedge clk_25MHz) begin
        if (draw) begin  // Enable RGB assignment only when swt[0] is high
            if (/*swt[0]*/0) begin//display test
                // Display region - set color
                if (pixel_y < 160) begin
                    r <= 4'hF; g <= 4'h0; b <= 4'h0;  // Red
                end else if (pixel_y < 320) begin
                    r <= 4'h0; g <= 4'hF; b <= 4'h0;  // Green
                end else begin
                    r <= 4'h0; g <= 4'h0; b <= 4'hF;  // Blue
                end
            end else begin
                // When switch is off, set RGB to white
                if(cur_label_pixel) begin //label display
                    r <= 4'h0; g <= 4'h0; b <= 4'hF;//Blue
          
                end else if (cur_circle_pixel)begin //circle + under label display
                    r <= 4'hF; g <= 4'h0; b <= 4'h0;//Red
                end else if (num_pixel_on)begin //number display
                    r <= 4'h0; g <= 4'hF; b <= 4'h0;//Green
                end else begin 
                    r <= 4'hF; g <= 4'hF; b <= 4'hF; //wite background
   
                end
                
            end
        end else begin
            
            // Outside display region - set to black
            r <= 4'h0; g <= 4'h0; b <= 4'h0;
        end
    end
    
//    initial begin
//        $writememh("vga_output.mem", pixel_memory);
//    end

endmodule

