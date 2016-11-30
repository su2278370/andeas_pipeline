`timescale 1ns/10ps

//`include "IM.sv"
`include "pc.sv"
`include "IF_ID.sv"
`include "decoder.sv"
`include "regfile.sv"
`include "forwarding.sv"
`include "ID_EXE.sv"
`include "ALU.sv"
`include "EXE_MEM.sv"
//`include "DM.sv"
`include "mux_movsrc.sv"
`include "MEM_WB.sv"
`include "mux_lwsrc.sv"
`include "performance.sv"

module top(	clk, 
       		rst,
		alu_overflow,
       		DM_read, 
      		DM_write, 
       		DM_address, 
       		DM_in, 
       		DM_out,
		IM_read,
	   	IM_write,	
       		IM_address, 
       		instruction,
       		cycle_cnt,
       		ins_cnt
 );
     
   
    input clk;
    input rst;
    input [`RegBus] instruction;
    input [`RegBus] DM_out;

    output  logic DM_read; //DM_read
    output  logic DM_write; //DM_write
    output  logic [`RegBus] DM_address; //DM_addr
    output  logic [`RegBus] DM_in; //DM_in
    
    output  logic IM_read;
    output  logic IM_write;
    output  logic [`InstAddrBus] IM_address; //IM_addr

    output  logic alu_overflow;

    //-----------Performance Counter-----// 
    output  logic [`CycleCountBus]  cycle_cnt;
    output  logic [`InstCountBus]   ins_cnt;
   
    
    //-------Instruction memory----------//
    //logic [`RegBus] IM_out;
    
    //--------program counter------------//
    //logic [`InstAddrBus] pc_output;
    
    //--------Fetch to Decoder----------//
    logic [`RegBus] id_pc;          
    logic [`RegBus] id_inst;
    
    //--------Decoder-------------------//
    
    logic [`InstAddrBus] branch_addr;

    logic reg1_read;
    logic reg2_read;
    logic sw_read;
    logic reg_write;
    logic [`RegAddrBus] reg1_addr_o;
    logic [`RegAddrBus] reg2_addr_o;
    logic [`RegAddrBus] write_addr_o;
    logic [`RegAddrBus] sw_addr_o;     
       
    logic [`RegBus]     reg1_o;
    logic [`RegBus]     reg2_o;
    logic [`RegBus]     sw_o;
    logic [`RegBus]     write_o;
       
       
    logic [`AluCtrl]    alu_ctrl;
    logic         lwsrc;
    logic        movsrc; 
    logic id_DM_read; 
    logic id_DM_write; 

    //--------Regfile-------------------//
    logic [`RegBus] dout1;
    logic [`RegBus] dout2;
    logic [`RegBus] swdout;

    //-----------Forwarding--------------//
    logic [`RegBus] forward1_data;
    logic [`RegBus] forward2_data;
    logic [`RegBus] forwardsw_data;
    logic stall_pc;
    logic stall_if_id;

    //------------Decoder to Execution---//
    
    logic [`InstAddrBus] exe_pc_o;
    logic [`RegAddrBus] exe_write_addr_o;
    logic [`InstAddrBus] exe_branch_addr;
    logic [`RegBus] exe_reg1_o;
    logic [`RegBus] exe_reg2_o;
    logic [`AluCtrl]    exe_aluctrl;
    
    logic [`RegBus] exe_sw_o;
    logic [`RegBus] exe_write_o;
    logic        exe_lwsrc;
 
    logic        exe_movsrc;
    logic exe_reg_write;
    logic exe_DM_read; 
    logic exe_DM_write;

    //--------------ALU-------------------//
    logic [`RegBus] alu_result;
    logic branch_true;
    logic [`InstAddrBus] new_addr;
    
    //----------Execution to Memory-------//
    logic        mem_lwsrc;
 
    logic [`RegAddrBus] mem_write_addr_o;
    logic           mem_movsrc;
    logic [`RegBus] mem_write_o;

  
  
     //logic [`RegBus] mem_sw_o;
     logic          mem_reg_write;
     //logic           mem_DM_read; 
     //logic           mem_DM_write;
     //logic [`RegBus] mem_alu_result; 
   
     //------------Data memory------------//
     //logic [`RegBus]DM_out;    
    
     //------------Mux Move Source--------//
     logic [`RegBus] movsrc_result;

     //-----------Memory to Writeback-----//
     logic wb_lwsrc;
     logic wb_reg_write;
     logic [`RegAddrBus] wb_write_addr_o;
     logic [`RegBus] wb_movsrc_result;
     logic [`RegBus] wb_DM_out;

     //-----------Mux Load Source---------//
     logic [`RegBus] lwsrc_result;

 
      
   
     pc program_counter(.clk(clk), 
			.rst(rst), 
	                .stall(stall_pc),
        	        .branch_true(branch_true),
                	.new_addr(new_addr), 
                        .pc_output(IM_address));

     if_id fetch_to_decoder(.clk(clk),
      	                    .rst(rst),
         		    .flush(branch_true),
		            .stall(stall_if_id),
             		    .if_pc(IM_address),
		            .if_inst(instruction),
             		    .id_pc(id_pc),
		            .id_inst(id_inst));
                
     decoder decoder1(	.clk(clk),
     		      	.rst(rst),
               		.inst_i(id_inst),
               		.reg1_data_i(dout1),
               		.reg2_data_i(dout2),
               		.sw_data_i(swdout),
		        .branch_addr(branch_addr),
               		.reg1_addr_o(reg1_addr_o),
	                .reg2_addr_o(reg2_addr_o),
         	        .sw_addr_o(sw_addr_o),
               		.write_addr_o(write_addr_o),
               		.reg1_read(reg1_read),
               		.reg2_read(reg2_read),
               		.sw_read(sw_read),
               		.reg_write(reg_write), 
               		.reg1_o(reg1_o),
               		.reg2_o(reg2_o),
               		.sw_o(sw_o),
               		.write_o(write_o), 
               		.alu_ctrl(alu_ctrl),
               		.lwsrc(lwsrc),
               		.movsrc(movsrc),
               		.DM_read(id_DM_read),
               		.DM_write(id_DM_write));

     regfile regfile1(	.clk(clk),
               		.rst(rst),
               		.dout1(dout1), 
		        .dout2(dout2), 
		        .swdout(swdout),
		        .write(wb_reg_write), 
		        .read1(reg1_read), 
		        .read2(reg2_read),
		        .swread(sw_read), 
		        .waddr1(wb_write_addr_o),
		        .raddr1(reg1_addr_o),
		        .raddr2(reg2_addr_o), 
		        .swaddr(sw_addr_o),
		        .din(lwsrc_result));

     forwarding forward_unit( 
	 			.id_inst(id_inst),
			        .id_reg1_addr(reg1_addr_o),
				.id_reg1_read(reg1_read),
				.id_reg1_o(reg1_o),
				.id_reg2_addr(reg2_addr_o),
				.id_reg2_read(reg2_read),
				.id_reg2_o(reg2_o),
				.id_sw_addr(sw_addr_o),
				.id_sw_read(sw_read),
				.id_sw_o(sw_o),     
				.exe_write_addr(exe_write_addr_o),
				.exe_reg_write(exe_reg_write),
				.exe_movsrc(exe_movsrc),
				.exe_alu_data(alu_result),
				.exe_mov_data(exe_write_o),
				.mem_write_addr(mem_write_addr_o),
				.mem_movsrc(mem_movsrc),
				.mem_reg_write(mem_reg_write),
				.mem_DM_read(DM_read),
				.mem_mov_data(mem_write_o),
				.mem_alu_data(DM_address),
				.mem_data(DM_out),
				.wb_write_addr(wb_write_addr_o),   
				.wb_reg_write(wb_reg_write),
				.wb_data(lwsrc_result),
				.forward1_data(forward1_data),
				.forward2_data(forward2_data),
				.forwardsw_data(forwardsw_data),
				.stall_pc(stall_pc),
				.stall_if_id(stall_if_id));
			       
     id_exe decoder_to_execution(     .clk(clk),
				      .rst(rst),
				      .flush(branch_true),
				      .id_pc_o(id_pc),
				      .id_branch_addr(branch_addr),
				      .id_write_addr_o(write_addr_o),
				      .id_reg1_o(forward1_data),
				      .id_reg2_o(forward2_data),
				      .id_sw_o(forwardsw_data),
				      .id_write_o(write_o),
				      .id_aluctrl(alu_ctrl),
				      .id_lwsrc(lwsrc),
				      .id_movsrc(movsrc),
				      .id_reg_write(reg_write),
				      .id_DM_read(id_DM_read),
				      .id_DM_write(id_DM_write),
				      .exe_pc_o(exe_pc_o),
				      .exe_branch_addr(exe_branch_addr),
				      .exe_write_addr_o(exe_write_addr_o),
				      .exe_reg1_o(exe_reg1_o),
				      .exe_reg2_o(exe_reg2_o),
				      .exe_sw_o(exe_sw_o),
				      .exe_write_o(exe_write_o),
				      .exe_aluctrl(exe_aluctrl),
				      .exe_lwsrc(exe_lwsrc),
				      .exe_movsrc(exe_movsrc),
				      .exe_reg_write(exe_reg_write),
				      .exe_DM_read(exe_DM_read),
				      .exe_DM_write(exe_DM_write));

       alu  execution(	.overflow(alu_overflow), 
        		.alu_result(alu_result), 
        		.src1(exe_reg1_o), 
        		.src2(exe_reg2_o), 
        		.aluctrl(exe_aluctrl),
        		.alu_pc_o(exe_pc_o),
      			.alu_branch_addr(exe_branch_addr), 
      			.branch_true(branch_true),
      			.new_addr(new_addr));

       exe_mem execution_to_memory( 	.clk(clk),
               				.rst(rst),
               				.exe_sw_o(exe_sw_o),
           				.exe_write_o(exe_write_o),
				  	.exe_lwsrc(exe_lwsrc),
				  	.exe_movsrc(exe_movsrc),
				  	.exe_write_addr_o(exe_write_addr_o),
				  	.exe_reg_write(exe_reg_write),
				  	.exe_DM_read(exe_DM_read), 
				  	.exe_DM_write(exe_DM_write),
				  	.exe_alu_result(alu_result),

          				.mem_lwsrc(mem_lwsrc),
          				.mem_movsrc(mem_movsrc),
          				.mem_write_o(mem_write_o),
          
          
          				.mem_sw_o(DM_in),
          				.mem_write_addr_o(mem_write_addr_o),
          				.mem_reg_write(mem_reg_write),
          				.mem_DM_read(DM_read), 
          				.mem_DM_write(DM_write),
          				.mem_alu_result(DM_address));



       mux_movsrc mux_movsrc1(	.Y(movsrc_result),
            			.S(mem_movsrc),
			    	.I0(DM_address),
			    	.I1(mem_write_o));

       mem_wb memory_to_write(	.clk(clk),
              			.rst(rst),
          			.mem_lwsrc(mem_lwsrc),
          			.mem_write_addr_o(mem_write_addr_o),
          			.mem_reg_write(mem_reg_write),
          			.mem_movsrc_result(movsrc_result),
          			.mem_DM_out(DM_out),
          			.wb_lwsrc(wb_lwsrc),
          			.wb_write_addr_o(wb_write_addr_o),
          			.wb_reg_write(wb_reg_write),
          			.wb_movsrc_result(wb_movsrc_result),
          			.wb_DM_out(wb_DM_out));
    
       mux_lwsrc mux_lwsrc1(	.Y(lwsrc_result),
            			.S(wb_lwsrc),
            			.I0(wb_movsrc_result),
            			.I1(wb_DM_out));
     
       performance pmu(	.clk(clk),
             		.rst(rst),
             		.stall(stall_pc),
             		.flush(branch_true),
             		.if_inst(instruction),
             		.cycle_count(cycle_cnt),
             		.inst_count(ins_cnt));                     
    
endmodule

