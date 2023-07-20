`include "defines.vh"
module PC (
    input wire [31:0]  npc,
    input wire         rst,
    input wire         clk,
    input wire         data_hazard,
    input wire 	       control_hazard,
    output reg  [31:0] pc
    );

    always @(posedge clk or negedge rst) begin
        if (rst == 1) begin
    `ifdef RUN_TRACE
            pc <= -8;
    `else
            pc <= 0;
    `endif
        end
        else if (control_hazard)
            pc <= npc;
        else if (data_hazard)
            pc <= pc;
        else
            pc <= npc;
    end
endmodule
