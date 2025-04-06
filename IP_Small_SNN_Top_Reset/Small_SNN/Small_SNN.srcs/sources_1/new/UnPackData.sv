`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:30:23 AM
// Design Name: 
// Module Name: UnPackData
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


module UnPackData #(
    parameter NUM   = 4,  // Number of signals to extract
    parameter WIDTH = 8   // Bit width of each signal
)(
    input  [NUM*WIDTH-1:0] packed_data,
    output [0:NUM-1][WIDTH-1:0] data 
);

    genvar i;
    generate
        // Loop through each slice to unpack it into an individual signal
        for (i = 0; i < NUM; i = i + 1) begin : unpack_loop
            assign data[i] = packed_data[(NUM-i)*WIDTH-1 -: WIDTH];
        end
    endgenerate

endmodule