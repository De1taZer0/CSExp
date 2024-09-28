`define ADD  4'b0000
`define ADDU 4'b0001
`define SUBU 4'b0011
`define AND  4'b0100
`define OR   4'b0101
`define SRAV 4'b0111
`define SLT  4'b1010
`define SLTU 4'b1011
`define BEQ  4'b1100
`define LUI  4'b1111

`define OPCODE_SPECIAL 6'b000000

`define OPCODE_ADDI  6'b001000
`define OPCODE_ADDIU 6'b001001
`define OPCODE_ANDI  6'b001100
`define OPCODE_ORI   6'b001101
`define OPCODE_LUI   6'b001111

`define OPCODE_SLTIU 6'b001011

`define OPCODE_LW 6'b100011
`define OPCODE_SW 6'b101011

`define OPCODE_BEQ 6'b000100
`define OPCODE_J   6'b000010
`define OPCODE_JAL 6'b000011

`define FUNCT_ADD  6'b100000
`define FUNCT_ADDU 6'b100001
`define FUNCT_SUBU 6'b100011
`define FUNCT_AND  6'b100100
`define FUNCT_OR   6'b100101
`define FUNCT_SRAV 6'b000111
`define FUNCT_SLT  6'b101010
`define FUNCT_SLTU 6'b101011

`define FUNCT_JR   6'b001000

`define EXTOP_ZEROEXTEND 2'b00
`define EXTOP_SIGNEXTEND 2'b01

`define N_nPC   2'b00
`define J_nPC   2'b01
`define JR_nPC  2'b10
`define BEQ_nPC 2'b11

`define Data_write_nPC 2'b00
`define Data_write_ALU 2'b01
`define Data_write_MEM 2'b10

`define Num_write_rt 2'b00
`define Num_write_rd 2'b01
`define Num_write_31 2'b10

`define ALU_a_nPC 2'b00
`define ALU_a_REG 2'b01