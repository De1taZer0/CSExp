/** @module gpr
 *  @brief 通用寄存器
 *  @note 通用寄存器文件
 *  @param a
 *  @param b
 *  @param clock
 *  @param reg_write 写使能
 *  @param num_write 写寄存器
 *  @param rs 读寄存器1
 *  @param rt 读寄存器2
 *  @param data_write 写数据
 */

module gpr(
    output [31:0] a,
    output [31:0] b,
    input clock,
    input reg_write,
    input [4:0] num_write,
    input [4:0] rs,
    input [4:0] rt,
    input [31:0] data_write);

    reg [31:0] gp_registers[31:0];

    always @(posedge clock)
        if(reg_write)
            if(num_write != 0)
                gp_registers[num_write] <= data_write;

    assign a = (rs == 0) ? 0 : gp_registers[rs];
    assign b = (rt == 0) ? 0 : gp_registers[rt];

endmodule