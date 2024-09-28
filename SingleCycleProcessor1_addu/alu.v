/** @module alu
 *  @brief 算术逻辑单元
 *  @note 只实现addu
 *  @param c
 *  @param a
 *  @param b
 */

module alu(
    output reg [31:0] c,
    input [31:0] a,
    input [31:0] b);

    always @(*)
        c <= a + b;

endmodule