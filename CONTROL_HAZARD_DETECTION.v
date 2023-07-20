`include "defines.vh"
module CONTROL_HAZARD_DETECTION(
    input wire [1:0] EX_npc_op,
    input wire       f,
    output reg       control_hazard
    );

    always @(*) begin
        if(EX_npc_op == `NPC_JALR || EX_npc_op == `NPC_JAL)
            control_hazard = 1'b1;
        else if(EX_npc_op == `NPC_JMP && f == 1)
            control_hazard = 1'b1;
        else control_hazard = 1'b0;
    end

endmodule