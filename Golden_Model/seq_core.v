/////////////////////////////////////////////////////////
//                                                     // 
//        Simple RISC Processor Golden Model           //
//                                                     // 
/////////////////////////////////////////////////////////

`timescale 1ns/1ps

/////////////////////////////////////////////////////////
//                                                     // 
//                      OPCODES                        //
//                                                     // 
/////////////////////////////////////////////////////////
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
`define NOP       7'b0000000
`define HALT      7'b0001111

`define LOAD      5'b00100
`define LOADC     5'b00101
`define STORE     5'b00110

`define JMP       4'b1000
`define JMPR      4'b1100
`define JMPC      4'b1010
`define JMPRC     4'b1110

`define N          3'b000
`define NN         3'b001
`define Z          3'b010
`define NZ         3'b011

// registers
`define R0  3'd0
`define R1  3'd1
`define R2  3'd2
`define R3  3'd3
`define R4  3'd4
`define R5  3'd5
`define R6  3'd6
`define R7  3'd7


module seq_core
    #( parameter A_SIZE = 10,
       parameter D_SIZE = 32)
     (
                                            		// general
       input 			rst,                    // active 0
       input			clk,
                                            		// program memory
       output [A_SIZE-1:0] 	pc,
       input        [15:0] 	instruction,
                                            		// data memory
       output 			read,                   // active 1
       output 			write,                  // active 1
       output [A_SIZE-1:0]	address,
       input  [D_SIZE-1:0]	data_in,
       output [D_SIZE-1:0]	data_out
     );
     
    reg [D_SIZE-1:0] 	register [0:7], data_out_l;
    reg [A_SIZE-1:0] 	pc_l; 
    reg 		halt_l, read_l, write_l;
    reg [A_SIZE-1:0] 	address_l;
    integer 		i;

    assign pc       = pc_l;
    assign data_out = data_out_l;
    assign read     = read_l;
    assign write    = write_l;
    assign address  = address_l;

    always @(posedge clk or negedge rst) begin    
        if(!rst) begin 
            pc_l 	<= 0;
            halt_l 	<= 0;
            for (i = 0; i<=7; i=i+1) 
                register[i] = 0;
        end
        else if (instruction[15:9] == `HALT)
                 halt_l <= 1'b1;
        else if(!halt_l)
                case(instruction[15:12])
                    `JMP  :     pc_l <= register[instruction[2:0]];
                    `JMPR :     pc_l <= pc_l + instruction[5:0];
                    `JMPC :     case(instruction[11:9])
                                    `N  : if(register[instruction[8:6]] < 0)  pc_l <= register[instruction[2:0]];
                                    `NN : if(register[instruction[8:6]] >= 0) pc_l <= register[instruction[2:0]];
                                    `Z  : if(register[instruction[8:6]] == 0) pc_l <= register[instruction[2:0]];
                                    `NZ : if(register[instruction[8:6]] != 0) pc_l <= register[instruction[2:0]];
                                endcase
                    `JMPRC:     case(instruction[11:9])
                                    `N  : if(register[instruction[8:6]] < 0)  pc_l <= instruction[5:0];
                                    `NN : if(register[instruction[8:6]] >= 0) pc_l <= instruction[5:0];
                                    `Z  : if(register[instruction[8:6]] == 0) pc_l <= instruction[5:0];
                                    `NZ : if(register[instruction[8:6]] != 0) pc_l <= instruction[5:0];
                                endcase
                    default: pc_l <= pc_l + 1;
                endcase
    end
    
    always @(posedge clk or negedge rst) begin
        if(rst && !halt_l)
            casex(instruction[15:9])
                `ADD:                register[instruction[8:6]]                         <= register[instruction[5:3]] + register[instruction[2:0]];
                `ADDF:               register[instruction[8:6]]                         <= register[instruction[5:3]] + register[instruction[2:0]];
                `SUB:                register[instruction[8:6]]                         <= register[instruction[5:3]] - register[instruction[2:0]];
                `SUBF:               register[instruction[8:6]]                         <= register[instruction[5:3]] - register[instruction[2:0]];
                `AND:                register[instruction[8:6]]                         <= register[instruction[5:3]] & register[instruction[2:0]];
                `OR:                 register[instruction[8:6]]                         <= register[instruction[5:3]] | register[instruction[2:0]];
                `XOR:                register[instruction[8:6]]                         <= register[instruction[5:3]] ^ register[instruction[2:0]];
                `NAND:               register[instruction[8:6]]                         <= ~(register[instruction[5:3]] & register[instruction[2:0]]);
                `NOR:                register[instruction[8:6]]                         <= ~(register[instruction[5:3]] | register[instruction[2:0]]);
                `NXOR:               register[instruction[8:6]]                         <= ~(register[instruction[5:3]] ^ register[instruction[2:0]]);
                `SHIFTR:             register[instruction[8:6]]                         <= register[instruction[8:6]] >> instruction[5:0];
                `SHIFTRA:            register[instruction[8:6]]                         <= register[instruction[8:6]] >>> instruction[5:0];
                `SHIFTL:             register[instruction[8:6]]                         <= register[instruction[8:6]] << instruction[5:0];
                `SHIFTLA:            register[instruction[8:6]]                         <= register[instruction[8:6]] <<< instruction[5:0];
                {`LOAD, 2'bxx}:      register[instruction[10:8]]                        <= data_in;
                {`LOADC, 2'bxx}:     begin
                                        register[instruction[10:8]][7:0]                <= instruction[7:0];
                                     end
                {`STORE, 2'bxx}:     data_out_l                                         <= register[instruction[2:0]]; 
            endcase
    end
    
    always @(*) begin    
        case(instruction[15:11])
            `LOAD:   begin
                         read_l     = 1;
                         write_l    = 0;
                         address_l  = register[instruction[2:0]][A_SIZE-1:0];
                     end
            `STORE:  begin
                         read_l     = 0;
                         write_l    = 1;
                         address_l  = register[instruction[10:8]][A_SIZE-1:0];
                     end
            default: begin
                         write_l = 0;
                         read_l  = 0;
                     end
        endcase
    end
    
endmodule