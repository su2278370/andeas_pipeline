//Data size
`define ImSize 1024
`define ImAddr 9:0
`define DmSize 4096
`define DmAddr 11:0

`define RegBus 31:0
`define RegAddrBus 4:0
`define RegNum 32

`define InstBus 31:0
`define InstAddrBus 31:0

//Extension
`define Extension 1:0
`define FiveZE 2'b00
`define FifteenZE 2'b01
`define FifteenSE 2'b10
`define TwentySE  2'b11

//Branch Extension
`define ZeroWord 32'b0
`define Thirdteen 12:0
`define Fifteen 14:0
`define Twentythree 22:0

//Control
`define RstEnable  1'b1
`define BranchTrue 1'b1
`define BranchFalse 1'b0
`define ReadEnable   1'b1
`define ReadDisable  1'b0
`define WriteEnable  1'b1
`define WriteDisable 1'b0

`define ImmSrc 1'b1
`define RegSrc 1'b0
`define LwMemSrc 1'b1
`define LwAluSrc 1'b0
`define MvRegSrc 1'b1
`define MvAluSrc 1'b0


//Alu control
`define AluCtrl 3:0
`define AluCtrlAdd  4'b0000
`define AluCtrlSub  4'b0001
`define AluCtrlAnd  4'b0010
`define AluCtrlOr   4'b0011
`define AluCtrlXor  4'b0100
`define AluCtrlSrli  4'b0101
`define AluCtrlSlli  4'b0110
`define AluCtrlRotri  4'b0111
`define AluCtrlNop   4'b1000
`define AluCtrlLwSw  4'b1001
`define AluCtrlLwiSwi  4'b1010
`define AluCtrlBeq  4'b1011
`define AluCtrlBne  4'b1100
`define AluCtrlBeqz 4'b1101
`define AluCtrlBnez 4'b1110
`define AluCtrlJump 4'b1111

//Sub Opcode
`define NOP_SRLI 5'b01001
`define ADD 5'b00000
`define SUB 5'b00001
`define AND 5'b00010
`define OR  5'b00100
`define XOR 5'b00011            
`define SLLI 5'b01000
`define ROTRI 5'b01011
`define ADDI 6'b101000
`define ORI  6'b101100
`define XORI 6'b101011
`define MOVI 6'b100010
`define LWI 6'b000010
`define SWI 6'b001010
`define JUMP 6'b100100
`define BEQ 1'b0
`define BNE 1'b1
`define BEQZ 4'b0010
`define BNEZ 4'b0011          
`define LW 8'b00000010
`define SW 8'b00001010

