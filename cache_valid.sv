`timescale 1ns/10ps
`include "port_define.sv"

module ValidRam(
					Address,
					ValidIn,
					ValidOut,
					Write,
					Reset,
					Clk
);

	input [`INDEX] Address;
	input ValidIn;
	input Write;
	input Reset;
	input Clk;

	output logic ValidOut;
	
	logic [`CACHESIZE-1:0] ValidBits;
	integer i;

	always_ff @(posedge Clk)begin

		if (Write && !Reset)
			ValidBits[Address] <= ValidIn; // write

		else if (Reset)begin
			for (i=0; i<`CACHESIZE;i=i+1)
				ValidBits[i] <=`ABSENT; //reset
		end
	end

	always_ff @(posedge Clk)
		ValidOut <= ValidBits[Address]; //read

endmodule