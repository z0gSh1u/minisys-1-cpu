`include "public.v"

module control32(
  input wire[5:0] Opcode,             // 来自取指单元[31..26]
  input wire[5:0] Function_opcode,    // R型指令的[5..0]
  output reg Jrn,                     // 为1表示下一PC来源于寄存器，否则来源于PC相关运算
  output reg RegDST,                  // 为1说明目标寄存器是rd，否则是rt
  output reg ALUSrc,                  // 为1表明第二个操作数是立即数，否则是寄存器（beq、bne除外）
  output reg MemtoReg,                // 寄存器组写入数据来源，1为Mem，0为ALU
  output reg RegWrite,                // 寄存器组写使能
  output reg MemWrite,                // DRAM写使能
  output reg Branch,                  // 为1表明是beq
  output reg nBranch,                 // 为1表明是bne
  output reg Jmp,                     // 为1表明是j
  output reg Jal,                     // 为1表明是jal
  output reg I_format,                // 是否为I型指令
  output reg Sftmd,                   // 为1表明是移位指令
  output reg[1:0] ALUOp               // LW/SW-00, BEQ/BNE-01, R-TYPE-10, I-TYPE=10
);
  
  reg R_format;

  always @(*) begin
    // 处理Jrn
    Jrn <= Opcode == `OP_RTYPE && Function_opcode == `FUNC_JR;

    // 处理RegDST
    R_format <= (Opcode == `OP_RTYPE) ? `Enable : `Disable; // 判断是否是R型指令
    RegDST <= R_format; // 为1说明目标寄存器是rd，否则是rt

    // 处理I_format
    I_format <= Opcode != `OP_RTYPE && Opcode != `OP_J && Opcode != `OP_JAL;
    
    // 处理ALUSrc
    ALUSrc <= I_format && Opcode != `OP_BEQ && Opcode != `OP_BNE;

    // 处理MemtoReg
    MemtoReg <= Opcode == `OP_LW;

    // 处理RegWrite
    RegWrite <= Opcode[5:3] == 3'b001 || (Opcode == `OP_RTYPE && Function_opcode != `FUNC_JR) || Opcode == `OP_LW || Opcode == `OP_JAL;

    // 处理MemWrite
    MemWrite <= Opcode == `OP_SW;
    
    // 处理Branch
    Branch <= Opcode == `OP_BEQ;

    // 处理nBranch
    nBranch <= Opcode == `OP_BNE;

    // 处理Jmp
    Jmp <= Opcode == `OP_J;

    // 处理Jal
    Jal <= Opcode == `OP_JAL;

    // 处理Sftmd
    Sftmd <= Opcode == `OP_RTYPE && 
      (Function_opcode == `FUNC_SLL || Function_opcode == `FUNC_SRL || Function_opcode == `FUNC_SRA 
      || Function_opcode == `FUNC_SLLV || Function_opcode == `FUNC_SRLV || Function_opcode == `FUNC_SRAV);

    // 处理ALUOp
    if (Opcode == `OP_LW || Opcode == `OP_SW) begin
      ALUOp <= 2'b00;
    end else if (Branch == `Enable || nBranch == `Enable) begin
      ALUOp <= 2'b01;
    end else if (I_format == `Enable || R_format == `Enable) begin
      ALUOp <= 2'b10;
    end else begin
      ALUOp <= 2'b00;
    end

  end

endmodule