/** @module tb_pc
 *  @brief pc testbench
 */
`timescale 1ps/1ps

`include "pc.v"

module tb_pc;

    integer i;

    reg clock;
    reg reset;
    reg [31:0] npc;
    wire [31:0] pc;

    initial begin
        $dumpfile("tb_pc.vcd");
        $dumpvars;
    end

    initial begin
        $monitor("pc = %h, npc = %h", pc, npc);
    end

    always @(*) npc = pc + 4;

    initial begin
        clock = 0; reset = 1;
        #10 reset = 0; #10 reset = 1;
        #200 $finish;
    end

    always begin
        #5 clock = ~clock;
    end

    pc PC (
        .pc(pc),
        .clock(clock),
        .reset(reset),
        .npc(npc)
    );

endmodule