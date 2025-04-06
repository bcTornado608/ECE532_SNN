`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 12:49:54 AM
// Design Name: 
// Module Name: data_input_mux
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


module data_input_mux32(
        input data_validA,
        input data_validB,
        input [31:0] dataA,
        input [31:0] dataB,
        input muxsel,
        output [31:0] dataout,
        output data_validout
    );

    assign dataout = muxsel? dataA : dataB;
    assign data_validout = muxsel? data_validA : data_validB;
endmodule
