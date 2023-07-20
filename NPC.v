`include "defines.vh"
module NPC (
    input wire [31:0] pc,
    input wire [31:0] offset,
    input wire [31:0] imm,
    input wire br,
    input wire [1:0] npc_op,
    output reg [31:0] pc4,
    output reg [31:0] npc
);

    always @(*) begin
        pc4 = pc + 32'd4;
    end
    // TODO
    // Note here
    always @(*) begin
        if (npc_op == `NPC_PC4) begin
            npc = pc + 32'd4;
        end else if (npc_op == `NPC_JAL) begin
            npc = pc + offset - 8;
        end else if (npc_op == `NPC_JALR) begin
            npc = imm;
        end else if (npc_op == `NPC_JMP) begin
            npc = br ? pc + offset - 8 : pc + 32'd4;
        end else begin
            npc = pc + 32'd4;
        end
    end
endmodule
