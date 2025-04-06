`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2025 05:16:19 AM
// Design Name: 
// Module Name: Fully_Connected_Layer_without_mul
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
module fc2_without_mul #(
    parameter NUM_INPUTS  = 2,  
    parameter NUM_OUTPUTS = 2,  
    parameter DATA_WIDTH  = 32,
    parameter SCALE_FACTOR = 24  // Fixed-point scaling factor
)(
    input  clk,
    input  resetn,
    input  enable,                                // Added enable signal
    input  signed [NUM_INPUTS-1:0] in_vector,
    output reg signed [NUM_OUTPUTS*DATA_WIDTH-1:0] out_vector,
    output reg done                               // Added done signal
);


    // BRAM for Weights
    wire Weight_CLK = clk;
    reg [9:0] Weight_ADDR;
    wire signed [DATA_WIDTH-1:0] Weight_DOUT;
    
    fc2_weight_mem_gen fc2_weight_BRAM (
        .clka(Weight_CLK),   
        .addra(Weight_ADDR),  
        .douta(Weight_DOUT)  
    );
    
    // BRAM for Bias
    wire Bias_CLK = clk;
    reg [5:0] Bias_ADDR;
    wire signed [DATA_WIDTH-1:0] Bias_DOUT;
    
    fc2_bias_mem_gen fc2_bias_BRAM (
        .clka(Bias_CLK),    
        .addra(Bias_ADDR),  
        .douta(Bias_DOUT)  
    );
    
    // State machine states
    localparam IDLE = 0,
               FETCH = 1,
               MULTIPLY = 2,
               ACCUMULATE = 3,
               ADD_BIAS = 4,
               OUTPUT = 5,
               UPDATE_IJ = 6;
               
    //Generate a pulse to initiate calculation.
	//only generate a one cycle pulse
	//will detect enable rising edge
    reg enable_1;
	reg enable_2;
	wire enable_pulse = (!enable_2) && enable_1;
	always @(posedge clk)										      
	  begin                                                                        
	    // Initiates AXI transaction delay    
	    if (resetn == 0 )                                                   
	      begin                                                                    
	        enable_1 <= 1'b0;                                                   
	        enable_2 <= 1'b0;                                                   
	      end                                                                               
	    else                                                                       
	      begin  
	        enable_1 <= enable;
	        enable_2 <= enable_1;                                                                 
	      end                                                                      
	  end   

    // Internal registers
    reg [2:0] state;
    reg in_val;
    reg signed [2*DATA_WIDTH-1:0] product;
    reg signed [DATA_WIDTH-1:0] sum_accum;
    reg signed [DATA_WIDTH-1:0] sum_bias;
    reg [5:0] i; //input neuron index
    reg [5:0] j; //output neuron index
    
    //control signals
    reg accum_clear;
    
    reg FETCH_COUNT;
    
    // Main control FSM
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
            Weight_ADDR <= 0;
            Bias_ADDR <= 0;
            in_val <= 0;
            i <= 0;
            j <= 0;
            done <= 0;
            accum_clear <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    i <= 0;
                    j <= 0;  
                    Weight_ADDR <= 0;
                    Bias_ADDR <= 0;
                    done <= 0;
                    FETCH_COUNT <= 0;

                    if (enable_pulse) begin
                        state <= FETCH;
                    end
                end
                
                FETCH: begin
                    //set BRAM ADDR to fetch weights and Bias
                    Weight_ADDR <= j*NUM_INPUTS + i;
                    Bias_ADDR <= j;
                    in_val <= in_vector[i];
                    
                    
                    if (FETCH_COUNT==1) state <= MULTIPLY;
                    FETCH_COUNT <= FETCH_COUNT + 1;
                end
                
                MULTIPLY: begin
                    state <= ACCUMULATE;
                end
                
                ACCUMULATE: begin
                    //only go to ADD_BIAS after going through all inputs
                    // otherwise, go directly to UPDATE_IJ
                    if (i < NUM_INPUTS-1) begin
                        state <= UPDATE_IJ;
                    end
                    else begin
                        state <= ADD_BIAS;
                    end
                    
                end
                
                ADD_BIAS: begin
                        state <= OUTPUT;
                end
                
                OUTPUT: begin
                    //update output_vector
                    out_vector[j*DATA_WIDTH +: DATA_WIDTH] <= sum_bias[DATA_WIDTH-1:0];
                    
                    //reset accumulation
                    accum_clear <= 1;
                    
                    state <= UPDATE_IJ;
                end
                
                UPDATE_IJ: begin
                    accum_clear <= 0;
                    if (i < NUM_INPUTS-1) begin
                        //this output neuron not done, increment i to the next input neuron
                        i <= i+1;
                        state <= FETCH;
                    end
                    else begin
                        if (j < NUM_OUTPUTS-1) begin
                            // this output neuron is done, increment j to the next output neuron
                            i <= 0;
                            j <= j+1;
                            state <= FETCH;
                        end
                        else begin
                            //all output neurons done, all computation done
                            i <= 0;
                            j <= 0;
                            done <= 1;
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end
    
    //Multiplier
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            product <= 0;
        end
        else begin
            //product <= Weight_DOUT;
            if (in_val == 1) begin
                product <= Weight_DOUT;
            end
            else begin
                product <= 0;
            end
        end
    end
    
    //Accumulator
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            sum_accum <= 0;
        end
        else begin
            if (accum_clear) sum_accum <= 0;
            else if (state == ACCUMULATE) begin
                sum_accum <= sum_accum + product;
            end
            else begin
                sum_accum <= sum_accum;
            end
        end
    end
    
    
    //ADD BIAS
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            sum_bias <= 0;
        end
        else begin
            sum_bias = sum_accum + Bias_DOUT;
        end
    end
    

endmodule


