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

    input [ 1:0] sel_src1,
    input [ 1:0] sel_src2,
    input [31:0] alu_res_mem,
    input [31:0] wb_res,

    output [31:0] alu_result,
    output [31:0] val_rm_out,
    output [31:0] branch_address,
    output [ 3:0] status_bits_out
);

  wire [31:0] val2;
  wire mem_access;

  reg [31:0] forwarded_rn;
  always @(*) begin
    case (sel_src1)
      2'b00:   forwarded_rn = val_rn;
      2'b01:   forwarded_rn = alu_res_mem;
      2'b10:   forwarded_rn = wb_res;
      default: forwarded_rn = val_rn;
    endcase
  end

  reg [31:0] forwarded_rm;
  always @(*) begin
    case (sel_src2)
      2'b00:   forwarded_rm = val_rm;
      2'b01:   forwarded_rm = alu_res_mem;
      2'b10:   forwarded_rm = wb_res;
      default: forwarded_rm = val_rm;
    endcase
  end

  assign val_rm_out = forwarded_rm;

  assign mem_access = mem_r_en_in | mem_w_en_in;
  wire [31:0] sign_extended_imm24 = {{8{signed_imm_24[23]}}, signed_imm_24};
  assign branch_address = pc_in + 32'd1 + sign_extended_imm24;

  Val2Generator val2_gen (
      .val_rm(forwarded_rm),
      .shift_operand(shift_operand),
      .imm(imm),
      .mem_access(mem_access),
      .val2(val2)
  );

  ALU alu_inst (
      .val1(forwarded_rn),
      .val2(val2),
      .exe_cmd(exe_cmd),
      .c_in(c_in),
      .alu_result(alu_result),
      .status_bits(status_bits_out)
  );

endmodule
