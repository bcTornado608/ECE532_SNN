`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/16 16:31:19
// Design Name: 
// Module Name: clk_gen_tb
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


module clk_gen_tb;

    // 信号声明
    reg clk;
    reg resetn;
    reg fc1_down;
    reg fc2_down;
    reg fc3_down;
    
    wire need_input_clk;
    wire fc1_clk;
    wire neuron1_clk;
    wire fc2_clk;
    wire neuron2_clk;
    wire fc3_clk;
    wire neuron3_clk;
    wire cal_down;

    // 实例化待测模块
    clk_gen_v2 uut (
        .clk(clk),
        .resetn(resetn),
        .fc1_down(fc1_down),
        .fc2_down(fc2_down),
        .fc3_down(fc3_down),
        .need_input_clk(need_input_clk),
        .fc1_clk(fc1_clk),
        .neuron1_clk(neuron1_clk),
        .fc2_clk(fc2_clk),
        .neuron2_clk(neuron2_clk),
        .fc3_clk(fc3_clk),
        .neuron3_clk(neuron3_clk),
        .cal_down(cal_down)
    );

    // 生成时钟信号
    always #5 clk = ~clk;  // 100MHz 时钟（周期 10ns）

    initial begin
        // 初始化信号
        clk = 0;
        resetn = 0;
        fc1_down = 0;
        fc2_down = 0;
        fc3_down = 0;
        
        // 释放复位
        #20 resetn = 1;
        
        // 模拟 `fc1_down` 信号，延迟 30ns 触发
        #30 fc1_down = 1;
        #10 fc1_down = 0;
        
        // 模拟 `fc2_down` 信号，延迟 40ns 触发
        #40 fc2_down = 1;
        #10 fc2_down = 0;
        
        // 模拟 `fc3_down` 信号，延迟 50ns 触发
        #50 fc3_down = 1;
        #10 fc3_down = 0;
        
        // 等待 `cal_down` 变高，验证计算结束
        #100;
        
        $finish;
    end

    // 监视信号变化
    initial begin
        $monitor("Time=%0t | need_input=%b | fc1_clk=%b | neuron1_clk=%b | fc2_clk=%b | neuron2_clk=%b | fc3_clk=%b | neuron3_clk=%b | cal_down=%b",
                  $time, need_input_clk, fc1_clk, neuron1_clk, fc2_clk, neuron2_clk, fc3_clk, neuron3_clk, cal_down);
    end

endmodule
