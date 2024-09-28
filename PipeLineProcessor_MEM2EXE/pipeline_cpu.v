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

module pipeline_cpu(
    input clock,
    input reset);

    // IF

    wire [31:0] pc_out;
    
    wire [31:0] npc_IF;

    assign npc_IF = pc_out + 4;

    // PC .... //

    wire [31:0] instruction_IF;

    // IM .... //

    // IF end

    // Reg IF-ID

    // data
    reg [31:0] npc_ID;
    reg [31:0] instruction_ID;
    
    always @(posedge clock)
    begin
        if(!reset)
        begin
            npc_ID <= 0;
            instruction_ID <= `INSTRUCTION_NOP;
        end
        else
        begin
            npc_ID <= npc_IF;
            instruction_ID <= instruction_IF;
        end
    end

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

    assign opcode_ID      = instruction_ID[31:26];
    assign rs_ID          = instruction_ID[25:21];
    assign rt_ID          = instruction_ID[20:16];
    assign rd_ID          = instruction_ID[15:11];
    assign shamt_ID       = instruction_ID[10: 6];
    assign funct_ID       = instruction_ID[ 5: 0];
    assign imm_ID         = instruction_ID[15: 0];
    assign instr_index_ID = instruction_ID[25: 0];

    wire reg_write_ID;
    wire [3:0] alu_op_ID;
    wire s_ext_ID;
    wire [1:0] s_num_write_ID;
    wire [1:0] s_data_write_ID;
    wire s_a_ID;
    wire s_b_ID;
    wire mem_write_ID;
    wire [1:0] s_npc_ID;

    // CTRL .... //

    wire [31:0] gpr_a_ID;
    wire [31:0] gpr_b_ID;

    // GPR .... //

    wire [31:0] ext_out_ID;

    // EXT .... //

    wire [4:0] num_write_ID;

    // MUX_num_write .... //

    // ID end

    // Reg ID-EXE

    // control
    reg s_b_EXE;

    reg mem_write_EXE;

    reg [1:0] s_data_write_EXE;
    reg reg_write_EXE;

    // data
    reg [31:0] npc_EXE;

    reg [4:0] rs_EXE;
    reg [4:0] rt_EXE;

    reg [31:0] ext_out_EXE;

    reg [4:0] shamt_EXE;
    reg [3:0] alu_op_EXE;

    reg [31:0] gpr_a_EXE;
    reg [31:0] gpr_b_EXE;

    reg [4:0] num_write_EXE;

    always @(posedge clock)
    begin
        if(!reset)
        begin
            s_b_EXE <= 0;
            mem_write_EXE <= 0;
            s_data_write_EXE <= 0;
            reg_write_EXE <= 0;
        
            npc_EXE <= 0;
            rs_EXE <= 0;
            rt_EXE <= 0;
            ext_out_EXE <= 0;
            shamt_EXE <= 0;
            alu_op_EXE <= 0;
            gpr_a_EXE <= 0;
            gpr_b_EXE <= 0;
            num_write_EXE <= 0;
        end
        else
        begin
            s_b_EXE <= s_b_ID;
            mem_write_EXE <= mem_write_ID;
            s_data_write_EXE <= s_data_write_ID;
            reg_write_EXE <= reg_write_ID;
        
            npc_EXE <= npc_ID;
            rs_EXE <= rs_ID;
            rt_EXE <= rt_ID;
            ext_out_EXE <= ext_out_ID;
            shamt_EXE <= shamt_ID;
            alu_op_EXE <= alu_op_ID;
            gpr_a_EXE <= gpr_a_ID;
            gpr_b_EXE <= gpr_b_ID;
            num_write_EXE <= num_write_ID;
        end
    end

    // Reg ID-EXE end

    // EXE

    wire [31:0] alu_a_EXE;
    wire [31:0] alu_b_EXE;

    // ALU .... //

    wire [31:0] alu_out_EXE;

    // MUX_a .... //

    // MUX_b .... //

    // EXE end

    // Reg EXE-MEM

    // control
    reg mem_write_MEM;

    reg [1:0] s_data_write_MEM;
    reg reg_write_MEM;

    // data
    reg [31:0] npc_MEM;

    reg [4:0] rs_MEM;
    reg [4:0] rt_MEM;

    reg [31:0] alu_out_MEM;
    reg [31:0] gpr_b_MEM;

    reg [4:0] num_write_MEM;

    always @(posedge clock)
    begin
        if(!reset)
        begin
            mem_write_MEM <= 0;
            s_data_write_MEM <= 0;
            reg_write_MEM <= 0;

            npc_MEM <= 0;
            alu_out_MEM <= 0;
            gpr_b_MEM <= 0;
            num_write_MEM <= 0;
        end
        else
        begin
            mem_write_MEM <= mem_write_EXE;
            s_data_write_MEM <= s_data_write_EXE;
            reg_write_MEM <= reg_write_EXE;

            npc_MEM <= npc_EXE;
            alu_out_MEM <= alu_out_EXE;
            gpr_b_MEM <= gpr_b_EXE;
            num_write_MEM <= num_write_EXE;
        end
    end

    // Reg EXE-MEM end

    // MEM

    wire [31:0] dm_out_MEM;

    // DM .... //

    // MEM end

    // Reg MEM-WB

    // control
    reg [1:0] s_data_write_WB;
    reg reg_write_WB;
    
    // data
    reg [31:0] npc_WB;

    reg [31:0] alu_out_WB;

    reg [31:0] dm_out_WB;

    reg [4:0] num_write_WB;

    always @(posedge clock)
    begin
        if(!reset)
        begin
            s_data_write_WB <= 0;
            reg_write_WB <= 0;

            npc_WB <= 0;
            alu_out_WB <= 0;
            dm_out_WB <= 0;
            num_write_WB <= 0;
        end
        else
        begin
            s_data_write_WB <= s_data_write_MEM;
            reg_write_WB <= reg_write_MEM;

            npc_WB <= npc_MEM;
            alu_out_WB <= alu_out_MEM;
            dm_out_WB <= dm_out_MEM;
            num_write_WB <= num_write_MEM;
        end
    end

    // Reg MEM-WB end

    // WB

    wire [31:0] data_write_WB;

    // MUX_data_write .... //

    // WB end

    // module instances

    pc PC(
        .pc(pc_out),
        .clock(clock),
        .reset(reset),
        .npc(npc_IF)
    );

    im IM(
        .instruction(instruction_IF),
        .pc(pc_out)
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
        .op(opcode_ID),
        .funct(funct_ID),
        .zero(1'b1)
    );

    ext EXT(
        .ext_out(ext_out_ID),
        .imm(imm_ID),
        .extop(s_ext_ID)
    );

    alu ALU(
        .c(alu_out_EXE),
        .a(alu_a_EXE),
        .b(alu_b_EXE),
        .shamt(shamt_EXE),
        .alu_op(alu_op_EXE)
    );

    dm DM(
        .data_out(dm_out_MEM),
        .clock(clock),
        .mem_write(mem_write_MEM),
        .address(alu_out_MEM),
        .data_in(gpr_b_MEM)
    );

    gpr GPR(
        .a(gpr_a_ID),
        .b(gpr_b_ID),
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

    wire [31:0] alu_out_FWD;

    assign alu_out_FWD = alu_out_MEM;

    wire s_a_FWD;
    wire s_b_FWD;

    wire [31:0] gpr_a_FWD;
    wire [31:0] gpr_b_FWD;

    mux2_1 #(.WIDTH(32)) MUX_a_FWD(
        .y(gpr_a_FWD),
        .a(gpr_a_EXE),
        .b(alu_out_FWD),
        .sel(s_a_FWD)
    );

    mux2_1 #(.WIDTH(32)) MUX_b_FWD(
        .y(gpr_b_FWD),
        .a(gpr_b_EXE),
        .b(alu_out_FWD),
        .sel(s_b_FWD)
    );

    // control
    assign s_a_FWD = (num_write_MEM != 0 && num_write_MEM == rs_EXE) ? 1'b1 : 1'b0;
    assign s_b_FWD = (num_write_MEM != 0 && num_write_MEM == rt_EXE) ? 1'b1 : 1'b0;

    // forwarding from MEM to EXE end

    // forwarding from WB to EXE

    // forwarding from WB to EXE end

    // forwarding from WB to ID

    // forwarding from WB to ID end

    // forwardings end

    // non-forwarding multiplexers

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
        .b(ext_out_EXE),
        .sel(s_b_EXE)
    );

    mux4_1 #(.WIDTH(32)) MUX_data_write(
        .y(data_write_WB),
        .a(npc_WB),
        .b(alu_out_WB),
        .c(dm_out_WB),
        .sel(s_data_write_WB)
    );

    // non-forwarding multiplexers end

endmodule