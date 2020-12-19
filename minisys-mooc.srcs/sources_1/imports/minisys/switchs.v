`include "public.v"


module switchs(switclk,switrst,switchread,switchaddrcs,switchrdata,switch_i);
    input switclk;
    input switrst;
    input switchaddrcs;
    input switchread;
    output [15:0] switchrdata; //
    // 板子上的拨码开关输入
    input [15:0] switch_i;

    reg [15:0] switchrdata; //
    always@(negedge switclk or posedge switrst) begin
 
    end
endmodule
