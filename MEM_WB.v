`include "defines.vh"
module MEM_WB (
    input wire        clk,
    input wire        rst,

    input wire [31:0] MEM_pc4,
    input wire [31:0] MEM_alu_c,
    input wire [4:0]  MEM_wR,
    input wire [31:0] MEM_rdo,
    input wire [1:0]  MEM_rf_wsel,
    input wire        MEM_rf_we,
    input wire        MEM_dram_we,
    output reg [31:0] WB_pc4,
    output reg [31:0] WB_alu_c,
    output reg [4:0]  WB_wR,
    output reg [31:0] WB_rdo,
    output reg [1:0]  WB_rf_wsel,
    output reg        WB_rf_we,
    output reg        WB_dram_we,
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_pc4    <= 0;
            WB_alu_c  <= 0;
            WB_wR     <= 0;
            WB_rdo    <= 0;
            WB_rf_wsel<= 0;
            WB_rf_we  <= 0;
            WB_dram_we<= 0;
        end
        else begin
            WB_pc4    <= MEM_pc4;
            WB_alu_c  <= MEM_alu_c;
            WB_wR     <= MEM_wR;
            WB_rdo    <= MEM_rdo;
            WB_rf_wsel<= MEM_rf_wsel;
            WB_rf_we  <= MEM_rf_we;
            WB_dram_we<= MEM_dram_we;
        end
    end
    endmodule