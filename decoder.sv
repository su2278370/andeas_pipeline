`timescale 1ns/10ps
`include "port_define.sv"

module decoder(clk,
               rst,
               pc_i,
               inst_i,
               reg1_data_i,
               reg2_data_i,
               reg3_data_i, //write
               reg1_addr_o,
               reg2_addr_o,
               reg3_addr_o, //write
               reg1_o,
               reg2_o,
               reg3_o, //write
               alu_ctrl,
               src_mem_alu,
               src_imm_reg,
               src_din, 
               extension
	       );

   input clk;
   input rst;
   input [`InstAddrBus] pc_i;
   input [`InstBus] 	inst_i;
   
   input [`RegBus] 	reg1_data_i;
   input [`RegBus] 	reg2_data_i;
   input [`RegBus] 	reg3_data_i;
   
   output logic [`RegAddrBus] reg1_addr_o;
   output logic [`RegAddrBus] reg2_addr_o;
   output logic [`RegAddrBus] reg3_addr_o;
   output logic [`RegBus]     reg1_o;
   output logic [`RegBus]     reg2_o;
   output logic [`RegBus]     reg3_o;
   output logic [`AluCtrl]    alu_ctrl;
   output logic 	      src_mem_alu;
   output logic 	      src_imm_reg;
   output logic 	      src_din;
   output logic [`Extension]  extension;
   
   logic [5:0] 		      opcode;
   logic 		            sub_opcode;
   logic [3:0] 		      sub_opcode_4;
   logic [4:0] 		      sub_opcode_5;
   logic [7:0] 		      sub_opcode_8;
   
   always_comb begin
      
      opcode       = inst_i[30:25];
      sub_opcode   = inst_i[14];
      sub_opcode_4 = inst_i[19:16];
      sub_opcode_5 = inst_i[4:0];
      sub_opcode_8 = inst_i[7:0];
      
   end
   
   
   always_comb begin
      unique case(opcode)
        6'b100000:begin
           
           case(sub_opcode_5)
             `NOP:begin
		
                if(inst_i[14:10]==5'b00000)begin
                   alu_ctrl = 4'b1000;
                   src_mem_alu  = 1'b0;
                   src_imm_reg = 1'b1;
                   src_din = 1'b0;
                   extension = `FiveZE;
                end
                else begin //SRLI
                   alu_ctrl = 4'b0101;
                   src_mem_alu  = 1'b0;
                   src_imm_reg = 1'b1;
                   src_din = 1'b0;
                   extension = `FiveZE;
                end  
             end
             `ADD:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;
                alu_ctrl = 4'b0000;
             end
             `SUB:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;
                alu_ctrl = 4'b0001;
             end
             `AND:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;
                alu_ctrl = 4'b0010;
             end
             `OR:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;
                alu_ctrl = 4'b0011;
             end
             `XOR:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;
                alu_ctrl = 4'b0100;
             end
             `SLLI:begin
                src_mem_alu  = 1'b0;
                src_imm_reg = 1'b1;
                src_din = 1'b0;
                extension = `FiveZE;
                alu_ctrl = 4'b0110;
             end
             `ROTRI:begin
                src_mem_alu  = 1'b0;
                src_imm_reg = 1'b1;
                src_din = 1'b0;
                extension = `FiveZE;
                alu_ctrl = 4'b0111;
             end
             default:begin
		
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;            
                alu_ctrl = 4'b1000;  
             end             
           endcase
        end
        6'b011100:begin
           case(sub_opcode_8)
             `LW:begin
		
                src_mem_alu  = 1'b1;
                alu_ctrl = 4'b1001;
                src_imm_reg = 1'b0;
                src_din = 1'b0;
                extension = `FifteenSE;//don't care because of src_imm_reg   
                
             end
             `SW:begin
                
                src_mem_alu  = 1'b0;
                alu_ctrl = 4'b1001;
                src_imm_reg = 1'b0;
                src_din = 1'b0;
                extension = `FifteenSE;//don't care because of src_imm_reg     
                
             end
             default:begin
		
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;            
                alu_ctrl = 4'b1000;  
             end
           endcase
           
        end
        `ADDI:begin
           
           src_mem_alu  = 1'b0;
           alu_ctrl = 4'b0000;
           src_imm_reg = 1'b1;
           src_din = 1'b0;
           extension = `FifteenSE;            
        end
        `ORI:begin
           
           src_mem_alu  = 1'b0;
           src_imm_reg = 1'b1;
           src_din = 1'b0;
           extension = `FifteenZE;
           alu_ctrl = 4'b0011;
           
        end
        `XORI:begin
           
           src_mem_alu  = 1'b0;
           src_imm_reg = 1'b1;
           src_din = 1'b0;
           extension = `FifteenZE;
           alu_ctrl = 4'b0100;
           
        end
        `MOVI:begin
           
           src_mem_alu  = 1'b0;
           src_imm_reg = 1'b1;
           src_din = 1'b1;
           extension = `TwentySE;
           alu_ctrl = 4'b1000;
        end
        `LWI:begin
           
           src_mem_alu  = 1'b1;
           src_imm_reg = 1'b1;
           src_din = 1'b0;
           extension = `FifteenZE;
           alu_ctrl = 4'b1010;
        end
        `SWI:begin
           
           src_mem_alu  = 1'b0; //don't care because of DM_write
           src_imm_reg = 1'b1;
           src_din = 1'b0; //don't care because of reg_write
           extension = `FifteenZE;
           alu_ctrl = 4'b1010;
        end
        
        6'b100110:begin
           case(sub_opcode)
             `BEQ:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;          
                alu_ctrl = 4'b1011;
                
             end
             `BNE:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;            
                alu_ctrl = 4'b1100;
                
             end
             default:begin
		
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;            
                alu_ctrl = 4'b1000;  
             end
           endcase    
        end
        
        6'b100111:begin
           case(sub_opcode_4)
             `BEQZ:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;          
                alu_ctrl = 4'b1101;
                
             end
             `BNEZ:begin
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;          
                alu_ctrl = 4'b1110;
                
             end
             default:begin
		
                src_mem_alu  = 1'b0;
                extension = 2'b00;        
                src_din = 1'b0;
                src_imm_reg = 1'b0;            
                alu_ctrl = 4'b1000;  
             end
           endcase    
        end
        
        `JUMP:begin
           src_mem_alu  = 1'b0;
           extension = 2'b00;        
           src_din = 1'b0;
           src_imm_reg = 1'b0;          
           alu_ctrl = 4'b1111;
           
        end
        
        default:begin
           
           src_mem_alu  = 1'b0;
           extension = 2'b00;        
           src_din = 1'b0;
           src_imm_reg = 1'b0;            
           alu_ctrl = 4'b1000;  
        end
      endcase          
   end 
   



endmodule

