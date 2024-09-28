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
        CPU.IM.ins_memory[0] = 32'h00430820; // add $1, $2, $3
        CPU.IM.ins_memory[1] = 32'h00a62023; // subu $4, $5, $6
        CPU.IM.ins_memory[2] = 32'h01093824; // and $7, $8, $9
        CPU.IM.ins_memory[3] = 32'h256a0064; // addiu $10, $11, 100
        CPU.IM.ins_memory[4] = 32'h35ac5555; // ori $12, $10, 0x5555
        CPU.IM.ins_memory[5] = 32'hac0e0008; // sw $14, 8($0)
        CPU.IM.ins_memory[6] = 32'h8c0f0008; // lw $15, 8($0)
        CPU.IM.ins_memory[7] = 32'h0232802a; // slt $16, $17, $18
        CPU.IM.ins_memory[8] = 32'h3c130064; // lui $19, 100
        CPU.IM.ins_memory[9] = 32'h02b6a025; // or $20, $21, $22
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