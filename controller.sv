`timescale 1ns/10ps

module controller(alu_control,
                  mux4to1_select,
                  mux2to1_select,
                  imm_reg_select,
                  reg_en, reg_write, reg_read,
                  alu_en,
                  clk, rst, 
                  ir,
                  pc_enable, IM_read, IM_enable,
                  DM_enable, DM_read, DM_write,
                  mem_or_reg,
                  CPU_STALL);
                  
      input clk;
      input rst;
      input CPU_STALL;
      
      input [31:0]ir;
               
      
      output logic [3:0]alu_control;
      output logic [1:0]mux4to1_select;
      output logic mux2to1_select;
      output logic imm_reg_select;
      output logic mem_or_reg; //new signal
      
      output logic alu_en;
      output logic reg_en;
      output logic reg_read;
      output logic reg_write;
      
      output logic pc_enable;
      output logic IM_enable;
      output logic IM_read;
      
      output logic DM_enable; //new signal
      output logic DM_read; //new signal
      output logic DM_write; //new signal
      
      logic sub_opcode;
      logic [5:0]opcode;
      logic [3:0]sub_opcode_4;
      logic [4:0]sub_opcode_5;
      logic [7:0]sub_opcode_8;  /////Fuck you
      logic [2:0]current_state;
      logic [2:0]next_state;
      
      
      always_comb begin
      
      //assign opcode = ir[30:25];
      //assign sub_opcode = ir[14];
      //assign sub_opcode_4 = ir[19:16];
      //assign sub_opcode_5 = ir[4:0];
      //assign sub_opcode_8 = ir[7:0];
      
          opcode = ir[30:25];
          sub_opcode = ir[14];
          sub_opcode_4 = ir[19:16];
          sub_opcode_5 = ir[4:0];
          sub_opcode_8 = ir[7:0];
      
      end
      
      parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;
      
      parameter NOP=5'b01001,
                ADD=5'b00000,
                SUB=5'b00001,
                AND=5'b00010,
                OR =5'b00100,
                XOR=5'b00011,
                
                SLLI=5'b01000,
                ROTRI=5'b01011,
                ADDI=6'b101000,
                ORI =6'b101100,
                XORI=6'b101011,
                MOVI=6'b100010,
                LWI=6'b000010,
                SWI=6'b001010,
                JUMP=6'b100100,
                BEQ=1'b0,
                BNE=1'b1,
                BEQZ=4'b0010,
                BNEZ=4'b0011,
                
                LW=8'b00000010,
                SW=8'b00001010;
                
                
      parameter five_ZE = 2'b00, 
                fifteen_SE = 2'b01, 
                fifteen_ZE = 2'b10,
                twenty_SE = 2'b11;
      
      always_ff@(posedge clk, posedge rst)begin
        if(rst)begin
          current_state <= S0;
        end
        else begin
          if(!CPU_STALL)
            current_state <= next_state;
        end
      end
      
      always_comb begin
        unique case(opcode)
          6'b100000:begin
             
            case(sub_opcode_5)
              NOP:begin
               
                if(ir[14:10]==5'b00000)begin
                  alu_control = 4'b1000;
                  mem_or_reg  = 1'b0;
                  imm_reg_select = 1'b1;
                  mux2to1_select = 1'b0;
                  mux4to1_select = five_ZE;
                end
                else begin //SRLI
                  alu_control = 4'b0101;
                  mem_or_reg  = 1'b0;
                  imm_reg_select = 1'b1;
                  mux2to1_select = 1'b0;
                  mux4to1_select = five_ZE;
                end  
              end
              ADD:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;
                alu_control = 4'b0000;
              end
              SUB:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;
                alu_control = 4'b0001;
              end
              AND:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;
                alu_control = 4'b0010;
              end
              OR:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;
                alu_control = 4'b0011;
              end
              XOR:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;
                alu_control = 4'b0100;
              end
              SLLI:begin
                mem_or_reg  = 1'b0;
                imm_reg_select = 1'b1;
                mux2to1_select = 1'b0;
                mux4to1_select = five_ZE;
                alu_control = 4'b0110;
              end
              ROTRI:begin
                mem_or_reg  = 1'b0;
                imm_reg_select = 1'b1;
                mux2to1_select = 1'b0;
                mux4to1_select = five_ZE;
                alu_control = 4'b0111;
              end
              default:begin
            
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;            
                alu_control = 4'b1000;  
              end             
            endcase
          end
          6'b011100:begin
            case(sub_opcode_8)
              LW:begin
               
                mem_or_reg  = 1'b1;
                alu_control = 4'b1001;
                imm_reg_select = 1'b0;
                mux2to1_select = 1'b0;
                mux4to1_select = fifteen_SE;//don't care because of imm_reg_select   
                
              end
              SW:begin
                
                mem_or_reg  = 1'b0;
                alu_control = 4'b1001;
                imm_reg_select = 1'b0;
                mux2to1_select = 1'b0;
                mux4to1_select = fifteen_SE;//don't care because of imm_reg_select     
                
              end
              default:begin
            
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;            
                alu_control = 4'b1000;  
              end
            endcase
            
          end
          ADDI:begin
            
            mem_or_reg  = 1'b0;
            alu_control = 4'b0000;
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b0;
            mux4to1_select = fifteen_SE;            
          end
          ORI:begin
            
            mem_or_reg  = 1'b0;
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b0;
            mux4to1_select = fifteen_ZE;
            alu_control = 4'b0011;
            
          end
          XORI:begin
            
            mem_or_reg  = 1'b0;
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b0;
            mux4to1_select = fifteen_ZE;
            alu_control = 4'b0100;
          
          end
          MOVI:begin
            
            mem_or_reg  = 1'b0;
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b1;
            mux4to1_select = twenty_SE;
            alu_control = 4'b1000;
          end
          LWI:begin
            
            mem_or_reg  = 1'b1;
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b0;
            mux4to1_select = fifteen_ZE;
            alu_control = 4'b1010;
          end
          SWI:begin
            
            mem_or_reg  = 1'b0; //don't care because of DM_write
            imm_reg_select = 1'b1;
            mux2to1_select = 1'b0; //don't care because of reg_write
            mux4to1_select = fifteen_ZE;
            alu_control = 4'b1010;
          end
          
          6'b100110:begin
            case(sub_opcode)
              BEQ:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;          
                alu_control = 4'b1011;
                
              end
              BNE:begin
                 mem_or_reg  = 1'b0;
                 mux4to1_select = 2'b00;        
                 mux2to1_select = 1'b0;
                 imm_reg_select = 1'b0;            
                 alu_control = 4'b1100;
                
              end
              default:begin
            
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;            
                alu_control = 4'b1000;  
              end
            endcase    
          end
          
          6'b100111:begin
            case(sub_opcode_4)
              BEQZ:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;          
                alu_control = 4'b1101;
                
              end
              BNEZ:begin
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;          
                alu_control = 4'b1110;
                
              end
               default:begin
            
                mem_or_reg  = 1'b0;
                mux4to1_select = 2'b00;        
                mux2to1_select = 1'b0;
                imm_reg_select = 1'b0;            
                alu_control = 4'b1000;  
              end
            endcase    
          end
          
          JUMP:begin
             mem_or_reg  = 1'b0;
             mux4to1_select = 2'b00;        
             mux2to1_select = 1'b0;
            imm_reg_select = 1'b0;          
            alu_control = 4'b1111;
            
          end
          
          default:begin
            
            mem_or_reg  = 1'b0;
            mux4to1_select = 2'b00;        
            mux2to1_select = 1'b0;
            imm_reg_select = 1'b0;            
            alu_control = 4'b1000;  
          end
        endcase          
      end 
      
      always_comb begin
        unique case(current_state)

          S0:begin
            next_state = S1;
          
            
            reg_en = 1'b1;
            reg_write = 1'b0;
            reg_read = 1'b1;
            alu_en = 1'b0;
            pc_enable = 1'b0;
            IM_read = 1'b1; 
            IM_enable = 1'b1; 
            DM_enable = 1'b0;
            DM_read = 1'b0; 
            DM_write = 1'b0;
          end
          
          S1:begin 
            next_state = S2;
           
     
            
            reg_en = 1'b0;
            reg_write = 1'b0;
            reg_read = 1'b0;
            alu_en = 1'b1;
            pc_enable = 1'b0;
            IM_read = 1'b0;
            IM_enable = 1'b0;
            DM_enable = 1'b0;
            DM_read = 1'b0; 
            DM_write = 1'b0;
          end
          
          S2:begin
            next_state = S3;
            
            reg_en = 1'b0;
            reg_write = 1'b0;
            reg_read = 1'b0;
            alu_en = 1'b1;
            pc_enable = 1'b0;
            IM_read = 1'b0;
            IM_enable = 1'b0;
            
            DM_enable = 1'b1;
            
            case(opcode)
                6'b011100:begin
                    if(sub_opcode_8==LW)begin
                        DM_read  = 1'b1;
                        DM_write = 1'b0;
                    end
                    else begin
                        DM_read  = 1'b0;
                        DM_write = 1'b1;
                    end 
                end
                
                6'b000010:begin
                    DM_read = 1'b1; 
                    DM_write = 1'b0;
                end     
                
                6'b001010:begin
                    DM_read = 1'b0; 
                    DM_write = 1'b1;
                end
                
                default:begin
                    DM_read = 1'b0; 
                    DM_write = 1'b0;
                end
            
            endcase
            /*if(opcode==6'b011100)begin
              if(sub_opcode_8==LW)begin
                DM_read  = 1'b1;
                DM_write = 1'b0;
              end
              else begin
                DM_read  = 1'b0;
                DM_write = 1'b1;
              end
            end
            
            else if(opcode==6'b000010)begin
              DM_read = 1'b1; 
              DM_write = 1'b0;
            end
            
            else if(opcode==6'b001010)begin
              DM_read = 1'b0; 
              DM_write = 1'b1;
            end
            
            else begin
              DM_read = 1'b0; 
              DM_write = 1'b0;
            end*/
            
          end
          
          S3:begin
            next_state = S4;
            
            reg_en = 1'b1;
            reg_read = 1'b0;
            if(opcode==6'b000000)begin
              reg_write = 1'b0;
              pc_enable = 1'b0;
            end        
            else if(opcode==6'b001010)begin
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else if(opcode==6'b011100 && sub_opcode_8==8'b00001010)begin
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else if(opcode==6'b100000 && sub_opcode_5==5'b01001 && ir[14:10]==5'b00000)begin //NOP
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else if(opcode==6'b100110)begin //BEQ BNE
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else if(opcode==6'b100111)begin //BEQZ BNEZ
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else if(opcode==6'b100100)begin //JUMP
              reg_write = 1'b0;
              pc_enable = 1'b1;
            end
            else begin
              reg_write = 1'b1;
              pc_enable = 1'b1;
            end
            
            alu_en = 1'b1;
            IM_read = 1'b0;
            IM_enable = 1'b0;
            DM_enable = 1'b0;
            DM_read = 1'b0; 
            DM_write = 1'b0;
            
          end
          
          S4:begin
            next_state = S0;
            
           
            reg_en = 1'b0;
            reg_write = 1'b0;
            reg_read = 1'b0;
            alu_en = 1'b1;
            pc_enable = 1'b0;
            IM_read = 1'b1;
            IM_enable = 1'b1;
            DM_enable = 1'b0;
            DM_read = 1'b0; 
            DM_write = 1'b0;
          end
          
        endcase  
      end
      
  
    
endmodule
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
