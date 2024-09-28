/** @module hazard_ctrl
 *  @brief 冒险控制模块
 *  @param s_a_FWD_EXE
 *  @param s_b_FWD_EXE
 *  @param s_a_FWD_ID
 *  @param s_b_FWD_ID
 *  @param nWrite_PC
 *  @param nWrite_IF_ID
 *  @param flush_IF_ID
 *  @param flush_ID_EXE
 *  @param rs_ID
 *  @param rt_ID
 *  @param inst_type_ID
 *  @param s_b_ID
 *  @param rs_EXE
 *  @param rt_EXE
 *  @param num_write_EXE
 *  @param inst_type_EXE
 *  @param reg_write_MEM
 *  @param num_write_MEM
 *  @param num_write_WB
 */

`include "def.v"

module hazard_ctrl(
    output reg [1:0] s_a_FWD_EXE,
    output reg [1:0] s_b_FWD_EXE,
    output reg s_a_FWD_ID,
    output reg s_b_FWD_ID,
    output reg nWrite_PC,
    output reg nWrite_IF_ID,
    output reg flush_IF_ID,
    output reg flush_ID_EXE,
    input [4:0] rs_ID,
    input [4:0] rt_ID,
    input [1:0] inst_type_ID,
    input s_b_ID,
    input [4:0] rs_EXE,
    input [4:0] rt_EXE,
    input [4:0] num_write_EXE,
    input [1:0] inst_type_EXE,
    input reg_write_MEM,
    input [4:0] num_write_MEM,
    input reg_write_WB,
    input [4:0] num_write_WB);

    always @(*)
    begin
        /**
         * @note MEM要在WB之前判定
         * @note 前递是有优先级的
         */
        s_a_FWD_EXE = `EXE_NOFWD;
        s_a_FWD_ID = `ID_NOFWD;
        if(num_write_WB != 0 && reg_write_WB == 1 && num_write_WB == rs_ID)
            s_a_FWD_ID = `WB2ID_FWD;
        if(num_write_MEM != 0 && reg_write_MEM == 1 && num_write_MEM == rs_EXE)
            s_a_FWD_EXE = `MEM2EXE_FWD;
        else if(num_write_WB != 0 && reg_write_WB == 1 && num_write_WB == rs_EXE) 
            s_a_FWD_EXE = `WB2EXE_FWD;

        s_b_FWD_EXE = `EXE_NOFWD;
        s_b_FWD_ID = `ID_NOFWD;
        if(num_write_WB != 0 && reg_write_WB == 1 && num_write_WB == rt_ID)
            s_b_FWD_ID = `WB2ID_FWD;
        if(num_write_MEM != 0 && reg_write_MEM == 1 && num_write_MEM == rt_EXE)
            s_b_FWD_EXE = `MEM2EXE_FWD;
        else if(num_write_WB != 0 && reg_write_WB == 1 && num_write_WB == rt_EXE) 
            s_b_FWD_EXE = `WB2EXE_FWD;


        /**
         * halt要提前一个周期判断，否则在halt更新后才会停止，导致多执行一个周期
         */
        nWrite_PC = 0;
        nWrite_IF_ID = 0;
        flush_ID_EXE = 0;
        if(inst_type_EXE == `INST_LW && num_write_EXE != 0)
        begin
            if(num_write_EXE == rs_ID || (s_b_ID != 1 && num_write_EXE == rt_ID))
            begin
                nWrite_PC = 1;
                nWrite_IF_ID = 1;
                flush_ID_EXE = 1;
            end
        end

        flush_IF_ID = 0;
        if(inst_type_ID == `INST_J_TYPE)
        begin
            flush_IF_ID = 1;
        end
    end

endmodule