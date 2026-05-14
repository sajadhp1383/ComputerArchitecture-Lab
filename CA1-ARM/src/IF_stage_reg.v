module IF_stage_reg (
    input clk,
    rst,
    freeze,
    flush,
    input [31:0] PC_in,
    Instruction_in,
    output reg [31:0] PC,
    Instruction
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      PC          <= 32'b0;
      Instruction <= 32'b0;
    end else if (flush) begin
      PC          <= 32'b0;
      Instruction <= 32'b0;
    end else if (!freeze) begin
      PC          <= PC_in;
      Instruction <= Instruction_in;
    end

  end
endmodule
