`include "defines.vh"
module ID_EX(
    input wire        clk,
    input wire        rst,

    input wire [4:0]  ID_wR,
    input wire [1:0]  ID_npc_op,
    input wire [1:0]  ID_rf_wsel,
    input wire        ID_rf_we,
    input wire [2:0]  ID_sext_op,
    input wire [3:0]  ID_alu_op,
    input wire        ID_b_sel,
    input wire [2:0]  ID_br_op,
    input wire        ID_dram_we,

    input wire [31:0] ID_rD1,
    input wire [31:0] ID_rD2,
    input wire [31:0] ID_ext,
    input wire [31:0] ID_pc4,

    output reg [4:0]  EX_wR,
    output reg [1:0]  EX_npc_op,
    output reg [1:0]  EX_rf_wsel,
    output reg        EX_rf_we,
    output reg [2:0]  EX_sext_op,
    output reg [3:0]  EX_alu_op,
    output reg        EX_b_sel,
    output reg [2:0]  EX_br_op,
    output reg        EX_dram_we,
    output reg [31:0] EX_rD1,
    output reg [31:0] EX_rD2,
    output reg [31:0] EX_ext,
    output reg [31:0] EX_pc4
    );

    always @(posedge clk or posedge rst) begin
        if (rst) EX_npc_op <= 0;
        else EX_npc_op <= ID_npc_op;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_rf_wsel <= 0;
        else EX_rf_wsel <= ID_rf_wsel;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_rf_we <= 0;
        else EX_rf_we <= ID_rf_we;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_sext_op <= 0;
        else EX_sext_op <= ID_sext_op;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_alu_op <= 0;
        else EX_alu_op <= ID_alu_op;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_b_sel <= 0;
        else EX_b_sel <= ID_b_sel;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_br_op <= 0;
        else EX_br_op <= ID_br_op;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_dram_we <= 0;
        else EX_dram_we <= ID_dram_we;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_rD1 <= 0;
        else EX_rD1 <= ID_rD1;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_rD2 <= 0;
        else EX_rD2 <= ID_rD2;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_ext <= 0;
        else EX_ext <= ID_ext;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_pc4 <= 0;
        else EX_pc4 <= ID_pc4;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) EX_wR <= 0;
        else EX_wR <= ID_wR;
    end
endmodule