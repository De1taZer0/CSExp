/** @module im
 *  @brief 指令存储器
 *  @note 取pc的低12位作为地址
 *  @param instruction 输出指令
 *  @param pc 当前指令地址
 */

module im(
    output [31:0] instruction,
    input [31:0] pc);

    reg [31:0] ins_memory[1023:0];

    assign instruction = ins_memory[pc[11:2]];

endmodule