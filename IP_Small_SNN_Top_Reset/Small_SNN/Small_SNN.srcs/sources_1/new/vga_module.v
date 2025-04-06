`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 04:45:14
// Design Name: 
// Module Name: vga_module
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


module vga_module(
    input wire clk_100MHz,  // 100MHz 时钟
    input wire rst,         // 复位信号
    output reg hsync,       // 水平同步信号
    output reg vsync,       // 垂直同步信号
    output reg [3:0] r,     // 红色信号
    output reg [3:0] g,     // 绿色信号
    output reg [3:0] b,      // 蓝色信号
    output wire draw,
    //output reg [11:0] rgb,
    output wire [9:0] pixel_x,
    output wire [9:0] pixel_y,
    output wire clk_25MHz

);
      // 25MHz 时钟

    // 实例化时钟分频模块
    clock_divider_4 clk_div (
        .clk_in(clk_100MHz),
        .clk_out(clk_25MHz)
    );

    // VGA 640x480 时序参数
    localparam H_VISIBLE = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_PULSE = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_TOTAL = 800;

    localparam V_VISIBLE = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC_PULSE = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_TOTAL = 525;

    reg [9:0] h_count = 0;  // 水平计数器
    reg [9:0] v_count = 0;  // 垂直计数器

    always @(posedge clk_25MHz or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            // 水平扫描
            if (h_count < H_TOTAL - 1) begin
                h_count <= h_count + 1;
            end else begin
                h_count <= 0;
                // 垂直扫描
                if (v_count < V_TOTAL - 1) begin
                    v_count <= v_count + 1;
                end else begin
                    v_count <= 0;
                end
            end
        end
    end

    // 生成同步信号
    always @(posedge clk_25MHz) begin
        hsync <= (h_count >= (H_VISIBLE + H_FRONT_PORCH)) && (h_count < (H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE)) ? 0 : 1;
        vsync <= (v_count >= (V_VISIBLE + V_FRONT_PORCH)) && (v_count < (V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE)) ? 0 : 1;
    end

    assign draw = h_count < H_VISIBLE && v_count < V_VISIBLE;
    assign pixel_x    =  h_count; 
    assign pixel_y    =  v_count;
    
    // 生成颜色信号
//    always @(posedge clk_25MHz) begin
//        if (h_count < H_VISIBLE && v_count < V_VISIBLE) begin
//            // 显示区，设定颜色
//            if (v_count < 160) begin
//                r <= 4'hF; g <= 4'h0; b <= 4'h0;  // 红色
//            end else if (v_count < 320) begin
//                r <= 4'h0; g <= 4'hF; b <= 4'h0;  // 绿色
//            end else begin
//                r <= 4'h0; g <= 4'h0; b <= 4'hF;  // 蓝色
//            end
//        end else begin
//            // 非显示区，颜色设为黑色
//            r <= 4'h0; g <= 4'h0; b <= 4'h0;
//        end
//    end

endmodule
