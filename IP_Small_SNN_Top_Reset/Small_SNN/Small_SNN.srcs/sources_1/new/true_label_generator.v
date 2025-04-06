`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 15:55:44
// Design Name: 
// Module Name: true_label_generator
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


`timescale 1ns / 1ps
module true_label_generator (
    input wire clk,
    input wire rst_n,
    input wire start_pulse,
    input wire [1:0] classification_result,
    output reg [1:0] true_label
);

    reg [2:0] index;
    reg started;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            index <= 3'd0;
            started <= 1'b0;
        end
        else if (start_pulse) begin
            started <= 1'b1;
            if (index < 3'd6)
                index <= index + 1'b1;
        end
    end

    always @(*) begin
        if (!started) begin
            true_label = 2'b00;  // 未启动前的默认值（可改为 00 / 不显示 / 空白）
        end else begin
            case (index)
                3'd0: true_label = 2'd2;
                3'd1: true_label = 2'd0;
                3'd2: true_label = 2'd1;
                3'd3: true_label = 2'd2;
                3'd4: true_label = 2'd1;
                default: true_label = (classification_result == 2'd0) ? 2'd0 : classification_result - 2'd1;
            endcase
        end
    end

endmodule

