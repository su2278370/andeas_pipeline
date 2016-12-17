`timescale 1ns/10ps
`include "port_define.sv"

module Control(
				PStrobe, 
				PRW, 	
				Ready,
				Match, 
				Valid, 
				Write,
				CacheDataSelect,
				PDataSelect,
				SysDataOE, 		
				PDataOE,
				SysStrobe, 	
				SysRW, 
				Reset,
				Clk,
);

	input PStrobe;
	input PRW;
	input Match;
	input Valid;
	input Reset;
	input Clk;

	output logic PReady;
	output logic Write;
	output logic CacheDataSelect;
	output logic PDataSelect;
	output logic SysDataOE;
	output logic PDataOE;
	output logic SysStrobe; 
	output logic SysRW;

	
	logic [1:0] WaitStateCtrInput = `WAITSTATES - 2'd1;
	logic WaitStateCtrCarry;
	logic LoadWaitStateCtr;


	WaitStateCtr WaitStateCtr(
		.Load (LoadWaitStateCtr),
		.LoadValue (WaitStateCtrInput), //WaitStateCtrCarry
		.Carry (WaitStateCtrCarry),
		.Clk (Clk)
	);

	logic PReadyEnable;
	logic [3:0] State;
	logic [3:0] NextState;
	

	always_ff @(posedge Clk)
		State <= Reset ?`STATE_IDLE : NextState;
	
	always_comb begin

		Case (State)

		`STATE_IDLE: begin
			if (PStrobe && PRW == `READ)
				NextState = `STATE_READ;
			else if (PStrobe && PRW ==` WRITE)
				NextState = `STATE_WRITE;
			else 
				NextState = `STATE_IDLE;
		end

		//Read sate
		`STATE_READ : begin
			if (Match && Valid)
				NextState = `STATE_IDLE;
			else 
				NextState = `STATE_READMISS;
		end
		`STATE_READMISS : begin
			NextState = `STATE_READSYS; //no read through
		end
		`STATE_READSYS : begin
			if(WaitStateCtrCarry) // Wait for main memory sending data from cache
				NextState = `STATE_READDATA;
			else 
				NextState = `STATE_READSYS;
		end
		`STATE_READDATA : begin
			NextState = `STATE_IDEL;
		end

		//Write state
		`STATE_WRITE : begin
			if (Match && Valid)
				NextState = `STATE_WRITEHIT;
			else
				NextState = `STATE_READMISS; //write allocate
		end
		`STATE_WRITEHIT : begin
			NextState = `STATE_WRITESYS; //write through
		end
		`STATE_WRITEMISS : begin
			NextState = `STATE_WRITESYS; //?????
		end
		`STATE_WRITESYS : begin
			if (WaitStateCtrCarry) // Wait for cache sending data to memory
				NextState = `STATE_WRITEDATA;
			else 
				NextState = `STATE_WRITESYS;
		end

		`STATE_WRITEDATA : begin
			NextState = `STATE_IDLE;
		end

		default:
			NextState = `STATE_IDLE;

		endcase

		task OutputVec;
			input [9:0] vector;
			begin
			vector =			
			{	LoadWaitStateCtr, PReadyEnable,
				Ready, Write, SysStrobe, SysRW,
				CacheDataSelect,
				DataSelect, PDataOE, SysDataOE	};
			end
		endtask

endmodule