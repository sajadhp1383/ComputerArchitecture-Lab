module MEM_stage_reg (
    input clk,
    input rst,
    input wb_en_in,
    input mem_r_en_in,
    input [31:0] alu_result_in,
    input [31:0] data_mem_in,
    input [3:0] dest_in,
    
    output reg wb_en_out,
    output reg mem_r_en_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] data_mem_out,
    output reg [3:0] dest_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_en_out      <= 1'b0;
            mem_r_en_out   <= 1'b0;
            alu_result_out <= 32'b0;
            data_mem_out   <= 32'b0;
            dest_out       <= 4'b0;
        end else begin
            wb_en_out      <= wb_en_in;
            mem_r_en_out   <= mem_r_en_in;
            alu_result_out <= alu_result_in;
            data_mem_out   <= data_mem_in;
            dest_out       <= dest_in;
        end
    end

endmodule