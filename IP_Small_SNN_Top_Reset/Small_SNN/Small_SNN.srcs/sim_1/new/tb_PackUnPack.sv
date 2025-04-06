`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:33:58 AM
// Design Name: 
// Module Name: tb_PackUnPack
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


module tb_PackUnPack(

    );
    // Parameters matching the modules
    parameter NUM   = 4;
    parameter WIDTH = 8;
    
    // Declare the multi-dimensional signals (SystemVerilog style)
    logic [0:NUM-1][WIDTH-1:0] data;           // Original individual signals
    logic [NUM*WIDTH-1:0]        packed_data;   // Wide vector from PackData
    logic [0:NUM-1][WIDTH-1:0]   unpacked_data; // Output of UnPackData

    // Instantiate the PackData module.
    PackData #(
        .NUM(NUM),
        .WIDTH(WIDTH)
    ) pack_inst (
        .data(data),
        .packed_data(packed_data)
    );
    
    // Instantiate the UnPackData module.
    UnPackData #(
        .NUM(NUM),
        .WIDTH(WIDTH)
    ) unpack_inst (
        .packed_data(packed_data),
        .data(unpacked_data)
    );
    
    // Testbench stimulus
    initial begin
        // Apply initial values to the 'data' array
        data[0] = 8'hAA;  // 10101010
        data[1] = 8'h55;  // 01010101
        data[2] = 8'hFF;  // 11111111
        data[3] = 8'h00;  // 00000000

        #10; // Wait for assignments to propagate
        
        // Display the original data, the packed data, and the unpacked data.
        $display("Time: %0t", $time);
        for (int i = 0; i < NUM; i++) begin
            $display("data[%0d]         = %h", i, data[i]);
        end
        $display("packed_data   = %h", packed_data);
        for (int i = 0; i < NUM; i++) begin
            $display("unpacked_data[%0d] = %h", i, unpacked_data[i]);
        end
        
        #10;
        $finish;
    end

    
endmodule
