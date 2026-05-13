module RegisterFile (
    input clk,
    input [3:0] Rn,          
    input [3:0] Rm,          
    input [3:0] Dest,        
    input [31:0] WriteData,  
    input WB_EN,             
    output [31:0] Val_Rn,    
    output [31:0] Val_Rm     
);

    reg [31:0] regs [14:0];  

    integer i;
    initial begin
        for (i = 0; i < 15; i = i + 1)
            regs[i] = i;
    end

    
    assign Val_Rn = regs[Rn];
    assign Val_Rm = regs[Rm];

    
    always @(posedge clk) begin
        if (WB_EN)
            regs[Dest] <= WriteData;
    end

endmodule