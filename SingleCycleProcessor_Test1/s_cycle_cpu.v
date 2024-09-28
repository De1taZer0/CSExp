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
`include "mux4_1.v"
`include "ext.v"
`include "dm.v"

module s_cycle_cpu(
    input clock,
    input reset);

    wire [31:0] pc_out;

    wire [31:0] npc;

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

    reg [25:0] instr_index;

    always @(*)
    begin
        opcode = im_out[31:26];
        rs = im_out[25:21];
        rt = im_out[20:16];
        rd = im_out[15:11];
        funct = im_out[5:0];

        imm = im_out[15:0];

        instr_index = im_out[25:0];
    end

    wire reg_write;
    wire [3:0] alu_op;
    wire [1:0] s_num_write;
    wire [1:0] s_ext;
    wire s_a;
    wire s_b;
    wire [1:0] s_data_write;
    wire mem_write;
    wire [1:0] s_npc;

    reg zero;

    ctrl CTRL(
        .reg_write(reg_write),
        .aluop(alu_op),
        .s_num_write(s_num_write),
        .s_ext(s_ext),
        .s_a(s_a),
        .s_b(s_b),
        .s_data_write(s_data_write),
        .mem_write(mem_write),
        .s_npc(s_npc),
        .op(opcode),
        .funct(funct),
        .zero(zero)
    );

    wire [31:0] alu_out;
    wire [31:0] a;
    wire [31:0] b;
    wire [4:0] num_write;
    wire [31:0] data_write;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] ext_out;

    reg [31:0] next_pc_J;
    reg [31:0] next_pc_N;

    always @(*)
    begin
        next_pc_J = {pc_out[31:28], instr_index, {2{1'b0}}};
        next_pc_N = pc_out + 4;
        zero = ((a ^ b) == 0) ? 1 : 0;
    end

    mux4_1 #(.WIDTH(5)) MUX_num_write(
        .y(num_write),
        .a(rt),
        .b(rd),
        .c(5'b11111),
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

    mux2_1 #(.WIDTH(32)) MUX_a(
        .y(alu_a),
        .a(next_pc_N),
        .b(a),
        .sel(s_a)
    );

    mux2_1 #(.WIDTH(32)) MUX_b(
        .y(alu_b),
        .a(b),
        .b(ext_out),
        .sel(s_b)
    );

    alu ALU (
        .c(alu_out),
        .ua(alu_a),
        .ub(alu_b),
        .alu_op(alu_op)
    );

    ext EXT(
        .ext_out(ext_out),
        .imm(imm),
        .extop(s_ext)
    );

    wire [31:0] dm_out;

    mux4_1 #(.WIDTH(32)) MUX_data_write(
        .y(data_write),
        .a(next_pc_N),
        .b(alu_out),
        .c(dm_out),
        .sel(s_data_write)
    );

    dm DM(
        .data_out(dm_out),
        .clock(clock),
        .mem_write(mem_write),
        .address(alu_out),
        .data_in(b)
    );

    mux4_1 #(.WIDTH(32)) MUX_npc(
        .y(npc),
        .a(next_pc_N),
        .b(next_pc_J),
        .c(a),
        .d(alu_out),
        .sel(s_npc)
    );

endmodule