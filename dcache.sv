`timescale 1ns/10ps
`include "port_define.sv"

module dcache(clk, 
	  		  rst,
          	  cpu_read_i, 
	          cpu_write_i, 
			  cpu_address_i, 
          	  cpu_data_i, 
          	  dcache_data_o,
          	  dm_write_o,
          	  dm_read_o,
          	  dm_address_o, 
          	  dm_data_i, 
          	  dm_data_o,
);

	input clk;
	input rst;

	input cpu_read_i;
	input cpu_write_i;
	
	input  [`DmAddr] cpu_address_i;
	input  [`RegBus] cpu_data_i;
	input  [`LineWidth] dm_data_i; //16 words

	output logic [`RegBus] dcache_data_o;

	output logic dm_write_o;
	output logic dm_read_o;
	output logic [`DmAddr]dm_address_o;
	output logic [`Regbus]dm_data_o;


	logic tag = dcache_address[`DTag];
	logic index = dcache_address[`DIndex];
	logic offset = dcache_address[`DOffset];

	logic [`LineWidth]mem_data[`DCacheSize-1:0];

	
	

endmodule