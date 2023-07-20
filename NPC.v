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

    // pc4 is very simple here
    always @(*) begin
        pc4 = pc + 32'd4;
    end
    // npc
    // TODO
    always @(*) begin
        if (npc_op == `NPC_PC4) begin
            npc = pc + 32'd4;
        end else if (npc_op == `NPC_JAL) begin
            npc = pc + offset;
        end else if (npc_op == `NPC_JALR) begin
            npc = imm;
        end else if (npc_op == `NPC_JMP) begin
            npc = br ? pc + offset : pc + 32'd4;
        end else begin
            npc = pc + 32'd4;
        end
    end
endmodule
