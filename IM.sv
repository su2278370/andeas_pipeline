`timescale 1ns/10ps
`include "port_define.sv"

module IM(clk, 
          rst,
          IM_read, 
          IM_addr, 
          IM_out);
  
  input clk;
  input rst; 
  input IM_read; 
  input [`ImAddr]IM_addr;
  
  output logic [`RegBus]IM_out;
  
  logic [`RegBus]mem_data[`ImSize-1:0];
  
  integer i;
  
  always_ff@(posedge clk)begin

    if(rst==`RstEnable)begin
      for(i=0;i<`ImSize;i=i+1)begin
        
        mem_data[i] <= `ZeroWord;

      end
    end

  end

  always_comb begin
    if(rst==`RstEnable)begin
      
      IM_out = `ZeroWord;
      
    end
    else if(IM_read==`ReadEnable)begin
        IM_out = mem_data[IM_addr];  
    end   
    
  end

endmodule
          
