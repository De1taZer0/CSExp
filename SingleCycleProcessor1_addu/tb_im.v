/** @module tb_im
 *  @brief IM testbench
 */

`timescale 1ps/1ps

`include "im.v"

module tb_im;

    integer i;

    wire [31:0] instruction;
    reg [31:0] pc;

    initial begin
        $dumpfile("tb_im.vcd");
        $dumpvars;
    end

    initial begin
        for(i = 0; i < 1024; i = i + 1)
            IM.ins_memory[i] = i;
    end

    initial begin
        pc = 32'h00003000; #10;
        for(i = 0; i < 20; i = i + 1) begin
            $display("pc = %h, instruction = %h", pc, instruction);
            pc =  pc + 4; #10;
        end
    end

    im IM(
        .instruction(instruction),
        .pc(pc)
    );

endmodule