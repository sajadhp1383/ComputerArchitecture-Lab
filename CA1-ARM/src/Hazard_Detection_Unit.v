module Hazard_Detection_Unit (
    input  wire [3:0] src1,
    input  wire [3:0] src2,
    input  wire [3:0] EXE_Dest,
    input  wire [3:0] Mem_Dest,
    input  wire       EXE_WB_EN,
    input  wire       MEM_WB_EN,
    input  wire       Two_src,
    input  wire       Forwarding_EN,
    input  wire       EXE_MEM_R_EN,
    output reg        Hazard_Detected
);

  always @(*) begin
    Hazard_Detected = 1'b0;

    if (Forwarding_EN == 1'b0) begin
      if (EXE_WB_EN == 1'b1 && src1 == EXE_Dest) Hazard_Detected = 1'b1;
      if (EXE_WB_EN == 1'b1 && Two_src == 1'b1 && src2 == EXE_Dest) Hazard_Detected = 1'b1;
      if (MEM_WB_EN == 1'b1 && src1 == Mem_Dest) Hazard_Detected = 1'b1;
      if (MEM_WB_EN == 1'b1 && Two_src == 1'b1 && src2 == Mem_Dest) Hazard_Detected = 1'b1;
    end else begin
      if (EXE_MEM_R_EN == 1'b1 && src1 == EXE_Dest) Hazard_Detected = 1'b1;
      if (EXE_MEM_R_EN == 1'b1 && Two_src == 1'b1 && src2 == EXE_Dest) Hazard_Detected = 1'b1;
    end
  end

endmodule
