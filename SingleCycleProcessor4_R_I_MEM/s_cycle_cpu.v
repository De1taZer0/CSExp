/** @module s_cycle_cpu
 *  @param clock 输入时钟
 *  @param reset 输入复位信号
 */

`include "alu.v"
`include "pc.v"
`include "gpr.v"
`include "im.v"
`include "ctrl.v"
`include "mux2_1.v"
`include "ext.v"
`include "dm.v"

module s_cycle_cpu(
    input clock,
    input reset);

    wire [31:0] pc_out;

    reg [31:0] npc;

    pc PC(
        .pc(pc_out),
        .clock(clock),
        .reset(reset),
        .npc(npc)
    );

    wire [31:0] im_out;

    im IM(
        .instruction(im_out),
        .pc(pc_out)
    );

    reg [5:0] opcode;
    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;
    reg [5:0] funct;

    reg [15:0] imm;

    always @(*)
    begin
        opcode = im_out[31:26];
        rs = im_out[25:21];
        rt = im_out[20:16];
        rd = im_out[15:11];
        funct = im_out[5:0];
        npc = pc_out + 4;

        imm = im_out[15:0];
    end

    wire reg_write;
    wire [3:0] alu_op;
    wire s_num_write;
    wire [1:0] s_ext;
    wire s_b;
    wire s_data_write;
    wire mem_write;

    ctrl CTRL(
        .reg_write(reg_write),
        .aluop(alu_op),
        .s_num_write(s_num_write),
        .s_ext(s_ext),
        .s_b(s_b),
        .s_data_write(s_data_write),
        .mem_write(mem_write),
        .op(opcode),
        .funct(funct)
    );

    wire [31:0] alu_out;
    wire [31:0] a;
    wire [31:0] b;
    wire [4:0] num_write;
    wire [31:0] data_write;
    wire [31:0] alu_b;
    wire [31:0] ext_out;

    mux2_1 #(.WIDTH(5)) MUX1(
        .y(num_write),
        .a(rt),
        .b(rd),
        .sel(s_num_write)
    );

    gpr GPR(
        .a(a),
        .b(b),
        .clock(clock),
        .reg_write(reg_write),
        .num_write(num_write),
        .rs(rs),
        .rt(rt),
        .data_write(data_write)
    );

    mux2_1 #(.WIDTH(32)) MUX2(
        .y(alu_b),
        .a(b),
        .b(ext_out),
        .sel(s_b)
    );

    alu ALU (
        .c(alu_out),
        .a(a),
        .b(alu_b),
        .alu_op(alu_op)
    );

    ext EXT(
        .ext_out(ext_out),
        .imm(imm),
        .extop(s_ext)
    );

    wire [31:0] dm_out;

    mux2_1 #(.WIDTH(32)) MUX3(
        .y(data_write),
        .a(alu_out),
        .b(dm_out),
        .sel(s_data_write)
    );

    dm DM(
        .data_out(dm_out),
        .clock(clock),
        .mem_write(mem_write),
        .address(alu_out),
        .data_in(b)
    );

endmodule