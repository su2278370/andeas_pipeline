`timescale 1ns/10ps
`include "port_define.sv"


module if_exe(clk,
              rst,
              id_reg1,
              id_reg2,
			  id_aluctrl,
              id_mem_reg
);
	input clk;
	input rst;
	
	input [`InstAddrBus] id_pc_o;
	input [`InstAddrBus] id_branch_addr;
	
	input [`RegBus] id_reg1_o;
	input [`RegBus] id_reg2_o;
	input [`RegBus] id_write_o;
	
	input [`AluCtrl]    id_alu_ctrl;
    input 	      id_lwsrc;
    input 	      id_aluSrc2;
    //input 	      id_src_din;
    //input [`Extension]  id_extension;   
    input id_DM_read; 
    input id_DM_write;
	
	output logic [`InstAddrBus] exe_pc_o;
	output logic [`InstAddrBus] exe_branch_addr;
	
	output logic [`RegBus] exe_reg1_o;
	output logic [`RegBus] exe_reg2_o;
	output logic [`RegBus] exe_write_o;
	
	output logic [`AluCtrl]    exe_alu_ctrl;
    output logic 	      exe_lwsrc;
    output logic 	      exe_aluSrc2;
    //output logic 	      exe_src_din;
    //output logic [`Extension]  exe_extension;   
    output logic exe_DM_read; 
    output logic exe_DM_write;
	
	always@(posedge clk, posedge rst)begin
		if(rst==`RstEnable)begin
			exe_pc_o <= `ZeroWord;
			exe_branch_addr <= `ZeroWord;	
			exe_reg1_o <= `ZeroWord;
			exe_reg2_o <= `ZeroWord;
			exe_write_o <= `ZeroWord;
			exe_alu_ctrl <= `AluCtrlNop;
			exe_lwsrc <= 1'b0;
			exe_aluSrc2 <= `RegSrc;
			//exe_src_din;
			//exe_extension;   
			exe_DM_read  <= `ReadDisable; 
			exe_DM_write <= `WriteDisable;
		end else begin
			exe_pc_o <= id_pc_o;
			exe_branch_addr <= id_branch_addr;	
			exe_reg1_o <= id_reg1_o;
			exe_reg2_o <= id_reg2_o;
			exe_write_o <= id_write_o;
			exe_alu_ctrl <= id_alu_ctrl;
			exe_lwsrc <= id_lwsrc;
			exe_aluSrc2 <= id_aluSrc2;
			//exe_src_din;
			//exe_extension;   
			exe_DM_read  <= id_DM_read; 
			exe_DM_write <= id_DM_write;
		end
	end     


endmodule