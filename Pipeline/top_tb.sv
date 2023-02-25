`timescale 1ns / 1ps

module top_tb #( parameter A_SIZE = 10,
                 parameter D_SIZE = 32)
             ();
             
    logic   [15:0]          instruction;
    logic                   clk, reset;
    logic   [D_SIZE-1:0]    data_in;
    logic   [15:0]          program_memory[0:100];
    logic   [D_SIZE-1:0]    data_memory[0:100];
    logic   [A_SIZE-1:0]    mem_addr;
    wire    [A_SIZE-1:0]    pc;
    wire    [D_SIZE-1:0]    data_out;
    wire                    mem_wr_en;
    wire    [A_SIZE-1:0]    addr;    
    
    pipeline DUT(.*, .input_clk(clk));
   
    assign mem_addr = addr;
    
    always_ff @(posedge clk)
        data_in <= data_memory[mem_addr];
      
    always_ff @(posedge clk)
        if(mem_wr_en) data_memory[mem_addr] <= data_out;
        
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    assign instruction = program_memory[pc];

    initial begin
        // reset
        @(negedge clk) reset = 0;
        @(negedge clk) reset = 1;
        
        program_memory[0] = {`LOADC, `R0, 8'd1};
        program_memory[1] = {`LOADC, `R1, 8'd2};
        program_memory[2] = {`LOADC, `R1, 8'd3};
        program_memory[3] = {`NOP, '0};
        
//        program_memory[0] = {`LOADC, `R0, 8'd5};
//        program_memory[1] = {`LOADC, `R1, 8'd8};
//        program_memory[2] = {`NOP, '0};
//        program_memory[2] = {`NOP, '0};
//        program_memory[3] = {`ADD, `R2, `R1, `R0};
//        program_memory[4] = {`LOADC, `R1, 8'd50};
        repeat(10) @(negedge clk);
        #20 $stop;
        
//        // jump
//        program_memory[0] = {`LOADC, `R0, 8'd10};
//        program_memory[1] = {`LOADC, `R1, 8'd20};
//        program_memory[2] = {`LOADC, `R2, 8'd30};
//        program_memory[3] = {`LOADC, `R3, 8'd2};
//        program_memory[4] = {`JMP, 9'd0, `R0};
//        program_memory[5] = {`ADD, `R1, `R1, `R0};
//        program_memory[6] = {`ADD, `R0, `R0, `R0};
//        program_memory[7] = {`ADD, `R4, `R2, `R3};
//        program_memory[8] = {`NOP, '0};
//        program_memory[9] = {`NOP, '0};
        
//        // data dependency 
//        program_memory[0] = {`LOADC, `R0, 8'd9};
//        program_memory[1] = {`LOADC, `R1, 8'd10};
//        program_memory[2] = {`ADD, `R2, `R1, `R0};
//        program_memory[3] = {`ADD, `R1, `R1, `R0};
//        program_memory[4] = {`ADD, `R0, `R0, `R0};
//        program_memory[5] = {`NOP, '0};
//        program_memory[6] = {`NOP, '0};
//        program_memory[7] = {`NOP, '0};
        
//        // memory
//        program_memory[0] =  {`LOADC, `R0, 8'd10};
//        program_memory[1] =  {`LOADC, `R1, 8'd11};
//        program_memory[2] =  {`LOADC, `R2, 8'd12};
//        program_memory[3] =  {`LOADC, `R3, 8'd13};
//        program_memory[4] =  {`LOADC, `R4, 8'd14};
//        program_memory[5] =  {`LOADC, `R5, 8'd15};
//        program_memory[6] =  {`ADD, `R6, `R5, `R4};
//        program_memory[7] =  {`STORE, `R0, 5'd0, `R6};
//        program_memory[8] =  {`STORE, `R1, 5'd0, `R5};
//        program_memory[9] =  {`LOAD, `R7, 5'd0, `R0};
//        program_memory[10] = {`ADD, `R7, `R7, `R2};
         
    end
    
endmodule
