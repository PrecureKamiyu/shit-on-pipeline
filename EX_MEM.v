`include "defines.vh"
module EX_MEM(
    input wire        clk,
    input wire        rst,

    input wire [1:0]  EX_npc_op,
    input wire [1:0]  EX_rf_wsel,
    input wire        EX_rf_we,
    input wire [2:0]  EX_sext_op,
    input wire [3:0]  EX_alu_op,
    input wire        EX_b_sel,
    input wire [2:0]  EX_br_op,
    input wire        EX_dram_we,
    input wire [31:0] EX_rD1,
    input wire [31:0] EX_rD2,
    input wire [31:0] EX_ext,
    input wire [31:0] EX_pc4,

    output reg [1:0]  MEM_npc_op,
    output reg [1:0]  MEM_rf_wsel,
    output reg        MEM_rf_we,
    output reg [2:0]  MEM_sext_op,
    output reg [3:0]  MEM_alu_op,
    output reg        MEM_b_sel,
    output reg [2:0]  MEM_br_op,
    output reg        MEM_dram_we,

    output reg [31:0] MEM_rD1,
    output reg [31:0] MEM_rD2,
    output reg [31:0] MEM_ext,
    output reg [31:0] MEM_pc4
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_npc_op <= 0;
            MEM_rf_wsel <= 0;
            MEM_rf_we <= 0;
            MEM_sext_op <= 0;
            MEM_alu_op <= 0;
            MEM_b_sel <= 0;
            MEM_br_op <= 0;
            MEM_dram_we <= 0;
            MEM_rD1 <= 0;
            MEM_rD2 <= 0;
            MEM_ext <= 0;
            MEM_pc <= 0;
        end
        else begin
            MEM_npc_op <=	 EX_npc_op;
            MEM_rf_wsel <=	 EX_rf_wsel;
            MEM_rf_we <=	 EX_rf_we;
            MEM_sext_op <=	 EX_sext_op;
            MEM_alu_op <=	 EX_alu_op;
            MEM_b_sel <=	 EX_b_sel;
            MEM_br_op <=	 EX_br_op;
            MEM_dram_we <=	 EX_dram_we;
            MEM_rD1 <=		 EX_rD1;
            MEM_rD2 <=		 EX_rD2;
            MEM_ext <=		 EX_ext;
            MEM_pc <=		 EX_pc4;
        end
    end

    endmodule