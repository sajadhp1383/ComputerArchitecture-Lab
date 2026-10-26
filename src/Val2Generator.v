module Val2Generator (
    input      [31:0] val_rm,
    input      [11:0] shift_operand,
    input             imm,
    input             mem_access,
    output reg [31:0] val2
);

  wire [31:0] imm32 = {24'b0, shift_operand[7:0]};
  wire [ 4:0] rotate_amount = {shift_operand[11:8], 1'b0};

  wire [ 4:0] shift_imm = shift_operand[11:7];
  wire [ 1:0] shift_type = shift_operand[6:5];

  always @(*) begin
    if (mem_access) begin
      // LDR, STR
      val2 = {20'b0, shift_operand};

    end else if (imm) begin
      val2 = (imm32 >> rotate_amount) | (imm32 << (32 - rotate_amount));

    end else begin
      case (shift_type)
        2'b00: val2 = val_rm << shift_imm;  // LSL
        2'b01: val2 = val_rm >> shift_imm;  // LSR
        2'b10:
        val2 = $signed(val_rm) >>> shift_imm;  // ASR
        2'b11: val2 = (val_rm >> shift_imm) | (val_rm << (32 - shift_imm));  // ROR
        default: val2 = val_rm;
      endcase
    end
  end

endmodule
