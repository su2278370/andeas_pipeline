`timescale 1ns/10ps
`include "port_define.sv"

module DataRam(
				Address, 
				DataIn,
				DataOut, 
				Write, 
				Clk);

	input [`INDEX] Address;
	input [`DATA] DataIn;
	input Write;
	input Clk;

	output logic [`DATA] DataOut;

	logic [`DATA] Dataout;
	logic [`DATA] Ram [`CACHESIZE-1:0];


	always_ff @(posedge Clk)begin
		if(Write)
			Ram[Address] <= DataIn; //write
	end


	always_ff @(posedge Clk)
		DataOut <= Ram[Address]; //read


endmodule