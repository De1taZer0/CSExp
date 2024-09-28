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
        CPU.IM.ins_memory[ 0] = 32'h00a63824; // and $7, $5, $6
        CPU.IM.ins_memory[ 1] = 32'h214b002d; // addi $11, $10, 45
        CPU.IM.ins_memory[ 2] = 32'h00430820; // add $1, $2, $3
        CPU.IM.ins_memory[ 3] = 32'h00a12023; // subu $4, $5, $1
        CPU.IM.ins_memory[ 4] = 32'h248a0064; // addi $10, $8, 100
        CPU.IM.ins_memory[ 5] = 32'h354c5555; // ori $12, $10, 0x5555
        CPU.IM.ins_memory[ 6] = 32'h00a64024; // and $8, $5, $6
        CPU.IM.ins_memory[ 7] = 32'h00220020; // add $0, $1, $2
        CPU.IM.ins_memory[ 8] = 32'h200d002d; // addi $13, $0, 45

        /**
         * @note 0号寄存器数据冒险需要特殊处理
         */

        CPU.IM.ins_memory[ 9] = 32'h00c54823; // subu $9, $6, $5
        CPU.IM.ins_memory[10] = 32'h00c31025; // or $2, $6, $3
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