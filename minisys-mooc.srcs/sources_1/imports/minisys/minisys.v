`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module minisys(prst,pclk,led2N4,switch2N4);
    input prst;               //板上的Reset信号，低电平复位
    input pclk;               //板上的100MHz时钟信号
    input[15:0] switch2N4;    //拨码开关输入
    output[15:0] led2N4;      //led结果输出到Nexys4
    
    wire clock;              //clock: 分频后时钟供给系统
    wire iowrite,ioread;     //I/O读写信号
    wire[31:0] write_data;   //写RAM或IO的数据
    wire[31:0] rdata;        //读RAM或IO的数据
    wire[15:0] ioread_data;  //读IO的数据
    wire[31:0] pc_plus_4;    //PC+4
    wire[31:0] read_data_1;  //
    wire[31:0] read_data_2;  //
    wire[31:0] sign_extend;  //符号扩展
    wire[31:0] add_result;   //
    wire[31:0] alu_result;   //
    wire[31:0] read_data;    //RAM中读取的数据
    wire[31:0] address;
    wire alusrc;
    wire branch;
    wire nbranch,jmp,jal,jrn,i_format;
    wire regdst;
    wire regwrite;
    wire zero;
    wire memwrite;
    wire memread;
    wire memoriotoreg;
    wire memreg;
    wire sftmd;
    wire[1:0] aluop;
    wire[31:0] instruction;
    wire[31:0] opcplus4;
    wire ledctrl,switchctrl;
    wire[15:0] ioread_data_switch;
    
    cpuclk cpuclk(
        .clk_in1(pclk),    //100MHz
        .clk_out1(clock)    //cpuclock
    );
    
    Ifetc32 ifetch(
        
    );
    
    Idecode32 idecode(
        
    );
    
    control32 control(
        
    );
                      
    Executs32 execute(
       
     );
    
    dmemory32 memory(
      
    );
            
    memorio memio(
       
    );
    
    ioread multiioread(
        
    );
 
    leds led16(
        
     );
     
     switchs switch16(
        
     );
endmodule
