`timescale 1ns/10ps
`include "port_define.sv"

module Comparator(
					Tag1, 
					Tag2,
					Match);

	input [`TAG] Tag1;
	input [`TAG] Tag2;

	output logic Match;

	logic Match;

	always_comb begin

		if(Tag1 == Tag2)
			Match = 1'b1;
		else
			Match = 1'b0;

	end 

endmodule