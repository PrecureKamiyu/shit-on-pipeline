`include "defines.vh"
module RF (
    input wire clk,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire [31:0] wD,
    input wire we,
    
    output wire [31:0] rD1,
    output wire [31:0] rD2
);
    reg [31:0] array [31:0];
    
    assign rD1 = (rR1 == 5'b0)? 32'b0 : array[rR1];
	assign rD2 = (rR2 == 5'b0)? 32'b0 : array[rR2];
    
    always @(posedge clk) begin
        if(we && (wR != 5'b0)) 
            array [wR] <= wD;
    end
endmodule
