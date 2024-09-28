/** @module tb_gpr
 *  @brief GPR testbench
 */

`timescale 1ps/1ps

`include "gpr.v"

module tb_gpr;

    integer i;

    reg clk;

    reg [4:0] rs;
    reg [4:0] rt;
    reg [4:0] rd;
    wire [31:0] rs_data;
    wire [31:0] rt_data;
    reg [31:0] rd_data;
    reg reg_write;

    initial begin
        $dumpfile("tb_gpr.vcd");
        $dumpvars;
    end

    initial begin
        reg_write = 1; #10;
        for(i = 1; i < 32; i = i + 1) begin
            rd = i; rd_data = i; #10;
        end
        reg_write = 0; #10;
        for(i = 1; i < 32; i = i + 1) begin
            rd = i + 1; rd_data = i; #10;
        end
    end

    initial begin
        #700;
        for(i = 1; i < 32; i = i + 1) begin
            $display("gp_registers[%2d] = %h", i, GPR.gp_registers[i]);
        end
    end

    initial begin
        #800;
        for(i = 0; i < 32; i = i + 1) begin
            rs = i; rt = 31 - i; #10;
            $display("[%2d]: a = %h, b = %h", i, rs_data, rt_data);
        end
        $finish;
    end

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    gpr GPR (
        .a(rs_data),
        .b(rt_data),
        .clock(clk),
        .reg_write(reg_write),
        .num_write(rd),
        .rs(rs),
        .rt(rt),
        .data_write(rd_data)
    );

endmodule