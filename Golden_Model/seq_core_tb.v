`timescale 1ns/1ps
module seq_core_tb 
    #( parameter A_SIZE = 10,
       parameter D_SIZE = 32)
    ();
    reg     rst, clk;
    reg     [7:0] random_data, random_data1; 
    reg     [15:0] program_memory[0:15]; 
    wire    read, write;
    wire    [15:0] instruction;
    wire    [A_SIZE-1:0]   pc;
    reg     [D_SIZE-1:0]	data_in;
    wire    [A_SIZE-1:0]	address;
    wire    [D_SIZE-1:0]	data_out;

    seq_core DUT(.rst(rst),
                 .clk(clk),
                 .pc(pc),
                 .instruction(instruction),
                 .read(read),
                 .write(write),
                 .address(address),
                 .data_in(data_in),
                 .data_out(data_out)
                 );
    
    assign instruction = program_memory[pc];
    
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;     
    end

    initial begin
        
        program_memory[0] = {`LOADC, `R1, 8'd3};
        program_memory[1] = {`JMP, 9'd0, `R1};
        
        rst = 1;
        #5 rst = 0;
        #10 rst = 1;
        
        program_memory[2] = {`LOADC, `R0, 8'd4};
        program_memory[3] = {`LOADC, `R7, 8'd10};
        program_memory[4] = {`ADD, `R2, `R0, `R1};
        program_memory[5] = {`ADD, `R2, `R2, `R1};
        program_memory[6] = {`ADD, `R2, `R2, `R1};
        program_memory[7] = {`LOADC, `R3, 8'd3};
        program_memory[8] = {`STORE, `R0, 5'd0, `R3};
        program_memory[9] = {`JMP, 9'd0, `R3};
        program_memory[10] = {`HALT, 9'd0};
        program_memory[11] = {`ADD, `R2, `R0, `R1};
        
        repeat(100) @(posedge clk);
            $stop;
    end
endmodule