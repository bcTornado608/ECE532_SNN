`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 00:30:28
// Design Name: 
// Module Name: Top
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


module Top (
    input wire clk_100M,
    input wire rst_n_btn,
    input wire start_btn,  

    output wire [1:0] classification_result,
    output wire [7:0] an,                 
    output wire [6:0] seg,                     
    
    output wire rst_n_btn_out,
    output wire rst_n_out,
    output wire start_btn_out,
    output wire start_out,
    output wire start_debug,    
    
    output wire hsync,      // VGA 
    output wire vsync,      // VGA 
    output wire [3:0] r,    // red
    output wire [3:0] g,    // green
    output wire [3:0] b,     // blue    

    // BRAM signals
    output wire [15:0] bram_addr,              // Address for 56 locations (0-55)
    input wire signed [31:0] bram_data_out,      // 56 * 32 = 1792 bits
    output wire clk_divided
);
    
    clk_divider #(
        .DIVIDE_COUNT(25)
    ) clk_divider (
        .clk(clk_100M),
        .clk_out(clk_divided)
    );

    wire [6:0] n_count;

    wire rst_n = !rst_n_btn;
//    reset_debouncer rst_debounce (
//        .clk(clk),
//        .btn_raw(rst_n_btn),
//        .rst_n_clean(rst_n)
//    );


    wire start;
    start_debounce_limiter start_limiter (
        .clk(clk_divided),
        .rst_n(rst_n),
        .start_btn(start_btn),
        .start_pulse(start)
    );
    
    wire [6:0] class1_count;
    wire [6:0] class2_count;
    wire [6:0] class3_count;
    wire complete;
    

    SNN_Top #(
        .INPUT_SIZE(56),
        .LAYER1_SIZE(50),
        .LAYER2_SIZE(20),
        .LAYER3_SIZE(3),
        .DATA_WIDTH(32),
        .MAX_CYCLES(7'd100)
    ) snn_top_inst (
        .clk(clk_divided),
        .rst_n(rst_n),
        .start(start),
        .n_count(n_count),              
        .class1_count(class1_count),
        .class2_count(class2_count),
        .class3_count(class3_count),
        .classification_result(classification_result),
        .start_debug(start_debug),
        .complete(complete),
        .bram_addr(bram_addr),
        .bram_data_out(bram_data_out)
    );

//  
    n_count_display_with_class display_inst (
        .clk(clk_100M),
        .rst_n(rst_n),
        .n_count(n_count),
        .classification_result(classification_result),
        .an(an),
        .seg(seg)
    );
    
    wire [1:0] true_label;
    
    assign true_label = classification_result - 2'd1;
    
//    true_label_generator true_label_gen (
//        .clk(clk_100M),                 // ����ʹ�÷�Ƶ��� clk
//        .rst_n(rst_n),
//        .start_pulse(start),              // ÿ�ΰ� start
//        .classification_result(classification_result),
//        .true_label(true_label)           // ����� label
//    );

    
    top_vga top_vga (
        .clk_100MHz(clk_100M),     // ���룺100MHz FPGA ϵͳʱ��
        .rst(rst_n_btn),                   // ���룺��λ�źţ��ߵ�ƽ��Ч
        .true_label(true_label),    // ���룺��ʵ��ǩ������ swt[4:3] �����

        .complete(complete),         // ���룺Ԥ����ɱ�־
    
        .num_DF(class1_count),             // ���룺dorsiflexion ������0~999��
        .num_PF(class2_count),             // ���룺plantarflexion ������0~999��
        .num_HP(class3_count),             // ���룺heel priking ������0~999��
    
        .hsync(hsync),               // VGA ˮƽͬ��
        .vsync(vsync),               // VGA ��ֱͬ��
        .r(r),                       // ��ɫͨ����4λ��
        .g(g),                       // ��ɫͨ����4λ��
        .b(b)                        // ��ɫͨ����4λ��
    );    
    
    
    
//    ila_0 your_instance_name (
//        .clk(clk_100M), // input wire clk
//        .probe0(complete), // input wire [0:0]  probe0  
//        .probe1(class1_count), // input wire [0:0]  probe1 
//	    .probe2(class2_count), // input wire [0:0]  probe1
//	    .probe3(class3_count),
//	    .probe4(start_debug)
//    ); 
    
    
    assign rst_n_btn_out = rst_n_btn;
    assign rst_n_out     = rst_n;
    assign start_btn_out = start_btn;
    assign start_out     = start;           

endmodule
