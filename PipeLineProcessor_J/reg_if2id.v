/** @module reg_if2id
 *  @brief IF/ID流水线寄存器
 *  @note flush高电平有效，写使能低电平有效，上升沿写入，reset低电平有效，同步复位
 *  @param pc_out
 *  @param npc_out
 *  @param instruction_out
 *  @param pc_in
 *  @param npc_in
 *  @param instruction_in
 *  @param clock 时钟
 *  @param reset 复位
 *  @param nwrite 写使能
 *  @param flush 清空
 */

`include "def.v"

module reg_if2id(
    output reg [31:0] pc_out,
    output reg [31:0] npc_out,
    output reg [31:0] instruction_out,
    input [31:0] pc_in,
    input [31:0] npc_in,
    input [31:0] instruction_in,
    input clock,
    input reset,
    input nwrite,
    input flush);

    always @(posedge clock)
    begin
        if(!reset || flush)
        begin
            pc_out <= 0;
            npc_out <= 0;
            instruction_out <= `INSTRUCTION_NOP;
        end
        else if(!nwrite)
        begin
            pc_out <= pc_in;
            npc_out <= npc_in;
            instruction_out <= instruction_in;
        end
    end

endmodule