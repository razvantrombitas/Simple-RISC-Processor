`timescale 1ns / 1ps

module execute #( parameter A_SIZE = 10,
                  parameter D_SIZE = 32)
             (
              input                         clk,
              input                         reset,
              input         [15:0]          ir_execute,
              input         [A_SIZE-1:0]    pc,
              input         [D_SIZE-1:0]    operand_1_read,
              input         [D_SIZE-1:0]    operand_2_read,
              
              output logic  [D_SIZE-1:0]    result_execute,
              output logic  [2:0]           dest_execute,
              output logic  [D_SIZE-1:0]    comb_result_execute,
              output logic  [D_SIZE-1:0]    data_out_execute,
              output logic  [A_SIZE-1:0]    load_pc,
              output logic  [A_SIZE-1:0]    addr_execute,
              output logic                  wen_execute,
              output logic                  flag_result_execute,
              output logic                  load_pc_flag,
              output logic                  stall,
              output logic                  halt
            );
    
    wire    [6:0]           opcode;
    wire                    halt_flag;
    logic   [D_SIZE-1:0]    result;
    
    assign opcode = ir_execute[15:9]; 
    assign comb_result_execute = result;
    assign halt_flag = (opcode == `HALT);
    
    always_ff @(posedge clk)
        result_execute <= result;
        
    always_ff @(posedge clk, negedge reset) begin
        if (!reset) halt <= 0;
        else if (halt_flag) halt <= 1;
    end
       
    always_comb begin
        flag_result_execute     =     0;
        addr_execute            =     0;
        wen_execute             =     0;
        stall                   =     0;    
        load_pc_flag            =    '0;
        load_pc                 =    '0;
        result                  =    '0;
        dest_execute            =    '0;

        case(opcode) inside
            `ADD:               begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read + operand_2_read;
                                    flag_result_execute     = 1;
                                end
                                
            `ADDF:              begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read + operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `SUB:               begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read - operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `SUBF:              begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read - operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `AND:               begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read & operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `OR:                begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read | operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `XOR:               begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read ^ operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `NAND:              begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = ~(operand_1_read & operand_2_read);
                                    flag_result_execute     = 1;
                                end
            
            `NOR:               begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = ~(operand_1_read | operand_2_read);
                                    flag_result_execute     = 1;
                                end
            
            `NXOR:              begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = ~(operand_1_read ^ operand_2_read);
                                    flag_result_execute     = 1;
                                end
            
            `SHIFTR:            begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read >> operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `SHIFTRA:           begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read >>> operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            `SHIFTL:            begin
                                    dest_execute            = ir_execute[8:6];
                                    result                  = operand_1_read << operand_2_read;
                                    flag_result_execute     = 1;
                                end
            
            {`LOAD, 2'b??}:     begin
                                    addr_execute    = operand_2_read;
                                    stall           = 1;
                                end
            
            {`STORE, 2'b??}:    begin
                                    addr_execute        = operand_1_read;
                                    data_out_execute    = operand_2_read;
                                    wen_execute         = 1;     
                                end
            
            {`LOADC, 2'b??}:    begin
                                    dest_execute            = ir_execute[10:8];
                                    result                  = operand_1_read;
                                    flag_result_execute     = 1;
                                end
            
            {`JMP, 3'b???}:     begin
                                    load_pc_flag    = 1'b1;
                                    load_pc         = operand_1_read;
                                end
            
            {`JMPC, 3'b???}:    begin
                                    case(opcode[2:0])
                                        3'b000: if( operand_2_read < 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   operand_1_read;
                                                end
                                        3'b001: if( operand_2_read >= 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   operand_1_read;
                                                end
                                        3'b010: if( operand_2_read == 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   operand_1_read;
                                                end
                                        3'b011: if( operand_2_read != 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   operand_1_read;
                                                end
                                    endcase
                                end
            
            {`JMPR, 3'b???}:    begin
                                    load_pc_flag    =   1'b1;
                                    load_pc         =   pc + (operand_1_read - 2);
                                end
            
            {`JMPRC, 3'b???}:   begin
                                    case(opcode[2:0])
                                        3'b000: if( operand_1_read < 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   pc + (operand_2_read - 2);
                                                end
                                        3'b001: if( operand_1_read >= 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   pc + (operand_2_read - 2);
                                                end
                                        3'b010: if( operand_1_read == 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   pc + (operand_2_read - 2);
                                                end
                                        3'b011: if( operand_1_read != 0 ) begin
                                                    load_pc_flag    =   1'b1;
                                                    load_pc         =   pc + (operand_2_read - 2);
                                                end
                                    endcase
                                end
        endcase
    end
endmodule
