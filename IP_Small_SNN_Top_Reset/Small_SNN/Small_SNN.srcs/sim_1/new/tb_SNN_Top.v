`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 22:55:56
// Design Name: 
// Module Name: tb_SNN_Top
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


module tb_SNN_Top;

    // Parameters
    parameter INPUT_SIZE   = 56;
    parameter LAYER1_SIZE  = 50;
    parameter LAYER2_SIZE  = 20;
    parameter LAYER3_SIZE  = 3;
    parameter DATA_WIDTH   = 32;
    parameter MAX_CYCLES   = 7'd100;

    // Signals
    reg clk;
    reg rst_n;
    reg start;

    wire [6:0] n_count;
    wire [6:0] class1_count;
    wire [6:0] class2_count;
    wire [6:0] class3_count;
    wire [1:0] classification_result;

    // Instantiate DUT (Design Under Test)
    SNN_Top #(
        .INPUT_SIZE(INPUT_SIZE),
        .LAYER1_SIZE(LAYER1_SIZE),
        .LAYER2_SIZE(LAYER2_SIZE),
        .LAYER3_SIZE(LAYER3_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_CYCLES(MAX_CYCLES)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .n_count(n_count),
        .class1_count(class1_count),
        .class2_count(class2_count),
        .class3_count(class3_count),
        .classification_result(classification_result)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to pulse the start signal for 1 clock cycle
    task pulse_start;
    begin
        start = 1;
        @(posedge clk);
        start = 0;
    end
    endtask

    // Main test sequence
    initial begin
        $display("Starting SNN top-level testbench...");

        // Initialize signals
        rst_n = 0;
        start = 0;

        // Apply reset
        #100;
        rst_n = 1;

        // Run 5 start cycles, each spaced by 20000ns
        repeat (2) begin
            pulse_start();
            #20000000;
            $display("At time %t ns: n_count=%d, class1=%d, class2=%d, class3=%d, classification_result=%d",
                     $time, n_count, class1_count, class2_count, class3_count, classification_result);
        end
        
        #100;
        rst_n = 0;
        #100;
        rst_n = 1;
        
        // Run 5 start cycles, each spaced by 20000ns
        repeat (5) begin
            pulse_start();
            #20000000;
            $display("At time %t ns: n_count=%d, class1=%d, class2=%d, class3=%d, classification_result=%d",
                     $time, n_count, class1_count, class2_count, class3_count, classification_result);
        end
        
        // Finish simulation
        #1000;
        $display("Test completed at time %t ns", $time);
        $stop;
    end

endmodule