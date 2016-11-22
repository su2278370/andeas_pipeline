`timescale 1ns/10ps

`include "CPU.sv"
`define PERIOD 10
`define prog0

module top_tb;

  logic clk;
  logic rst;
  
  integer i;
  
  CPU cpu(.clk(clk),
	  .rst(rst));
  
  //clock gen.
  always #(`PERIOD/2) clk=~clk;
  
  
  initial begin
  clk=0;
  rst=1'b1;
  #(`PERIOD*2) rst=1'b0;

  `ifdef prog0
  		  //verification default program
  			$readmemb("mins.prog",cpu.inst_memory.mem_data);
  `elsif progA
  		  //verification hidden program 
  			$readmemb("mins.prog.A",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.A",cpu.data_memory.mem_data);
  `elsif prog1
  		  //verification program 1
  			$readmemb("mins.prog.p1",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p1",cpu.data_memory.mem_data);
  `elsif prog2
  		  //verification program 2
  			$readmemb("mins.prog.p2",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p2",cpu.data_memory.mem_data);
  `elsif prog3
  		  //verification program 3
  			$readmemb("mins.prog.p3",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p3",cpu.data_memory.mem_data);
  `elsif prog4
  		  //verification program 4
  			$readmemb("mins.prog.p4",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p4",cpu.data_memory.mem_data);
  `elsif prog5
  		  //verification program 5
  			$readmemb("mins.prog.p5",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p5",cpu.data_memory.mem_data);
  `elsif prog6
  		  //verification program 6
  			$readmemb("mins.prog.p6",cpu.inst_memory.mem_data);
  			$readmemb("mdm.prog.p6",cpu.data_memory.mem_data);
  `endif
      #30000
      #10
      $display( "done" );
      for( i=0;i<31;i=i+1 ) $display( "IM[%h]=%h",i,cpu.inst_memory.mem_data[i] ); 
      for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,cpu.regfile1.rw_reg[i] ); 
      for( i=0;i<40;i=i+1 ) $display( "DM[%d]=%d",i,cpu.data_memory.mem_data[i] );      

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
