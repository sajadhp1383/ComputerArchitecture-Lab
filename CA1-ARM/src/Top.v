module Top (
    input clk,
    input rst
);

  wire [31:0] PC_IF, Instruction_IF;
  wire [31:0] Branch_Address;
  wire B_EXE;
  IF_stage IF_stage_inst (
      .clk(clk),
      .rst(rst),
      .freeze(1'b0),
      .Branch_taken(B_EXE),
      .BranchAddr(Branch_Address),
      .PC(PC_IF),
      .Instruction(Instruction_IF)
  );

  wire [31:0] PC_ID, Instruction_ID;
  IF_stage_reg IF_reg (
      .clk(clk),
      .rst(rst),
      .freeze(1'b0),
      .flush(B_EXE),
      .PC_in(PC_IF),
      .Instruction_in(Instruction_IF),
      .PC(PC_ID),
      .Instruction(Instruction_ID)
  );

  wire [31:0] PC_ID_out, Val_Rn_ID, Val_Rm_ID;
  wire [23:0] signed_imm_24_ID;
  wire [3:0] EXE_CMD_ID, Dest_ID, src1_ID, src2_ID;
  wire MEM_R_EN_ID, MEM_W_EN_ID, WB_EN_ID, B_ID, S_ID, Two_src_ID;
  wire [11:0] shift_operand_ID;
  wire        imm_ID;
  wire [ 3:0] SR;

  ID_stage ID_stage_inst (
      .clk(clk),
      .rst(rst),
      .PC_in(PC_ID),
      .Instruction(Instruction_ID),
      .SR(SR),
      .WB_WB_EN(1'b0),
      .WB_WB_Dest(4'd0),
      .WB_WB_Value(32'd0),
      .PC(PC_ID_out),
      .EXE_CMD(EXE_CMD_ID),
      .MEM_R_EN(MEM_R_EN_ID),
      .MEM_W_EN(MEM_W_EN_ID),
      .WB_EN(WB_EN_ID),
      .Val_Rn(Val_Rn_ID),
      .Val_Rm(Val_Rm_ID),
      .B(B_ID),
      .S(S_ID),
      .signed_imm_24(signed_imm_24_ID),
      .shift_operand(shift_operand_ID),
      .imm(imm_ID),
      .Dest(Dest_ID)
  );

  wire [31:0] PC_EXE, Val_Rn_EXE, Val_Rm_EXE;
  wire [23:0] signed_imm_24_EXE;
  wire [3:0] EXE_CMD_EXE, Dest_EXE, src1_EXE, src2_EXE;
  wire MEM_R_EN_EXE, MEM_W_EN_EXE, WB_EN_EXE, S_EXE, Two_src_EXE;
  wire [11:0] shift_operand_EXE;
  wire c_out;
  wire imm_EXE;
  ID_stage_reg ID_reg (
      .clk(clk),
      .rst(rst),
      .WB_EN_in(WB_EN_ID),
      .MEM_R_EN_in(MEM_R_EN_ID),
      .MEM_W_EN_in(MEM_W_EN_ID),
      .EXE_CMD_in(EXE_CMD_ID),
      .B_in(B_ID),
      .S_in(S_ID),
      .PC_in(PC_ID_out),
      .Val_Rn_in(Val_Rn_ID),
      .Val_Rm_in(Val_Rm_ID),
      .Dest_in(Dest_ID),
      .shift_operand_in(shift_operand_ID),
      .imm_in(imm_ID),
      .c_in(SR[2]),
      .signed_imm_24_in(signed_imm_24_ID),
      .PC(PC_EXE),
      .EXE_CMD(EXE_CMD_EXE),
      .MEM_R_EN(MEM_R_EN_EXE),
      .MEM_W_EN(MEM_W_EN_EXE),
      .WB_EN(WB_EN_EXE),
      .Val_Rn(Val_Rn_EXE),
      .Val_Rm(Val_Rm_EXE),
      .B(B_EXE),
      .S(S_EXE),
      .Dest(Dest_EXE),
      .signed_imm_24(signed_imm_24_EXE),
      .shift_operand(shift_operand_EXE),
      .imm(imm_EXE),
      .c_out(c_out)

  );
  wire [3:0] status_bits_exe;
  StatusRegister SR_inst (
      .clk(clk),
      .rst(rst),
      .s_update(S_EXE),
      .alu_status_bits(status_bits_exe),
      .status_bus(SR)
  );

  wire wb_en_exe_out;
  wire mem_r_en_exe_out;
  wire mem_w_en_exe_out;
  wire [31:0] alu_result_exe;
  wire [31:0] val_rm_exe_out;
  wire [31:0] branch_address_exe;

  EXE_stage EXE_stage_inst (
      .exe_cmd(EXE_CMD_EXE),
      .s_update(S_EXE),
      .imm(imm_EXE),
      .c_in(c_out),
      .mem_r_en_in(MEM_R_EN_EXE),
      .mem_w_en_in(MEM_W_EN_EXE),
      .pc_in(PC_EXE),
      .val_rn(Val_Rn_EXE),
      .val_rm(Val_Rm_EXE),
      .shift_operand(shift_operand_EXE),
      .signed_imm_24(signed_imm_24_EXE),
      .sr_status_bits_in(SR),
      .alu_result(alu_result_exe),
      .val_rm_out(val_rm_exe_out),
      .branch_address(Branch_Address),
      .status_bits_out(status_bits_exe)

  );
  wire WB_EN_MEM;
  wire MEM_R_EN_MEM;
  wire MEM_W_EN_MEM;
  wire [31:0] ALU_result_MEM;
  wire [31:0] Val_Rm_MEM;
  wire [3:0] Dest_MEM;

  EXE_stage_reg EXE_reg (
      .clk(clk),
      .rst(rst),
      .wb_en_in(WB_EN_EXE),
      .mem_r_en_in(MEM_R_EN_EXE),
      .mem_w_en_in(MEM_W_EN_EXE),
      .alu_result_in(alu_result_exe),
      .val_rm_in(val_rm_exe_out),
      .dest_in(Dest_EXE),
      .wb_en_out(WB_EN_MEM),
      .mem_r_en_out(MEM_R_EN_MEM),
      .mem_w_en_out(MEM_W_EN_MEM),
      .alu_result_out(ALU_result_MEM),
      .val_rm_out(Val_Rm_MEM),
      .dest_out(Dest_MEM)
  );
  wire [31:0] PC_dummy;
  MEM_stage MEM_stage_inst (
      .clk(clk),
      .rst(rst),
      .PC_in(ALU_result_MEM),
      .PC(PC_dummy)
  );

  MEM_stage_reg WB_reg (
      .clk(clk),
      .rst(rst),
      .PC_in(PC_dummy),
      .PC()
  );

endmodule
