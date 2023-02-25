`timescale 1ns / 1ps

module write_back #( parameter A_SIZE = 10,
                     parameter D_SIZE = 32)
                (
                input           [15:0]          ir_wb,
                input           [D_SIZE-1:0]    result_execute,
                input           [D_SIZE-1:0]    data_in,
        
                output          [D_SIZE-1:0]    result_wb,
                output logic    [2:0]           dest_wb,
                output logic                    write_en,
                output logic                    result_mux_sel        
    );
    
    wire [6:0] opcode;
    
    assign opcode       = ir_wb[15:9]; 
    assign result_wb    = result_mux_sel ? data_in : result_execute;
    
    always_comb begin
        dest_wb         = 0;
        result_mux_sel  = 0;
        write_en        = 0;
        
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
            `NXOR,
            `SHIFTR,
            `SHIFTRA,
            `SHIFTL:            begin
                                    dest_wb     = ir_wb[8:6];
                                    write_en    = 1;
                                end
            
            {`LOAD, 2'b??}:     begin
                                    dest_wb         = ir_wb[10:8];
                                    write_en        = 1;
                                    result_mux_sel  = 1;
                                end
            
            {`STORE, 2'b??}:    begin
                                    
                                end
            
            {`LOADC, 2'b??}:    begin
                                    dest_wb     = ir_wb[10:8];
                                    write_en    = 1;
                                end
            
            {`JMP, 3'b???}:     begin
                                    
                                end
            
            {`JMPC, 3'b???}:    begin
                                    
                                end
            
            {`JMPR, 3'b???}:    begin
                                    
                                end
            
            {`JMPRC, 3'b???}:   begin
                                    
                                end
        endcase
    end
endmodule
