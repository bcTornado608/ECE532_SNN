`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 12:08:25 AM
// Design Name: 
// Module Name: LIF_neuron
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


module LIF_neuron(
    input wire resetn,
    input wire clk,
    input wire signed  [31:0] Spike_in, //1 bit integer, either 1 or 0
    input wire signed  [31:0] Threshold, //Q16.16, MSB for sign
    //input wire [32:0] weight, //Q15.16
    output wire Spike_out
    );
    
    reg signed [31:0] mem_potential;
    //reg signed [31:0] mem_potential_last;
    //reg signed [31:0] beta = 32'h0000F800;
    wire fire;
    assign fire = mem_potential > Threshold;
    assign Spike_out = fire;
    
    //intermediate variable that stores mem_potential after fire, fire could be 0 or 1
    wire signed [31:0] mem_after_fire;
    assign mem_after_fire = mem_potential - (fire ? Threshold : 32'b0);
    
    //wire signed [63:0] mem_after_fire_afer_decay = mem_after_fire*beta;
    
    
    always @(posedge clk or negedge resetn) begin
        if (resetn == 1'b0) begin
            //update mem_potential: decay by 31/32 + weighter input
            mem_potential <= 0;
        end
        else begin
            //update mem_potential: decay by 31/32 + weighter input, use Arithmetic shift (>>> or <<<) to for signed numbers
            //mem_potential_last <= mem_potential;
            mem_potential <= mem_after_fire - ( mem_after_fire>>>5 ) + Spike_in;
//            mem_potential <= mem_after_fire_afer_decay[16+:32] + Spike_in;
        end
    end
    
endmodule
