/** @module ext
 *  @brief 扩展单元
 *  @param imm 输入
 *  @param ext_out 输出
 *  @param extop 扩展方式
 */

`include "def.v"

module ext(
    output [31:0] ext_out,
    input [15:0] imm,
    input [1:0] extop);

    assign ext_out = (extop == `EXTOP_SIGNEXTEND) ? {{16{imm[15]}}, imm} :
                     (extop == `EXTOP_ZEROEXTEND) ? {{16{1'b0}}, imm} :
                     {{16{1'b0}}, imm};

endmodule