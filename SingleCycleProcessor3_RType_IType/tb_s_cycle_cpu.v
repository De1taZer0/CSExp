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
        CPU.IM.ins_memory[0] = 32'h200103e8; // addi  $1, $0, 1000
        CPU.IM.ins_memory[1] = 32'h242200c7; // addiu $2, $1,  199
        CPU.IM.ins_memory[2] = 32'h20030002; // addi  $3, $0,    2
        CPU.IM.ins_memory[3] = 32'h30640006; // andi  $4, $3,    6
        CPU.IM.ins_memory[4] = 32'h34650004; // ori   $5, $3,    4
        CPU.IM.ins_memory[5] = 32'h3c060064; // lui   $6,    100
    end

    initial begin
        reset = 0; #10;
        reset = 1; #10;
    end

    initial begin
        #100;
        $display("gpr[1] = %d", CPU.GPR.gp_registers[1]);
        $display("gpr[2] = %d", CPU.GPR.gp_registers[2]);
        $display("gpr[3] = %d", CPU.GPR.gp_registers[3]);
        $display("gpr[4] = %d", CPU.GPR.gp_registers[4]);
        $display("gpr[5] = %d", CPU.GPR.gp_registers[5]);
        $display("gpr[6] = %d", CPU.GPR.gp_registers[6]);
        $finish;
    end

    always @(posedge clock) begin
        $display("time = %d", $time);
        $display("PC = %h, instruction = %h", CPU.pc_out, CPU.im_out);
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