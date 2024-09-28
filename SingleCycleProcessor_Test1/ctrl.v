/** @module ctrl
 *  @brief 控制器
 *  @param reg_write 寄存器写使能
 *  @param aluop ALU操作码
 *  @param s_num_write 寄存器写选择
 *  @param s_ext 扩展方式
 *  @param s_b 选择ALU_B
 *  @param s_data_write 数据写选择
 *  @param mem_write MEM写使能
 *  @param s_npc PC写选择
 *  @param op 操作码
 *  @param funct 功能码
 *  @param zero 零标志
 */

`include "def.v"

module ctrl(
    output reg reg_write,
    output reg [3:0] aluop,
    output reg [1:0] s_num_write,
    output reg [1:0] s_ext,
    output reg s_a,
    output reg s_b,
    output reg [1:0] s_data_write,
    output reg mem_write,
    output reg [1:0] s_npc,
    input [5:0] op,
    input [5:0] funct,
    input zero);

    always @(*)
    begin
        case(op)
            `OPCODE_SPECIAL:
            case(funct)
                `FUNCT_ADD,
                `FUNCT_ADDU,
                `FUNCT_SUBU,
                `FUNCT_AND,
                `FUNCT_OR,
                `FUNCT_SRAV,
                `FUNCT_SLT:
                begin
                    reg_write <= 1;
                    aluop <= funct[3:0];
                    s_num_write <= `Num_write_rd;
                    s_ext <= `EXTOP_ZEROEXTEND;
                    s_a <= `ALU_a_REG;
                    s_b <= 0;
                    s_data_write <= `Data_write_ALU;
                    mem_write <= 0;
                    s_npc <= `N_nPC;
                end
                `FUNCT_JR:
                begin
                    reg_write <= 0;
                    aluop <= `ADDU;
                    s_num_write <= 0;
                    s_ext <= `EXTOP_ZEROEXTEND;
                    s_a <= `ALU_a_REG;
                    s_b <= 0;
                    s_data_write <= `Data_write_ALU;
                    mem_write <= 0;
                    s_npc <= `JR_nPC;
                end
                default:
                begin
                    reg_write <= 0;
                    mem_write <= 0;
                    s_npc <= `N_nPC;
                end
            endcase
            `OPCODE_ADDI:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_ADDIU:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_ANDI:
            begin
                reg_write <= 1;
                aluop <= `AND;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_ORI:
            begin
                reg_write <= 1;
                aluop <= `OR;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_LUI:
            begin
                reg_write <= 1;
                aluop <= `LUI;
                s_num_write <= 0;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_SLTIU:
            begin
                reg_write <= 1;
                aluop <= `SLTU;
                s_num_write <= 0;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_LW:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_MEM;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
            `OPCODE_SW:
            begin
                reg_write <= 0;
                aluop <= `ADDU;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 1;
                s_npc <= `N_nPC;
            end
            `OPCODE_J:
            begin
                reg_write <= 0;
                aluop <= `ADDU;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= `J_nPC;
            end
            `OPCODE_JAL:
            begin
                reg_write <= 1;
                aluop <= `ADDU;
                s_num_write <= `Num_write_31;
                s_ext <= `EXTOP_ZEROEXTEND;
                s_a <= `ALU_a_REG;
                s_b <= 1;
                s_data_write <= `Data_write_nPC;
                mem_write <= 0;
                s_npc <= `J_nPC;
            end
            `OPCODE_BEQ:
            begin
                reg_write <= 0;
                aluop <= `BEQ;
                s_num_write <= `Num_write_rt;
                s_ext <= `EXTOP_SIGNEXTEND;
                s_a <= `ALU_a_nPC;
                s_b <= 1;
                s_data_write <= `Data_write_ALU;
                mem_write <= 0;
                s_npc <= (zero == 1) ? `BEQ_nPC : `N_nPC;
            end
            default:
            begin
                reg_write <= 0;
                mem_write <= 0;
                s_npc <= `N_nPC;
            end
        endcase
    end

endmodule