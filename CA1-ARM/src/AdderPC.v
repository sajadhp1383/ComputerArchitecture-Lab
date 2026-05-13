module PC_adder (
    input [31:0] PC,
    output [31:0] PCPlus1
);
    assign PCPlus1 = PC + 32'd1;
endmodule