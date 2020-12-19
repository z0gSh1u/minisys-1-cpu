`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/07 21:58:34
// Design Name: 
// Module Name: exe_sim
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


module exe_sim(
    );
   // input
   reg[31:0]  Read_data_1 = 32'h00000005;		//r-form rs
   reg[31:0]  Read_data_2 = 32'h00000006;        //r-form rt
   reg[31:0]  Sign_extend = 32'hffffff40;        //i-form
   reg[5:0]   Function_opcode = 6'b100000;      //add 
   reg[5:0]   Exe_opcode = 6'b000000;          //op code
   reg[1:0]   ALUOp = 2'b10;
   reg[4:0]   Shamt = 5'b00000;
   reg        Sftmd = 1'b0;
   reg        ALUSrc = 1'b0;
   reg        I_format = 1'b0;
   reg[31:0]  PC_plus_4 = 32'h00000004;
    // output
   wire       Zero;
   wire[31:0] ALU_Result;
   wire[31:0] Add_Result;        //pc op        
 
    
   Executs32 Uexe(
   .Read_data_1(Read_data_1),	// r-form rs 从译码单元是Read_data_1中来
   .Read_data_2(Read_data_2),	// r-form rt 从译码单元是Read_data_2中来
   .Sign_extend(Sign_extend),	// i-form 译码单元来的扩展后的立即数
   .Function_opcode(Function_opcode),  // r-form instructions[5..0] 取指单元来的R型的Func
   .Exe_opcode(Exe_opcode),    // opcode 取值单元来的Op
   .ALUOp(ALUOp),              // 控制单元来的ALUOp，第一级控制（LW/SW 00，BEQ/BNE 01，R/I 10）
   .Shamt(Shamt),              // 移位量
   .Sftmd(Sftmd),              // 是否是移位指令
   .ALUSrc(ALUSrc),            // 来自控制单元，表明第二个操作数是立即数（beq、bne除外）
   .I_format(I_format),        // 该指令是除了beq、bne、lw、sw以外的其他I类型指令
   .Zero(Zero),                // Zero Flag
   .ALU_Result(ALU_Result),    // 执行单元的最终运算结果
   .Add_Result(Add_Result),	   // 计算的地址结果       
   .PC_plus_4(PC_plus_4)       // 来自取指单元的PC+4
   );

    initial begin
       #200 begin Exe_opcode = 6'b001000;  //addi 
                Read_data_1 = 32'h00000003;		//r-form rs
                Read_data_2 = 32'h00000006;        //r-form rt
                Sign_extend = 32'hffffff40;  
                Function_opcode = 6'b100000;      //addi 
                ALUOp = 2'b10;
                Shamt = 5'b00000;
                Sftmd = 1'b0;
                ALUSrc = 1'b1;
                I_format = 1'b1;
                PC_plus_4 = 32'h00000008;
            end 
       #200 begin Exe_opcode = 6'b000000;  //and
                Read_data_1 = 32'h000000ff;        //r-form rs
                Read_data_2 = 32'h00000ff0;        //r-form rt
                Sign_extend = 32'hffffff40;  
                Function_opcode = 6'b100100;      //and 
                ALUOp = 2'b10;
                Shamt = 5'b00000;
                Sftmd = 1'b0;
                ALUSrc = 1'b0;
                I_format = 1'b0;
                PC_plus_4 = 32'h0000000c;
             end 
       #200 begin Exe_opcode = 6'b000000;  //sll
                Read_data_1 = 32'h00000001;        //r-form rs
                Read_data_2 = 32'h00000002;        //r-form rt
                Sign_extend = 32'hffffff40;  
                Function_opcode = 6'b000000;      //sll
                ALUOp = 2'b10;
                Shamt = 5'b00011;
                Sftmd = 1'b1;
                ALUSrc = 1'b0;
                I_format = 1'b0;
                PC_plus_4 = 32'h00000010;
           end 
       #200 begin Exe_opcode = 6'b001111;  // LUI
                Read_data_1 = 32'h00000001;        //r-form rs
                Read_data_2 = 32'h00000002;        //r-form rt
                Sign_extend = 32'h00000040;  
                Function_opcode = 6'b000000;      //LUI
                ALUOp = 2'b10;
                Shamt = 5'b00001;
                Sftmd = 1'b0;
                ALUSrc = 1'b1;
                I_format = 1'b1;
                PC_plus_4 = 32'h00000014;
            end 
       #200 begin Exe_opcode = 6'b000100;  // BEQ
                Read_data_1 = 32'h00000001;        //r-form rs
                Read_data_2 = 32'h00000001;        //r-form rt
                Sign_extend = 32'h00000004;  
                Function_opcode = 6'b000100;      //LUI
                ALUOp = 2'b01;
                Shamt = 5'b00000;
                Sftmd = 1'b0;
                ALUSrc = 1'b0;
                I_format = 1'b0;
                PC_plus_4 = 32'h00000018;
            end 
      end
endmodule
