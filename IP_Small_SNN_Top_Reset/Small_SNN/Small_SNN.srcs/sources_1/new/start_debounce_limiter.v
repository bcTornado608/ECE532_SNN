`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 01:00:04
// Design Name: 
// Module Name: start_debounce_limiter
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

module start_debounce_limiter (
    input wire clk,
    input wire rst_n,
    input wire start_btn,
 
    output reg start_pulse
);
 
    reg [31:0] cooldown;
    reg [15:0] pulse_counter;      // Counter to extend pulse duration
    reg busy;
 
    reg prev_btn;
    wire rising_edge;
 
    assign rising_edge = (~prev_btn) & start_btn;
 
    parameter PULSE_WIDTH = 16'd10;     // Number of clock cycles for pulse (e.g., 50,000 for 1ms if 50MHz)
 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cooldown      <= 32'd0;
            pulse_counter <= 16'd0;
            busy          <= 1'b0;
            start_pulse   <= 1'b0;
            prev_btn      <= 1'b0;
        end else begin
            prev_btn <= start_btn;
 
            if (pulse_counter != 0) begin
                start_pulse <= 1'b1;
                pulse_counter <= pulse_counter - 1;
            end else begin
                start_pulse <= 1'b0;
            end
 
            if (busy) begin
                if (cooldown != 32'd0)
                    cooldown <= cooldown - 32'd1;
                else
                    busy <= 1'b0;
            end else begin
                if (rising_edge) begin
                    pulse_counter <= PULSE_WIDTH;  // Start pulse extension
                    busy <= 1'b1;
                    cooldown <= 32'd1_000_000;     // Debounce duration
                end
            end
        end
    end
 
endmodule



