module PC_mux (
    input PCSrc,
    input [31:0] PCPlus1,
    input [31:0] PCTarget,
    output reg [31:0] PCNext
);
  always @(*) begin
    case (PCSrc)
      2'b00:   PCNext = PCPlus1;
      2'b01:   PCNext = PCTarget;
      default: PCNext = 32'b0;
    endcase
  end
endmodule
