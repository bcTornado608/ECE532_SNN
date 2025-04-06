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
    input wire btn_raw,     // ԭʼ��ť��active low��
    output reg rst_n_clean  // ȥ����ĸ�λ�źţ�active low��
);

    // ����λ�Ĵ����ж��Ƿ��ȶ�
    reg [15:0] filter_reg;

    always @(posedge clk) begin
        filter_reg <= {filter_reg[14:0], btn_raw};  // ÿ�����ڲ���һλ

        // ��������������ȫΪ 0�������Ϊ 0����ť���£�
        // ��������������ȫΪ 1�������Ϊ 1����ť�ɿ���
        if (filter_reg == 16'h0000)
            rst_n_clean <= 1'b0;
        else if (filter_reg == 16'hFFFF)
            rst_n_clean <= 1'b1;
        // ����������ֵ�ǰ״̬�����䣩
    end

endmodule

