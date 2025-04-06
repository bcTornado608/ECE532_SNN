`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/01 13:24:20
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
    input wire clk,
    input wire resetn,
    output wire fc1_clk,
    output wire neuron1_clk,
    output wire fc2_clk,
    output wire neuron2_clk,
    output wire fc3_clk,
    output wire neuron3_clk
    );
    
    reg [3:0] counter;
    reg fc1_enable, neuron1_enable, fc2_enable, neuron2_enable, fc3_enable, neuron3_enable;
    
    assign fc1_clk = fc1_enable;
    assign neuron1_clk = neuron1_enable;
    assign fc2_clk = fc2_enable;
    assign neuron2_clk = neuron2_enable;
    assign fc3_clk = fc3_enable;
    assign neuron3_clk = neuron3_enable;    
    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 4'b0000;
            fc1_enable <= 1'b0;
            neuron1_enable <= 1'b0;
            fc2_enable <= 1'b0;
            neuron2_enable <= 1'b0;
            fc3_enable <= 1'b0;
            neuron3_enable <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 4'b0001) fc1_enable <= 1'b1;
            if (counter == 4'b0010) fc1_enable <= 1'b0;
            if (counter == 4'b0011) neuron1_enable <= 1'b1;
            if (counter == 4'b0100) neuron1_enable <= 1'b0;
            if (counter == 4'b0101) fc2_enable <= 1'b1;
            if (counter == 4'b0110) fc2_enable <= 1'b0;            
            if (counter == 4'b0111) neuron2_enable <= 1'b1;
            if (counter == 4'b1000) neuron2_enable <= 1'b0;
            if (counter == 4'b1001) fc3_enable <= 1'b1;
            if (counter == 4'b1010) fc3_enable <= 1'b0;            
            if (counter == 4'b1011) neuron3_enable <= 1'b1;
            if (counter == 4'b1100) begin
                neuron3_enable <= 1'b0;
                counter <= 4'b0000;
            end
                        
        end
    end    
    
endmodule
