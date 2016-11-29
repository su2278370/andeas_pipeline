`timescale 1ns/10ps
`include "port_define.sv"

module DM(clk, 
	         rst,
          DM_read, 
          DM_write, 
	        DM_addr, 
          DM_in, 
          DM_out
);
  
  input clk;
  input rst; 

  //From interface
  input DM_read; 
  input DM_write;
  input [`RegBus]DM_in;
  input [`DmAddr]DM_addr;
  
  output logic [`RegBus]DM_out;
  
  logic [`RegBus]mem_data[`DmSize-1:0];
  
  integer i;
  
  always_ff@(posedge clk, posedge)begin
    if(rst==`RstEnable)begin
      for(i=0;i<`DmSize;i=i+1)begin
        
        mem_data[i] <= `ZeroWord;
      end
            
    end
    else begin
      //if(DM_read==`ReadEnable)
        //DM_out <= mem_data[DM_addr];

      if(DM_write==`WriteEnable)
        mem_data[DM_addr] <= DM_in;
     
      

    end
      
  end

  always_comb begin

    if(rst==`RstEnable)begin
      
      DM_out = `ZeroWord;
      
    end
    /*if(rst==`RstEnable)begin
      for(i=0;i<`DmSize;i=i+1)begin
        
        mem_data[i] = `ZeroWord;
      end
      DM_out = `ZeroWord;
      
    end
    else begin*/
      if(DM_read==`ReadEnable)
        DM_out = mem_data[DM_addr];

      //else if(DM_write==`WriteEnable)
        //mem_data[DM_addr] = DM_in;  

    //end
  end
  
endmodule
