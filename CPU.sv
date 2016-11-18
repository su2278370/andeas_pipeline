`timescale 1ns/10ps

`include "ALU.sv"
`include "mux2to1.sv"
`include "controller.sv"
`include "pc.sv"
`include "extension.sv"
`include "regfile.sv"
`include "branch_target.sv"

module CPU(clk, rst,  
           CPU_STALL,
           IM_read, IM_enable, 
           IM_out, IM_addr,
           DM_read, DM_write, DM_enable, 
           DM_out, DM_in, DM_addr);
  
   parameter DSize = 32;
   parameter IMSize = 10;
   parameter DMSize = 12;
   
   input clk;
   input rst;
   input CPU_STALL;
   
   //-------Instruction memory----------//
   output logic [DSize-1:0] IM_addr;
   output logic IM_read; 
   output logic IM_enable;
   input  [DSize-1:0] IM_out;
   
   //-----------------------------------//
   
   //------------Data memory------------//
   output logic [DSize-1:0] DM_addr;
   output logic DM_read; 
   output logic DM_write;
   output logic DM_enable;
   output logic [DSize-1:0] DM_in;
   input  [DSize-1:0] DM_out;
  
   //------------------------------------//
   
   //--------------ALU-------------------//
   logic [DSize-1:0] src1_data; 
   logic [DSize-1:0] alu_src2_data;
   logic [DSize-1:0] term_data;
   
   //-------------TEMP-------------------//
   logic [DSize-1:0] imm_data;
   logic [DSize-1:0] src2_data;
   logic [DSize-1:0] alu_result;
   logic [DSize-1:0] alu_DM_result;
   logic [DSize-1:0] write_in_data;
   
   //--------------PC---------------------//
   logic [DSize-1:0] pc_output;
   logic [DSize-1:0] branch_addr;
   logic branch_true;
   
   //-------------CONTROL-----------------//
   logic reg_en, reg_write, reg_read;
   logic [3:0]alu_control;
   logic [1:0]mux4to1_select;
   logic alu_enable;
   logic write_in_data_select;
   logic imm_reg_select;
   logic pc_enable;
   logic mem_or_reg;
   
   assign IM_addr = pc_output;
   assign DM_addr = alu_result;
   assign DM_in = term_data;
   
   pc program_counter(.clk(clk), .rst(rst), 
                      .pc_enable(pc_enable),
                      .branch_true(branch_true), 
                      .pc_output(pc_output),
                      .new_addr(branch_addr));
                      
   branch_target branch_tar(.clk(clk), .rst(rst),
                            .alu_control(alu_control),
                            .instruction(IM_out[23:0]),
                            .pc(pc_output),
                            .branch_addr(branch_addr));                   
                            
   controller controll(.clk(clk), .rst(rst), 
                       .CPU_STALL(CPU_STALL),
                       .alu_control(alu_control),
                       .mux4to1_select(mux4to1_select),
                       .mux2to1_select(write_in_data_select),
                       .imm_reg_select(imm_reg_select),
                       .mem_or_reg(mem_or_reg),
                       .reg_en(reg_en), .reg_write(reg_write), .reg_read(reg_read),
                       .alu_en(alu_enable),
                       .ir(IM_out),
                       .pc_enable(pc_enable), 
                       .IM_enable(IM_enable), .IM_read(IM_read), 
                       .DM_enable(DM_enable), .DM_read(DM_read), .DM_write(DM_write));
                       
   mux2to1 mem_or_reg_sle(.Y(alu_DM_result), 
                          .S(mem_or_reg), 
                          .I0(alu_result), .I1(DM_out));
                          
                          
   extension extent(.instruction(IM_out[19:0]),
                    .S0(mux4to1_select[0]), .S1(mux4to1_select[1]), 
                    .Y(imm_data)); 
                         
                         
   mux2to1 imm_reg_sle(.Y(alu_src2_data),
                       .S(imm_reg_select),
                       .I0(src2_data),.I1(imm_data));
   
   mux2to1 write_in_data_sle(.Y(write_in_data),
                             .S(write_in_data_select),
                             .I0(alu_DM_result),.I1(alu_src2_data));
   
   regfile regfile1(.clk(clk), .rst(rst),
                     .OUT_1(src1_data), .OUT_2(src2_data), .OUT_3(term_data),
                     .Write(reg_write), .Read(reg_read),
                     .Read_ADDR_1(IM_out[19:15]), .Read_ADDR_2(IM_out[14:10]),
                     .Write_ADDR(IM_out[24:20]),
                     .DIN(write_in_data),
                     .enable(reg_en));                 
                     
   ALU alu(.overflow(), 
           .alu_result(alu_result), 
           .src1(src1_data), .src2(alu_src2_data), .src3(term_data),
           .op(alu_control), 
           .enable(alu_enable),
           .sv(IM_out[9:8]),
           .branch_true(branch_true));
endmodule

