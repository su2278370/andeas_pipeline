`timescale 1ns/10ps
`include "port_define.sv"

module regfile(clk,
               rst,
               dout1, dout2, 
               swdout,
               write, 
               read1, read2,
               swread, 
               waddr1,
               raddr1,
               raddr2, 
               swaddr,
               din
);
  
  input clk;
  input rst; 
  input write; 
  input read1, read2; 
  input swread;
  input [`RegAddrBus] waddr1;
  input [`RegAddrBus] raddr1, raddr2;
  input [`RegAddrBus] swaddr;
  input [`RegBus] din;
  
  output logic [`RegBus] dout1, dout2, swdout;
  
  logic [`RegBus] rw_reg [`RegAddrBus];
  
  integer i;
  
  always_ff@(posedge clk, posedge rst)begin
    
    if(rst==`RstEnable)begin
        for(i=0;i<`RegNum;i=i+1)begin
          rw_reg[i] <= `ZeroWord;
        end
    end else begin
        
        if(write==`RegWrite)begin
            
            rw_reg[waddr1] <= din;
            
        end else if(read1==`RegRead && read2=`RegRead)begin
            
            dout1 <= rw_reg[raddr1];
            dout2 <= rw_reg[raddr2];
            
        end
    end
    
  end
  
  always_comb begin
    
    if(rst==`RstEnable)begin
        swdout = `ZeroWord;
    end else if(swread==`RegRead) begin
        swdout = rw_reg[swaddr];
    end else
		    swdout = `ZeroWord
		  
	end
  
  always_comb begin
    
    if(rst==`RstEnable)begin
        dout1 = `ZeroWord;
    end else if(read1==`RegRead) begin
        dout1 = rw_reg[raddr1];
    end else
		dout1 = `ZeroWord
	
	end
    
  end
  
  always_comb begin
    
    if(rst==`RstEnable)begin
        dout2 = `ZeroWord;
    end else if(read2==`RegRead) begin
        dout2 = rw_reg[raddr2];
    end else
		dout2 = `ZeroWord;
	  
    
  end
  
endmodule
            
  
  
