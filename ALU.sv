`timescale 1ns/10ps

module ALU(overflow, alu_result, src1, src2, aluctrl, enable, branch_true);

input enable;
input [`RegBus] src1 , src2;
input [`AluCtrl] aluctrl;
input [`InstAddrBus] alu_pc_o;
input [`InstAddrBus] alu_branch_addr;

output logic [`RegBus] alu_result;
output logic overflow;
output logic branch_true;
output logic [`InstAddrBus] new_addr;

logic [DSize-1:0] temp;

always_comb begin
  
  temp  = {src1 , src1}>>(src2 % 32);       


      case(aluctrl)
          `AluCtrlAdd :begin //ADD
            alu_result = src1 + src2;
            branch_true = 1'b0;
            //???
            if((alu_result[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b0) || (alu_result[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b1))
              overflow = 1'b1;
            else
              overflow = 1'b0;
          end
          `AluCtrlSub :begin //SUB
            alu_result = src1 - src2;
            branch_true = 1'b0;
            if((alu_result[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b1) || (alu_result[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b0))
              overflow = 1'b1;
            else
              overflow = 1'b0;
          end
          `AluCtrlAnd :begin //AND
            alu_result = src1 & src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlOr :begin //OR

            alu_result = src1 | src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlXor :begin //XOR
            alu_result = src1 ^ src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlSrli :begin //shift right
            alu_result = src1 >> src2[4:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlSlli :begin //shift left
            alu_result = src1 << src2[4:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlRotri :begin //rotate
            alu_result = temp[31:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlLwSw :begin //Load & store address
             alu_result = src1 + src2;
             branch_true = 1'b0;
             overflow = 1'b0;
  
          end
          `AluCtrlLwiSwi :begin //Load & store immediate address
            alu_result = src1 + src2;
            branch_true = 1'b0;
            overflow = 1'b0;
            
          end
          `AluCtrlBeq :begin //Branch equal
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1==src2)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBne :begin //Branch if not equal
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1!=src2)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBeqz :begin //Branch if zero
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1==0)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlBnez :begin //Branch if not zero
            new_addr = alu_pc_o + alu_branch_addr;
            if(src1!=0)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          `AluCtrlJump :begin //Jump
            new_addr = alu_pc_o + alu_branch_addr;
            branch_true = 1'b1;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          default :begin
            alu_result = 1'b0;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
      endcase
  
end

endmodule
