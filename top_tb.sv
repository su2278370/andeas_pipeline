`timescale 1ns/10ps
`include "IM.sv"
`include "DM.sv"

//`define syn
//`define FSDB
`define prog1

`ifdef syn
  `include "tsmc13_neg.v"
  `include "top_syn.v"
`else
  `include "top.sv"
`endif

`define PERIOD 20 // modify by yourself, maximum 20 ns
`define End_CYCLE 100000

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
  
  //Performance Counter
  logic [127:0] cycle_cnt;
  logic [63:0] ins_cnt;
  
  //Check
  logic fin;
    
  top TOP1(.clk(clk),
	  .rst(rst),
	  .mem_DM_read(mem_DM_read), 
          .mem_DM_write(mem_DM_write), 
	  .mem_alu_result(mem_alu_result), 
          .mem_sw_o(mem_sw_o), 
          .DM_out(DM_out),
          .pc_output(pc_output), 
          .IM_out(IM_out),
	  .cycle_count(cycle_cnt),
	  .inst_count(ins_cnt));

  IM IM1(.clk(clk), 
	   	 .rst(rst),
          	 .IM_read(1'b1), 
          	 .IM_addr(pc_output), 
          	 .IM_out(IM_out));

  DM DM1(.clk(clk), 
		 .rst(rst),
		 .DM_read(mem_DM_read), 
		 .DM_write(mem_DM_write), 
		 .DM_addr(mem_alu_result), 
		 .DM_in(mem_sw_o), 
		 .DM_out(DM_out));

  
  
always #(`PERIOD/2) clk = ~clk;
  
  integer i;
   ///////////Default instruction verification//////////
  `ifdef prog0
  initial begin
          clk = 0;
          rst = 0;
   	  fin = 0;
          #1 rst = 1;
          #(`PERIOD) rst = 0;
          $readmemb("./prog0/IM_data.dat",IM1.mem_data);
          $readmemh("./prog0/DM_data.dat",DM1.mem_data);
    
  end
  
  ///////////Individual instruction verification//////////
  `elsif prog1
  initial begin
          clk = 0;
          rst = 0;
    	  fin = 0;
          #1 rst = 1;
          #(`PERIOD) rst = 0;
          $readmemb("./prog1/IM_data.dat",IM1.mem_data);
          $readmemh("./prog1/DM_data.dat",DM1.mem_data);
    
  end
  
  /////////// 64bit add/sub ///////////
  `elsif prog2
  initial begin
          clk = 0;
          rst = 0;
    	  fin = 0;
          #1 rst = 1;
          #(`PERIOD) rst = 0;
          $readmemb("./prog2/IM_data.dat",IM1.mem_data);
          $readmemh("./prog2/DM_data.dat",DM1.mem_data);

  end

  /////////// SAD ///////////
  `elsif prog3
  initial begin
    clk = 0;
    rst = 0;
    fin = 0;
    #1 rst = 1;
    #(`PERIOD) rst = 0;
    $readmemb("./prog3/IM_data.dat",IM1.mem_data);
    $readmemh("./prog3/image1.dat",DM1.mem_data,2); // do not modify address here, modify file name only
    $readmemh("./prog3/image2.dat",DM1.mem_data,800); // do not modify address here, modify file name only
    
  end
  `endif
  
  always@(posedge clk)begin
    if(DM1.mem_data[32767]==32'h0000FFFF) fin = 1'b1;
  end
    
  initial begin
      @(posedge fin)      
      if(fin)begin
        $display("-----------------------------------------------------\n");
        $display("----------------Print DM[0] ~ DM[31]-----------------\n");
        for(i=0;i<32;i=i+1)begin
        $display("DM_MEM[%d] = %d ",i,DM1.mem_data[i]);
        end
        $display("---------------------Performance----------------------\n");
        $display("Cycle Count = %d", cycle_cnt);
        $display("Instruction Count = %d", ins_cnt);
        $display("-----------------------FINISH------------------------\n");
        $display("-----------------------------------------------------\n");
	`ifdef syn
    	//for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP1.regfile1.(\rw_reg_reg[i]));
    	`else
    	for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP1.regfile1.rw_reg[i]);
    	`endif
      end
      #(`PERIOD/2); $finish;
  end
  
  `ifdef syn
  //post_syn simulation
    initial $sdf_annotate("top_syn.sdf", TOP1); // add your sdf file here
  `endif
  
  initial begin
  `ifdef FSDB
    $dumpfile("top.fsdb");
    $dumpvars;
  `elsif VCD
    $dumpfile("top.vcd");
    $dumpvars;
  `endif
  end
  
  initial begin



    #(`PERIOD * `End_CYCLE);
    $display("-----------------------------------------------------\n");
    $display("Error!!! Somethings' wrong with your code ...!\n");
    $display("Perhaps you can adjust the bigger value of End_CYCLE and then run the simulation again!");
    $display("-------------------------FAIL------------------------\n");
    $display("-----------------------------------------------------\n");
    `ifdef syn
    //for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP1.regfile1.(\rw_reg_reg[i]));
    `else
    for( i=0;i<32;i=i+1 ) $display( "register[%d]=%d",i,TOP1.regfile1.rw_reg[i]);
    `endif
    $finish;
  
  end
  
endmodule
