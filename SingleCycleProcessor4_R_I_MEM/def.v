`define OPCODE_SPECIAL 6'b000000

`define ADD  6'b0000
`define ADDU 6'b0001
`define SUBU 6'b0011
`define AND  6'b0100
`define OR   6'b0101
`define SLT  6'b1010
`define LUI  6'b1011

`define OPCODE_ADDI  6'b001000
`define OPCODE_ADDIU 6'b001001
`define OPCODE_ANDI  6'b001100
`define OPCODE_ORI   6'b001101
`define OPCODE_LUI   6'b001111

`define OPCODE_LW 6'b100011
`define OPCODE_SW 6'b101011

`define EXTOP_ZEROEXTEND 2'b00
`define EXTOP_SIGNEXTEND 2'b01