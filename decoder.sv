`timescale 1ns/10ps
`include "port_define.sv"

module decoder(clk,
               rst,
               inst_i,
               reg1_data_i,
               reg2_data_i,
               sw_data_i,
                 branch_addr,
               reg1_addr_o,
               reg2_addr_o,
               sw_addr_o,
               write_addr_o,
               reg1_read,
               reg2_read,
               sw_read,
               reg_write, 
               reg1_o,
               reg2_o,
               sw_o,
               write_o, 
               alu_ctrl,
               lwsrc,
               
               movsrc,
               DM_read,
               DM_write
 );

   input clk;
   input rst;
   input [`InstBus]     inst_i;
   
   //Regfile to decoder
   input [`RegBus]  reg1_data_i;
   input [`RegBus]  reg2_data_i;
   input [`RegBus]  sw_data_i;

   //Decoder to interface
   output logic [`InstAddrBus] branch_addr;
   
   //Decoder to regfile
   output logic reg1_read;
   output logic reg2_read;
   output logic sw_read;
   output logic reg_write;
   output logic [`RegAddrBus] reg1_addr_o;
   output logic [`RegAddrBus] reg2_addr_o;
   output logic [`RegAddrBus] write_addr_o;
   output logic [`RegAddrBus] sw_addr_o;
   
   //Decoder to interface
   output logic [`RegBus]     reg1_o;
   output logic [`RegBus]     reg2_o;
   output logic [`RegBus]     sw_o;
   output logic [`RegBus]     write_o;
   
   //Control Signals, decoder to interface
   output logic [`AluCtrl]    alu_ctrl;
   output logic           lwsrc;
   
   output logic        movsrc; 
   output logic DM_read; 
   output logic DM_write; 
   
   logic [5:0]            opcode;
   logic                    sub_opcode;
   logic               sub_opcode_1;
   logic [3:0]            sub_opcode_4;
   logic [4:0]            sub_opcode_5;
   logic [7:0]            sub_opcode_8;
   logic [9:8]  sv;
   logic          aluSrc2;
   
   logic [`RegBus]  imm;
   logic [`Thirdteen]   thirdteenSE;
   logic [`Fifteen]     fifteenSE;
   logic [`Twentythree] twentythreeSE;
   
   always_comb begin
       thirdteenSE = inst_i[13:0]>>1'b1;
       fifteenSE = inst_i[15:0]>>1'b1;
       twentythreeSE = inst_i[23:0]>>1'b1;
   end
   
   
   always_comb begin
      
      opcode        = inst_i[30:25];
      sub_opcode    = inst_i[14];
      sub_opcode_1  = inst_i[5];
      sub_opcode_4 = inst_i[19:16];
      sub_opcode_5 = inst_i[4:0];
      sub_opcode_8 = inst_i[7:0];
      sv = inst_i[9:8];
      
   end
   
   always_comb begin
        if(aluSrc2==`ImmSrc)begin
            
            if(DM_write==`WriteEnable)begin
              reg1_o = reg1_data_i;
              reg2_o = imm;
              sw_o   = sw_data_i;
            end
            else begin
              reg1_o = reg1_data_i;
              reg2_o = imm;
              sw_o   = `ZeroWord;
            end
        end
        else if(aluSrc2==`RegSrc)begin      
            
            if(DM_write==`WriteEnable)begin
              reg1_o = reg1_data_i;
              reg2_o = reg2_data_i<<sv;
              sw_o   = sw_data_i;
            end
            else if(DM_read==`ReadEnable)begin
              reg1_o = reg1_data_i;
              reg2_o = reg2_data_i<<sv;
              sw_o   = `ZeroWord;
            end
            else begin
              reg1_o = reg1_data_i;
              reg2_o = reg2_data_i;  
              sw_o   = `ZeroWord;
            end
        end
        else begin
            reg1_o = `ZeroWord;
            reg2_o = `ZeroWord;  
            sw_o   = `ZeroWord;
        end
   end
   
   always_comb begin
      unique case(opcode)
        6'b100000:begin
           
           case(sub_opcode_5)
             `NOP_SRLI:begin
        
                if(inst_i[14:10]==5'b00000)begin //NOP
                    reg1_addr_o  = inst_i[19:15];
                    reg2_addr_o  = inst_i[14:10];
                    sw_addr_o    = inst_i[24:20];
                    write_addr_o = inst_i[24:20];
                    DM_read      = `ReadDisable; 
                    DM_write     = `WriteDisable;
                    sw_read = `ReadDisable; 
                    reg_write   = `WriteDisable;
                    alu_ctrl = `AluCtrlNop;
                    lwsrc = `LwAluSrc;
                    aluSrc2 = `ImmSrc;
                    movsrc = `MvAluSrc;
                    reg1_read    = `ReadEnable;
                    reg2_read    = `ReadDisable;
                    write_o = `ZeroWord;
                    branch_addr = `ZeroWord;
                    imm = `ZeroWord;
                   
                end
                else begin //SRLI
                    reg1_addr_o  = inst_i[19:15];
                    reg2_addr_o  = inst_i[14:10];
                    sw_addr_o    = inst_i[24:20];
                    write_addr_o = inst_i[24:20];           
                    DM_read      = `ReadDisable; 
                    DM_write     = `WriteDisable;
                    sw_read = `ReadDisable; 
                    reg_write   = `WriteEnable;
                    alu_ctrl = `AluCtrlSrli;
                    lwsrc = `LwAluSrc;
                    aluSrc2 = `ImmSrc;
                    movsrc = `MvAluSrc;
                    reg1_read    = `ReadEnable;
                    reg2_read    = `ReadDisable;
                    write_o = `ZeroWord;
                    branch_addr = `ZeroWord;
                    imm = {{27{1'b0}},inst_i[14:10]};
                end  
             end
             `ADD:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable; 
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlAdd;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
             end
             `SUB:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable; 
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlSub;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
             end
             `AND:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;            
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlAnd;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
                
             end
             `OR:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlOr;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
                
             end
             `XOR:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlXor;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
                
             end
             `SLLI:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlSlli;
                lwsrc = `LwAluSrc;
                aluSrc2 = `ImmSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = {{27{1'b0}},inst_i[14:10]};
                
                
             end
             `ROTRI:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlRotri;
                lwsrc = `LwAluSrc;
                aluSrc2 = `ImmSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = {{27{1'b0}},inst_i[14:10]};
                
                
                
             end
            `SVA:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlSva;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;     
                imm = `ZeroWord;
            end
            `SVS:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;
                sw_read = `ReadDisable;           
                reg_write   = `WriteEnable;
                alu_ctrl = `AluCtrlSvs;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
            end
            default:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;     
                reg_write   = `WriteDisable;
                alu_ctrl = `AluCtrlNop;  
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadDisable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;            
                
            end             
        endcase
      end
      `ADDI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write   = `WriteEnable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlAdd;
           lwsrc = `LwAluSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;
           reg1_read    = `ReadEnable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = `ZeroWord;
           branch_addr = `ZeroWord;
           imm = {{17{inst_i[14]}},inst_i[14:0]};
           
        end
        `ORI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write   = `WriteEnable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlOr;
           lwsrc = `LwAluSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;
           reg1_read    = `ReadEnable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = `ZeroWord;
           branch_addr = `ZeroWord;
           imm = {{17{1'b0}},inst_i[14:0]};
                    
           
           
        end
        `XORI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write   = `WriteEnable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlXor;
           lwsrc = `LwAluSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;
           reg1_read    = `ReadEnable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = `ZeroWord;
           branch_addr = `ZeroWord;
           imm = {{17{1'b0}},inst_i[14:0]};
           
           
        end
        `MOVI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write   = `WriteEnable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlNop;
           lwsrc = `LwAluSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvRegSrc;
           reg1_read    = `ReadDisable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = {{12{inst_i[19]}},inst_i[19:0]};
           branch_addr = `ZeroWord;
           imm = `ZeroWord;
           
        end
        6'b011100:begin
           case(sub_opcode_8)
             `LW:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                reg_write   = `WriteEnable;
                DM_read      = `ReadEnable; 
                DM_write     = `WriteDisable; 
                alu_ctrl = `AluCtrlLwSw;
                lwsrc = `LwMemSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
             end
             `SW:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                reg_write    = `WriteDisable;
                DM_read      = `ReadDisable; 
                DM_write     = `WriteEnable; 
                alu_ctrl = `AluCtrlLwSw;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                sw_read      = `ReadEnable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;
                
             end
             default:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;     
                reg_write   = `WriteDisable;
                alu_ctrl = `AluCtrlNop;  
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadDisable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;           
             end
           endcase
           
        end
        
        `LWI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write   = `WriteEnable;
           DM_read      = `ReadEnable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlLwiSwi;
           lwsrc = `LwMemSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;
           reg1_read    = `ReadEnable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = `ZeroWord;
           branch_addr = `ZeroWord;
           imm = {{17{1'b0}},inst_i[14:0]}<<2'b10;
                      
        end
        `SWI:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write    = `WriteDisable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteEnable; 
           alu_ctrl = `AluCtrlLwiSwi;
           lwsrc = `LwAluSrc; //don't care because of DM_write
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;
           reg1_read    = `ReadEnable;
           reg2_read    = `ReadDisable;
           sw_read      = `ReadEnable;
           write_o = `ZeroWord;
           branch_addr = `ZeroWord;
           imm = {{17{1'b0}},inst_i[14:0]}<<2'b10;
           
        end
        
        6'b100110:begin
           case(sub_opcode)
             `BEQ:begin
                reg1_addr_o  = inst_i[24:20];
                reg2_addr_o  = inst_i[19:15];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                reg_write    = `WriteDisable;
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable; 
                alu_ctrl = `AluCtrlBeq;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;  
                movsrc = `MvAluSrc;
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = {{19{inst_i[13]}},thirdteenSE[12:0]};
                imm = `ZeroWord;
                
             end
             `BNE:begin
                reg1_addr_o  = inst_i[24:20];
                reg2_addr_o  = inst_i[19:15];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                reg_write    = `WriteDisable;
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable; 
                alu_ctrl = `AluCtrlBne;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc; 
                movsrc = `MvAluSrc;    
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadEnable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = {{19{inst_i[13]}},thirdteenSE[12:0]};             
                imm = `ZeroWord;
                
                
                
             end
             default:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;     
                reg_write   = `WriteDisable;
                alu_ctrl = `AluCtrlNop;  
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadDisable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;           
                     
             end
           endcase    
        end
        
        6'b100111:begin
           case(sub_opcode_4)
             `BEQZ:begin
                reg1_addr_o  = inst_i[24:20];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                reg_write    = `WriteDisable;
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable; 
                alu_ctrl = `AluCtrlBeqz;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;   
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = {{17{inst_i[15]}},fifteenSE[14:0]};
                imm = `ZeroWord; 
                 
             end
             `BNEZ:begin
                reg1_addr_o  = inst_i[24:20];
                reg2_addr_o  = inst_i[14:10];
                write_addr_o = inst_i[24:20];
                sw_addr_o    = inst_i[24:20];
                reg_write    = `WriteDisable;
                DM_read      = `ReadDisable; 
                DM_write     = `WriteDisable; 
                alu_ctrl = `AluCtrlBnez;
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;   
                reg1_read    = `ReadEnable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = {{17{inst_i[15]}},fifteenSE[14:0]};
                imm = `ZeroWord;     
                
             end
             default:begin
                reg1_addr_o  = inst_i[19:15];
                reg2_addr_o  = inst_i[14:10];
                sw_addr_o    = inst_i[24:20];
                write_addr_o = inst_i[24:20];
                DM_read      = `ReadDisable;
                DM_write     = `WriteDisable;     
                reg_write   = `WriteDisable;
                alu_ctrl = `AluCtrlNop;  
                lwsrc = `LwAluSrc;
                aluSrc2 = `RegSrc;
                movsrc = `MvAluSrc;
                reg1_read    = `ReadDisable;
                reg2_read    = `ReadDisable;
                sw_read = `ReadDisable;
                write_o = `ZeroWord;
                branch_addr = `ZeroWord;
                imm = `ZeroWord;        
                
             end
           endcase    
        end
    
        `ABS:begin
            reg1_addr_o  = inst_i[19:15];
            reg2_addr_o  = inst_i[14:10];
            sw_addr_o    = inst_i[24:20];
            write_addr_o = inst_i[24:20];
            reg_write    = `WriteEnable;
            DM_read      = `ReadDisable; 
            DM_write     = `WriteDisable; 
            alu_ctrl = `AluCtrlAbs;
            lwsrc = `LwAluSrc;
            aluSrc2 = `RegSrc;
            movsrc = `MvAluSrc;   
            reg1_read    = `ReadEnable;
            reg2_read    = `ReadDisable;
            sw_read = `ReadDisable;
            write_o = `ZeroWord;
            branch_addr = `ZeroWord;
            imm = `ZeroWord;      
        end
        
        `JUMP:begin
           reg1_addr_o  = inst_i[19:15];
           reg2_addr_o  = inst_i[14:10];
           sw_addr_o    = inst_i[24:20];
           write_addr_o = inst_i[24:20];
           reg_write    = `WriteDisable;
           DM_read      = `ReadDisable; 
           DM_write     = `WriteDisable; 
           alu_ctrl = `AluCtrlJump;
           lwsrc = `LwAluSrc;
           aluSrc2 = `ImmSrc;
           movsrc = `MvAluSrc;   
           reg1_read    = `ReadDisable;
           reg2_read    = `ReadDisable;
           sw_read = `ReadDisable;
           write_o = `ZeroWord;  
           branch_addr = {{9{inst_i[23]}} ,twentythreeSE[22:0]};
           imm = `ZeroWord;     
           
        end

        6'b100101:begin
    
            case(sub_opcode_1)

            `JR:begin
               reg1_addr_o  = inst_i[19:15];
               reg2_addr_o  = inst_i[14:10];
               sw_addr_o    = inst_i[24:20];
               write_addr_o = inst_i[24:20];
               reg_write    = `WriteDisable;
               DM_read      = `ReadDisable; 
               DM_write     = `WriteDisable; 
               alu_ctrl = `AluCtrlJrRet;
               lwsrc = `LwAluSrc;
               aluSrc2 = `RegSrc;
               movsrc = `MvAluSrc;   
               reg1_read    = `ReadDisable;
               reg2_read    = `ReadEnable;
               sw_read = `ReadDisable;  
               write_o = `ZeroWord;
               branch_addr = `ZeroWord;
               imm = `ZeroWord;  
            end

            `RET:begin
               reg1_addr_o  = inst_i[19:15];
               reg2_addr_o  = inst_i[14:10];
               sw_addr_o    = inst_i[24:20];
               write_addr_o = inst_i[24:20];
               reg_write    = `WriteDisable;
               DM_read      = `ReadDisable; 
               DM_write     = `WriteDisable; 
               alu_ctrl = `AluCtrlJrRet;
               lwsrc = `LwAluSrc;
               aluSrc2 = `RegSrc;
               movsrc = `MvAluSrc;   
               reg1_read    = `ReadDisable;
               reg2_read    = `ReadEnable;
               sw_read = `ReadDisable;  
               write_o = `ZeroWord;
               branch_addr = `ZeroWord;
               imm = `ZeroWord;  
            end

            endcase

        end
        
        default:begin
            reg1_addr_o  = inst_i[19:15];
            reg2_addr_o  = inst_i[14:10];
            sw_addr_o    = inst_i[24:20];
            write_addr_o = inst_i[24:20];
            DM_read      = `ReadDisable;
            DM_write     = `WriteDisable;     
            reg_write   = `WriteDisable;
            alu_ctrl = `AluCtrlNop;  
            lwsrc = `LwAluSrc;
            aluSrc2 = `RegSrc;
            movsrc = `MvAluSrc;
            reg1_read    = `ReadDisable;
            reg2_read    = `ReadDisable;
            sw_read = `ReadDisable;
            write_o = `ZeroWord;
            branch_addr = `ZeroWord;
            imm = `ZeroWord;                
  
        end
      endcase          
   end 
   

endmodule

