module ID_stage_reg (
    input clk,
    input rst,
    input [31:0] PC_in,
    input [3:0] EXE_CMD_in,
    input MEM_R_EN_in,
    input MEM_W_EN_in,
    input WB_EN_in,
    input [31:0] Val_Rn_in,
    input [31:0] Val_Rm_in,
    input [3:0] Dest_in,
    input [31:0] Operand2_in,
    input B_in,
    input S_in,
    input [31:0] signed_imm_24_in,
    input [3:0] src1_in,
    input [3:0] src2_in,
    input Two_src_in,
    output reg [31:0] PC,
    output reg [3:0] EXE_CMD,
    output reg MEM_R_EN,
    output reg MEM_W_EN,
    output reg WB_EN,
    output reg [31:0] Val_Rn,
    output reg [31:0] Val_Rm,
    output reg [3:0] Dest,
    output reg [31:0] Operand2,
    output reg B,
    output reg S,
    output reg [31:0] signed_imm_24,
    output reg [3:0] src1,
    output reg [3:0] src2,
    output reg Two_src
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
            EXE_CMD <= 4'd0;
            MEM_R_EN <= 1'b0;
            MEM_W_EN <= 1'b0;
            WB_EN <= 1'b0;
            Val_Rn <= 32'd0;
            Val_Rm <= 32'd0;
            Dest <= 4'd0;
            Operand2 <= 32'd0;
            B <= 1'b0;
            S <= 1'b0;
            signed_imm_24 <= 32'd0;
            src1 <= 4'd0;
            src2 <= 4'd0;
            Two_src <= 1'b0;
        end else begin
            PC <= PC_in;
            EXE_CMD <= EXE_CMD_in;
            MEM_R_EN <= MEM_R_EN_in;
            MEM_W_EN <= MEM_W_EN_in;
            WB_EN <= WB_EN_in;
            Val_Rn <= Val_Rn_in;
            Val_Rm <= Val_Rm_in;
            Dest <= Dest_in;
            Operand2 <= Operand2_in;
            B <= B_in;
            S <= S_in;
            signed_imm_24 <= signed_imm_24_in;
            src1 <= src1_in;
            src2 <= src2_in;
            Two_src <= Two_src_in;
        end
    end

endmodule