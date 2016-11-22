`timescale 1ns/10ps
`include "port_define.sv"

module IM(clk, 
	  rst,
          IM_read, 
          IM_addr, 
          IM_out,
 );
  
  input clk;
  input rst; 
  input IM_read; 
  input [`ImAddr]IM_addr;
  
  output logic [`RegBus]IM_out;
  
  logic [`RegBus]mem_data[`ImSize-1:0];
  
  integer i;
  
  always_ff@(posedge clk, posedge rst)begin
    if(rst)begin
      for(i=0;i<`ImSize;i=i+1)begin
        
        mem_data[i] <= `ZeroWord;
      end
      IM_out <= `ZeroWord;
      
    end
    else begin
      if(IM_read)
        IM_out <= mem_data[IM_addr];
      
      else
	IM_out <= `ZeroWord;
    end
 
  end
  
endmodule
          
