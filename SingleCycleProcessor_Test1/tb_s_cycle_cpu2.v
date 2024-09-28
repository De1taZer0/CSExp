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
        CPU.IM.ins_memory[0] = 32'h2001ffff;
        CPU.IM.ins_memory[1] = 32'h20020064;
        CPU.IM.ins_memory[2] = 32'h00221820;

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
        #500;
        $display("%d", CPU.GPR.gp_registers[1]);
        $display("%d", CPU.GPR.gp_registers[2]);
        $display("%d", CPU.GPR.gp_registers[3]);
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