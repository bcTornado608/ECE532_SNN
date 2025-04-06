`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 05:53:31 PM
// Design Name: 
// Module Name: tb_PMOD_AD1_wrapper
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


module tb_PMOD_AD1_wrapper();

    reg  clk_100mhz;
    wire sclk;
    wire cs;
    reg  sdataA;
    reg  sdataB;
    reg  reset;
    
    //AXI master (memory interface)
    wire [31:0] M_AXI_AWADDR;
    wire        M_AXI_AWVALID;
    wire         M_AXI_AWREADY;
    
    wire [31:0] M_AXI_WDATA;
    wire [3:0]  M_AXI_WSTRB;
    wire        M_AXI_WVALID;
    wire         M_AXI_WREADY;
    
    wire [1:0]   M_AXI_BRESP;
    wire         M_AXI_BVALID;
    wire        M_AXI_BREADY;
    
    wire [31:0] Output_Addr;
    
    // Clock generation: 100 MHz
    initial clk_100mhz = 1'b0;
    always #(5) clk_100mhz = ~clk_100mhz;
    
    
    PMOD_AD1_Wrapper DUT(
        .clk_100MH(clk_100mhz),
        .resetn(reset),
        .ADC_input_A(sdataA),
        .ADC_input_B(sdataB),
        .CS(cs),
        .SCLK(sclk),
        
        .M_AXI_AWADDR(M_AXI_AWADDR),
        .M_AXI_AWVALID(M_AXI_AWVALID),
        .M_AXI_AWREADY(M_AXI_AWREADY),
        
        .M_AXI_WDATA(M_AXI_WDATA),
        .M_AXI_WSTRB(M_AXI_WSTRB),
        .M_AXI_WVALID(M_AXI_WVALID),
        .M_AXI_WREADY(M_AXI_WREADY),
        
        .M_AXI_BRESP(M_AXI_BRESP),
        .M_AXI_BVALID(M_AXI_BVALID),
        .M_AXI_BREADY(M_AXI_BREADY),
        
        .Output_Addr(Output_Addr)
        
    );
    
    

    // Simulated shift registers for each channel (16 bits: 4 zeros + 12 data)
    reg [15:0] shiftA = {4'b0000, 12'hABC}; // channel A
    reg [15:0] shiftB = {4'b0000, 12'h123}; // channel B

    // Load first bit when CS goes low
    always @(negedge cs) begin
        shiftA <= {shiftA[14:0], 1'b0};
        shiftB <= {shiftB[14:0], 1'b0};
        sdataA <= shiftA[15];
        sdataB <= shiftB[15];
    end

    // Shift data on SCLK falling edge while CS is low
    always @(negedge sclk) begin
        if (!cs) begin
            shiftA <= {shiftA[14:0], 1'b0};
            shiftB <= {shiftB[14:0], 1'b0};
            sdataA <= shiftA[15];
            sdataB <= shiftB[15];
        end else begin
            // If CS is high, drive high impedance
            sdataA <= 1'bZ;
            sdataB <= 1'bZ;
        end
    end

    initial begin
        // Initial conditions
        reset = 1'b0;
        sdataA = 1'bZ;
        sdataB = 1'bZ;

        // Release reset after a few cycles
        #(30);
        reset = 1'b1;

        // Let it run for a few samples
        #(200);

    end
    


endmodule
