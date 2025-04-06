`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:24:27 AM
// Design Name: 
// Module Name: PackData
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


module PackData #(
    parameter NUM   = 4,  // Number of signals to pack
    parameter WIDTH = 8   // Bit width of each signal
)(
    input [WIDTH-1:0] data [0:NUM-1],
    output [NUM*WIDTH-1:0] packed_data
);

    genvar i;
    generate
        // Loop through each signal to pack it into the appropriate slice
        for (i = 0; i < NUM; i = i+1) begin : pack_loop
            // The slice notation "[(NUM-i)*WIDTH-1 -: WIDTH]" selects WIDTH bits.
            assign packed_data[(NUM-i)*WIDTH-1 -: WIDTH] = data[i];
        end
    endgenerate

endmodule