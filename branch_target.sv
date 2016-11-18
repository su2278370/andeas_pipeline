`timescale 1ns/10ps
`include "port_define.sv"

module branch_target(clk,rst,
                    alu_control,
                    instruction,
                    pc,
                    branch_addr);
   
   input clk,rst;
   input [3:0] alu_control;
   input [23:0] instruction;
   input [`RegBus] pc;
   
   output logic [`RegBus] branch_addr;
   
   logic [`ThirdTeem]   thirdteenSE;
   logic [`Fifteen]     fifteenSE;
   logic [`TwentyThree] twentythreeSE;
   logic [`RegBus] pc_bq, pc_bqz, pc_jp;
   
   
   always_comb begin
       thirdteenSE = instruction[13:0]>>1'b1;
       fifteenSE = instruction[15:0]>>1'b1;
       twentythreeSE = instruction[23:0]>>1'b1;
    
       pc_bq  = pc + {{19{instruction[13]}},thirdteenSE[12:0]};
       pc_bqz = pc +{{17{instruction[15]}},fifteenSE[14:0]};
       pc_jp  = pc + {{9{instruction[23]}} ,twentythreeSE[22:0]};
   end
   
   
    always_ff@(posedge clk, posedge rst)begin
        if(rst)begin

            branch_addr <= `ZeroWord;
    
        end
        else begin

            case(alu_control)
                `AluCtrlBeq:begin
                  
                  branch_addr <= pc_bq;
                end
                `AluCtrlBne:begin
                  
                  branch_addr <= pc_bq;
                end
                `AluCtrlBeqz:begin
                  
                  branch_addr <= pc_bqz;
                end
                `AluCtrlBnez:begin
                  
                  branch_addr <= pc_bqz;
                end
                `AluCtrlJump:begin
                  
                  branch_addr <= pc_jp;
                end
            endcase
        end
    end
   
  
   
endmodule
