`timescale 1ns/10ps
`include "port_define.sv"

module WaitStateCtr(
			Load,
			LoadValue, 
			Carry, 
			Clk);

	input Load;
	input [1:0] LoadValue;
	input Clk;

	output logic Carry;
	logic [1:0] Count;


	always_ff @(posedge Clk)begin
		if (Load)
			Count <= LoadValue;
		else
			Count <= Count - 2'b1;
	end
	
	always_comb begin
		if(Count == 2'b0)
			Carry = 1'b1;
		else
			Carry = 1'b0;
	end


endmodule