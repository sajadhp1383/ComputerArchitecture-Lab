module Top(
    input clk,
    input rst
);

    wire [31:0] PC_IF, Instruction_IF;
    IF_stage IF_stage_inst (
        .clk(clk),
        .rst(rst),
        .freeze(1'b0),
        .Branch_taken(1'b0),
        .BranchAddr(32'b0),
        .PC(PC_IF),
        .Instruction(Instruction_IF)
    );

    wire [31:0] PC_ID, Instruction_ID;
    IF_stage_reg IF_reg (
        .clk(clk),
        .rst(rst),
        .freeze(1'b0),
        .flush(1'b0),
        .PC_in(PC_IF),
        .Instruction_in(Instruction_IF),
        .PC(PC_ID),
        .Instruction(Instruction_ID)
    );

    wire [31:0] PC_ID_out, Val_Rn_ID, Val_Rm_ID, Operand2_ID, signed_imm_24_ID;
    wire [3:0] EXE_CMD_ID, Dest_ID, src1_ID, src2_ID;
    wire MEM_R_EN_ID, MEM_W_EN_ID, WB_EN_ID, B_ID, S_ID, Two_src_ID;

    ID_stage ID_stage_inst (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_ID),
        .Instruction(Instruction_ID),
        .SR(4'b0),                      
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
        .Dest(Dest_ID),
        .Operand2(Operand2_ID),
        .B(B_ID),
        .S(S_ID),
        .signed_imm_24(signed_imm_24_ID),
        .src1(src1_ID),
        .src2(src2_ID),
        .Two_src(Two_src_ID)
    );

    wire [31:0] PC_EXE, Val_Rn_EXE, Val_Rm_EXE, Operand2_EXE, signed_imm_24_EXE;
    wire [3:0] EXE_CMD_EXE, Dest_EXE, src1_EXE, src2_EXE;
    wire MEM_R_EN_EXE, MEM_W_EN_EXE, WB_EN_EXE, B_EXE, S_EXE, Two_src_EXE;

    ID_stage_reg ID_reg (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_ID_out),
        .EXE_CMD_in(EXE_CMD_ID),
        .MEM_R_EN_in(MEM_R_EN_ID),
        .MEM_W_EN_in(MEM_W_EN_ID),
        .WB_EN_in(WB_EN_ID),
        .Val_Rn_in(Val_Rn_ID),
        .Val_Rm_in(Val_Rm_ID),
        .Dest_in(Dest_ID),
        .Operand2_in(Operand2_ID),
        .B_in(B_ID),
        .S_in(S_ID),
        .signed_imm_24_in(signed_imm_24_ID),
        .src1_in(src1_ID),
        .src2_in(src2_ID),
        .Two_src_in(Two_src_ID),
        .PC(PC_EXE),
        .EXE_CMD(EXE_CMD_EXE),
        .MEM_R_EN(MEM_R_EN_EXE),
        .MEM_W_EN(MEM_W_EN_EXE),
        .WB_EN(WB_EN_EXE),
        .Val_Rn(Val_Rn_EXE),
        .Val_Rm(Val_Rm_EXE),
        .Dest(Dest_EXE),
        .Operand2(Operand2_EXE),
        .B(B_EXE),
        .S(S_EXE),
        .signed_imm_24(signed_imm_24_EXE),
        .src1(src1_EXE),
        .src2(src2_EXE),
        .Two_src(Two_src_EXE)
    );

    wire [31:0] PC_MEM;
    EXE_stage EXE_stage_inst (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_EXE),
        .PC(PC_MEM)
    );

    wire [31:0] PC_WB;
    MEM_stage_reg MEM_reg (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_MEM),
        .PC(PC_WB)
    );

    wire [31:0] PC_dummy;
    MEM_stage MEM_stage_inst (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_WB),
        .PC(PC_dummy)
    );

    MEM_stage_reg WB_reg (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_dummy),
        .PC()
    );

endmodule