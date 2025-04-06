`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24 17:07:52
// Design Name: 
// Module Name: start_debouncer_v2
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


module start_debouncer_v2(
    input wire clk,
    input wire rst_n,
    input wire start_btn,        // �ߵ�ƽ������ť

    output reg start_pulse       // ���һ�� 1-cycle ����
);

    // �̶���ȴʱ�䣨@100MHz������ 1_000_000 = 10ms��
    parameter COOLDOWN_CYCLES = 32'd1_000_000;

    reg [31:0] cooldown;
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cooldown     <= 32'd0;
            busy         <= 1'b0;
            start_pulse  <= 1'b0;
        end else begin
            start_pulse <= 1'b0;  // Ĭ�ϲ����

            if (busy) begin
                if (cooldown != 32'd0)
                    cooldown <= cooldown - 1;
                else
                    busy <= 1'b0;  // ��ȴ����
            end else if (start_btn) begin
                start_pulse <= 1'b1;
                busy <= 1'b1;
                cooldown <= COOLDOWN_CYCLES;
            end
        end
    end

endmodule
