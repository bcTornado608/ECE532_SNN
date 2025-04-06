`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:16:19 AM
// Design Name: 
// Module Name: Fully_Connected_Layer_without_mul
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
module Fully_Connected_Layer_without_mul #(
    parameter NUM_INPUTS  = 5,  // Number of binary inputs
    parameter NUM_OUTPUTS = 2,  // Number of output neurons
    parameter DATA_WIDTH  = 32  // Q8.24 fixed-point (32-bit signed)
)(
    input clk,
    input resetn,
    // Binary input vector: each bit is either 1 or 0
    input [NUM_INPUTS-1:0] in_vector,
    // Flattened weight matrix:
    //   Each output neuron has NUM_INPUTS weights.
    //   Total width = NUM_OUTPUTS * NUM_INPUTS * DATA_WIDTH
    input signed [NUM_OUTPUTS*NUM_INPUTS*DATA_WIDTH-1:0] weight_matrix,
    // Flattened bias vector: one bias per output neuron (Q8.24)
    input signed [NUM_OUTPUTS*DATA_WIDTH-1:0] bias_vector,
    // Flattened output vector: one Q8.24 number per output neuron
    output reg signed [NUM_OUTPUTS*DATA_WIDTH-1:0] out_vector
);

  // Loop variables
  integer i, j;
  // Accumulator with enough width to prevent overflow
  reg signed [2*DATA_WIDTH-1:0] sum;
  // Temporary variables for weight and bias extraction
  reg signed [DATA_WIDTH-1:0] current_weight;
  reg signed [DATA_WIDTH-1:0] current_bias;

  // Main sequential block
  always @(posedge clk or negedge resetn) begin
    if (resetn == 1'b0) begin
      out_vector <= 0;
    end else begin
      // For each output neuron:
      for (j = 0; j < NUM_OUTPUTS; j = j + 1) begin
        // Extract the bias for the j-th output neuron.
        current_bias = bias_vector[j*DATA_WIDTH +: DATA_WIDTH];
        sum = current_bias;  // Initialize sum with bias
        $display("------------------------------------------------");
        $display("  sum(bias)        = %f", $signed(sum[31:24]) + sum[23:0] * 2.0**(-24));           
        // For each binary input:
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
          // If the input bit is 1, add the corresponding weight.
          if (in_vector[i]) begin
            current_weight = weight_matrix[(j*NUM_INPUTS + i)*DATA_WIDTH +: DATA_WIDTH];
            sum = sum + current_weight;
            $display("  sum        = %f", $signed(sum[31:24]) + sum[23:0] * 2.0**(-24));  
          end
        end
        
        // Assign the lower DATA_WIDTH bits of the sum to the output.
        out_vector[j*DATA_WIDTH +: DATA_WIDTH] <= sum[DATA_WIDTH-1:0];
      end
    end
  end

endmodule
