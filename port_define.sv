//Data size
`define ImSize 1024
`define ImAddr 9:0
`define DmSize 32768
`define DmAddr 14:0

`define TempBus 63:0
`define RegBus  31:0
`define RegAddrBus 4:0
`define ZeroRegAddr 5'b00000
`define RegNum 32

`define InstBus 31:0
`define InstAddrBus 31:0

`define CycleCountBus 127:0
`define InstCountBus  63:0

//Extension
`define Extension 1:0
`define FiveZE 2'b00
`define FifteenZE 2'b01
`define FifteenSE 2'b10
`define TwentySE  2'b11

//Branch Extension
`define ZeroWord 32'b00000000_00000000_00000000_00000000
`define Thirdteen 12:0
`define Fifteen 14:0
`define Twentythree 22:0

//Control
`define RstEnable  1'b1
`define FlushEnable  1'b1
`define StallEnable  1'b1
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
`define FwTrue  1'b1
`define FwFalse 1'b0


//Alu control
`define OverFlowTrue  32'b00000000_00000000_00000000_00000001
`define OverFlowFalse 32'b00000000_00000000_00000000_00000000
`define AluCtrl 4:0
`define AluCtrlAdd  5'b00000
`define AluCtrlSub  5'b00001
`define AluCtrlAnd  5'b00010
`define AluCtrlOr   5'b00011
`define AluCtrlXor  5'b00100
`define AluCtrlSrli  5'b00101
`define AluCtrlSlli  5'b00110
`define AluCtrlRotri  5'b00111
`define AluCtrlNop   5'b01000
`define AluCtrlLwSw  5'b01001
`define AluCtrlLwiSwi  5'b01010
`define AluCtrlBeq  5'b01011
`define AluCtrlBne  5'b01100
`define AluCtrlBeqz 5'b01101
`define AluCtrlBnez 5'b01110
`define AluCtrlJump 5'b01111
`define AluCtrlSva  5'b10000
`define AluCtrlSvs  5'b10001
`define AluCtrlAbs  5'b10010    
`define AluCtrlJrRet 5'b10011

//Sub Opcode
`define NOP_SRLI 5'b01001
`define ADD 5'b00000
`define SUB 5'b00001
`define AND 5'b00010
`define OR  5'b00100
`define XOR 5'b00011            
`define SLLI 5'b01000
`define ROTRI 5'b01011
`define SVA 5'b11000
`define SVS 5'b11001
`define ADDI 6'b101000
`define ORI  6'b101100
`define XORI 6'b101011
`define MOVI 6'b100010
`define LWI 6'b000010
`define SWI 6'b001010
`define JUMP 6'b100100
`define ABS  6'b100001
`define BEQ 1'b0
`define BNE 1'b1
`define BEQZ 4'b0010
`define BNEZ 4'b0011          
`define LW 8'b00000010
`define SW 8'b00001010
`define JR  1'b0
`define RET 1'b1

//DCache
`define DCacheSize 1024
`define DLineSize  16
`define LineWidth  511:0
`define DIndex  	  11:6
`define DTag    	  31:12
`define DOffset 	  6:3

//Cache
`define CACHESIZE 1024
`define INDEX 13:4
`define TAG   31:14
`define OFFSET 3:0
`define DATA  31:0
//`define ABSENT 1'b0
`define WAITSTATE 'd2

`define STATE_IDLE 4'd0
`define STATE_READ 4'd1
`define STATE_READMISS 4'd2
`define STATE_READSYS 4'd3
`define STATE_READDATA 4'd4
`define STATE_WRITE 4'd5
`define STATE_WRITEHIT 4'd6
`define STATE_WRITEMISS 4'd7
`define STATE_WRITESYS 4'd8
`define STATE_WRITEDATA 4'd9

`define READ 1'b1
`define WRITE 1'b0
//`define ADDR 15:0
//`define ADDRWIDTH 16
`define ADDR 31:0
`define ADDRWIDTH 32
//`define INDEX 9:0
//`define TAG 15:10
//`define DATA 31:0
`define DATAWIDTH 32
`define PRESENT 1'b1
`define ABSENT !`PRESENT



