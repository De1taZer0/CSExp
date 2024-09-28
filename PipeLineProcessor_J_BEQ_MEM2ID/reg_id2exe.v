/** @module reg_id2exe
 *  @brief ID/EXE流水线寄存器
 *  @note flush高电平有效，上升沿写入，reset低电平有效，同步复位
 *  @param s_b_out
 *  @param mem_write_out
 *  @param s_data_write_out
 *  @param reg_write_out
 *  @param npc_out
 *  @param inst_type_out
 *  @param rs_out
 *  @param rt_out
 *  @param ext_imm_out
 *  @param shamt_out
 *  @param alu_op_out
 *  @param gpr_a_out
 *  @param gpr_b_out
 *  @param num_write_out
 *  @param s_b_in
 *  @param mem_write_in
 *  @param s_data_write_in
 *  @param reg_write_in
 *  @param npc_in
 *  @param inst_type_in
 *  @param rs_in
 *  @param rt_in
 *  @param ext_imm_in
 *  @param shamt_in
 *  @param alu_op_in
 *  @param gpr_a_in
 *  @param gpr_b_in
 *  @param num_write_in
 *  @param clock 时钟
 *  @param reset 复位
 *  @param flush 清空
 */

module reg_id2exe(
    output reg s_b_out,
    output reg mem_write_out,
    output reg [1:0] s_data_write_out,
    output reg reg_write_out,
    output reg [31:0] npc_out,
    output reg [2:0] inst_type_out,
    output reg [4:0] rs_out,
    output reg [4:0] rt_out,
    output reg [31:0] ext_imm_out,
    output reg [4:0] shamt_out,
    output reg [3:0] alu_op_out,
    output reg [31:0] gpr_a_out,
    output reg [31:0] gpr_b_out,
    output reg [4:0] num_write_out,
    input s_b_in,
    input mem_write_in,
    input [1:0] s_data_write_in,
    input reg_write_in,
    input [31:0] npc_in,
    input [2:0] inst_type_in,
    input [4:0] rs_in,
    input [4:0] rt_in,
    input [31:0] ext_imm_in,
    input [4:0] shamt_in,
    input [3:0] alu_op_in,
    input [31:0] gpr_a_in,
    input [31:0] gpr_b_in,
    input [4:0] num_write_in,
    input clock,
    input reset,
    input flush);

    always @(posedge clock)
    begin
        if(!reset || flush)
        begin
            s_b_out <= 0;
            mem_write_out <= 0;
            s_data_write_out <= 0;
            reg_write_out <= 0;
            npc_out <= 0;
            inst_type_out <= 0;
            rs_out <= 0;
            rt_out <= 0;
            ext_imm_out <= 0;
            shamt_out <= 0;
            alu_op_out <= 0;
            gpr_a_out <= 0;
            gpr_b_out <= 0;
            num_write_out <= 0;
        end
        else
        begin
            s_b_out <= s_b_in;
            mem_write_out <= mem_write_in;
            s_data_write_out <= s_data_write_in;
            reg_write_out <= reg_write_in;
            npc_out <= npc_in;
            inst_type_out <= inst_type_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            ext_imm_out <= ext_imm_in;
            shamt_out <= shamt_in;
            alu_op_out <= alu_op_in;
            gpr_a_out <= gpr_a_in;
            gpr_b_out <= gpr_b_in;
            num_write_out <= num_write_in;
        end
    end

endmodule