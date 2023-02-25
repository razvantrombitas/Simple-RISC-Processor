`timescale 1ns / 1ps
module pipeline #( parameter A_SIZE = 10,
                   parameter D_SIZE = 32)
                (
                input                           input_clk,
                input                           reset,
                input           [15:0]          instruction,
                input           [D_SIZE-1:0]    data_in,
                
                output          [A_SIZE-1:0]    pc,
                output logic    [D_SIZE-1:0]    data_out,
                output          [A_SIZE-1:0]    addr,
                output logic                    mem_wr_en
                );
  
    wire [15:0]         ir;
    wire [D_SIZE-1:0]   operand_1_read, operand_2_read;
    wire [2:0]          addr_1_reg, addr_2_reg, raddr_1, raddr_2;
    wire [D_SIZE-1:0]   data_1_reg, data_2_reg, rdata_1, rdata_2;
    wire [2:0]          dest_wb;
    wire [D_SIZE-1:0]   result_wb, result_execute;
    wire                write_en;
    wire [2:0]          dest_execute;
    wire [D_SIZE-1:0]   comb_result_execute;
    wire                load_pc_flag;
    wire [A_SIZE-1:0]   load_pc;
    wire                flag_result_execute;
    wire [A_SIZE-1:0]   addr_execute;
    wire                wen_execute;
    wire [D_SIZE-1:0]   data_out_execute;
    wire                result_mux_sel, stall, halt;
    
    logic [15:0]    ir_execute;
    logic [15:0]    ir_wb;
    logic           reset_read;
    logic           reset_execute;
    logic           reset_wb;
  
    assign addr     = addr_execute;
    assign clk      = halt ? 0 : input_clk;
  
    fetch               fetch_stage(.*);
    read                read_stage(.*);
    registers           registers_block(.*);
    execute             execute_stage(.*);
    write_back          write_back_stage(.*);
    data_dependency     data_dependency_block(.*);

    always @(posedge clk)
        if(load_pc_flag | stall) ir_execute <= '0;
        else        ir_execute <= ir;
        
    always @(posedge clk)
        ir_wb <= ir_execute;
        
    always_ff @(posedge clk, negedge reset)
        reset_read <= reset;
        
    always_ff @(posedge clk, negedge reset)
        reset_execute <= reset & reset_read;
        
    always_ff @(posedge clk, negedge reset)
        reset_wb <= reset & reset_read & reset_execute;
        
    always_comb begin
        mem_wr_en = wen_execute;
        data_out  = data_out_execute;
    end

endmodule
