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
        for(i = 1; i < 11; i = i + 1)
            CPU.GPR.gp_registers[i] = i;
    end

    initial begin
        CPU.IM.ins_memory[0] = 32'h00225821; // addu $11, $1 , $2
        CPU.IM.ins_memory[1] = 32'h01635823; // subu $11, $11, $3
        CPU.IM.ins_memory[2] = 32'h0164a821; // addu $21, $11, $4
        CPU.IM.ins_memory[3] = 32'h00a6582a; // slt  $11, $5 , $6
        CPU.IM.ins_memory[4] = 32'h00c5602a; // slt  $12, $6 , $5
        CPU.IM.ins_memory[5] = 32'h016cb023; // subu $21, $11, $12
        CPU.IM.ins_memory[6] = 32'h00e85824; // and  $11, $7 , $8
        CPU.IM.ins_memory[7] = 32'h012a6024; // and  $21, $9 , $10
        CPU.IM.ins_memory[8] = 32'h016cb825; // or   $21, $11, $12
    end

    initial begin
        reset = 0; #10;
        reset = 1; #10;
    end

    initial begin
        #100;
        $display("gpr[21] = %h", CPU.GPR.gp_registers[21]);
        $display("gpr[22] = %h", CPU.GPR.gp_registers[22]);
        $display("gpr[23] = %h", CPU.GPR.gp_registers[23]);
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