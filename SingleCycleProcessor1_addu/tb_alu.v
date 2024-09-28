/** @module tb_alu
 *  @brief ALU testbench
 */
`timescale 1ps/1ps

`include "alu.v"

module tb_alu;

    integer i;

    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] alu_out;

    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars;
    end

    initial begin
        $monitor("a = %d, b = %d, alu_out = %d", a, b, alu_out);
    end

    initial begin
        for(i = 0; i < 20; i = i + 1) begin
            a = $random;
            b = $random;
            #10;
        end
    end

    alu ALU (
        .a(a),
        .b(b),
        .c(alu_out)
    );

endmodule