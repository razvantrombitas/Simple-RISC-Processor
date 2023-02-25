`timescale 1ns / 1ps
module data_dependency #( parameter A_SIZE = 10,
                          parameter D_SIZE = 32)
                   (
                    input  logic                    reset_execute,
                    input  logic                    reset_wb,
                    input  logic                    write_en,
                    input  logic                    flag_result_execute,
                    input  logic    [2:0]           raddr_1,
                    input  logic    [2:0]           raddr_2,
                    input  logic    [2:0]           dest_wb,
                    input  logic    [2:0]           dest_execute,
                    input  logic    [D_SIZE-1:0]    result_wb,
                    input  logic    [D_SIZE-1:0]    comb_result_execute,
                    input  logic    [D_SIZE-1:0]    data_1_reg,
                    input  logic    [D_SIZE-1:0]    data_2_reg,

                    output logic    [D_SIZE-1:0]    rdata_1,
                    output logic    [D_SIZE-1:0]    rdata_2,
                    output logic    [2:0]           addr_1_reg,
                    output logic    [2:0]           addr_2_reg
                );
    
    assign addr_1_reg = raddr_1;
    assign addr_2_reg = raddr_2;
        
    always_comb
        if ((dest_wb == raddr_1) & reset_wb & write_en)
            rdata_1 = result_wb;
        else if ((dest_execute == raddr_1) & reset_execute & flag_result_execute)
            rdata_1 = comb_result_execute;
        else
            rdata_1 = data_1_reg;
            
     always_comb
        if ((dest_wb == raddr_2) & reset_wb & write_en)
            rdata_2 = result_wb;
        else if ((dest_execute == raddr_2) & reset_execute & flag_result_execute)
            rdata_2 = comb_result_execute;
        else
            rdata_2 = data_2_reg;       
endmodule
