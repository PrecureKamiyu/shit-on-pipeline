// Annotate this macro before synthesis
`define RUN_TRACE

`define NPC_PC4     'b00
`define NPC_JAL     'b01
`define NPC_JALR    'b10
`define NPC_JMP     'b11

`define SEXT_R 'b000
`define SEXT_I 'b001
`define SEXT_S 'b010
`define SEXT_B 'b011
`define SEXT_U 'b100
`define SEXT_J 'b101
`define SEXT_MOVE 'b110

`define ALU_ADD 'b0001
`define ALU_SUB 'b0010
`define ALU_AND 'b0011
`define ALU_OR  'b0100
`define ALU_XOR 'b0101
`define ALU_SLL 'b0110
`define ALU_SRL 'b0111
`define ALU_SRA 'b1000

`define TRUE 1'b1
`define FALSE 1'b0

`define RF_WSEL_PC4 'b01
`define RF_WSEL_EXT 'b10
`define RF_WSEL_ALU 'b00
`define RF_WSEL_RDO 'b11

`define B_SEL_RD2 'b0
`define B_SEL_EXT 'b1

`define BR_NO 'b000
`define BR_EQ 'b001
`define BR_GE 'b010
`define BR_LT 'b011
`define BR_NE 'b100
`define BR_GO 'b111
// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
