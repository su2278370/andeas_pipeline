`timescale 1ns/10ps
`include "port_define.sv"

module performance(rst, 
          clk, 
      stall,
          flush,
      if_inst,
      cycle_count,
      inst_count
);
  
  input  clk;
  input  rst;
  input  stall; 
  input  flush;
  input  [`RegBus] if_inst;
  
  output logic [`CycleCountBus] cycle_count;
  output logic [`InstCountBus]  inst_count;


  always_ff@(posedge clk)begin
    if(rst==`RstEnable)begin
        cycle_count <= `ZeroWord;
        end
    else begin
        cycle_count <= cycle_count + 1'b1;
    end
  end
  
  always_ff@(posedge clk)begin
    if(rst==`RstEnable)begin
        inst_count <= `ZeroWord;
        end
    else if(stall==`StallEnable) begin
        inst_count <= inst_count;
    end 
    else if(flush==`FlushEnable) begin  
        inst_count <= inst_count - 1'b1;
    end
    else begin
        if(if_inst==`ZeroWord)
            inst_count <= inst_count;
        else
            inst_count <= inst_count + 1'b1;
    end
  end
  
  
endmodule



