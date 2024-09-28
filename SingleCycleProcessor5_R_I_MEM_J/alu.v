/** @module alu
 *  @brief 算术逻辑单元
 *  @note 只实现addu
 *  @param c 运算结果
 *  @param a 操作数1
 *  @param b 操作数2
 *  @param alu_op ALU操作码
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
            `LUI: c = {b[15:0], {16{1'b0}}};
            `BEQ: c = a + (b << 2);
        endcase

endmodule