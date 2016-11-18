`timescale 1ns/10ps
`include "port_define.sv"

module decoder(clk,
               rst,
               pc_i,
               inst_i,
               reg1_data_i,
               reg2_data_i,
               reg3_data_i, //write
               reg1_addr_o,
               reg2_addr_o,
               reg3_addr_o, //write
               reg1_o,
               reg2_o,
               reg3_o, //write
               alu_control,
               mem_or_reg,
               imm_reg_select,
               mux2to1_select, 
               mux4to1_select
               
);
