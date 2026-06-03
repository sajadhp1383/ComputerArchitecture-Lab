module data_mem (
    input clk,
    input MEM_R_EN,
    input MEM_W_EN,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] memory [0:1023];

    wire [9:0] addr = address[9:0];

    assign read_data = MEM_R_EN ? memory[addr] : 32'b0;

    always @(posedge clk) begin
        if (MEM_W_EN) begin
            memory[addr] <= write_data;
        end
    end

endmodule