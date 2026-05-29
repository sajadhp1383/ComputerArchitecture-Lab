module WB_stage (
    input MEM_R_EN,
    input [31:0] ALU_res,
    input [31:0] data_mem_out,
    output [31:0] write_back_data
);
  assign write_back_data = MEM_R_EN ? data_mem_out : ALU_res;
endmodule
