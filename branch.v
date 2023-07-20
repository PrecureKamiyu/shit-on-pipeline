`timescale 1ns / 1ps
`include "defines.vh"

module branch(
    input wire [2:0] op,
    input wire [31:0] C,
    output reg f
);

always @(*) begin
    case (op)
        `BR_NO: f = 1'b0;
        `BR_EQ: f = (C == 32'b0);
        `BR_NE: f = (C != 32'b0);
        `BR_GE: f = (C[31] == 1'b0);
        `BR_LT: f = (C[31] == 1'b1);
        `BR_GO: f = 1'b1;
        default:        f = 1'b0;
    endcase
end

endmodule
