/** @module alu
 *  @brief 算术逻辑单元
 *  @note 只实现addu
 *  @param c
 *  @param a
 *  @param b
 *  @param alu_op
 */

`include "def.v"

module alu(
    output reg [31:0] c,
    input signed [31:0] a,
    input signed [31:0] b,
    input [3:0] alu_op);

    always @(*)
        case(alu_op)
            `ADD: c = a + b;
            `ADDU: c = a + b;
            `SUBU: c = a - b;
            `AND: c = a & b;
            `OR: c = a | b;
            `SLT: c = (a < b) ? 1 : 0;
        endcase

endmodule