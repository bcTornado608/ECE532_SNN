`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 01:12:22
// Design Name: 
// Module Name: fixedpoint_converter
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


package fixedpoint_converter;
    function real convert_fixedpoint(input [31:0] data_in);
        integer i;
        reg signed [7:0] int_part;
        reg [23:0] frac_part;
        real frac_value;

        begin
            // 提取整数部分
            int_part = data_in[31:24];
            if (data_in[31] == 1) begin
                int_part = -((~data_in[31:24] + 1) & 8'hFF);
            end

            // 提取小数部分
            frac_part = data_in[23:0];
            frac_value = 0.0;

            for (i = 0; i < 24; i = i + 1) begin
                if (frac_part[i]) begin
                    frac_value = frac_value + (1.0 / (1 << (i + 1)));
                end
            end

            // 返回值赋给 function 名称
            convert_fixedpoint = int_part + frac_value;
        end
    endfunction
endpackage
