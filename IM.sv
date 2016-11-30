`timescale 1ns/10ps
`include "port_define.sv"

module IM(clk, 
          rst,
          IM_read, 
          IM_address, 
          instruction);
  
  input clk;
  input rst; 
  input IM_read; 
  input [`ImAddr]IM_address;
  
  output logic [`RegBus]instruction;
  
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
      
      instruction = `ZeroWord;
      
    end
    else if(IM_read==`ReadEnable)begin
        instruction = mem_data[IM_address];  
    end   
    
  end

endmodule
          
