`timescale 1ns/10ps
`include "port_define.sv"

module exe_mem(clk,
               rst,
               exe_sw_o,
           exe_write_o,
  exe_lwsrc,
  exe_movsrc,
  exe_write_addr_o,
  exe_reg_write,
  exe_DM_read, 
  exe_DM_write,
  exe_alu_result,

  mem_lwsrc,
  
  
  mem_movsrc,
  mem_write_o,
  
  
  mem_sw_o,
  mem_write_addr_o,
  mem_reg_write,
  mem_DM_read, 
  mem_DM_write,
  mem_alu_result 

);
  
  input clk;
  input rst;

  input [`RegBus] exe_sw_o;
  input [`RegBus] exe_write_o;
  input       exe_lwsrc;
  input           exe_movsrc;
  input  [`RegAddrBus]exe_write_addr_o;
  input           exe_reg_write;
  input           exe_DM_read; 
  input           exe_DM_write;
  input [`RegBus] exe_alu_result;

  
  //Interface to Interface
  output logic        mem_lwsrc;
  
  //Interface to mux
  output logic           mem_movsrc;
  output logic [`RegBus] mem_write_o;
//output logic [`RegBus] mem_alu_result;
  
  //Interface to Date Memory  
  output logic [`RegBus] mem_sw_o;
  output logic [`RegAddrBus] mem_write_addr_o;
  output logic mem_reg_write;
  output logic           mem_DM_read; 
  output logic           mem_DM_write;
  output logic [`RegBus] mem_alu_result; 

  //Alu to Pc
  //input logic exe_overflow              
  //input logic exe_branch_true
  //input logic [`InstAddrBus] exe_nwe_addr;

  
  always_ff@(posedge clk)begin
    if(rst==`RstEnable)begin
      mem_sw_o <= `ZeroWord;
      mem_write_o <= `ZeroWord;
      mem_lwsrc <= `LwAluSrc;
      mem_movsrc <= `MvAluSrc;
      mem_write_addr_o <= `ZeroRegAddr;
      mem_reg_write <= `WriteDisable;
      mem_DM_read <= `ReadDisable; 
      mem_DM_write <= `WriteDisable;
      mem_alu_result <= `ZeroWord;
    end else begin
      mem_sw_o <= exe_sw_o;
      mem_write_o <= exe_write_o;
      mem_lwsrc <= exe_lwsrc;
      mem_movsrc <= exe_movsrc;
      mem_write_addr_o <= exe_write_addr_o;
      mem_reg_write <= exe_reg_write;
      mem_DM_read <= exe_DM_read; 
      mem_DM_write <= exe_DM_write;
      mem_alu_result <= exe_alu_result;
      
    end
  end     
            
endmodule
