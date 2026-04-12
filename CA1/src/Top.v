module Top(
  input clk,
  input rst
);
  wire [31:0] PC_IF;
  wire [31:0] Instruction_IF;
  IF_stage IF(
    .clk(clk),
    .rst(rst),
    .freeze(1'b0),
    .Branch_taken(1'b0),
    .BranchAddr(32'b0),
    .PC(PC_IF),
    .Instruction(Instruction_IF)
  );

  wire [31:0] PC_ID;
  wire [31:0] Instruction_ID;
  IF_stage_reg IF_reg(
    .clk(clk),
    .rst(rst),
    .freeze(1'b0),
    .flush(1'b0),
    .PC_in(PC_IF),
    .Instruction_in(Instruction_IF),
    .PC(PC_ID),
    .Instruction(Instruction_ID)
  );

  wire [31:0] PC_EXE;
  ID_stage ID(
    .clk(clk),
    .rst(rst),
    .PC_in(PC_ID),
    .PC(PC_EXE)
  );

  wire [31:0] PC_MEM;
  ID_stage_reg ID_reg(
    .clk(clk),
    .rst(rst),
    .PC_in(PC_EXE),
    .PC(PC_MEM)
  );

  wire [31:0] PC_WB;
  MEM_stage MEM(
    .clk(clk),
    .rst(rst),
    .PC_in(PC_MEM),
    .PC(PC_WB)
  );

  wire [31:0] PC;
  MEM_stage_reg MEM_reg(
    .clk(clk),
    .rst(rst),
    .PC_in(PC_WB),
    .PC(PC)
  );

endmodule