`timescale 1ns/10ps
`include "port_define.sv"

module pc(rst, 
          clk, 
      stall,
          branch_true,
          new_addr, 
          pc_output
);
  
  input  clk;
  input  rst;
  input  stall; 
  input  branch_true;
  input  [`InstAddrBus]new_addr;
  
  output logic [`InstAddrBus] pc_output;
  
  always_ff@(posedge clk)begin
    if(rst==`RstEnable)begin

        pc_output <= `ZeroWord;
       
    end
    else if(stall==`StallEnable)begin

    pc_output <= pc_output;
    
    end
    else begin

        if(branch_true==`BranchTrue)begin
          pc_output <= new_addr; 
        end
        else begin
          pc_output <= pc_output + 1'b1;  
        end
      
      
    end  
  end
  
  
  
endmodule
