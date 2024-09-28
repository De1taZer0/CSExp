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
    input [31:0] ua,
    input [31:0] ub,
    input [3:0] alu_op);

    integer i;

    wire signed [31:0] a;
    wire signed [31:0] b;

    assign a = ua;
    assign b = ub;

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
            `SRAV: c = b >>> a[4:0];
            `SLTU: c = (ua < ub) ? 1 : 0;
        endcase

endmodule