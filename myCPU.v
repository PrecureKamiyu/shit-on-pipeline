`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

`ifdef RUN_TRACE
    // Debug Interface
    // dont know what is for
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc        = (debug_wb_have_inst) ? pc : 32'b0;
    assign debug_wb_ena       = (debug_wb_have_inst && rf_we) ? 1'b1 : 1'b0;
    assign debug_wb_reg       = (debug_wb_ena) ? inst[11:7] : 5'b0;
    assign debug_wb_value     = (debug_wb_ena) ? wD : 32'b0;
`endif



    // pipeline part
    // note: this doesn't mean other parts will not be changed
    // IROM part
    assign inst_addr = pc[15:2];

    wire [31:0]         rd;
    // DRAM part here
    assign Bus_addr = alu_c;
    assign rd = Bus_rdata;
    assign Bus_wen = dram_we;
    assign Bus_wdata = rD2;

    wire [31:0]         npc_pc4;
    wire [31:0]         npc;

    NPC myNPC (
        .pc(pc),
        .offset(sext_ext),
        .imm(alu_c),
        .br(f),
        .npc_op(npc_op),
        .pc4(npc_pc4),
        .npc(npc)
        );

    wire [31:0]         pc;
    PC myPC (
        .npc(npc),
        .pc(pc),
        .clk(cpu_clk),
        .rst(cpu_rst)
        );


    wire [31:0]         rD1;
    wire [31:0]         rD2;
    wire [31:0]         sext_ext;
    wire [31:0]         wD;

    ID myID (
        .clk(cpu_clk),
        .din(inst),
        .npc_pc4(npc_pc4),
        .dram_rdo(rd),
        .alu_c(alu_c),
        .rf_wsel(rf_wsel),
        .rf_we(rf_we),
        .sext_op(sext_op),
        .rD1(rD1),
        .rD2(rD2),
        .ext(sext_ext),
        .rf_wD(wD)
        );

    wire [31:0]         alu_c;
    wire                f;

    EX myEX (
        .b_sel(b_sel),
        .alu_op(alu_op),
        .br_op(br_op),
        .A(rD1),
        .sext_ext(sext_ext),
        .rf_rD2(rD2),
        .C(alu_c),
        .f(f)
        );

    wire [1:0]          npc_op;

    wire [1:0]          rf_wsel;
    wire                rf_we;
    wire [2:0]          sext_op;

    wire [3:0]          alu_op;
    wire                b_sel;
    wire [2:0]          br_op;

    wire                dram_we;

    CONTROLLER myCON(
        .inst(inst),
        .npc_op(npc_op),
        .rf_wsel(rf_wsel),
        .rf_we(rf_we),
        .sext_op(sext_op),
        .alu_op(alu_op),
        .b_sel(b_sel),
        .br_op(br_op),
        .dram_we(dram_we)
        );

endmodule