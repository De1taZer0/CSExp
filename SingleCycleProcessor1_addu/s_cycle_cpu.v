/** @module s_cycle_cpu
 *  @param clock 输入时钟
 *  @param reset 输入复位信号
 */

`include "alu.v"
`include "pc.v"
`include "gpr.v"
`include "im.v"

module s_cycle_cpu(
    input clock,
    input reset);

    wire [31:0] pc_out;
    wire [31:0] im_out;
    reg [31:0] npc;

    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;

    wire [31:0] alu_out;
    wire [31:0] a;
    wire [31:0] b;

    always @(*)
    begin
      rs = im_out[25:21];
      rt = im_out[20:16];
      rd = im_out[15:11];
      npc = pc_out + 4;
    end

    pc PC(
        .pc(pc_out),
        .clock(clock),
        .reset(reset),
        .npc(npc)
    );

    im IM(
        .instruction(im_out),
        .pc(pc_out)
    );

    gpr GPR(
        .a(a),
        .b(b),
        .clock(clock),
        .reg_write(1'b1),
        .num_write(rd),
        .rs(rs),
        .rt(rt),
        .data_write(alu_out)
    );

    alu ALU (
        .c(alu_out),
        .a(a),
        .b(b)
    );

endmodule