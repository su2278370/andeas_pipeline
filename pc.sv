`timescale 1ns/10ps
`include "port_define.sv"

module pc(rst, 
          clk, 
          pc_enable,  
          branch_true,
          new_addr, 
          pc_output
);
  
  input  clk;
  input  rst; 
  input  pc_enable;
  input  branch_true;
  input  [`RegSize]new_addr;
  
  output logic [`RegSize] pc_output;
  
  
  always_ff@(posedge clk, posedge rst)begin
    if(rst==`RstEnable)begin

      pc_output <= `ZeroWord;
    
    end
    else begin
      if(pc_enable==`PcEnable)begin
        if(branch_true==`Branchtrue)begin
          pc_output <= new_addr; 
        end
        else begin
          pc_output <= pc_output + 1'b1;  
        end
      end
      
    end  
  end
  
  
  
endmodule
