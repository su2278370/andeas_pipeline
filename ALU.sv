`timescale 1ns/10ps

module ALU(overflow, alu_result, src1, src2, src3, op, enable, sv, branch_true);

parameter DSize = 32;
parameter OSize = 3;

input enable;
input [DSize-1:0] src1 , src2 , src3;
input [OSize:0] op;
input [1:0] sv;

output logic [DSize-1:0] alu_result;
output logic overflow;
output logic branch_true;

//logic [2*DSize-1:0] temp;
logic [DSize-1:0] temp;
//logic [DSize-1:0] temp1;

//assign temp1  = src%2;
//assign temp   = {src1 , src1}>>(src2 % 32);

always_comb begin
  
  temp  = {src1 , src1}>>(src2 % 32);       

  if(enable)begin
      case(op)
          4'b0000 :begin //ADD
            alu_result = src1 + src2;
            branch_true = 1'b0;
            //???
            if((alu_result[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b0) || (alu_result[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b1))
              overflow = 1'b1;
            else
              overflow = 1'b0;
          end
          4'b0001 :begin //SUB
            alu_result = src1 - src2;
            branch_true = 1'b0;
            if((alu_result[31] == 1'b1 && src1[31] == 1'b0 && src2[31] == 1'b1) || (alu_result[31] == 1'b0 && src1[31] == 1'b1 && src2[31] == 1'b0))
              overflow = 1'b1;
            else
              overflow = 1'b0;
          end
          4'b0010 :begin //AND
            alu_result = src1 & src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b0011 :begin //OR

            alu_result = src1 | src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b0100 :begin //XOR
            alu_result = src1 ^ src2;
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b0101 :begin //shift right
            alu_result = src1 >> src2[4:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b0110 :begin //shift left
            alu_result = src1 << src2[4:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b0111 :begin //rotate
            alu_result = temp[31:0];
            branch_true = 1'b0;
            overflow = 1'b0;
          end
          4'b1001 :begin //Load & store address
             alu_result = src1 + (src2 << sv);
             branch_true = 1'b0;
             overflow = 1'b0;
  
          end
          4'b1010 :begin //Load & store immediate address
            alu_result = src1 + (src2 << 2);
            branch_true = 1'b0;
            overflow = 1'b0;
            
          end
          4'b1011 :begin //Branch equal
            if(src1==src3)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          4'b1100 :begin //Branch if not equal
            if(src1!=src3)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          4'b1101 :begin //Branch if zero
            if(src3==0)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          4'b1110 :begin //Branch if not zero
            if(src3!=0)
              branch_true = 1'b1;
            else
              branch_true = 1'b0;
            alu_result = 1'b0;
            overflow = 1'b0;
          end
          4'b1111:begin //Jump
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
  else begin
    alu_result = 1'b0;
    branch_true = 1'b0;
    overflow = 1'b0;
  end
end

endmodule
