`include "defines.vh"
module PC (
    input wire [31:0]  npc,
    input wire         rst,
    input wire         clk,
    input wire data_hazard,
    output wire [31:0] pc
    );
    reg [31:0]         curr_adr;

    always @(posedge clk or negedge rst) begin
        if (rst == 1) begin
    `ifdef RUN_TRACE
            curr_adr <= -8;
    `else
            curr_adr <= 0;
    `endif
        else if (data_hazard) begin
            pc <= pc;
        end
        end else
            curr_adr <= npc;
    end
    assign pc = curr_adr;
endmodule
