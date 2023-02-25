`timescale 1ns / 1ps

module fetch #( parameter A_SIZE = 10,
                parameter D_SIZE = 32)
            (
            input   logic                   clk,
            input   logic                   reset,
            input   logic   [15:0]          instruction,
            input   logic                   load_pc_flag,
            input   logic   [A_SIZE-1:0]    load_pc,   
            input   logic                   stall,
            
            output          [A_SIZE-1:0]    pc,
            output          [15:0]          ir
            );
    
    logic [A_SIZE-1:0] pc_l;
    logic [15:0] ir_l;
    
    assign ir = ir_l;
    assign pc = pc_l;
    
    always @(posedge clk, negedge reset)
        if(!reset) begin
            pc_l <= '0;
            ir_l <= instruction;
        end
        else begin
            if(load_pc_flag) begin
                pc_l <= load_pc;
                ir_l <= '0;
            end
            else if (!stall) begin
                pc_l <= pc_l + 1;
                ir_l <= instruction;
            end
        end
endmodule
