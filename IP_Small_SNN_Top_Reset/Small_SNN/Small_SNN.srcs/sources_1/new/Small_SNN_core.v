`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2025 03:40:47 PM
// Design Name: 
// Module Name: Small_SNN_core
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
//`define DEBUG

module Small_SNN_core #(
    parameter INPUT_SIZE = 56, //assume 1 channel input, Q8.24, signed
    parameter LAYER1_SIZE = 50, //number of neurons in each layer
    parameter LAYER2_SIZE = 20,
    parameter LAYER3_SIZE = 3,
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire resetn_all,
    input wire resetn_clk,
    input wire [DATA_WIDTH-1 : 0] Threshold,
    input wire [INPUT_SIZE*DATA_WIDTH-1 : 0] Input, 
    output wire [LAYER3_SIZE-1:0] SNN_out,
    output wire cal_done,
    output wire need_input_clk
    );
    
    wire fc1_done, fc2_done, fc3_done, fc1_enable, neuron1_enable, fc2_enable, neuron2_enable, fc3_enable, neuron3_enable;

    clk_gen_v2 u_clk_gen (
        .clk(clk),
        .resetn(resetn_clk),
        .fc1_down(fc1_done),
        .fc2_down(fc2_done),
        .fc3_down(fc3_done),
        .need_input_clk(need_input_clk),
        .fc1_clk(fc1_enable),
        .neuron1_clk(neuron1_enable),
        .fc2_clk(fc2_enable),
        .neuron2_clk(neuron2_enable),
        .fc3_clk(fc3_enable),
        .neuron3_clk(neuron3_enable),
        .cal_down(cal_done)
    );    

    
    //fc1
    wire [LAYER1_SIZE*DATA_WIDTH-1:0] fc1_out_vector;
    fc1_with_mul #( 
        .NUM_INPUTS(INPUT_SIZE), 
        .NUM_OUTPUTS(LAYER1_SIZE), 
        .DATA_WIDTH(DATA_WIDTH),
        .SCALE_FACTOR(24)
    ) fc1 (
        .clk(clk),
        .resetn(resetn_all),
        .enable(fc1_enable),         
        .in_vector(Input),
        .out_vector(fc1_out_vector),
        .done(fc1_done)              
    );

    
    // layer 1: 3 neurons
    wire [LAYER1_SIZE-1:0] layer1_out;
    genvar i;
    generate
        for (i = 0; i < LAYER1_SIZE; i = i + 1) begin : gen_block_layer1
            LIF_neuron neuron (
                .clk(neuron1_enable),
                .resetn(resetn_all),
                .Spike_in(fc1_out_vector[DATA_WIDTH*i +: DATA_WIDTH]),
                .Threshold(Threshold),
                .Spike_out(layer1_out[i])
            );
        end
    endgenerate
    
    //fc2
    wire [LAYER2_SIZE*DATA_WIDTH-1:0] fc2_out_vector;
    fc2_without_mul #( 
        .NUM_INPUTS(LAYER1_SIZE), 
        .NUM_OUTPUTS(LAYER2_SIZE), 
        .DATA_WIDTH(DATA_WIDTH) 
    ) fc2 (
        .clk(clk),
        .resetn(resetn_all),
        .enable(fc2_enable),          
        .in_vector(layer1_out),       
        .out_vector(fc2_out_vector),
        .done(fc2_done)               
    );  

    
    // layer 2: 2 neurons
    wire [LAYER2_SIZE-1:0] layer2_out;
    genvar j;
    generate
        for (j = 0; j < LAYER2_SIZE; j = j + 1) begin : gen_block_layer2
            LIF_neuron neuron (
                .clk(neuron2_enable),
                .resetn(resetn_all),
                .Spike_in(fc2_out_vector[DATA_WIDTH*j +: DATA_WIDTH]),
                .Threshold(Threshold),
                .Spike_out(layer2_out[j])
            );
        end
    endgenerate
    
    //fc3
    wire [LAYER3_SIZE*DATA_WIDTH-1:0] fc3_out_vector;
    fc3_without_mul #( 
        .NUM_INPUTS(LAYER2_SIZE), 
        .NUM_OUTPUTS(LAYER3_SIZE), 
        .DATA_WIDTH(DATA_WIDTH) 
    ) fc3 (
        .clk(clk),
        .resetn(resetn_all),
        .enable(fc3_enable),          
        .in_vector(layer2_out),       
        .out_vector(fc3_out_vector),
        .done(fc3_done)               
    );

    
    // layer 3: 1 neurons
    genvar k;
    generate
        for (k = 0; k < LAYER3_SIZE; k = k + 1) begin : gen_block_layer3
            LIF_neuron neuron (
                .clk(neuron3_enable),
                .resetn(resetn_all),
                .Spike_in(fc3_out_vector[DATA_WIDTH*k +: DATA_WIDTH]),
                .Threshold(Threshold),
                .Spike_out(SNN_out[k])
            );
        end
    endgenerate
    
endmodule
    
 
