`timescale 1ns/10ps
`include "port_define.sv"


module if_id(clk,
             rst,
	     flush,
	     stall,
             if_pc,
             if_inst,
             id_pc,
             id_inst
);
            
  input clk;
  input rst;
  input flush;
  input stall;

  input [`RegBus]if_pc;
  input [`RegBus]if_inst;
  
  output logic [`RegBus]id_pc;          
  output logic [`RegBus]id_inst;
  
  always@(posedge clk, posedge rst)begin
    if(rst==`RstEnable || flush==`FlushEnable || stall==`StallEnable)begin
      id_pc <= `ZeroWord;
      id_inst <= `ZeroWord;
    end else begin
      id_pc <= if_pc;
      id_inst <= if_inst;
    end
  end     
            
endmodule
