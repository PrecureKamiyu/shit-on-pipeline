`include "defines.vh"
module EX_MEM(
    input wire        clk,
    input wire        rst,

    input wire [1:0]  EX_npc_op,
    input wire [1:0]  EX_rf_wsel,
    input wire        EX_rf_we,
    input wire        EX_dram_we,
    input wire [31:0] EX_rD1,
    input wire [31:0] EX_rD2,
    input wire [31:0] EX_ext,
    input wire [31:0] EX_pc4,
    input wire [31:0] EX_alu_c,
    input wire [31:0] EX_wR,

    output reg [1:0]  MEM_npc_op,
    output reg [1:0]  MEM_rf_wsel,
    output reg        MEM_rf_we,
    output reg        MEM_dram_we,
    output reg [31:0] MEM_rD1,
    output reg [31:0] MEM_rD2,
    output reg [31:0] MEM_ext,
    output reg [31:0] MEM_pc4,
    output reg [31:0] MEM_alu_c,
    output reg [31:0] MEM_wR
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_npc_op <= 0;
            MEM_rf_wsel <= 0;
            MEM_rf_we <= 0;
            MEM_dram_we <= 0;
            MEM_rD1 <= 0;
            MEM_rD2 <= 0;
            MEM_ext <= 0;
            MEM_pc4 <= 0;
            MEM_alu_c <= 0;
            MEM_wR <= 0;
        end
        else begin
            MEM_npc_op <=	 EX_npc_op;
            MEM_rf_wsel <=	 EX_rf_wsel;
            MEM_rf_we <=	 EX_rf_we;
            MEM_dram_we <=	 EX_dram_we;
            MEM_rD1 <=		 EX_rD1;
            MEM_rD2 <=		 EX_rD2;
            MEM_ext <=		 EX_ext;
            MEM_pc4 <=		 EX_pc4;
            MEM_alu_c <= 	 EX_alu_c;
            MEM_wR <= 	   	 EX_wR;
        end
    end

    endmodule