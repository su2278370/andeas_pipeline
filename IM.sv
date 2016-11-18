`timescale 1ns/10ps

module IM(clk, rst,
          IM_read, IM_write, IM_enable,
          IM_in, IM_addr, IM_out,
          IM_ready, IM_resp, IM_finish);

  parameter data_size = 32;
  parameter mem_size = 1024;
  parameter addr_size = 10;
  parameter OKAY=2'b00, ERROR=2'b01, RETRY=2'b10, SPLIT=2'b11;
  
  input logic clk, rst, IM_read, IM_write, IM_enable;
  input logic [data_size-1:0]IM_in;
  input logic [addr_size-1:0]IM_addr;
  
  output logic IM_ready;
  output logic [1:0]IM_resp;
  output logic IM_finish;
  output logic [data_size-1:0]IM_out;
  
  logic [data_size-1:0]mem_data[mem_size-1:0];
  
  integer i;
  
  always_ff@(posedge clk, posedge rst)begin
    if(rst)begin
      for(i=0;i<mem_size;i=i+1)begin
        
        mem_data[i] <=0;
      end
      IM_out <=0;
      IM_ready <=1'b1;
      IM_resp <=OKAY;
      IM_finish <=1'b0;
    end
    else if(IM_enable)begin
      if(IM_read)begin
        IM_out <=mem_data[IM_addr];
        IM_ready <=0;
        IM_resp  <=OKAY;
        IM_finish <=1'b1;
      end
      else if(IM_write)begin
        //IM_out <=0;
        IM_ready <=0;
        IM_resp  <=ERROR;
        IM_finish <=1'b1;
      end
    end
    else begin
      //IM_out <=0;
      IM_ready <=1;
      IM_resp  <=OKAY;
      IM_finish <=1'b0;
    end  
 
  end
  
endmodule
          
