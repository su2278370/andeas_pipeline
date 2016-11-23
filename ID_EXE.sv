`timescale 1ns/10ps
`include "port_define.sv"


module id_exe(clk,
              rst,
              id_pc_o,
              id_branch_addr,
              id_write_addr_o,
              id_reg1_o,
              id_reg2_o,
              id_sw_o,
              id_write_o,
			        id_aluctrl,
              id_lwsrc,
              
              id_movsrc,
              id_reg_write,
              id_DM_read,
              id_DM_write,
              exe_pc_o,
              exe_branch_addr,
              exe_write_addr_o,
              exe_reg1_o,
              exe_reg2_o,
              exe_sw_o,
              exe_write_o,
			        exe_aluctrl,
              exe_lwsrc,
              
              exe_movsrc,
              exe_reg_write,
              exe_DM_read,
              exe_DM_write
);
	input clk;
	input rst;
	
	input [`InstAddrBus] id_pc_o;
	input [`InstAddrBus] id_branch_addr;
	input [`RegAddrBus] id_write_addr_o;
	
	input [`RegBus] id_reg1_o;
	input [`RegBus] id_reg2_o;
	input [`RegBus] id_sw_o;
	input [`RegBus] id_write_o;
	
	input [`AluCtrl]    id_aluctrl;
  input id_lwsrc;
  
  input id_movsrc;
  input id_reg_write;
  input id_DM_read; 
  input id_DM_write;
	
	//Interface to Alu
	output logic [`InstAddrBus] exe_pc_o;
	output logic [`InstAddrBus] exe_branch_addr;
	output logic [`RegAddrBus] exe_write_addr_o;
	output logic [`RegBus] exe_reg1_o;
	output logic [`RegBus] exe_reg2_o;
  output logic [`AluCtrl]    exe_aluctrl;
	
	//Interface tp Interface
	output logic [`RegBus] exe_sw_o;
	output logic [`RegBus] exe_write_o;
  output logic 	      exe_lwsrc;
 
  output logic        exe_movsrc;
  output logic exe_reg_write;
  output logic exe_DM_read; 
  output logic exe_DM_write;
	
	always@(posedge clk, posedge rst)begin
		if(rst==`RstEnable)begin
			exe_pc_o <= `ZeroWord;
			exe_branch_addr <= `ZeroWord;
			exe_write_addr_o <= `ZeroRegAddr;	
			exe_reg1_o <= `ZeroWord;
			exe_reg2_o <= `ZeroWord;
			exe_sw_o   <= `ZeroWord;
			exe_write_o <= `ZeroWord;
			exe_aluctrl <= `AluCtrlNop;
			exe_lwsrc <= `LwAluSrc;
			
			exe_movsrc  <= `MvAluSrc;
			exe_reg_write <= `WriteDisable;
			exe_DM_read  <= `ReadDisable; 
			exe_DM_write <= `WriteDisable;
		end else begin
			exe_pc_o <= id_pc_o;
			exe_branch_addr <= id_branch_addr;
			exe_write_addr_o <= id_write_addr_o;	
			exe_reg1_o <= id_reg1_o;
			exe_reg2_o <= id_reg2_o;
			exe_sw_o <= id_sw_o;
			exe_write_o <= id_write_o;
			exe_aluctrl <= id_aluctrl;
			exe_lwsrc <= id_lwsrc;
			
			exe_movsrc <= id_movsrc;
			exe_reg_write <= id_reg_write;  
			exe_DM_read  <= id_DM_read; 
			exe_DM_write <= id_DM_write;
		end
	end     


endmodule
