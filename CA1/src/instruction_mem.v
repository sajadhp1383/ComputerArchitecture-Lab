module instruction_mem (
    input  [10:0] addr,
    output [31:0] instruction
);

  reg [31:0] mem[0:2047];

  initial begin
    $readmemb("instruction_mem.mem", mem);
  end

  assign instruction = mem[addr];

endmodule
