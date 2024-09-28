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
        CPU.DM.data_memory[1] = 1234;
        CPU.DM.data_memory[2] = 2683;
    end

    initial begin
        CPU.IM.ins_memory[0] = 32'h8c010004; // lw $1, 4($0)
        CPU.IM.ins_memory[1] = 32'h8c020008; // lw $2, 8($0)
        CPU.IM.ins_memory[2] = 32'h00221820; // add $3, $1, $2
        CPU.IM.ins_memory[3] = 32'hac03000c; // sw $3, 12($0)
    end

    initial begin
        reset = 0; #10;
        reset = 1; #10;
    end

    initial begin
        #100;
        $display("DM[1] = %d", CPU.DM.data_memory[1]);
        $display("DM[2] = %d", CPU.DM.data_memory[2]);
        $display("DM[3] = %d", CPU.DM.data_memory[3]);
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