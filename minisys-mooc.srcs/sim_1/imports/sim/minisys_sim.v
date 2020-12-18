`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/26 15:07:19
// Design Name: 
// Module Name: minisys_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module minisys_sim(

    );
    // input
    reg prst = 1'b0;
    reg pclk = 1'b0;
    reg[15:0] switch2N4;
    
    // output
    wire [15:0] led2N4; 
    minisys U(prst,pclk,led2N4,switch2N4);
    
    initial begin
        #1500  prst = 1'b1;
        switch2N4 = 16'hABCD;
    end

    always #5 pclk = ~pclk;
    
endmodule
