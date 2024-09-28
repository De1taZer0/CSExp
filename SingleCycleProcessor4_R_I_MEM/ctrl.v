/** @module ctrl
 *  @brief 控制器
 *  @param reg_write 寄存器写使能
 *  @param aluop ALU操作码
 *  @param s_num_write 寄存器写选择
 *  @param s_ext 扩展方式
 *  @param s_b 选择ALU_B
 *  @param s_data_write 数据写选择
 *  @param mem_write MEM写使能
 *  @param op 操作码
 *  @param funct 功能码
 */

`include "def.v"

module ctrl(
    output reg reg_write,
    output reg [3:0] aluop,
    output reg s_num_write,
    output reg [1:0] s_ext,
    output reg s_b,
    output reg s_data_write,
    output reg mem_write,
    input [5:0] op,
    input [5:0] funct);

    always @(*)
        case(op)
            `OPCODE_SPECIAL:
            begin
                reg_write <= 1;
                aluop <= funct[3:0];
                s_num_write <= 1;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_b <= 0;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_ADDI:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= 0;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_ADDIU:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= 0;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_ANDI:
            begin
                reg_write <= 1;
                aluop <= `AND;
                s_num_write <= 0;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_ORI:
            begin
                reg_write <= 1;
                aluop <= `OR;
                s_num_write <= 0;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_LUI:
            begin
                reg_write <= 1;
                aluop <= `LUI;
                s_num_write <= 0;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 0;
            end
            `OPCODE_LW:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= 0;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_b <= 1;
                s_data_write <= 1;
                mem_write <= 0;
            end
            `OPCODE_SW:
            begin
                reg_write <= 0;
                aluop <= `ADDU;
                s_num_write <= 0;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_b <= 1;
                s_data_write <= 0;
                mem_write <= 1;
            end
            default:
            begin
                reg_write <= 1;
            end
        endcase

endmodule