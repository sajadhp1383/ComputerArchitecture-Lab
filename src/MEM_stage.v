module MEM_stage (
    input clk,
    input MEM_R_EN,
    input MEM_W_EN,
    input [31:0] ALU_res_in,
    input [31:0] Val_Rm_in,
    output [31:0] data_mem_out
);
  data_mem Data_Memory (
        .clk(clk),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .address(ALU_res_in),
        .write_data(Val_Rm_in),
        .read_data(data_mem_out)
    );

endmodule
