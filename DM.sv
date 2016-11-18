`timescale 1ns/10ps

module DM(clk, rst,
          DM_read, DM_write, DM_enable,
          DM_in, DM_addr, DM_out,
          DM_ready, DM_resp, DM_finish);

  parameter data_size = 32;
  parameter mem_size = 4096;
  parameter addr_size = 12;
  parameter OKAY=2'b00, ERROR=2'b01, RETRY=2'b10, SPLIT=2'b11; //HRESP
  
  input logic clk, rst, DM_read, DM_write, DM_enable;
  input logic [data_size-1:0]DM_in;
  input logic [addr_size-1:0]DM_addr;
  
  output logic DM_ready; 
  output logic [1:0]DM_resp;
  output logic DM_finish;
  output logic [data_size-1:0]DM_out;
  
  logic [data_size-1:0]mem_data[mem_size-1:0];
  
  integer i;
  
  always_ff@(posedge clk, posedge rst)begin
    if(rst)begin
      for(i=0;i<mem_size;i=i+1)begin
        
        mem_data[i] <=0;
      end
      DM_out <=0;
      DM_ready <=1;
      DM_resp <=OKAY;
      DM_finish <=1'b0;
    end
    else if(DM_enable)begin
      if(DM_read)begin
        DM_out <=mem_data[DM_addr];
        DM_ready <=0;
        DM_resp <=OKAY;
        DM_finish <=1'b1;
      end
      else if(DM_write)begin
        mem_data[DM_addr] <= DM_in;
        DM_ready <=0;
        DM_resp <=OKAY;
        DM_finish <=1'b1;
      end
    end
    else begin
      //DM_out <=0;
      DM_ready <=1;
      DM_resp  <=OKAY;
      DM_finish <=1'b0;
    end  
  
  end
  
endmodule