`timescale 1ns / 1ps
`include "defines.vh"
module CONTROLLER
#(
    localparam OP_R    = 7'b0110011,
    localparam OP_I    = 7'b0010011,
    localparam OP_LOAD = 7'b0000011,
    localparam OP_S    = 7'b0100011,
    localparam OP_B    = 7'b1100011,
    localparam OP_LUI  = 7'b0110111,
    localparam OP_JAL  = 7'b1101111,
    localparam OP_JALR = 7'b1100111
    )
(
    input wire [31:0] inst,
    
    // IF
    output reg [1:0] npc_op,
    
    // ID
    output reg [1:0] rf_wsel,
    output reg rf_we,
    output reg [2:0] sext_op,
    
    // EX ALU, branch
    output reg [3:0] alu_op,
    output reg b_sel,
    output reg [2:0] br_op,
    
    // dram
    output reg dram_we
    );
    
    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];
    
    // npc_op
    always @(*) begin
      case (opcode)
        OP_R, OP_I, OP_LOAD, OP_LUI, OP_S:
                 npc_op = `NPC_PC4;
        OP_JALR: npc_op = `NPC_JALR;
        OP_JAL:  npc_op = `NPC_JAL;
        OP_B:    npc_op = `NPC_JMP;
        default: npc_op = `NPC_PC4;
      endcase
    end
    
    // rf_wsel
    always @(*) begin
        case (opcode)
            OP_LOAD: rf_wsel = `RF_WSEL_RDO;
            OP_LUI : rf_wsel = `RF_WSEL_EXT;
            OP_JAL : rf_wsel = `RF_WSEL_PC4;
            OP_JALR: rf_wsel = `RF_WSEL_PC4;
            
            OP_R, OP_I: rf_wsel = `RF_WSEL_ALU;
            default: rf_wsel = `RF_WSEL_ALU;
        endcase
    end
    
    // rf_we
    always @(*) begin
        case (opcode)
            OP_B, OP_S: rf_we = 0;
            default:    rf_we = 1;
        endcase
    end
    
    // sext_op
    always @(*) begin
        case(opcode)
            OP_I:
              case(funct3)
                3'b001, 3'b101: sext_op = `SEXT_MOVE;
                default: sext_op = `SEXT_I;
              endcase
            OP_LOAD, OP_JALR: sext_op = `SEXT_I;
            OP_LUI: sext_op = `SEXT_U;
            OP_JAL: sext_op = `SEXT_J;
            OP_B  : sext_op = `SEXT_B;
            OP_S  : sext_op = `SEXT_S;
            OP_R  : sext_op = `SEXT_R;
            default:sext_op = `SEXT_R;
        endcase
    end
    
    // alub_sel
    always @(*) begin
        case (opcode)
            OP_I, OP_LOAD, OP_S, OP_JALR:
                b_sel = `B_SEL_EXT;
            default:
                b_sel = `B_SEL_RD2;
        endcase
    end
    
    // dram we
    always @(*) begin
        case (opcode)
            OP_S: dram_we = 1;
            default: dram_we = 0;
        endcase
    end
    
    // alu_op
    always @(*) begin
        case (opcode)
            OP_R: begin
                case (funct3)
                    3'b000: alu_op = funct7[5] ? `ALU_SUB : `ALU_ADD;
                    3'b111: alu_op = `ALU_AND;
                    3'b110: alu_op = `ALU_OR;
                    3'b100: alu_op = `ALU_XOR;
                    3'b001: alu_op = `ALU_SLL;
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;
                    default: alu_op = `ALU_AND;
                endcase
            end
            OP_I: begin
                case (funct3)
                    3'b000: alu_op = `ALU_ADD;
                    3'b111: alu_op = `ALU_AND;
                    3'b110: alu_op = `ALU_OR;
                    3'b100: alu_op = `ALU_XOR;
                    3'b001: alu_op = `ALU_SLL;
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;
                    default: alu_op = `ALU_AND;
                endcase
            end
            OP_LOAD, OP_S, OP_JALR:
                alu_op = `ALU_ADD;
            OP_B:
                alu_op = `ALU_SUB;
                // note here
            default:
                alu_op = `ALU_AND;
        endcase
    end

    // additional br_op
    always @(*) begin
        if (opcode == OP_B) begin
            case (funct3)
                3'b000: br_op = `BR_EQ;
                3'b001: br_op = `BR_NE;
                3'b100: br_op = `BR_LT;
                3'b101: br_op = `BR_GE;
                default:br_op = `BR_NO;
            endcase
        end
        else br_op = `BR_NO;
    end
endmodule
