module IF_stage (
  input clk,rst,freeze,Branch_taken,
  input [31:0] BranchAddr,
  output [31:0] PC,Instruction
);
  instruction_mem IF_memory(
    .addr(PC),
    .instruction(Instruction)
  );
  wire [31:0] PCNext,PCPlus1;
  PC_reg PCReg(
    .clk(clk),
    .rst(rst),
    .freeze(freeze),
    .PCNext(PCNext),
    .PC(PC)
  );
  PC_adder PCAdder(
    .PC(PC),
    .PCPlus1(PCPlus1)
  );
  PC_mux PCMux(
    .PCSrc(Branch_taken),
    .PCPlus1(PCPlus1),
    .PCTarget(BranchAddr),
    .PCNext(PCNext)
  );
endmodule