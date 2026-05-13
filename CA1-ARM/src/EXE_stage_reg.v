module EXE_stage_reg (
  input clk,
  input rst,
  input [31:0] PC_in,
  output reg [31:0] PC
);
  always @(posedge clk) begin
      if (rst) begin
        PC <= 32'h0;
      end else begin
        PC <= PC_in;
      end
    end
endmodule