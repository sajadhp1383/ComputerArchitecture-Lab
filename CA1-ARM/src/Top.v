module Top (
    input clk,
    input rst,
    input Forwarding_EN
);

  wire [31:0] PC_IF, Instruction_IF;
  wire [31:0] Branch_Address;
  wire B_EXE;

  wire Hazard_Detected_wire;
  wire true_hazard = Hazard_Detected_wire & (~B_EXE);

  IF_stage IF_stage_inst (
      .clk(clk),
      .rst(rst),
      .freeze(true_hazard),
      .Branch_taken(B_EXE),
      .BranchAddr(Branch_Address),
      .PC(PC_IF),
      .Instruction(Instruction_IF)
  );

  wire [31:0] PC_ID, Instruction_ID;
  IF_stage_reg IF_reg (
      .clk(clk),
      .rst(rst),
      .freeze(true_hazard),
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

  wire        WB_EN_WB;
  wire [ 3:0] Dest_WB;
  wire [31:0] WB_WB_Value;

  ID_stage ID_stage_inst (
      .clk(clk),
      .rst(rst),
      .hazard(true_hazard | B_EXE),
      .PC_in(PC_ID),
      .Instruction(Instruction_ID),
      .SR(SR),
      .WB_WB_EN(WB_EN_WB),
      .WB_WB_Dest(Dest_WB),
      .WB_WB_Value(WB_WB_Value),
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
      .Dest(Dest_ID),
      .Two_src(Two_src_ID),
      .src1(src1_ID),
      .src2(src2_ID)
  );

  wire [31:0] PC_EXE, Val_Rn_EXE, Val_Rm_EXE;
  wire [23:0] signed_imm_24_EXE;
  wire [3:0] EXE_CMD_EXE, Dest_EXE;
  wire MEM_R_EN_EXE, MEM_W_EN_EXE, WB_EN_EXE, S_EXE;
  wire [11:0] shift_operand_EXE;
  wire c_out;
  wire imm_EXE;

  wire [3:0] src1_EXE, src2_EXE;

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
      .src1_in(src1_ID),
      .src2_in(src2_ID),

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
      .c_out(c_out),
      .src1_out(src1_EXE),
      .src2_out(src2_EXE)
  );
  wire WB_EN_MEM;
  wire MEM_R_EN_MEM;
  wire MEM_W_EN_MEM;
  wire [31:0] ALU_result_MEM;
  wire [31:0] Val_Rm_MEM;
  wire [3:0] Dest_MEM;
  wire [1:0] sel_src1_wire, sel_src2_wire;

  Forwarding_Unit FU (
      .Forwarding_EN(Forwarding_EN),
      .src1(src1_EXE),
      .src2(src2_EXE),
      .mem_wb_en(WB_EN_MEM),
      .mem_dest(Dest_MEM),
      .wb_wb_en(WB_EN_WB),
      .wb_dest(Dest_WB),
      .sel_src1(sel_src1_wire),
      .sel_src2(sel_src2_wire)
  );

  Hazard_Detection_Unit HDU (
      .src1(src1_ID),
      .src2(src2_ID),
      .EXE_Dest(Dest_EXE),
      .Mem_Dest(Dest_MEM),
      .EXE_WB_EN(WB_EN_EXE),
      .MEM_WB_EN(WB_EN_MEM),
      .Two_src(Two_src_ID),

      .Forwarding_EN(Forwarding_EN),
      .EXE_MEM_R_EN (MEM_R_EN_EXE),

      .Hazard_Detected(Hazard_Detected_wire)
  );

  wire [3:0] status_bits_exe;
  StatusRegister SR_inst (
      .clk(clk),
      .rst(rst),
      .s_update(S_EXE),
      .alu_status_bits(status_bits_exe),
      .status_bus(SR)
  );
  wire [31:0] alu_result_exe;
  wire [31:0] val_rm_exe_out;

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

      .sel_src1(sel_src1_wire),
      .sel_src2(sel_src2_wire),
      .alu_res_mem(ALU_result_MEM),
      .wb_res(WB_WB_Value),

      .alu_result(alu_result_exe),
      .val_rm_out(val_rm_exe_out),
      .branch_address(Branch_Address),
      .status_bits_out(status_bits_exe)
  );

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

  wire [31:0] data_mem_out_MEM;

  MEM_stage MEM_stage_inst (
      .clk(clk),
      .MEM_R_EN(MEM_R_EN_MEM),
      .MEM_W_EN(MEM_W_EN_MEM),
      .ALU_res_in(ALU_result_MEM),
      .Val_Rm_in(Val_Rm_MEM),
      .data_mem_out(data_mem_out_MEM)
  );

  wire MEM_R_EN_WB;
  wire [31:0] ALU_result_WB;
  wire [31:0] data_mem_out_WB;

  MEM_stage_reg MEM_reg (
      .clk(clk),
      .rst(rst),
      .wb_en_in(WB_EN_MEM),
      .mem_r_en_in(MEM_R_EN_MEM),
      .alu_result_in(ALU_result_MEM),
      .data_mem_in(data_mem_out_MEM),
      .dest_in(Dest_MEM),

      .wb_en_out(WB_EN_WB),
      .mem_r_en_out(MEM_R_EN_WB),
      .alu_result_out(ALU_result_WB),
      .data_mem_out(data_mem_out_WB),
      .dest_out(Dest_WB)
  );

  WB_stage WB_stage_inst (
      .MEM_R_EN(MEM_R_EN_WB),
      .ALU_res(ALU_result_WB),
      .data_mem_out(data_mem_out_WB),
      .write_back_data(WB_WB_Value)
  );

endmodule
