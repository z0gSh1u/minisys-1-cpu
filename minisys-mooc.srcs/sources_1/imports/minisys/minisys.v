`include "public.v"

module minisys(
    input wire prst,               // 板上的Reset信号，低电平复位
    input wire pclk,               // 板上的100MHz时钟信号
    input wire[15:0] switch2N4,    // 拨码开关输入
    output reg[15:0] led2N4        // led结果输出到Nexys4
);

    wire clock;              // clock: 分频后时钟供给系统
    wire iowrite,ioread;     // I/O读写信号
    wire[31:0] write_data;   // 写RAM或IO的数据
    wire[31:0] rdata;        // 读RAM或IO的数据
    wire[15:0] ioread_data;  // 读IO的数据
    wire[31:0] pc_plus_4;    // PC+4
    wire[31:0] read_data_1;  // 
    wire[31:0] read_data_2;  // 
    wire[31:0] sign_extend;  // 符号扩展
    wire[31:0] add_result;   // 执行单元的最终运算结果
    wire[31:0] alu_result;   // 
    wire[31:0] read_data;    // RAM中读取的数据
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
    .clk_in1(pclk),    // 100MHz
    .clk_out1(clock)   // cpuclock
    );
    
    Ifetc32 ifetch(
    .Instruction(),			// 输出指令
    .PC_plus_4_out(),         // PC+4的结果输出
    .Add_result(),            // 来自执行单元，算出的跳转地址
    .Read_data_1(),           // 来自译码单元，jr指令用的跳转地址
    .Branch(),                    // beq
    .nBranch(),                   // bne
    .Jmp(),                       // j
    .Jal(),                       // jal
    .Jrn(),                       // jr
    .Zero(),                      // 来自执行单元，1说明运算结果为0
    .clock(),                     // clk
    .reset(),                     // rst
    .opcplus4()               // 返回地址（$31），要早于对JAL的修改
    );
    
    Idecode32 idecode(
    .read_data_1(),  // 读数据1（rs）
    .read_data_2(),  // 读数据2（rt）
    .Instruction(), // 来自取指模块
    .read_data(),   // 从DATA RAM or I/O port取出的数据
    .ALU_result(),  // 需要扩展立即数到32位
    .Jal(),              // 指令是不是JAL
    .RegWrite(),         // 寄存器写使能
    .MemorIOtoReg(),     // 数据来源是不是MEM
    .RegDst(),           // 为1说明目标寄存器是rd，否则是rt
    .Sign_extend(),  // 立即数扩展的结果
    .clock(),
    .reset(),
    .opcplus4(),         // 来自取指单元，JAL中用
    .read_register_1_address() // rs
    );
    
    control32 control(
    .Opcode(),             // 来自取指单元[31..26]
    .Function_opcode(),    // R型指令的[5..0]
    .Jrn(),                     // 为1表示下一PC来源于寄存器，否则来源于PC相关运算
    .RegDST(),                  // 为1说明目标寄存器是rd，否则是rt
    .ALUSrc(),                  // 为1表明第二个操作数是立即数，否则是寄存器（beq、bne除外）
    .MemtoReg(),                // 寄存器组写入数据来源，1为Mem，0为ALU
    .RegWrite(),                // 寄存器组写使能
    .MemWrite(),                // DRAM写使能
    .Branch(),                  // 为1表明是beq
    .nBranch(),                 // 为1表明是bne
    .Jmp(),                     // 为1表明是j
    .Jal(),                     // 为1表明是jal
    .I_format(),                // 是否为I型指令
    .Sftmd(),                   // 为1表明是移位指令
    .ALUOp()               // LW/SW-00, BEQ/BNE-01, R-TYPE-10, I-TYPE=10
    );
                      
    Executs32 execute(
    .Read_data_1(),		// r-form rs 从译码单元是Read_data_1中来
    .Read_data_2(),		// r-form rt 从译码单元是Read_data_2中来
    .Sign_extend(),		// i-form 译码单元来的扩展后的立即数
    .Function_opcode(),  // r-form instructions[5..0] 取指单元来的R型的Func
    .Exe_opcode(),  		// opcode 取值单元来的Op
    .ALUOp(),            // 控制单元来的ALUOp，第一级控制（LW/SW 00，BEQ/BNE 01，R/I 10）
    .Shamt(),            // 移位量
    .Sftmd(),            // 是否是移位指令
    .ALUSrc(),           // 来自控制单元，表明第二个操作数是立即数（beq、bne除外）
    .I_format(),         // 该指令是除了beq、bne、lw、sw以外的其他I类型指令
    .Zero(),             // Zero Flag
    .ALU_Result(),       // 执行单元的最终运算结果
    .Add_Result(),		// 计算的地址结果       
    .PC_plus_4()         // 来自取指单元的PC+4
    );
    
    dmemory32 memory(
    .read_data(),
    .address(),     // 来自memorio模块，源头是来自执行单元算出的alu_result
    .write_data(),  // 来自译码单元的read_data2
    .Memwrite(),         // 来自控制单元
    .clock()
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
