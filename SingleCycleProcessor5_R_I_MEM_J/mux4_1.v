/** @module mux4_1
 *  @brief 4选1多路选择器
 *  @param a 输入1
 *  @param b 输入2
 *  @param c 输入3
 *  @param d 输入4
 *  @param sel 选择信号
 *  @param y 输出
 */

module mux4_1 #(parameter WIDTH = 32) (
    output [WIDTH-1:0] y,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    input [1:0] sel);

    assign y = (sel == 0) ? a : 
               (sel == 1) ? b :
               (sel == 2) ? c :
               (sel == 3) ? d : 0;

endmodule 