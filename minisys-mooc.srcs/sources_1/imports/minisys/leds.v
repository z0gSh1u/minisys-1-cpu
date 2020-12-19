`include "public.v"

module leds(led_clk,ledrst,ledwrite,ledaddrcs,ledwdata,ledout);
    input led_clk;
    input ledrst;
    input ledwrite; // 写信号
    input ledaddrcs; // 从memorio来的，由低至高位形成的LED片选信号
    input[15:0] ledwdata; // 
    output[15:0] ledout; // 向板子上输出的LED灯亮灭信号
    
    reg [15:0] ledout;
    
    always @(posedge led_clk or posedge ledrst) begin
  
    end
endmodule
