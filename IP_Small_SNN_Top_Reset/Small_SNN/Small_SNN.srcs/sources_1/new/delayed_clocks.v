module delayed_clocks (
    input wire clk,
    input wire resetn,
    output wire clk1,
    output wire clk2,
    output wire clk3
);

    reg [1:0] counter;
    reg enable2, enable3;
    
    assign clk1 = clk & resetn;
    assign clk2 = clk & enable2;
    assign clk3 = clk & enable3;    
    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 2'b00;
            enable2 <= 1'b0;
            enable3 <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b01) enable2 <= 1'b1;
            if (counter == 2'b10) enable3 <= 1'b1;          
        end
    end

endmodule