/** @module pc
 *  @brief 程序计数器
 *  @note clock上升沿有效，reset低电平有效
 *  @note reset有效时，pc同步复位为0x0000_3000
 *  @param pc 当前指令地址
 *  @param clock 输入时钟
 *  @param reset 输入复位信号
 *  @param npc 下一条指令地址
 */
module pc(
    output reg [31:0] pc,
    input clock,
    input reset,
    input [31:0] npc);

    always @(posedge clock) begin
        if(!reset)
            pc <= 32'h0000_3000;
        else
            pc <= npc;
    end

endmodule