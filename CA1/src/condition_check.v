module condition_check (
    input [3:0] cond,
    input [3:0] SR,    
    output reg Cond    
);

    wire N, Z, C, V;
    assign {N, Z, C, V} = SR;

    always @(*) begin
        case (cond)
            4'b0000: Cond = Z;                    // EQ
            4'b0001: Cond = ~Z;                   // NE
            4'b0010: Cond = C;                    // CS/HS
            4'b0011: Cond = ~C;                   // CC/LO
            4'b0100: Cond = N;                    // MI
            4'b0101: Cond = ~N;                   // PL
            4'b0110: Cond = V;                    // VS
            4'b0111: Cond = ~V;                   // VC
            4'b1000: Cond = C & ~Z;               // HI
            4'b1001: Cond = ~C | Z;               // LS
            4'b1010: Cond = (N == V);             // GE
            4'b1011: Cond = (N != V);             // LT
            4'b1100: Cond = (~Z) & (N == V);      // GT
            4'b1101: Cond = Z | (N != V);         // LE
            4'b1110: Cond = 1'b1;                 // AL
            default: Cond = 1'b0;
        endcase
    end

endmodule