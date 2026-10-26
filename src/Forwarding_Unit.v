module Forwarding_Unit (
    input wire       Forwarding_EN,
    input wire [3:0] src1,
    input wire [3:0] src2,
    input wire       mem_wb_en,
    input wire [3:0] mem_dest,
    input wire       wb_wb_en,
    input wire [3:0] wb_dest,

    output reg [1:0] sel_src1,
    output reg [1:0] sel_src2
);

  always @(*) begin
    sel_src1 = 2'b00;
    sel_src2 = 2'b00;

    if (Forwarding_EN == 1'b1) begin
      if (mem_wb_en == 1'b1 && mem_dest == src1) begin
        sel_src1 = 2'b01;
      end else if (wb_wb_en == 1'b1 && wb_dest == src1) begin
        sel_src1 = 2'b10;
      end

      if (mem_wb_en == 1'b1 && mem_dest == src2) begin
        sel_src2 = 2'b01;
      end else if (wb_wb_en == 1'b1 && wb_dest == src2) begin
        sel_src2 = 2'b10;
      end
    end
  end

endmodule
