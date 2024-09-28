/** @module reg_exe2mem
 *  @brief EXE/MEM流水线寄存器
 *  @note 上升沿写入，reset低电平有效，同步复位
 *  @param mem_write_out
 *  @param s_data_write_out
 *  @param reg_write_out
 *  @param npc_out
 *  @param alu_res_out
 *  @param gpr_b_out
 *  @param num_write_out
 *  @param mem_write_in
 *  @param s_data_write_in
 *  @param reg_write_in
 *  @param npc_in
 *  @param alu_res_in
 *  @param gpr_b_in
 *  @param num_write_in
 *  @param clock 时钟
 *  @param reset 复位
 */

module reg_exe2mem(
    output reg mem_write_out,
    output reg [1:0] s_data_write_out,
    output reg reg_write_out,
    output reg [31:0] npc_out,
    output reg [31:0] alu_res_out,
    output reg [31:0] gpr_b_out,
    output reg [4:0] num_write_out,
    input mem_write_in,
    input [1:0] s_data_write_in,
    input reg_write_in,
    input [31:0] npc_in,
    input [31:0] alu_res_in,
    input [31:0] gpr_b_in,
    input [4:0] num_write_in,
    input clock,
    input reset);

    always @(posedge clock)
    begin
        if(!reset)
        begin
            mem_write_out <= 0;
            s_data_write_out <= 0;
            reg_write_out <= 0;
            npc_out <= 0;
            alu_res_out <= 0;
            gpr_b_out <= 0;
            num_write_out <= 0;
        end
        else
        begin
            mem_write_out <= mem_write_in;
            s_data_write_out <= s_data_write_in;
            reg_write_out <= reg_write_in;
            npc_out <= npc_in;
            alu_res_out <= alu_res_in;
            gpr_b_out <= gpr_b_in;
            num_write_out <= num_write_in;
        end
    end

endmodule
