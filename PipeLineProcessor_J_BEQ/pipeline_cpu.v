/** @module pipeline_cpu
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
`include "reg_if2id.v"
`include "reg_id2exe.v"
`include "reg_exe2mem.v"
`include "reg_mem2wb.v"
`include "hazard_ctrl.v"
`include "instsplit.v"

module pipeline_cpu(
    input clock,
    input reset);

    // IF

    wire [31:0] pc_IF;
    wire [31:0] npc_IF;
    wire [31:0] npc_N_IF;

    assign npc_N_IF = pc_IF + 4;

    wire nWrite_PC;

    // PC .... //

    wire [31:0] instruction_IF;

    // IM .... //

    // IF end

    wire flush_IF_ID;

    // Reg IF-ID

    wire nWrite_IF_ID;

    // data
    wire [31:0] pc_ID;
    wire [31:0] npc_N_ID;
    wire [31:0] instruction_ID;

    // Reg IF-ID end
    
    // ID

    wire [ 5:0] opcode_ID;
    wire [ 4:0] rs_ID;
    wire [ 4:0] rt_ID;
    wire [ 4:0] rd_ID;
    wire [ 4:0] shamt_ID;
    wire [ 5:0] funct_ID;
    wire [15:0] imm_ID;
    wire [25:0] instr_index_ID;

    instsplit INSTSPLIT(
        .opcode(opcode_ID),
        .rs(rs_ID),
        .rt(rt_ID),
        .rd(rd_ID),
        .shamt(shamt_ID),
        .funct(funct_ID),
        .imm(imm_ID),
        .instr_index(instr_index_ID),
        .instruction(instruction_ID)
    );

    wire reg_write_ID;
    wire [3:0] alu_op_ID;
    wire s_ext_ID;
    wire [1:0] s_num_write_ID;
    wire [1:0] s_data_write_ID;
    wire s_a_ID;
    wire s_b_ID;
    wire mem_write_ID;
    wire [1:0] s_npc_ID;
    wire [1:0] inst_type_ID;

    // CTRL .... //

    wire [31:0] gpr_a_ID;
    wire [31:0] gpr_b_ID;

    // GPR .... //

    wire [31:0] ext_imm_ID;

    // EXT .... //

    wire [4:0] num_write_ID;

    // MUX_num_write .... //

    wire [31:0] npc_J_ID;

    assign npc_J_ID = {pc_ID[31:28], instr_index_ID, {2{1'b0}}};

    wire zero_ID;

    assign zero_ID = (gpr_a_ID == gpr_b_ID) ? 1 : 0;

    wire [31:0] npc_BEQ_ID;

    assign npc_BEQ_ID = npc_N_ID + (ext_imm_ID << 2);

    // ID end

    // Reg ID-EXE

    wire flush_ID_EXE;

    // control
    wire s_b_EXE;
    wire mem_write_EXE;
    wire [1:0] s_data_write_EXE;
    wire wire_write_EXE;

    // data
    wire [31:0] npc_N_EXE;
    wire [1:0] inst_type_EXE;
    wire [4:0] rs_EXE;
    wire [4:0] rt_EXE;
    wire [31:0] ext_imm_EXE;
    wire [4:0] shamt_EXE;
    wire [3:0] alu_op_EXE;
    wire [31:0] gpr_a_EXE;
    wire [31:0] gpr_b_EXE;
    wire [4:0] num_write_EXE;

    // Reg ID-EXE end

    // EXE

    wire [31:0] alu_a_EXE;
    wire [31:0] alu_b_EXE;

    // ALU .... //

    wire [31:0] alu_res_EXE;

    // MUX_a .... //

    // MUX_b .... //

    // EXE end

    // Reg EXE-MEM

    // control
    wire mem_write_MEM;
    wire [1:0] s_data_write_MEM;
    wire reg_write_MEM;

    // data
    wire [31:0] npc_MEM;
    wire [31:0] alu_res_MEM;
    wire [31:0] gpr_b_MEM;
    wire [4:0] num_write_MEM;

    // Reg EXE-MEM end

    // MEM

    wire [31:0] dm_read_MEM;

    // DM .... //

    // MEM end

    // Reg MEM-WB

    // control
    wire [1:0] s_data_write_WB;
    wire reg_write_WB;
    
    // data
    wire [31:0] npc_N_WB;
    wire [31:0] alu_res_WB;
    wire [31:0] dm_read_WB;
    wire [4:0] num_write_WB;

    // Reg MEM-WB end

    // WB

    wire [31:0] data_write_WB;

    // MUX_data_write .... //

    // WB end

    // module instances

    pc PC(
        .pc(pc_IF),
        .clock(clock),
        .reset(reset),
        .npc(npc_IF),
        .nWrite(nWrite_PC)
    );

    im IM(
        .instruction(instruction_IF),
        .pc(pc_IF)
    );

    ctrl CTRL(
        .reg_write(reg_write_ID),
        .aluop(alu_op_ID),
        .s_num_write(s_num_write_ID),
        .s_ext(s_ext_ID),
        .s_a(s_a_ID),
        .s_b(s_b_ID),
        .s_data_write(s_data_write_ID),
        .mem_write(mem_write_ID),
        .s_npc(s_npc_ID),
        .inst_type(inst_type_ID),
        .op(opcode_ID),
        .funct(funct_ID),
        .zero(zero_ID)
    );

    ext EXT(
        .ext_out(ext_imm_ID),
        .imm(imm_ID),
        .extop(s_ext_ID)
    );

    alu ALU(
        .c(alu_res_EXE),
        .a(alu_a_EXE),
        .b(alu_b_EXE),
        .shamt(shamt_EXE),
        .alu_op(alu_op_EXE)
    );

    dm DM(
        .data_out(dm_read_MEM),
        .clock(clock),
        .mem_write(mem_write_MEM),
        .address(alu_res_MEM),
        .data_in(gpr_b_MEM)
    );

    wire [31:0] gpr_a_out;
    wire [31:0] gpr_b_out;

    gpr GPR(
        .a(gpr_a_out),
        .b(gpr_b_out),
        .clock(clock),
        .reg_write(reg_write_WB),
        .num_write(num_write_WB),
        .rs(rs_ID),
        .rt(rt_ID),
        .data_write(data_write_WB)
    );

    // module instances end
    
    // forwardings

    // forwarding from MEM to EXE

    wire [31:0] alu_res_FWD;

    assign alu_res_FWD = alu_res_MEM;

    // MUX_a_FWD_EXE .... //

    // MUX_b_FWD_EXE .... //

    // forwarding from MEM to EXE end

    // forwarding from WB to EXE

    wire [31:0] data_write_FWD;

    assign data_write_FWD = data_write_WB;

    // MUX_a_FWD_EXE .... //

    // MUX_b_FWD_EXE .... //

    // forwarding from WB to EXE end

    // forwarding from WB to ID

    // MUX_a_FWD_ID .... //

    // MUX_b_FWD_ID .... //

    // forwarding from WB to ID end

    // control

    wire [1:0] s_a_FWD_EXE;
    wire [1:0] s_b_FWD_EXE;

    wire s_a_FWD_ID;
    wire s_b_FWD_ID;

    hazard_ctrl HAZARD_CTRL(
        .s_a_FWD_EXE(s_a_FWD_EXE),
        .s_b_FWD_EXE(s_b_FWD_EXE),
        .s_a_FWD_ID(s_a_FWD_ID),
        .s_b_FWD_ID(s_b_FWD_ID),
        .nWrite_PC(nWrite_PC),
        .nWrite_IF_ID(nWrite_IF_ID),
        .flush_IF_ID(flush_IF_ID),
        .flush_ID_EXE(flush_ID_EXE),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .inst_type_ID(inst_type_ID),
        .s_b_ID(s_b_ID),
        .rs_EXE(rs_EXE),
        .rt_EXE(rt_EXE),
        .num_write_EXE(num_write_EXE),
        .inst_type_EXE(inst_type_EXE),
        .reg_write_MEM(reg_write_MEM),
        .num_write_MEM(num_write_MEM),
        .reg_write_WB(reg_write_WB),
        .num_write_WB(num_write_WB),
        .zero_ID(zero_ID)
    );                                                                                            

    // control end

    // forwardings end

    // multiplexers

    wire [31:0] gpr_a_FWD;
    wire [31:0] gpr_b_FWD;

    mux4_1 #(.WIDTH(5)) MUX_num_write(
        .y(num_write_ID),
        .a(rt_ID),
        .b(rd_ID),
        .c(5'd31),
        .sel(s_num_write_ID)
    );

    mux2_1 #(.WIDTH(32)) MUX_a(
        .y(alu_a_EXE),
        .a(gpr_a_FWD),
        .sel(1'b0)
    );

    mux2_1 #(.WIDTH(32)) MUX_b(
        .y(alu_b_EXE),
        .a(gpr_b_FWD),
        .b(ext_imm_EXE),
        .sel(s_b_EXE)
    );

    mux4_1 #(.WIDTH(32)) MUX_npc(
        .y(npc_IF),
        .a(npc_N_IF),
        .b(npc_J_ID),
        .c(gpr_a_ID),
        .d(npc_BEQ_ID),
        .sel(s_npc_ID)
    );

    mux4_1 #(.WIDTH(32)) MUX_data_write(
        .y(data_write_WB),
        .a(npc_N_WB),
        .b(alu_res_WB),
        .c(dm_read_WB),
        .sel(s_data_write_WB)
    );

    // forwardings
    mux4_1 #(.WIDTH(32)) MUX_a_FWD_EXE(
        .y(gpr_a_FWD),
        .a(gpr_a_EXE),
        .b(alu_res_FWD),
        .c(data_write_FWD),
        .sel(s_a_FWD_EXE)
    );

    mux4_1 #(.WIDTH(32)) MUX_b_FWD_EXE(
        .y(gpr_b_FWD),
        .a(gpr_b_EXE),
        .b(alu_res_FWD),
        .c(data_write_FWD),
        .sel(s_b_FWD_EXE)
    );

    mux2_1 #(.WIDTH(32)) MUX_a_FWD_ID(
        .y(gpr_a_ID),
        .a(gpr_a_out),
        .b(data_write_FWD),
        .sel(s_a_FWD_ID)
    );

    mux2_1 #(.WIDTH(32)) MUX_b_FWD_ID(
        .y(gpr_b_ID),
        .a(gpr_b_out),
        .b(data_write_FWD),
        .sel(s_b_FWD_ID)
    );

    // multiplexers end

    // pipeline registers

    reg_if2id IF_ID(
        .pc_out(pc_ID),
        .npc_out(npc_N_ID),
        .instruction_out(instruction_ID),
        .pc_in(pc_IF),
        .npc_in(npc_N_IF),
        .instruction_in(instruction_IF),
        .clock(clock),
        .reset(reset),
        .nwrite(nWrite_IF_ID),
        .flush(flush_IF_ID)
    );

    reg_id2exe ID_EXE(
        .s_b_out(s_b_EXE),
        .mem_write_out(mem_write_EXE),
        .s_data_write_out(s_data_write_EXE),
        .reg_write_out(reg_write_EXE),
        .npc_out(npc_N_EXE),
        .inst_type_out(inst_type_EXE),
        .rs_out(rs_EXE),
        .rt_out(rt_EXE),
        .ext_imm_out(ext_imm_EXE),
        .shamt_out(shamt_EXE),
        .alu_op_out(alu_op_EXE),
        .gpr_a_out(gpr_a_EXE),
        .gpr_b_out(gpr_b_EXE),
        .num_write_out(num_write_EXE),
        .s_b_in(s_b_ID),
        .mem_write_in(mem_write_ID),
        .s_data_write_in(s_data_write_ID),
        .reg_write_in(reg_write_ID),
        .npc_in(npc_N_ID),
        .inst_type_in(inst_type_ID),
        .rs_in(rs_ID),
        .rt_in(rt_ID),
        .ext_imm_in(ext_imm_ID),
        .shamt_in(shamt_ID),
        .alu_op_in(alu_op_ID),
        .gpr_a_in(gpr_a_ID),
        .gpr_b_in(gpr_b_ID),
        .num_write_in(num_write_ID),
        .clock(clock),
        .reset(reset),
        .flush(flush_ID_EXE)
    );

    reg_exe2mem EXE_MEM(
        .mem_write_out(mem_write_MEM),
        .s_data_write_out(s_data_write_MEM),
        .reg_write_out(reg_write_MEM),
        .npc_out(npc_MEM),
        .alu_res_out(alu_res_MEM),
        .gpr_b_out(gpr_b_MEM),
        .num_write_out(num_write_MEM),
        .mem_write_in(mem_write_EXE),
        .s_data_write_in(s_data_write_EXE),
        .reg_write_in(reg_write_EXE),
        .npc_in(npc_N_EXE),
        .alu_res_in(alu_res_EXE),
        .gpr_b_in(gpr_b_FWD),
        .num_write_in(num_write_EXE),
        .clock(clock),
        .reset(reset)
    );

    reg_mem2wb MEM_WB(
        .s_data_write_out(s_data_write_WB),
        .reg_write_out(reg_write_WB),
        .npc_out(npc_N_WB),
        .alu_res_out(alu_res_WB),
        .dm_read_out(dm_read_WB),
        .num_write_out(num_write_WB),
        .s_data_write_in(s_data_write_MEM),
        .reg_write_in(reg_write_MEM),
        .npc_in(npc_MEM),
        .alu_res_in(alu_res_MEM),
        .dm_read_in(dm_read_MEM),
        .num_write_in(num_write_MEM),
        .clock(clock),
        .reset(reset)
    );

    // pipeline registers end

endmodule