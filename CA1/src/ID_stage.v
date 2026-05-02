module ID_stage (
    input clk,
    input rst,
    input [31:0] PC_in,
    input [31:0] Instruction,
    input [3:0] SR,
    input WB_WB_EN,
    input [3:0] WB_WB_Dest,
    input [31:0] WB_WB_Value,
    output [31:0] PC,
    output [3:0] EXE_CMD,
    output MEM_R_EN,
    output MEM_W_EN,
    output WB_EN,
    output [31:0] Val_Rn,
    output [31:0] Val_Rm,
    output [3:0] Dest,
    output [31:0] Operand2,
    output B,
    output S,
    output [23:0] signed_imm_24,   
    output [3:0] src1,
    output [3:0] src2,
    output imm,   
    output Two_src,
    output [11:0] shift_operand
);

    wire [3:0] cond   = Instruction[31:28];
    wire [1:0] Mode   = Instruction[27:26];
    wire I            = Instruction[25];
    wire [3:0] OpCode = Instruction[24:21];
    wire S_bit        = Instruction[20];
    wire [3:0] Rn     = Instruction[19:16];
    wire [3:0] Rd     = Instruction[15:12];
    wire [11:0] shifter = Instruction[11:0];
    wire [3:0] Rm     = Instruction[3:0];

    assign PC = PC_in;
    assign signed_imm_24 = Instruction[23:0];   


    wire uncond_MEM_R_EN, uncond_MEM_W_EN, uncond_WB_EN;
    wire [3:0] src2_pre = (uncond_MEM_W_EN) ? Rd : Rm;
    assign src1 = Rn;
    assign src2 = src2_pre;
    assign Two_src = ~(uncond_MEM_R_EN | imm);

    wire [3:0] uncond_EXE_CMD;
    wire uncond_Imm, uncond_B, uncond_S_update;

    control_unit CU (
        .Mode(Mode),
        .OpCode(OpCode),
        .S(S_bit),
        .EXE_CMD(uncond_EXE_CMD),
        .MEM_R_EN(uncond_MEM_R_EN),
        .MEM_W_EN(uncond_MEM_W_EN),
        .WB_EN(uncond_WB_EN),
        .Imm(uncond_Imm),
        .B(uncond_B),
        .S_update(uncond_S_update)
    );

    wire Cond;
    condition_check CC (
        .cond(cond),
        .SR(SR),
        .Cond(Cond)
    );

    assign EXE_CMD  = Cond ? uncond_EXE_CMD  : 4'b0000;
    assign MEM_R_EN = Cond ? uncond_MEM_R_EN : 1'b0;
    assign MEM_W_EN = Cond ? uncond_MEM_W_EN : 1'b0;
    assign WB_EN    = Cond ? uncond_WB_EN    : 1'b0;
    assign B        = Cond ? uncond_B        : 1'b0;
    assign S        = Cond ? uncond_S_update : 1'b0;

    RegisterFile RF (
        .clk(clk),
        .Rn(src1),
        .Rm(src2),
        .Dest(4'd0),
        .WriteData(32'd0),
        .WB_EN(1'b0),
        .Val_Rn(Val_Rn),
        .Val_Rm(Val_Rm)
    );

    wire is_load_store = (Mode == 2'b01);
    wire is_imm_operand = (Mode == 2'b00) ? I : uncond_Imm;

    wire [31:0] shifted_val;
    shift_operand SH (
        .shifter_operand(shifter),
        .Rm_val(Val_Rm),
        .I(is_imm_operand && (Mode == 2'b00)),
        .is_load_store(is_load_store),
        .shifted_val(shifted_val)
    );

    assign Operand2 = is_imm_operand ? shifted_val : Val_Rm;
    assign imm = is_imm_operand;                
    assign Dest = Rd;
    assign shift_operand = shifter;   

endmodule