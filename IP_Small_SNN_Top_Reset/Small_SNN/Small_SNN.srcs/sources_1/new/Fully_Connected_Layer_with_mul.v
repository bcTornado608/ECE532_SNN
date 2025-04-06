`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:08:24 AM
// Design Name: 
// Module Name: Fully_Connected_Layer_with_mul
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

module Fully_Connected_Layer_with_mul #(
    parameter NUM_INPUTS  = 3,  // Change as needed
    parameter NUM_OUTPUTS = 4,  // Change as needed
    parameter DATA_WIDTH  = 32  // Q8.24 fixed-point: 32-bit signed
)(
    input  clk,
    input  resetn, 
    // Flattened input vector: concatenation of NUM_INPUTS numbers (each DATA_WIDTH bits)
    input  signed [NUM_INPUTS*DATA_WIDTH-1:0] in_vector,
    // Flattened weight matrix:
    //   Each output neuron has NUM_INPUTS weights.
    //   Total width = NUM_OUTPUTS*NUM_INPUTS*DATA_WIDTH
    input  signed [NUM_OUTPUTS*NUM_INPUTS*DATA_WIDTH-1:0] weight_matrix,
    // Flattened bias vector: one bias per output neuron
    input  signed [NUM_OUTPUTS*DATA_WIDTH-1:0] bias_vector,
    // Flattened output vector: concatenation of NUM_OUTPUTS numbers (each DATA_WIDTH bits)
    output reg signed [NUM_OUTPUTS*DATA_WIDTH-1:0] out_vector
);

  integer i, j;

  // Temporary variables for calculation.
  // Using a wider register (2*DATA_WIDTH) to accumulate products and sums.
  reg signed [DATA_WIDTH-1:0] in_val;
  reg signed [DATA_WIDTH-1:0] weight_val;
  reg signed [2*DATA_WIDTH-1:0] product;
  reg signed [2*DATA_WIDTH-1:0] sum;

  always @(posedge clk or negedge resetn) begin
    if (resetn == 1'b0) begin
      out_vector <= 0;
    end
    else begin
      // For each output neuron:
      for (j = 0; j < NUM_OUTPUTS; j = j + 1) begin
        // Extract bias for neuron j.
        // The slice operator [start -: width] extracts width bits starting at bit "start"
        sum = bias_vector[j*DATA_WIDTH + DATA_WIDTH-1 -: DATA_WIDTH];
        $display("------------------------------------------------");
        $display("  sum(bias)        = %f", $signed(sum[31:24]) + sum[23:0] * 2.0**(-24));   
        // Multiply each input by its corresponding weight and add to the sum.
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
          in_val     = in_vector[i*DATA_WIDTH + DATA_WIDTH-1 -: DATA_WIDTH];
              weight_val = weight_matrix[(j*NUM_INPUTS + i)*DATA_WIDTH + DATA_WIDTH-1 -: DATA_WIDTH];
          product = in_val * weight_val;
          // Since multiplying two Q8.24 numbers yields Q16.48,
          // arithmetic right shift by 24 bits to get back to Q8.24.
          sum = sum + (product >>> 24); 
          $display("fc1:");
          $display("Iteration (j=%0d, i=%0d):", j, i);
          $display("  in_val     = %f", $signed(in_val[31:24]) + in_val[23:0] * 2.0**(-24));
          $display("  weight_val = %f", $signed(weight_val[31:24]) + weight_val[23:0] * 2.0**(-24));
          $display("  product    = %f", $signed(product[55:48]) + product[47:24] * 2.0**(-24));
          $display("  sum        = %f", $signed(sum[31:24]) + sum[23:0] * 2.0**(-24));             
        end
        // Assign the computed sum to the appropriate slice of the output vector.
        out_vector[j*DATA_WIDTH + DATA_WIDTH-1 -: DATA_WIDTH] <= sum[DATA_WIDTH-1:0];
      end
    end
  end

endmodule
