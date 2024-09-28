/** @module tb_pipeline_cpu
 *  @brief Pipeline CPU testbench
 */

`timescale 1ps/1ps

`include "pipeline_cpu.v"

module tb_pipeline_cpu;

    integer i;

    reg clock;
    reg reset;
    
    initial begin
        $dumpfile("tb_pipeline_cpu.vcd");
        $dumpvars;
    end

    initial begin
        for(i = 1; i <= 31; i = i + 1)
        begin
            CPU.GPR.gp_registers[i] = i;
        end
    end

    initial begin
        CPU.IM.ins_memory[ 0] = 32'h00430820;
        CPU.IM.ins_memory[ 1] = 32'h00a12023;
        CPU.IM.ins_memory[ 2] = 32'h00293824;
        CPU.IM.ins_memory[ 3] = 32'h01933824;
        CPU.IM.ins_memory[ 4] = 32'h00e13025;
        CPU.IM.ins_memory[ 5] = 32'h24ea0064;
        CPU.IM.ins_memory[ 6] = 32'h34ec5555;
        CPU.IM.ins_memory[ 7] = 32'h00a64024;
        CPU.IM.ins_memory[ 8] = 32'h214d002d;
        CPU.IM.ins_memory[ 9] = 32'h00c54823;
        CPU.IM.ins_memory[10] = 32'h00c31025;
    end

    initial begin
        reset = 0; #10;
        reset = 1; #10;
    end

    initial begin
        #1000;
        for(i = 1; i <= 31; i = i + 1)
            $display("GPR[%d] = %h", i, CPU.GPR.gp_registers[i]);
        $finish;
    end

    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
        end
    end

    pipeline_cpu CPU(
        .clock(clock),
        .reset(reset)
    );

endmodule