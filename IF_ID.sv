`timescale 1ns/10ps
`include "port_define.sv"


module if_id(clk,
             rst,
	     flush,
             if_pc,
             if_inst,
             id_pc,
             id_inst
);
            
  input clk;
  input rst;
  input flush;

  input [`RegBus]if_pc;
  input [`RegBus]if_inst;
  
  output logic [`RegBus]id_pc;          
  output logic [`RegBus]id_inst;
  
  always@(posedge clk, posedge rst)begin
    if(rst==`RstEnable || flush==`FlushEnable)begin
      id_pc <= `ZeroWord;
      id_inst <= `ZeroWord;
    end else begin
      id_pc <= if_pc;
      id_inst <= if_inst;
    end
  end     
            
endmodule
