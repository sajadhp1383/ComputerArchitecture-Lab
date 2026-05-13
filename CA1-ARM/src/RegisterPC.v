module PC_reg(
    input clk, rst, freeze,
    input [31:0] PCNext,
    output reg [31:0] PC
);
    initial begin
        PC = 32'd0;
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            PC <= 32'd0;
        else if (!freeze)
            PC <= PCNext;
    end
endmodule