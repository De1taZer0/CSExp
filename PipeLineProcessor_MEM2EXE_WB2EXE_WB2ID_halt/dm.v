/** @module dm
 *  @brief 数据存储器
 *  @note 读取时取addr的低12位作为地址
 *  @param data_out 输出数据
 *  @param clock 时钟
 *  @param mem_write 写使能
 *  @param address 地址
 *  @param data_in 输入数据
 */

module dm (
    output [31:0] data_out,
    input clock,
    input mem_write,
    input [31:0] address,
    input [31:0] data_in);

    reg [31:0] data_memory[1023:0]; // 4k数据存储器

    assign data_out = data_memory[address[11:2]];

    always @(posedge clock)
        if(mem_write)
            data_memory[address[11:2]] <= data_in;

endmodule