module Hazard_Detection_Unit (
    input [3:0] src1,
    input [3:0] src2,
    input [3:0] EXE_Dest,
    input [3:0] Mem_Dest,
    input EXE_WB_EN,
    input MEM_WB_EN,
    input Two_src,
    output reg Hazard_Detected
);

    always @(*) begin
        Hazard_Detected = 1'b0;

        if (EXE_WB_EN == 1'b1 && (src1 == EXE_Dest)) 
            Hazard_Detected = 1'b1;
        
        if (EXE_WB_EN == 1'b1 && Two_src == 1'b1 && (src2 == EXE_Dest)) 
            Hazard_Detected = 1'b1;

        if (MEM_WB_EN == 1'b1 && (src1 == Mem_Dest)) 
            Hazard_Detected = 1'b1;
            
        if (MEM_WB_EN == 1'b1 && Two_src == 1'b1 && (src2 == Mem_Dest)) 
            Hazard_Detected = 1'b1;
    end

endmodule