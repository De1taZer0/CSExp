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
        for(i = 0; i <= 31; i = i + 1)
        begin
            CPU.GPR.gp_registers[i] = i;
        end
    end

    initial begin
        for(i = 0;i <= 9; i = i + 1)
        begin
            CPU.DM.data_memory[i] = i + 32'haa;
        end
    end

    initial begin
        CPU.IM.ins_memory[ 0] = 32'hac020000;
        // 101011 00000 00010 0000000000000000 sw $2, 0($0)
        CPU.IM.ins_memory[ 1] = 32'h00430820;
        // 000000 00010 00011 00001 00000 100000 add $1, $2, $3
        CPU.IM.ins_memory[ 2] = 32'h00a12023;
        // 000000 00101 00001 00100 00000 100011 subu $4, $5, $1
        CPU.IM.ins_memory[ 3] = 32'h00293824;
        // 000000 00001 01001 00111 00000 100100 and $7, $1, $9
        CPU.IM.ins_memory[ 4] = 32'h00e13025;
        // 000000 00111 00001 00110 00000 100101 or $6, $7, $1
        CPU.IM.ins_memory[ 5] = 32'h24ea0064;
        // 001001 00111 01010 0000000001100100 addiu $10, $7, 100
        CPU.IM.ins_memory[ 6] = 32'h34ec5555;
        // 001101 00111 01100 0101010101010101 ori $12, $7, 0x5555
        CPU.IM.ins_memory[ 7] = 32'h8c0d0000;
        // 100011 00000 01101 0000000000000000 lw $13, 0($0)
        CPU.IM.ins_memory[ 8] = 32'h01aa7820;
        // 000000 01101 01010 01111 00000 100000 add $15, $13, $10 
        CPU.IM.ins_memory[ 9] = 32'h0c000c0f;

        CPU.IM.ins_memory[10] = 32'h00430820;

        CPU.IM.ins_memory[11] = 32'hac0f0000;

        CPU.IM.ins_memory[12] = 32'hac0f0004;

        CPU.IM.ins_memory[13] = 32'h24080054;

        CPU.IM.ins_memory[14] = 32'h00084900;

        CPU.IM.ins_memory[15] = 32'h3c019321;
        // 001111 00000 00001 1001001001000001 lui $1, 0x9321
        CPU.IM.ins_memory[16] = 32'h342a55aa;

        CPU.IM.ins_memory[17] = 32'h000a59c0;

        CPU.IM.ins_memory[18] = 32'h03e00008;

        CPU.IM.ins_memory[19] = 32'h00430820;
        // 000000 00010 00011 00001 00000 100000 add $1, $2, $3
    end

    initial begin
        reset = 0; #10;
        reset = 1;
    end

    always @(posedge clock) begin
        $display("time = %d", $time);
        $display("PC = %h", CPU.PC.pc);
    end

    initial begin
        #375;
        for(i = 1; i <= 31; i = i + 1)
            $display("GPR[%2d] = %h", i, CPU.GPR.gp_registers[i]);
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