// arithmetic & logic
`define ADD       7'b0000001
`define ADDF      7'b0000010
`define SUB       7'b0000011
`define SUBF      7'b0000100
`define AND       7'b0000101
`define OR        7'b0000110
`define XOR       7'b0000111
`define NAND      7'b0001000
`define NOR       7'b0001001
`define NXOR      7'b0001010
`define SHIFTR    7'b0001011
`define SHIFTRA   7'b0001100
`define SHIFTL    7'b0001101
`define SHIFTLA   7'b0001110
// control
`define NOP       7'b0000000
`define HALT      7'b0001111
// memory 
`define LOAD      5'b00100
`define LOADC     5'b00101
`define STORE     5'b00110
// branching
`define JMP       4'b1000
`define JMPR      4'b1100
`define JMPC      4'b1010
`define JMPRC     4'b1110

// registers
`define R0  3'd0
`define R1  3'd1
`define R2  3'd2
`define R3  3'd3
`define R4  3'd4
`define R5  3'd5
`define R6  3'd6
`define R7  3'd7
