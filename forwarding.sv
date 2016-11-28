`timescale 1ns/10ps
`include "port_define.sv"

module forwarding(
	   id_inst, //load dependency
	   id_reg1_addr,
	   id_reg2_addr,
	   id_sw_addr,
	   id_reg1_o,
	   id_reg2_o,
	   id_sw_o,
	   id_reg1_read,
	   id_reg2_read,
           id_sw_read,		
	   exe_write_addr,
           exe_reg_write,
	   exe_movsrc,
	   exe_alu_data,
	   exe_mov_data,
	   mem_write_addr,
	   mem_reg_write,
	   mem_DM_read,
	   mem_movsrc,
	   mem_alu_data,
           mem_data,
	   mem_mov_data,
           //wb_write_addr,   
	   //wb_reg_write,
	   //wb_data,
	   forward1_data,
           forward2_data,
	   forwardsw_data,
           //forwardsrc1,
	   //forwardsrc2
	   stall_pc, //load dependency
	   stall_if_id //load dependency	   
);
	
	input [`RegBus] id_inst;
	input [`RegAddrBus] id_reg1_addr;
	input [`RegAddrBus] id_reg2_addr;
        input [`RegAddrBus] id_sw_addr;
	input [`RegBus] id_reg1_o;
	input [`RegBus] id_reg2_o;
	input [`RegBus] id_sw_o;
	input id_reg1_read;
	input id_reg2_read;
	input id_sw_read;
	

	input [`RegAddrBus] exe_write_addr;
	input exe_reg_write;
	input exe_movsrc;
	input [`RegBus] exe_alu_data;
	input [`RegBus] exe_mov_data;

	input [`RegAddrBus] mem_write_addr;
	input mem_reg_write;
	input mem_DM_read;
	input mem_movsrc;
	input [`RegBus] mem_alu_data;
	input [`RegBus] mem_data;
	input [`RegBus] mem_mov_data;

	//input [`RegAddrBus] wb_write_addr;
	//input wb_reg_write;
	//input [`RegBus] wb_data;
	
	output logic [`RegBus] forward1_data;
	output logic [`RegBus] forward2_data;
	output logic [`RegBus] forwardsw_data;
	//output logic forwardsrc1;
	//output logic forwardsrc2;


	output logic stall_pc; //load depedency
	output logic stall_if_id;//load depedency

	logic [5:0] opcode;
	logic [7:0] sub_opcode_8;

	always_comb begin
		
		opcode = id_inst[30:25];
		sub_opcode_8 = id_inst[7:0];

	end
	
	always_comb begin

		if(opcode==6'b011100 && sub_opcode_8==`LW)begin
			stall_pc = 1'b1;
			stall_if_id = 1'b1;
		end
		else begin
			stall_pc = 1'b0;
			stall_if_id = 1'b0;
		end
	end	


	always_comb begin
		
		if(id_reg1_read == `ReadEnable)begin
			if(id_reg1_addr == exe_write_addr && exe_reg_write == `WriteEnable)begin
				if(exe_movsrc == `MvRegSrc)
					forward1_data = exe_mov_data;
				else
					forward1_data = exe_alu_data;
			end
			else if(id_reg1_addr == mem_write_addr && mem_reg_write == `WriteEnable) 
				if(mem_DM_read==`ReadEnable) 
					forward1_data = mem_data;
				else if(mem_movsrc == `MvRegSrc)
					forward1_data = mem_mov_data; 
				else
					forward1_data = mem_alu_data;
			//else if(id_reg1_addr == wb_write_addr && wb_reg_write == `WriteEnable) 
				//forward1_data = wb_data;
			else
				forward1_data = id_reg1_o;
		end
		else
			forward1_data = id_reg1_o;
	end

	always_comb begin
		
		if(id_reg2_read==`ReadEnable)begin
			if(id_reg2_addr == exe_write_addr && exe_reg_write == `WriteEnable)begin
				if(exe_movsrc == `MvRegSrc)
					forward2_data = exe_mov_data;
				else
					forward2_data = exe_alu_data;
			end
			else if(id_reg2_addr == mem_write_addr && mem_reg_write == `WriteEnable)
				if(mem_DM_read==`ReadEnable) 
					forward2_data = mem_data;
				else if(mem_movsrc == `MvRegSrc)
					forward2_data = mem_mov_data;
				else
					forward2_data = mem_alu_data;
			//else if(id_reg2_addr == wb_write_addr && wb_reg_write == `WriteEnable) 
				//forward2_data = wb_data;
			else
				forward2_data = id_reg2_o;		
		end
		else
			forward2_data = id_reg2_o;	

	end

	always_comb begin
		
		if(id_sw_read == `ReadEnable)begin
			if(id_sw_addr == exe_write_addr && exe_reg_write == `WriteEnable)begin
				if(exe_movsrc == `MvRegSrc)
					forwardsw_data = exe_mov_data;
				else
					forwardsw_data = exe_alu_data;
			end
			else if(id_sw_addr == mem_write_addr && mem_reg_write == `WriteEnable) 
				if(mem_DM_read==`ReadEnable) 
					forwardsw_data = mem_data;
				else if(mem_movsrc == `MvRegSrc)
					forwardsw_data = mem_mov_data;
				else
					forwardsw_data = mem_alu_data;
			//else if(id_sw_addr == wb_write_addr && wb_reg_write == `WriteEnable) 
				//forward1_data = wb_data;
			else
				forwardsw_data = id_sw_o;
		end
		else
			forwardsw_data = id_sw_o;
	end
	

endmodule
