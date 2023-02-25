`timescale 1ns / 1ps
module registers #( parameter A_SIZE = 10,
                    parameter D_SIZE = 32)
                (
                input                   clk,
                input                   reset,
                input   [2:0]           dest_wb,
                input   [D_SIZE-1:0]    result_wb,
                input   [2:0]           addr_1_reg,
                input   [2:0]           addr_2_reg,
                input                   write_en,
                input                   result_mux_sel,
                input   [D_SIZE-1:0]    data_in,
              
                output  [D_SIZE-1:0]    data_1_reg,
                output  [D_SIZE-1:0]    data_2_reg
            );
    
    logic [D_SIZE-1:0] program_memory [0:7];
    
    assign data_1_reg   = program_memory[addr_1_reg];
    assign data_2_reg   = program_memory[addr_2_reg];
    
    always @(posedge clk, negedge reset) begin
        if(!reset)
            for (int i = 0; i<=7; i=i+1) begin
                program_memory[i] = '0;
            end
        else if (write_en)
                program_memory[dest_wb] <= result_wb;
    end
endmodule
