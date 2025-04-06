`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24 01:09:25
// Design Name: 
// Module Name: tb_Top
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


module tb_Top(

    );
    
    // DUT inputs
    reg clk;
    reg rst_n_btn;
    reg start_btn;

    // DUT outputs
    wire [1:0] classification_result;
    wire [7:0] an;
    wire [6:0] seg;

    wire rst_n_btn_out;
    wire rst_n_out;
    wire start_btn_out;
    wire start_out;

    // Instantiate the DUT
    Top uut (
        .clk_100M(clk),
        .rst_n_btn(rst_n_btn),
        .start_btn(start_btn),

        .classification_result(classification_result),
        .an(an),
        .seg(seg),

        .rst_n_btn_out(rst_n_btn_out),
        .rst_n_out(rst_n_out),
        .start_btn_out(start_btn_out),
        .start_out(start_out)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("=== Starting Top Testbench ===");

        // Initial values
        rst_n_btn = 0;
        start_btn = 0;

        // Reset for 100ns
        #100;
        rst_n_btn = 1;
        #5000;
        rst_n_btn = 0;
        $display("[%t] Deassert reset", $time);

        // Wait a little
        #200;

        // Simulate start_btn press (active-high)
        $display("[%t] Simulate start press 1", $time);
        start_btn = 1;
        #20000;     // 按住 20ns
        start_btn = 0;
        #20_000_000; // wait 10ms
        
        #100;
        rst_n_btn = 1;
        #500;
        rst_n_btn = 0;
        
        #200 
        
        start_btn = 1;
        #20000;     // 按住 20ns
        start_btn = 0;
        #20_000_000; // wait 10ms
        
//        $display("[%t] Simulate start press 2", $time);
//        start_btn = 1;
//        #30000;
//        start_btn = 0;
//        #1_000_000_000;

//        $display("[%t] Simulate start press 3", $time);
//        start_btn = 1;
//        #25000;
//        start_btn = 0;
//        #1_000_000_000;

//        $display("[%t] Simulate start press 4", $time);
//        start_btn = 1;
//        #25000;
//        start_btn = 0;
//        #1_000_000_000;
        
//        $display("[%t] Simulate start press 5", $time);
//        start_btn = 1;
//        #25000;
//        start_btn = 0;
//        #1_000_000_000; 
        
        
//        rst_n_btn = 1;
//        #20000;
//        rst_n_btn = 0;      
//        $display("[%t] Deassert reset", $time); 

//        // Wait a little
//        #20000;

//        // Simulate start_btn press (active-high)
//        $display("[%t] Simulate start press 6", $time);
//        start_btn = 1;
//        #20000;     // 按住 20ns
//        start_btn = 0;
//        #1_000_000_000; // wait 10ms
        
//        $display("[%t] Simulate start press 7", $time);
//        start_btn = 1;
//        #30000;
//        start_btn = 0;
//        #1_000_000_000;        
        
//        // Finish simulation
//        #10000;
//        $display("=== Simulation Finished at %t ===", $time);
//        $stop;
    end    
    
endmodule
