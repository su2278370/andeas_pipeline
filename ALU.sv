`timescale 1ns/10ps
`include "port_define.sv"

module alu(overflow, 
    alu_result, 
    src1, 
    src2, 
    aluctrl,
    alu_pc_o,
    alu_branch_addr, 
    branch_true,
    new_addr);

input [`RegBus] src1 , src2;
input [`AluCtrl] aluctrl;
input [`InstAddrBus] alu_pc_o;
input [`InstAddrBus] alu_branch_addr;

output logic [`RegBus] alu_result;
output logic overflow;
output logic branch_true;
output logic [`InstAddrBus] new_addr;

logic [`TempBus] temp;

always_comb begin
  
  temp  = {src1 , src1}>>(src2 % 32);       


      case(aluctrl)
          `AluCtrlAdd :begin //ADD
            alu_result = src1 + src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;

          end
          `AluCtrlSub :begin //SUB
            alu_result = src1 - src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
            
          end
          `AluCtrlAnd :begin //AND
            alu_result = src1 & src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlOr :begin //OR

            alu_result = src1 | src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlXor :begin //XOR
            alu_result = src1 ^ src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlSrli :begin //shift right
            alu_result = src1 >> src2[4:0];
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlSlli :begin //shift left
            alu_result = src1 << src2[4:0];
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlRotri :begin //rotate
            alu_result = temp[31:0];
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
          `AluCtrlLwSw :begin //Load & store address
             alu_result = src1 + src2;
             branch_true = `BranchFalse;
             overflow = 1'b0;
             new_addr = `ZeroWord;
  
          end
          `AluCtrlLwiSwi :begin //Load & store immediate address
            alu_result = src1 + src2;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
            
          end
          `AluCtrlBeq :begin //Branch equal
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1==src2)
              branch_true = `BranchTrue;
            else
              branch_true = `BranchFalse;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBne :begin //Branch if not equal
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1!=src2)
              branch_true = `BranchTrue;
            else
              branch_true = `BranchFalse;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBeqz :begin //Branch if zero
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1==0)
              branch_true = `BranchTrue;
            else
              branch_true = `BranchFalse;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBnez :begin //Branch if not zero
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1!=0)
              branch_true = `BranchTrue;
            else
              branch_true = `BranchFalse;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlJump :begin //Jump
            new_addr = alu_pc_o + alu_branch_addr;
            branch_true = `BranchTrue;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
      `AluCtrlSva :begin
         temp = src1 + src2;
             branch_true = `BranchFalse;
            
             if((temp[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b0) || (temp[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b1))begin
        alu_result = `OverFlowTrue;
                overflow = 1'b1;
         end
             else begin
        alu_result = `OverFlowFalse;
                overflow = 1'b0;
         end
         new_addr = `ZeroWord;
      end
      `AluCtrlSvs:begin
         temp = src1 - src2;
             branch_true = `BranchFalse;
        
             if((temp[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b1) || (temp[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b0))begin
        alu_result = `OverFlowTrue;
                overflow = 1'b1;
             end
             else begin
        alu_result = `OverFlowFalse;
                overflow = 1'b0;
         end
         new_addr = `ZeroWord;
      end
      `AluCtrlAbs:begin
        if(src1[31]==1'b1) //negative       
            alu_result = (~src1) + 1'b1;
        else //positive
            alu_result = src1;
        new_addr = `ZeroWord;
        overflow = 1'b0;
        branch_true = `BranchFalse;
      end
      `AluCtrlJrRet:begin
        new_addr = src2 >> 2;
            branch_true = `BranchTrue;
            alu_result = 1'b0;
                overflow = 1'b0;
      end
          default :begin
            alu_result = 1'b0;
            branch_true = `BranchFalse;
            overflow = 1'b0;
            new_addr = `ZeroWord;
          end
      endcase
  
end

endmodule
