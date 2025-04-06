`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 00:49:16
// Design Name: 
// Module Name: n_count_display_with_class
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


module n_count_display_with_class (
    input wire clk,
    input wire rst_n,
    input wire [6:0] n_count,                 // 要显示的计数值 (0~100)
    input wire [1:0] classification_result,   // 分类结果 (0~3)

    output reg [7:0] an,  // 8个数码管控制（active low）
    output reg [6:0] seg  // 七段编码（CA~CG, active low）
);

    // 分频计数器（用于刷新扫描）
    reg [15:0] clk_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 16'd0;
        else
            clk_div <= clk_div + 16'd1;
    end

    // 位选择：扫描哪个数码管（3 bits）
    wire [2:0] scan_sel;
    assign scan_sel = clk_div[15:13];

    // 拆分 n_count 为百、十、个位
    reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] ones;

    integer temp;
    always @(*) begin
        temp = n_count;
        hundreds = temp / 100;
        tens     = (temp % 100) / 10;
        ones     = temp % 10;
    end

    // 当前位要显示的数字
    reg [3:0] current_digit;
    always @(*) begin
        case (scan_sel)
            3'd0: current_digit = ones;
            3'd1: current_digit = tens;
            3'd2: current_digit = hundreds;
            3'd4: current_digit = classification_result;
            default: current_digit = 4'd15;  // 空白
        endcase
    end

    // 七段译码器（active low）
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111; // 全灭
        endcase
    end

    // 数码管使能位（active low）
    always @(*) begin
        an = 8'b11111111;  // 默认关闭全部
        case (scan_sel)
            3'd0: an[0] = 1'b0;  // AN0: 个位
            3'd1: an[1] = 1'b0;  // AN1: 十位
            3'd2: an[2] = 1'b0;  // AN2: 百位
            3'd4: an[4] = 1'b0;  // AN4: 分类结果
            default: an = 8'b11111111;
        endcase
    end

endmodule
