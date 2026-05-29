module EXE_stage (
    input [3:0] exe_cmd,
    input s_update,
    input imm,
    input c_in,
    input mem_r_en_in,
    input mem_w_en_in,
    input [31:0] pc_in,
    input [31:0] val_rn,
    input [31:0] val_rm,
    input [11:0] shift_operand,
    input [23:0] signed_imm_24,
    input [3:0] sr_status_bits_in,
    output [31:0] alu_result,
    output [31:0] val_rm_out,
    output [31:0] branch_address,
    output [3:0] status_bits_out
);

  wire [31:0] val2;
  wire mem_access;
  assign val_rm_out = val_rm;
  assign mem_access = mem_r_en_in | mem_w_en_in;
  wire [31:0] sign_extended_imm24 = {{8{signed_imm_24[23]}}, signed_imm_24};
  assign branch_address = pc_in + 32'd1 + sign_extended_imm24;
  Val2Generator val2_gen (
      .val_rm(val_rm),
      .shift_operand(shift_operand),
      .imm(imm),
      .mem_access(mem_access),
      .val2(val2)
  );

  ALU alu_inst (
      .val1(val_rn),
      .val2(val2),
      .exe_cmd(exe_cmd),
      .c_in(c_in),
      .alu_result(alu_result),
      .status_bits(status_bits_out)
  );

endmodule
