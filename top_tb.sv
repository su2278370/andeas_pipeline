`timescale 1ns/10ps

`include "CPU.sv"
`include "IM.sv"
`include "DM.sv"
`define PERIOD 10
`define prog0

module top_tb;

  logic clk;
  logic rst;

  logic [`RegBus] IM_out;
  logic [`RegBus] DM_out;

  logic	mem_DM_read; //DM_read
  logic	mem_DM_write; //DM_write
  logic [`DmAddr] mem_alu_result; //DM_addr
  logic	[`RegBus] mem_sw_o; //DM_in
	
  logic	[`ImAddr] pc_output; //IM_addr 
  
  integer i;
  
  CPU cpu(.clk(clk),
	  .rst(rst),
	  .mem_DM_read(mem_DM_read), 
          .mem_DM_write(mem_DM_write), 
	  .mem_alu_result(mem_alu_result), 
          .mem_sw_o(mem_sw_o), 
          .DM_out(DM_out),
          .pc_output(pc_output), 
          .IM_out(IM_out));

  IM inst_memory(.clk(clk), 
	   	 .rst(rst),
          	 .IM_read(1'b1), 
          	 .IM_addr(pc_output), 
          	 .IM_out(IM_out));

  DM data_memory(.clk(clk), 
		 .rst(rst),
		 .DM_read(mem_DM_read), 
		 .DM_write(mem_DM_write), 
		 .DM_addr(mem_alu_result), 
		 .DM_in(mem_sw_o), 
		 .DM_out(DM_out));

  
  //clock gen.
  always #(`PERIOD/2) clk=~clk;
  
  
  initial begin
  clk=0;
  rst=1'b1;
  #(`PERIOD*2) rst=1'b0;

  `ifdef prog0
  		  //verification default program
  			$readmemb("mins.prog",inst_memory.mem_data);
  `elsif prog1
  		  //verification program 1
  			$readmemb("mins.prog.p1",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p1",data_memory.mem_data);
  `elsif prog2
  		  //verification program 2
  			$readmemb("mins.prog.p2",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p2",data_memory.mem_data);
  `elsif prog3
  		  //verification program 3
  			$readmemb("mins.prog.p3",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p3",data_memory.mem_data);
  `elsif prog4
  		  //verification program 4
  			$readmemb("mins.prog.p4",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p4",data_memory.mem_data);
  `elsif prog5
  		  //verification program 5
  			$readmemb("mins.prog.p5",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p5",data_memory.mem_data);
  `elsif prog6
  		  //verification program 6
  			$readmemb("mins.prog.p6",inst_memory.mem_data);
  			//$readmemb("mdm.prog.p6",data_memory.mem_data);
  `endif
      #1000
      #10
      $display( "done" );
      for( i=0;i<31;i=i+1 ) $display( "IM[%h]=%h",i,inst_memory.mem_data[i] ); 
      for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,cpu.regfile1.rw_reg[i] ); 
      for( i=0;i<40;i=i+1 ) $display( "DM[%d]=%d",i,data_memory.mem_data[i] );
      $display( "DM[%d]=%d",32767,data_memory.mem_data[32767] );      
      $display( "DM[%d]=%d",32766,data_memory.mem_data[32766] );
      $finish;
  end

  initial begin
	  $dumpfile("top.fsdb");
	  $dumpvars(0, top_tb);
	  //$fsdbDumpfile("top.fsdb");
	  //$fsdbDumpvars(0, top_tb);
	  #10000000 $finish;
  end
endmodule
