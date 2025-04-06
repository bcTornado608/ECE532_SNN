module out_addr_gen #(
    parameter integer BRAM_MAX_ADDR	= 32'h00002000
)(
    input TX_done,
    input resetn,
    output reg [31:0] Output_Addr
);

//generate output address
//Start from address 0, increment by 4 for each sample
//reset to 0 if 
always @(posedge TX_done or negedge resetn) begin
    if (resetn == 0) begin
        Output_Addr <= 32'h0000_0000;
    end
    else begin
        if (Output_Addr < BRAM_MAX_ADDR-1) begin
            Output_Addr <= Output_Addr + 4;
        end
        else begin
            Output_Addr <= 32'h0000_0000;
        end
    end
end

endmodule