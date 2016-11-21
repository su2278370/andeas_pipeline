`timescale 1ns/10ps
`include "port_define.sv"

module exe_mem(clk,
               rst,
               if_pc,
               if_inst,
               id_pc,
               id_inst
);
  
  input clk;
  input rst;

  input [`RegBus] exe_sw_o;
  input [`RegBus] exe_write_o;
  input  	  exe_lwsrc;
  input           exe_movsrc;
  input           exe_DM_read; 
  input           exe_DM_write;
  input [`RegBus] exe_alu_result;

  
  //Interface to Interface
  output logic  	  mem_lwsrc;
  
  //Interface to mux
  output logic           mem_movsrc;
  output logic [`RegBus] mem_write_o;
  
  //Interface to Date Memory  
  output logic [`RegBus] mem_sw_o;
  output logic           mem_DM_read; 
  output logic           mem_DM_write;
  output logic [`RegBus] mem_alu_result; //Interface to mux

  //Alu to Pc
  //input logic	exe_overflow	          
  //input logic	exe_branch_true
  //input logic	[`InstAddrBus] exe_nwe_addr;

  
  always@(posedge clk, posedge rst)begin
    if(rst==`RstEnable)begin
      mem_sw_o <= `ZeroWord;
      mem_write_o <= `ZeroWord;
      mem_lwsrc <= `LwAluSrc;
      mem_movsrc <= `MvAluSrc;
      mem_DM_read <= `ReadDisable; 
      mem_DM_write <= `WriteDisable;
      mem_alu_result <= `ZeroWord;
    end else begin
      mem_sw_o <= exe_sw_o;
      mem_write_o <= exe_write_o;
      mem_lwsrc <= exe_lwsrc;
      mem_movsrc <= exe_movsrc;
      mem_DM_read <= exe_DM_read; 
      mem_DM_write <= exe_DM_write;
      mem_alu_result <= exe_alu_result;
      
    end
  end     
            
endmodule
