/** @module tb_s_cycle_cpu
 *  @brief Single Cycle CPU testbench
 */

`timescale 1ps/1ps

`include "s_cycle_cpu.v"

module tb_s_cycle_cpu;

    integer i;

    reg clock;
    reg reset;
    
    initial begin
        $dumpfile("tb_s_cycle_cpu.vcd");
        $dumpvars;
    end

    initial begin
        CPU.DM.data_memory[0] = 1000;
    end

    initial begin
        CPU.IM.ins_memory[0] = 32'h20010000; // addi $1, $0, 0
        CPU.IM.ins_memory[1] = 32'h20020000; // addi $2, $0, 0
        CPU.IM.ins_memory[2] = 32'h8c030000; // lw $3, 0($0)
        CPU.IM.ins_memory[3] = 32'h20210001; // loop: addi $1, $1, 1
        CPU.IM.ins_memory[4] = 32'h00411020; // add $2, $2, $1
        CPU.IM.ins_memory[5] = 32'h10230001; // beq $1, $3, loopEnd
        CPU.IM.ins_memory[6] = 32'h08000c03; // j loop
        CPU.IM.ins_memory[7] = 32'hac020004; // loopEnd: sw $2, 4($0)
    end

    initial begin
        reset = 0; #10;
        reset = 1; #10;
    end
/*
    always @(posedge clock) begin
        $display("time = %d", $time);
        $display("PC = %h, instruction = %h", CPU.pc_out, CPU.im_out);
        $display("data_write = %d, reg_write = %d", CPU.data_write, CPU.reg_write);
        $display("mem_write = %d", CPU.mem_write);
        $display("GPR[1] = %d, GPR[2] = %d, GPR[3] = %d", CPU.GPR.gp_registers[1], CPU.GPR.gp_registers[2], CPU.GPR.gp_registers[3]);
    end
*/
    initial begin
        #50000;
        $display("DM[1] = %d", CPU.DM.data_memory[1]);
        $finish;
    end

    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
        end
    end

    s_cycle_cpu CPU(
        .clock(clock),
        .reset(reset)
    );

endmodule