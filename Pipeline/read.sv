`timescale 1ns / 1ps
`include "defines.sv"

module read #( parameter A_SIZE = 10,
               parameter D_SIZE = 32)
            (
            input   logic                   clk,            
            input   logic   [15:0]          ir,
            input   logic   [D_SIZE-1:0]    rdata_1,
            input   logic   [D_SIZE-1:0]    rdata_2, 
            
            output  logic   [D_SIZE-1:0]    operand_1_read,
            output  logic   [D_SIZE-1:0]    operand_2_read,
            output  logic   [2:0]           raddr_1,
            output  logic   [2:0]           raddr_2
            );
            
    wire [6:0] opcode;

    logic [D_SIZE-1:0] operand_1;
    logic [D_SIZE-1:0] operand_2;
    
    assign opcode = ir[15:9]; 
    
    always @(posedge clk) begin
        operand_1_read <= operand_1;
        operand_2_read <= operand_2;
    end
    
    always @(*) begin
        
        // set default values in order to avoid inferred latches in design or use always_comb
        raddr_1 = '0;
        raddr_2 = '0;
        operand_1  = '0;
        operand_2  = '0;
        
        case(opcode) inside
            `ADD,
            `ADDF,
            `SUB,
            `SUBF,
            `AND,
            `OR,
            `XOR,
            `NAND,
            `NOR,
            `NXOR:              begin
                                    raddr_1 = ir[5:3];
                                    raddr_2 = ir[2:0];
                                    operand_1  = rdata_1;
                                    operand_2  = rdata_2;
                                end
            
            `SHIFTR,
            `SHIFTRA,
            `SHIFTL:            begin
                                    raddr_1 = ir[8:6];
                                    operand_1  = rdata_1;
                                    operand_2  = {'0, ir[5:0]};
                                end
            
            {`LOAD, 2'b??},
            {`STORE, 2'b??}:    begin
                                    raddr_1 = ir[10:8];
                                    raddr_2 = ir[2:0];
                                    operand_1  = rdata_1;
                                    operand_2  = rdata_2;
                                end
            
            {`LOADC, 2'b??}:    begin
                                    operand_1  = ir[7:0];
                                end
            
            {`JMP, 3'b???}:     begin
                                    raddr_1 = ir[2:0]; 
                                    operand_1  = rdata_1;
                                end
            
            {`JMPC, 3'b???}:    begin
                                    raddr_1 = ir[8:6];
                                    raddr_2 = ir[2:0];
                                    operand_1  = rdata_2;
                                    operand_2  = rdata_1;
                                end
            
            {`JMPR, 3'b???}:    operand_1 = {'0, ir[5:0]};
            
            {`JMPRC, 3'b???}:   begin
                                    raddr_1 = ir[8:6]; 
                                    operand_1  = rdata_1;
                                    operand_2  = {'0, ir[5:0]};
                                end
        endcase
    end
    
endmodule
