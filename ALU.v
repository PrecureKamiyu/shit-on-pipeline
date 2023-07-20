`include "defines.vh"

module ALU (
    input wire [3:0] op,
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] C
);

always @(*) begin
    case(op)
        `ALU_ADD : C = A + B;
        `ALU_SUB : C = A - B;
        `ALU_AND : C = A & B;
        `ALU_OR  : C = A | B;
        `ALU_XOR : C = A ^ B;
        `ALU_SLL : C = A << B[4:0];
        `ALU_SRL : C = A >> B[4:0];
        `ALU_SRA : C = ($signed(A)) >>> B[4:0];
        // this one!
        default  : C = 32'b0;
    endcase
end

endmodule
