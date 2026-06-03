`timescale 1ns / 1ns

module Topmodule_tb;
  reg clk;
  reg rst;
  reg Forwarding_EN;

  Top uut (
      .clk(clk),
      .rst(rst),
      .Forwarding_EN(Forwarding_EN)
  );

  always #5 clk = ~clk;

  initial begin

    clk = 0;
    rst = 1;

    Forwarding_EN = 1'b1;

    #10 rst = 0;

    #5000;

    $display("\n========================================");
    $display("Simulation Finished!");
    $display("Forwarding_EN = %b", Forwarding_EN);
    $display("R0 = %0d", uut.ID_stage_inst.RF.regs[0]);
    $display("R1 = %0d", uut.ID_stage_inst.RF.regs[1]);
    $display("R2 = %0d", uut.ID_stage_inst.RF.regs[2]);
    $display("R3 = %0d", uut.ID_stage_inst.RF.regs[3]);
    $display("R4 = %0d", uut.ID_stage_inst.RF.regs[4]);
    $display("R5 = %0d", uut.ID_stage_inst.RF.regs[5]);
    $display("R6 = %0d", uut.ID_stage_inst.RF.regs[6]);
    $display("========================================\n");

    $stop;
  end

endmodule
