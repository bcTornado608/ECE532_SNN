`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/16 16:21:10
// Design Name: 
// Module Name: clk_gen_v2
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

module clk_gen_v2(
    input wire clk,
    input wire resetn,
    input wire fc1_down, 
    input wire fc2_down, 
    input wire fc3_down, 
    output reg need_input_clk,
    output reg fc1_clk,
    output reg neuron1_clk,
    output reg fc2_clk,
    output reg neuron2_clk,
    output reg fc3_clk,
    output reg neuron3_clk,
    output reg cal_down
);

    // 状态定义
    localparam IDLE           = 4'b0000;
    localparam NEED_INPUT     = 4'b0001;
    localparam FC1_START      = 4'b0010;
    localparam WAIT_FC1       = 4'b0011;
    localparam NEURON1_START  = 4'b0100;
    localparam FC2_START      = 4'b0101;
    localparam WAIT_FC2       = 4'b0110;
    localparam NEURON2_START  = 4'b0111;
    localparam FC3_START      = 4'b1000;
    localparam WAIT_FC3       = 4'b1001;
    localparam NEURON3_START  = 4'b1010;
    localparam DONE           = 4'b1011;

    reg [3:0] state;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
            need_input_clk <= 1'b0;
            fc1_clk <= 1'b0;
            neuron1_clk <= 1'b0;
            fc2_clk <= 1'b0;
            neuron2_clk <= 1'b0;
            fc3_clk <= 1'b0;
            neuron3_clk <= 1'b0;
            cal_down <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    need_input_clk <= 1'b1;
                    state <= NEED_INPUT;
                end

                NEED_INPUT: begin
                    need_input_clk <= 1'b0;
                    fc1_clk <= 1'b1;
                    state <= FC1_START;
                end

                FC1_START: begin
                    state <= WAIT_FC1; // 等待 fc1_down
                end

                WAIT_FC1: begin
                    if (fc1_down) begin
                        fc1_clk <= 1'b0;
                        neuron1_clk <= 1'b1;
                        state <= NEURON1_START;
                    end
                end

                NEURON1_START: begin
                    neuron1_clk <= 1'b0;
                    fc2_clk <= 1'b1;
                    state <= FC2_START;
                end

                FC2_START: begin
                    state <= WAIT_FC2; // 等待 fc2_down
                end

                WAIT_FC2: begin
                    if (fc2_down) begin
                        fc2_clk <= 1'b0;
                        neuron2_clk <= 1'b1;
                        state <= NEURON2_START;
                    end
                end

                NEURON2_START: begin
                    neuron2_clk <= 1'b0;
                    fc3_clk <= 1'b1;
                    state <= FC3_START;
                end

                FC3_START: begin
                    state <= WAIT_FC3; // 等待 fc3_down
                end

                WAIT_FC3: begin
                    if (fc3_down) begin
                        fc3_clk <= 1'b0;
                        neuron3_clk <= 1'b1;
                        state <= NEURON3_START;
                    end
                end

                NEURON3_START: begin
                    neuron3_clk <= 1'b0;
                    cal_down <= 1'b1; // cycle 结束，保持 cal_down 为 1
                    state <= DONE;
                end

                DONE: begin
                    // 计算完成，保持 cal_down = 1
                end

            endcase
        end
    end    
    
endmodule

