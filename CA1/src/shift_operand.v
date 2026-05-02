module shift_operand (
    input [11:0] shifter_operand,
    input [31:0] Rm_val,
    input I,
    input is_load_store,
    output reg [31:0] shifted_val
);

    wire [7:0]  immed_8;
    wire [3:0]  rotate_imm;
    wire [4:0]  shift_amount;
    wire [1:0]  shift_type;

    assign immed_8      = shifter_operand[7:0];
    assign rotate_imm   = shifter_operand[11:8];
    assign shift_amount = shifter_operand[11:7];
    assign shift_type   = shifter_operand[6:5];

    always @(*) begin
        if (is_load_store) begin
            shifted_val = {{20{shifter_operand[11]}}, shifter_operand[11:0]};
        end
        else if (I) begin
            shifted_val = (immed_8 >> (2*rotate_imm)) |
                          (immed_8 << (32 - 2*rotate_imm));
        end
        else begin
            case (shift_type)
                2'b00: shifted_val = Rm_val << shift_amount;                   // LSL
                2'b01: shifted_val = Rm_val >> shift_amount;                   // LSR
                2'b10: shifted_val = $signed(Rm_val) >>> shift_amount;         // ASR
                2'b11: shifted_val = (Rm_val >> shift_amount) |
                                     (Rm_val << (32 - shift_amount));          // ROR
                default: shifted_val = Rm_val;
            endcase
        end
    end

endmodule