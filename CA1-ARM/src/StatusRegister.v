module StatusRegister (
    input clk,
    input rst,
    input s_update,
    input [3:0] alu_status_bits,
    output reg [3:0] status_bus
);

  always @(negedge clk or posedge rst) begin
    if (rst) begin
      status_bus <= 4'b0000;
    end else if (s_update) begin
      status_bus <= alu_status_bits;
    end
  end

endmodule
