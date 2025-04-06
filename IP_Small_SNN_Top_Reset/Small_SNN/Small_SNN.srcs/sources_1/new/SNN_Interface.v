`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 21:32:58
// Design Name: 
// Module Name: SNN_Interface
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


module SNN_Interface #(
    parameter INPUT_SIZE = 56,
    parameter DATA_WIDTH = 32,
    parameter MAX_CYCLES = 7'd100    // N = 100 cycles
)(
    input wire clk,                    // Clock input
    input wire reset_n,                // Active-low synchronous reset
    input wire start,                  // Start signal, connect to a button
    input wire done,                   // Done signal from SNN core
    (* MARK_DEBUG = "TRUE" *) output reg reset_all,              // Reset all signal
    (* MARK_DEBUG = "TRUE" *) output reg reset_clk,              // Clock reset signal
    (* MARK_DEBUG = "TRUE" *) output reg [6:0] n_count,          // Cycle counter (up to 100)
    (* MARK_DEBUG = "TRUE" *) output reg [6:0] class1_count,    // Class 1 spike counter
    (* MARK_DEBUG = "TRUE" *) output reg [6:0] class2_count,    // Class 2 spike counter
    (* MARK_DEBUG = "TRUE" *) output reg [6:0] class3_count,    // Class 3 spike counter
    input wire class1_spike,           // Spike detection for class 1
    input wire class2_spike,           // Spike detection for class 2
    input wire class3_spike,           // Spike detection for class 3
    output reg signed [INPUT_SIZE*DATA_WIDTH-1:0] data_out,        // 56 channels of 32-bit data
    output wire start_debug,
    
    // BRAM signals
    output reg [15:0] bram_addr,              // Address for 56 locations (0-55)
    (* MARK_DEBUG = "TRUE" *) input wire signed [DATA_WIDTH-1:0] bram_data_out      // 56 * 32 = 1792 bits
);

    assign start_debug = start;

    // State encoding
    localparam [2:0]
        IDLE       = 3'b000,
        RESET_ALL  = 3'b001,
        FETCH_DATA = 3'b010,
        RESET_CLK  = 3'b011,
        WAIT_DONE  = 3'b100;

    // State registers
    (* MARK_DEBUG = "TRUE" *) reg [2:0] current_state, next_state;


    // // Integrated BRAM 
    // data_blk_mem_gen Data_BRAM (
    //     .clka(clk),    // input wire clka
    //     .addra(bram_addr),  // input wire [15 : 0] addra
    //     .douta(bram_data_out)  // output wire [31 : 0] douta
    // );

    // State transition logic
    always @(posedge clk) begin
        if (!reset_n)                  // Active-low reset
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    reg fetch_data_done;
    
    // Next state and output logic
    always @(*) begin
        // Default outputs
        reset_all = 1'b0;
        reset_clk = 1'b0;
        
        case (current_state)
            IDLE: begin
                if (start) begin
                    next_state = RESET_ALL;
                end else begin
                    next_state = IDLE;
                end
            end
            
            RESET_ALL: begin
                reset_all = 1'b1;
                next_state = FETCH_DATA;
            end
            
            FETCH_DATA: begin
                // wait until read 56 data
                if (fetch_data_done) begin
                    next_state = RESET_CLK;
                end
                else begin
                    next_state = FETCH_DATA;
                end
            end
            
            RESET_CLK: begin
                reset_clk = 1'b1;
                next_state = WAIT_DONE;
            end
            
            WAIT_DONE: begin
                if (done) begin
                    if (n_count >= MAX_CYCLES - 1)
                        next_state = IDLE;
                    else
                        next_state = FETCH_DATA;
                end else begin
                    next_state = WAIT_DONE;
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    
    reg [6:0] BRAM_read_count;
    
    // Counter and BRAM logic
    always @(posedge clk) begin
        if (!reset_n) begin            // Active-low reset
            n_count <= 7'b0;
            class1_count <= 32'b0;
            class2_count <= 32'b0;
            class3_count <= 32'b0;
            bram_addr <= 6'b0;
            BRAM_read_count <= 7'b0;
        end
        else begin
            fetch_data_done = 0;
            case (current_state)
                IDLE: begin
                    n_count <= 7'b0;
                    BRAM_read_count <= 7'b0;
                end
                
                RESET_ALL: begin
                    class1_count <= 32'b0;
                    class2_count <= 32'b0;
                    class3_count <= 32'b0;
                end
                
                FETCH_DATA: begin
                    //read data from all 56 channels
                    if (BRAM_read_count < INPUT_SIZE) begin
                        if (BRAM_read_count > 0) begin
                            data_out[DATA_WIDTH*(BRAM_read_count-1) +: DATA_WIDTH] <= bram_data_out;
                        end
                        bram_addr <= bram_addr + 1;
                        BRAM_read_count <= BRAM_read_count + 1;
                    end
                    else begin
                        
                        fetch_data_done = 1;
                        if (BRAM_read_count == INPUT_SIZE) begin
                            data_out[DATA_WIDTH*(BRAM_read_count-1) +: DATA_WIDTH] <= bram_data_out;
                        end
                        
                        BRAM_read_count <= BRAM_read_count+1;
                    end
                end
                
                RESET_CLK: begin
                    BRAM_read_count <= 0;
                end
                
                WAIT_DONE: begin
                    if (done) begin
                        n_count <= n_count + 1;
                        // Count spikes for each class
                        if (class1_spike)
                            class1_count <= class1_count + 1;
                        if (class2_spike)
                            class2_count <= class2_count + 1;
                        if (class3_spike)
                            class3_count <= class3_count + 1;
                    end
                end
            endcase
        end
    end
endmodule
