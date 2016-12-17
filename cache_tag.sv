`timescale 1ns/10ps
`include "port_define.sv"

module TagRam(
				Address, 
				TagIn, 
				TagOut,
				Write, 
				Clk);

	input [`INDEX]Address;
	input [`TAG] TagIn;
	input Write;
	input Clk;

	output logic [`TAG] TagOut;

	logic [`TAG] TagOut;
	logic [`TAG] TagRam [`CACHESIZE-1:0];

	always_ff @(negedge Clk)begin //????
		if (Write) 
			TagRam[Address] <= TagIn; //write
	end

	always_ff @(posedge Clk)
		TagOut <= TagRam[Address]; //read


endmodule