`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 20:54:43
// Design Name: 
// Module Name: reset_debouncer
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


module reset_debouncer (
    input wire clk,
    input wire btn_raw,     // 原始按钮（active low）
    output reg rst_n_clean  // 去抖后的复位信号（active low）
);

    // 用移位寄存器判断是否稳定
    reg [15:0] filter_reg;

    always @(posedge clk) begin
        filter_reg <= {filter_reg[14:0], btn_raw};  // 每个周期采样一位

        // 如果连续采样结果全为 0，则输出为 0（按钮按下）
        // 如果连续采样结果全为 1，则输出为 1（按钮松开）
        if (filter_reg == 16'h0000)
            rst_n_clean <= 1'b0;
        else if (filter_reg == 16'hFFFF)
            rst_n_clean <= 1'b1;
        // 其他情况保持当前状态（不变）
    end

endmodule

