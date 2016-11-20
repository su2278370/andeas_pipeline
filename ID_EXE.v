`timescale 1ns/10ps
`include "port_define.sv"


module if_id(clk,
             rst,
             id_reg1,
             id_reg2,
			 id_aluctrl,
             id_mem_reg
);

	output logic [`RegAddrBus] reg1_addr_o;
	output logic [`RegAddrBus] reg2_addr_o;
	output logic [`RegAddrBus] reg3_addr_o;
	output logic [`RegBus]     reg1_o;
	output logic [`RegBus]     reg2_o;
	output logic [`RegBus]     reg3_o;
	
	output logic [`AluCtrl]    alu_ctrl;
	output logic 	      src_mem_alu;
	output logic 	      src_imm_reg;
	output logic 	      src_din;
	output logic [`Extension]  extension;


endmodule