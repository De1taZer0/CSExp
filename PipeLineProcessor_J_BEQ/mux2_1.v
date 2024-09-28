/** @module mux2_1
 *  @brief 2选1多路选择器
 *  @param a 输入1
 *  @param b 输入2
 *  @param sel 选择信号
 *  @param y 输出
 */

module mux2_1 #(parameter WIDTH = 32) (
    output [WIDTH-1:0] y,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input sel);

    assign y = (sel == 1) ? b : a;

endmodule 