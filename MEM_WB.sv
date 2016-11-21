`timescale 1ns/10ps
`include "port_define.sv"

module mem_wb(clk,
              rst,
  	      mem_lwsrc,
	      mem_movsrc_result,
   	      mem_DM_out,
	      wb_lwsrc,
	      wb_movsrc_result,
	      wb_DM_out
);
  
  input clk;
  input rst;
  
  //From Interface
  input mem_lwsrc;
  
  //From Mux
  input [`RegBus] mem_movsrc_result;
  
  //From Data memory
  input [`RegBus] mem_DM_out;


  //From Interface
  output logic wb_lwsrc;
  
  //From Mux
  output logic [`RegBus] wb_movsrc_result;
  
  //From Data memory
  output logic [`RegBus] wb_DM_out;
  
  
    
  always@(posedge clk, posedge rst)begin
    if(rst==`RstEnable)begin
    
    	wb_lwsrc = `LwAluSrc;
  	wb_movsrc_result = `ZeroWord;
  	wb_DM_out = `ZeroWord; 

    end else begin
        wb_lwsrc = mem_lwsrc;
  	wb_movsrc_result = mem_movsrc_result;
  	wb_DM_out = mem_DM_out; 
      
    end
  end     
            
endmodule
