`timescale 1ns / 1ps
`include "defines.vh"

module IF(
    input wire clk,
    input wire rst,
    input wire [31:0] offset,
    input wire br,
    input wire [1:0] npc_op,
    output wire [31:0] pc4
    );
    
    wire [31:0] pc;
    wire [31:0] npc;
    
    NPC IF_NPC (
        .pc(pc),
        .offset(offset),
        .br(br),
        .op(npc_op),
        .npc(npc),
        .pc4(pc4)
    );
    
    PC IF_PC (
        .clk(clk),
        .rst(rst),
        .npc(npc),
        .pc(pc)
    );
endmodule
