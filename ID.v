`timescale 1ns / 1ps
`include "defines.vh"

module ID(
    input wire         clk,
    // data part
    input wire [31:0]  din,
    input wire [31:0]  npc_pc4,
    input wire [31:0]  WB_ext,
    // input
    input wire [31:0]  dram_rdo,
    input wire [31:0]  alu_c,
    // control part
    input wire [1:0]   rf_wsel,
    input wire         rf_we,
    input wire [2:0]   sext_op,
    // output part
    output wire [31:0] rD1,
    output wire [31:0] rD2,
    output wire [31:0] ext,
    // rf_wD is only for debug
    output wire [31:0] rf_wD,
    input wire [4:0]   wR
    );


    SEXT ID_SEXT (
        .din(din),
        .op(sext_op),
        .ext(ext)
    );

    wire [31:0] sext_ext;
    assign sext_ext = WB_ext;
    reg [31:0] wD;
    always @(*) begin
        case (rf_wsel)
        `RF_WSEL_ALU: wD = alu_c;
        `RF_WSEL_PC4: wD = npc_pc4;
        `RF_WSEL_EXT: wD = sext_ext;
        `RF_WSEL_RDO: wD = dram_rdo;
        default: wD = 0;
        endcase
    end
    // for rf_wD
    assign rf_wD = wD;

    RF ID_RF (
        .clk(clk),
        .rR1(din[19:15]),
        .rR2(din[24:20]),
        .wR(wR),
        .wD(wD),
        .we(rf_we),

        .rD1(rD1),
        .rD2(rD2)
    );
endmodule
