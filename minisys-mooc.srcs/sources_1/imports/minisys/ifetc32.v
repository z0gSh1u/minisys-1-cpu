`include "public.v"

module Ifetc32(
    output reg[31:0] Instruction,			// 输出指令
    output reg[31:0] PC_plus_4_out,         // PC+4的结果输出
    input wire[31:0] Add_result,            // 来自执行单元，算出的跳转地址
    input wire[31:0] Read_data_1,           // 来自译码单元，jr指令用的跳转地址
    input        Branch,                    // beq
    input        nBranch,                   // bne
    input        Jmp,                       // j
    input        Jal,                       // jal
    input        Jrn,                       // jr
    input        Zero,                      // 来自执行单元，1说明运算结果为0
    input        clock,                     // clk
    input        reset,                     // rst
    output reg[31:0] opcplus4               // 返回地址（$31），要早于对JAL的修改
);

    reg[31:0] PC_plus_4;
    reg[31:0] PC;
    reg[31:0] next_PC; // 下一条指令的PC
    wire[31:0] Jpadr;
    
    // 分配 64KB ROM
    prgrom instmem(
        .clka(clock),         // input wire clka
        .addra(PC[15:2]),     // input wire [13 : 0] addra
        .douta(Jpadr)         // output wire [31 : 0] douta
    );

    always @(*) begin
        PC_plus_4 <= PC + 32'd4;
        PC_plus_4_out <= PC_plus_4;
        Instruction <= Jpadr; // 取出指令
        // beq且eq，或bne且ne
        if ((Branch == `Enable && Zero == `Enable) || (nBranch == `Enable && Zero == `Disable)) begin
            next_PC <= Add_result;
        // Jr指令直接覆写PC
        end else if (Jrn == `Enable) begin
            next_PC <= Read_data_1;
        // 如果是跳转指令，记录返回地址，然后根据指令中的地址字面改写当前PC
        end else if (Jmp == `Enable || Jal == `Enable) begin
            opcplus4 = PC_plus_4;
            next_PC = { 4'b0000, Jpadr[`AddressRange], 2'b00 };
        // 一般情况下PC=PC+4
        end else begin
            next_PC <= PC_plus_4;
        end
    end
    
    always @(negedge clock) begin
        if (reset == `Enable) begin
            PC <= 32'd0;
        end else begin
            PC <= next_PC;
        end
    end
    
endmodule
