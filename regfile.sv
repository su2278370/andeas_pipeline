`timescale 1ns/10ps
`include "port_define.sv"

module regfile(clk,
               rst,
               dout1, dout2, dout3,
               write, 
               read, 
               enable,
               raddr1,
               raddr2, 
               waddr1,
               din
);
  
  input clk;
  input rst; 
  input write; 
  input read1, read2;
  input [`RegAddrBus] waddr1;
  input [`RegAddrBus] raddr1, raddr2;
  input [`RegBus] din;
  
  output logic [`RegBus] dout1, dout2, dout3;
  
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
            
        end else if(read==`RegRead)begin
            
            dout1 <= rw_reg[raddr1];
            dout2 <= rw_reg[raddr2];
            dout3 <= rw_reg[waddr1];
            
        end
    end
    
  end
  
endmodule
            
  
  
