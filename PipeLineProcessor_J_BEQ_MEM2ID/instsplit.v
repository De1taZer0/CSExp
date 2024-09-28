/** @module instsplit
 *  @brief 指令分割模块
 *  @param opcode 操作码
 *  @param rs 源寄存器1
 *  @param rt 源寄存器2
 *  @param rd 目的寄存器
 *  @param shamt 移位量
 *  @param funct 功能码
 *  @param imm 立即数
 *  @param instr_index 地址
 *  @param instruction 输入指令
 */

module instsplit(
    output [5:0] opcode,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] shamt,
    output [5:0] funct,
    output [15:0] imm,
    output [25:0] instr_index,
    input [31:0] instruction);

    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign shamt = instruction[10:6];
    assign funct = instruction[5:0];
    assign imm = instruction[15:0];
    assign instr_index = instruction[25:0];

endmodule