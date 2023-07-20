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
    assign debug_wb_have_inst = (WB_pc4 == 32'b0) ? 0 : 1; //if pc4 == 0,it must be nop
    assign debug_wb_pc        = (debug_wb_have_inst) ? (WB_pc4 - 4) : 32'b0;
    assign debug_wb_ena       = (debug_wb_have_inst && WB_rf_we) ? 1'b1 : 1'b0;
    assign debug_wb_reg       = (debug_wb_ena) ? WB_wR : 5'b0;
    assign debug_wb_value     = (debug_wb_ena) ? wD : 32'b0;
`endif



    // note the pipeline register is interleaved between other normal parts
    // all the register variable will be declared here
    // this time
    wire [31:0]         ID_inst;
    wire [31:0]         ID_pc4;
    wire [1:0]          EX_npc_op;
    wire [1:0]          EX_rf_wsel;
    wire                EX_rf_we;
    wire [2:0]          EX_sext_op;
    wire [3:0]          EX_alu_op;
    wire                EX_b_sel;
    wire [2:0]          EX_br_op;
    wire                EX_dram_we;
    wire [31:0]         EX_rD1;
    wire [31:0]         EX_rD2;
    wire [31:0]         EX_ext;
    wire [31:0]         EX_pc4;
    wire [31:0]         EX_alu_c;
    wire [4:0]          EX_wR;
    wire [1:0]          MEM_npc_op;
    wire [1:0]          MEM_rf_wsel;
    wire                MEM_rf_we;
    //wire [2:0]          MEM_sext_op;
    //wire [3:0]          MEM_alu_op;
    //wire                MEM_b_sel;
    //wire [2:0]          MEM_br_op;
    wire                MEM_dram_we;
    wire [31:0]         MEM_rD1;
    wire [31:0]         MEM_rD2;
    wire [31:0]         MEM_ext;
    wire [31:0]         MEM_pc4;
    wire [31:0]         MEM_alu_c;
    wire [4:0]          MEM_wR;
    wire [31:0]         WB_ext;
    wire [31:0]         WB_pc4;
    wire [31:0]         WB_alu_c;
    wire [4:0]          WB_wR;
    wire [31:0]         WB_rdo;
    wire [1:0]          WB_rf_wsel;
    wire                WB_rf_we;
    wire                WB_dram_we;
    // IROM part
    assign inst_addr = pc[15:2] ;

    wire [31:0]         rd;

    wire [31:0]         npc_pc4;
    wire [31:0]         npc;

    NPC myNPC (
        .pc(pc),
        .offset(EX_ext),
        .imm(alu_c),
        .br(f),
        .npc_op(EX_npc_op),
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

    IF_ID myIF_ID (
        .clk(cpu_clk),
        .rst(cpu_rst),
        .IF_inst(inst),
        .IF_pc4(npc_pc4),
        .ID_inst(ID_inst),
        .ID_pc4(ID_pc4)
        );

    wire [31:0]         rD1;
    wire [31:0]         rD2;
    wire [31:0]         sext_ext;
    wire [31:0]         wD;

    ID myID (
        .clk(cpu_clk),
        .din(ID_inst),
        .WB_ext(WB_ext),
        .npc_pc4(WB_pc4),
        .dram_rdo(WB_rdo),
        .alu_c(WB_alu_c),
        .rf_wsel(WB_rf_wsel),
        .rf_we(WB_rf_we),
        .sext_op(sext_op),
        .wR(WB_wR),
        // output
        .rD1(rD1),
        .rD2(rD2),
        .ext(sext_ext),

        .rf_wD(wD)
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
        .inst(ID_inst),
        .npc_op(npc_op),
        .rf_wsel(rf_wsel),
        .rf_we(rf_we),
        .sext_op(sext_op),
        .alu_op(alu_op),
        .b_sel(b_sel),
        .br_op(br_op),
        .dram_we(dram_we)
        );

    ID_EX myID_EX (
        .clk(cpu_clk),
        .rst(cpu_rst),
        .ID_npc_op(npc_op),
        .ID_rf_wsel(rf_wsel),
        .ID_rf_we(rf_we),
        .ID_sext_op(sext_op),
        .ID_alu_op(alu_op),
        .ID_b_sel(b_sel),
        .ID_dram_we(dram_we),
        .ID_rD1(rD1),
        .ID_rD2(rD2),
        .ID_ext(sext_ext),
        .ID_pc4(ID_pc4),
        .ID_wR(ID_inst[11:7]),
        .EX_npc_op(EX_npc_op),
        .EX_rf_wsel(EX_rf_wsel),
        .EX_rf_we(EX_rf_we),
        .EX_sext_op(EX_sext_op),
        .EX_alu_op(EX_alu_op),
        .EX_b_sel(EX_b_sel),
        .EX_br_op(EX_br_op),
        .EX_dram_we(EX_dram_we),
        .EX_rD1(EX_rD1),
        .EX_rD2(EX_rD2),
        .EX_ext(EX_ext),
        .EX_pc4(EX_pc4)
        );

    wire [31:0]         alu_c;
    wire                f;

    EX myEX (
        .b_sel(EX_b_sel),
        .alu_op(EX_alu_op),
        .br_op(EX_br_op),
        .A(EX_rD1),
        .sext_ext(EX_ext),
        .rf_rD2(EX_rD2),
        .C(alu_c),
        .f(f)
        );

    EX_MEM myEX_MEM (
        .clk(cpu_clk),
        .rst(cpu_rst),
        .EX_npc_op(EX_npc_op),
        .EX_rf_we(EX_rf_we),
        .EX_rf_wsel(EX_rf_wsel),
        .EX_dram_we(dram_we),
        .EX_rD1(rD1),
        .EX_rD2(rD2),
        .EX_ext(EX_ext),
        .EX_pc4(EX_pc4),
        .EX_alu_c(EX_alu_c),
        .EX_wR(EX_wR),
        .MEM_npc_op(MEM_npc_op),
        .MEM_rf_wsel(MEM_rf_wsel),
        .MEM_rf_we(MEM_rf_we),
        .MEM_dram_we(MEM_dram_we),
        .MEM_rD1(MEM_rD1),
        .MEM_rD2(MEM_rD2),
        .MEM_ext(MEM_ext),
        .MEM_pc4(MEM_pc4),
        .MEM_alu_c(MEM_alu_c),
        .MEM_wR(MEM_wR)
        );

    // DRAM part here
    assign Bus_addr = MEM_alu_c;
    assign rd = Bus_rdata;
    assign Bus_wen = MEM_dram_we;
    assign Bus_wdata = MEM_rD2;

    MEM_WB myMEM_WB (
        .clk(cpu_clk),
        .rst(cpu_rst),
        .MEM_pc4(MEM_pc4),
        .MEM_alu_c(MEM_alu_c),
        .MEM_wR(MEM_wR),
        .MEM_rdo(rd),
        .MEM_rf_wsel(MEM_rf_wsel),
        .MEM_rf_we(MEM_rf_we),
        .MEM_dram_we(MEM_dram_we),
        .WB_pc4(WB_pc4),
        .WB_alu_c(WB_alu_c),
        .WB_wR(WB_wR),
        .WB_rdo(WB_rdo),
        .WB_rf_wsel(WB_rf_wsel),
        .WB_rf_we(WB_rf_we),
        .WB_dram_we(WB_dram_we)
        );

endmodule