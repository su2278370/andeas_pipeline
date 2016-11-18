//Data size
`define ImSize 1024
`define ImAddr 9:0
`define DmSize 4096
`define DmAddr 11:0

`define RegBus 31:0
`define RegAddrBus 4:0
`define RegNum 32

`define ZeroWord 0
`define Thirdteen 12:0
`define Fifteen 14:0
`define TwentyThree 22:0


//Control
`define RstEnable  1'b1
`define PcEnable   1'b1
`define BranchTrue 1'b1

`define AluCtrlBeq  4'b1011
`define AluCtrlBne  4'b1100
`define AluCtrlBeqz 4'b1101
`define AluCtrlBnez 4'b1110
`define AluCtrlJump 4'b1111
