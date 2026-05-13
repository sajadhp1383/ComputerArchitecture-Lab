`timescale 1ns / 1ns

module Topmodule_tb;
    reg clk;
    reg rst;
    Top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;
    initial begin
        rst = 1;
        #10 rst = 0;
        clk = 0;
        #400;
        $stop;
    end
endmodule