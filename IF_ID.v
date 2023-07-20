`include "defines.vh"
module IF_ID(
    input wire        clk,
    input wire        rst,
    input wire [31:0] IF_inst,
    input wire [31:0] IF_pc4,

    output reg [31:0] ID_inst,
    output reg [31:0] ID_pc4
    );

    always @(posedge clk or posedge rst) begin
        if (rst) ID_inst <= 0;
        else ID_inst <= IF_inst;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) ID_pc4 <= 0;
        else ID_pc4 <= IF_pc4;
    end
endmodule