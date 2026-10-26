module ALU (
    input      [31:0] val1,
    input      [31:0] val2,
    input      [ 3:0] exe_cmd,
    input             c_in,
    output reg [31:0] alu_result,
    output     [ 3:0] status_bits
);

  reg c_out, v_out;
  wire n_out, z_out;

  always @(*) begin
    c_out = 1'b0;
    v_out = 1'b0;
    alu_result = 32'b0;

    case (exe_cmd)
      4'b0001: begin  // MOV
        alu_result = val2;
      end
      4'b1001: begin  // MVN
        alu_result = ~val2;
      end
      4'b0010: begin  // ADD, LDR, STR
        {c_out, alu_result} = {1'b0, val1} + {1'b0, val2};
        v_out = (val1[31] == val2[31]) & (alu_result[31] != val1[31]);
      end
      4'b0011: begin  // ADC
        {c_out, alu_result} = {1'b0, val1} + {1'b0, val2} + c_in;
        v_out = (val1[31] == val2[31]) & (alu_result[31] != val1[31]);
      end
      4'b0100: begin  // SUB, CMP
        {c_out, alu_result} = {1'b0, val1} + {1'b0, ~val2} + 1'b1;
        v_out = (val1[31] != val2[31]) & (alu_result[31] != val1[31]);
      end
      4'b0101: begin  // SBC
        {c_out, alu_result} = {1'b0, val1} + {1'b0, ~val2} + {32'b0, c_in};
        v_out = (val1[31] != val2[31]) & (alu_result[31] != val1[31]);
      end
      4'b0110: begin  // AND, TST
        alu_result = val1 & val2;
      end
      4'b0111: begin  // ORR
        alu_result = val1 | val2;
      end
      4'b1000: begin  // EOR
        alu_result = val1 ^ val2;
      end
      default: alu_result = 32'b0;
    endcase
  end

  assign n_out = alu_result[31];
  assign z_out = (alu_result == 32'b0) ? 1'b1 : 1'b0;
  assign status_bits = {z_out, c_out, n_out, v_out};

endmodule