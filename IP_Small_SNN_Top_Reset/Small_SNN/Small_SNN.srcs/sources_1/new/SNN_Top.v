`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 21:45:37
// Design Name: 
// Module Name: SNN_Top
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


module SNN_Top #(
    parameter INPUT_SIZE = 56,
    parameter LAYER1_SIZE = 50,
    parameter LAYER2_SIZE = 20,
    parameter LAYER3_SIZE = 3,
    parameter DATA_WIDTH = 32,
    parameter MAX_CYCLES = 7'd100
    )( 
    input wire clk,
    input wire rst_n,     
    input wire start,     
    
    output wire [6:0] n_count,
    output wire [6:0] class1_count,
    output wire [6:0] class2_count,
    output wire [6:0] class3_count,    
    
    output reg [1:0] classification_result,   // 1: class1, 2: class2, 3: class3, 0: tie
    output wire start_debug,
    (* MARK_DEBUG = "TRUE" *) output reg complete,
    
    // BRAM signals
    output wire [15:0] bram_addr,              // Address for 56 locations (0-55)
    (* MARK_DEBUG = "TRUE" *) input wire signed [DATA_WIDTH-1:0] bram_data_out      // 56 * 32 = 1792 bits
);

    localparam [DATA_WIDTH-1:0] Threshold = 32'b00000001000000000000000000000000;
    

    (* MARK_DEBUG = "TRUE" *) wire reset_all;
    (* MARK_DEBUG = "TRUE" *) wire reset_clk;
    wire [INPUT_SIZE*DATA_WIDTH-1:0] data_out;

    wire [LAYER3_SIZE-1:0] SNN_out;
    (* MARK_DEBUG = "TRUE" *) wire cal_done;

    // SNN spike detection
    (* MARK_DEBUG = "TRUE" *) wire class1_spike = SNN_out[0];
    (* MARK_DEBUG = "TRUE" *) wire class2_spike = SNN_out[1];
    (* MARK_DEBUG = "TRUE" *) wire class3_spike = SNN_out[2];

    //SNN_Interface
    SNN_Interface #(
        .INPUT_SIZE(INPUT_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_CYCLES(MAX_CYCLES)
    ) interface (
        .clk(clk),
        .reset_n(rst_n),
        .start(start),
        .done(cal_done),
        .reset_all(reset_all),
        .reset_clk(reset_clk),
        .n_count(n_count),
        .class1_count(class1_count),
        .class2_count(class2_count),
        .class3_count(class3_count),
        .class1_spike(class1_spike),
        .class2_spike(class2_spike),
        .class3_spike(class3_spike),
        .data_out(data_out),
        .start_debug(start_debug),
        .bram_addr(bram_addr),
        .bram_data_out(bram_data_out)
    );

    // Small_SNN_core
    Small_SNN_core #(
        .INPUT_SIZE(INPUT_SIZE),
        .LAYER1_SIZE(LAYER1_SIZE),
        .LAYER2_SIZE(LAYER2_SIZE),
        .LAYER3_SIZE(LAYER3_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) snn_core (
        .clk(clk),
        .resetn_all(~reset_all),
        .resetn_clk(~reset_clk),
        .Threshold(Threshold),
        .Input(data_out),
        .SNN_out(SNN_out),
        .cal_done(cal_done),
        .need_input_clk()
    ); 
    

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            classification_result <= 2'd0;
        end else begin
            if (class1_count > class2_count && class1_count > class3_count)
                classification_result <= 2'd1;
            else if (class2_count > class1_count && class2_count > class3_count)
                classification_result <= 2'd2;
            else if (class3_count > class1_count && class3_count > class2_count)
                classification_result <= 2'd3;
            else
                classification_result <= 2'd0; 
        end
    end    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            complete <= 1'b0;
        end 
        else begin
            if (n_count == MAX_CYCLES-1) begin
                complete <= 1'b1;
            end
            else begin
                complete <= 1'b0;
            end
        end
    end
endmodule
