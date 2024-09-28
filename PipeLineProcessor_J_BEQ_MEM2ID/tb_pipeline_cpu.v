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
        CPU.IM.ins_memory[ 5] = 32'h0043882a;
        // 000000 00010 00011 10001 00000 101010 slt $17, $2, $3
        CPU.IM.ins_memory[ 6] = 32'h00a4882a;
        // 000000 00101 00100 10001 00000 101010 slt $17, $5, $4
        CPU.IM.ins_memory[ 7] = 32'h12270008;
        // 000100 10001 00111 000000001000 beq $17, $7, 8
        CPU.IM.ins_memory[ 8] = 32'h24ea0064;
        CPU.IM.ins_memory[ 9] = 32'h00430820;
        CPU.IM.ins_memory[10] = 32'h00850823;
        CPU.IM.ins_memory[11] = 32'h00e90824;
        CPU.IM.ins_memory[12] = 32'h01013025;
        CPU.IM.ins_memory[13] = 32'h24420005;
        CPU.IM.ins_memory[14] = 32'h24840010;
        CPU.IM.ins_memory[15] = 32'h08000c05;
        CPU.IM.ins_memory[16] = 32'h34ec5555;
        CPU.IM.ins_memory[17] = 32'hac8d0000;
        CPU.IM.ins_memory[18] = 32'h01aa7820;
        CPU.IM.ins_memory[19] = 32'hac002000;
        CPU.IM.ins_memory[20] = 32'h00430820;
        CPU.IM.ins_memory[21] = 32'h00a12023;
        CPU.IM.ins_memory[22] = 32'h00293824;
        CPU.IM.ins_memory[23] = 32'h00e13025;
        CPU.IM.ins_memory[24] = 32'h24ea0064;
        CPU.IM.ins_memory[25] = 32'h34ec5555;
        CPU.IM.ins_memory[26] = 32'h8c0d0000;
        CPU.IM.ins_memory[27] = 32'h01aa7820;
        CPU.IM.ins_memory[28] = 32'h0c000c22;
        CPU.IM.ins_memory[29] = 32'h00430820;
        CPU.IM.ins_memory[30] = 32'h8c030008;
        CPU.IM.ins_memory[31] = 32'h31a35555;
        CPU.IM.ins_memory[32] = 32'h01013025;
        CPU.IM.ins_memory[33] = 32'h08000c21;
        CPU.IM.ins_memory[34] = 32'h8c0f0000;
        CPU.IM.ins_memory[35] = 32'h24080054;
        CPU.IM.ins_memory[36] = 32'h00084900;
        CPU.IM.ins_memory[37] = 32'h3c019321;
        CPU.IM.ins_memory[38] = 32'h342a55aa;
        CPU.IM.ins_memory[39] = 32'h000a59c0;
        CPU.IM.ins_memory[40] = 32'h03e00008;
        CPU.IM.ins_memory[41] = 32'h00430820;
    end

    initial begin
        reset = 0; #10;
        reset = 1;
    end

    initial begin
        #7200;
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