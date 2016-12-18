`timescale 1ns/10ps
`include "port_define.sv"

module Control(
				PStrobe, 
				PRW, 	
				PReady,
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
	output logic CacheDataSelect; //write selection
	output logic PDataSelect; //read selection
	output logic SysDataOE;
	output logic PDataOE;
	output logic SysStrobe; 
	output logic SysRW;

	
	//logic [1:0] WaitStateCtrInput = `WAITSTATES - 2'd1;
	logic WaitStateCtrCarry;
	logic LoadWaitStateCtr;


	WaitStateCtr WaitStateCtr(
		.Load (LoadWaitStateCtr),
		.LoadValue (`WAITSTATE - 2'd1), //WaitStateCtrCarry
		.Carry (WaitStateCtrCarry),
		.Clk (Clk)
	);

	logic PReadyEnable; //????
	logic [3:0] State;
	logic [3:0] NextState;


	/*PReady =;
	Write =;
	CacheDataSelect =;
	PDataSelect =;
	SysDataOE =;
	PDataOE =;
	SysStrobe =; 
	SysRW =;*/
	

	always_ff @(posedge Clk)
		State <= Reset ?`STATE_IDLE : NextState;
	
	always_comb begin

		case (State)

		`STATE_IDLE: begin
			if (PStrobe && PRW == `READ)begin

				PReady = 1'b0; //to cpu rd

				Write  = 1'b0; //cache rw 0->read 1->write
				CacheDataSelect = 1'b0; //cache in 0->sys 1->cpu
				PDataSelect = 1'b0; //cache out 0->sys 1->cache

				SysDataOE = 1'b0; //to sys
				PDataOE = 1'b0; //to cpu

				SysStrobe = 1'b0; //request sys
				SysRW = 1'b0; //request sys rw

				NextState = `STATE_READ;
			end
			else if (PStrobe && PRW ==` WRITE)begin

				PReady = 1'b0;

				Write  = 1'b0;
				CacheDataSelect = 1'b0; 
				PDataSelect = 1'b0; 

				SysDataOE = 1'b0;
				PDataOE = 1'b0;

				SysStrobe = 1'b0; 
				SysRW = 1'b0;

				NextState = `STATE_WRITE;
			end
			else begin

			end
		end

		//Read sate
		`STATE_READ : begin
			if (Match && Valid)begin

				PReady = 1'b1;

				Write  = 1'b0;
				CacheDataSelect = 1'b0; 
				PDataSelect = 1'b1; 

				SysDataOE = 1'b0;  
				PDataOE = 1'b1; 

				SysStrobe = 1'b0; 
				SysRW = 1'b0;

				NextState = `STATE_IDLE;
			end
			else begin 

				PReady = 1'b0;

				Write  = 1'b0;
				CacheDataSelect = 1'b0; 
				PDataSelect = 1'b1; 

				SysDataOE = 1'b0;
				PDataOE = 1'b0;

				SysStrobe = 1'b0; 
				SysRW = 1'b0;

				NextState = `STATE_READMISS;
			end
		end
		`STATE_READMISS : begin 

			PReady = 1'b0;

			Write  = 1'b0;
			CacheDataSelect = 1'b0;
			PDataSelect = 1'b1; 

			SysDataOE = 1'b0;
			PDataOE = 1'b0;

			SysStrobe = 1'b1; 
			SysRW = 1'b0;

			NextState = `STATE_READSYS; 
		end
		`STATE_READSYS : begin
			if(WaitStateCtrCarry)begin 
				//if(?????)begin

					PReady = 1'b0;

					Write  = 1'b1; 
					CacheDataSelect = 1'b0; 
					PDataSelect = 1'b0;

					SysDataOE = 1'b0;
					PDataOE = 1'b0;

					SysStrobe = 1'b1; 
					SysRW = 1'b0;

					NextState = `STATE_READDATA;
				//end
				//else begin


					//NextState = `STATE_WRITEHIT;
				//end
			end
			else begin 

			end
		end
		`STATE_READDATA : begin

			PReady = 1'b1;

			Write  = 1'b0;
			CacheDataSelect = 1'b0;
			PDataSelect = 1'b1; 

			SysDataOE = 1'b0;
			PDataOE = 1'b1;

			SysStrobe = 1'b0; 
			SysRW = 1'b0;

			NextState = `STATE_IDLE;
		end

		//Write state
		`STATE_WRITE : begin
			if (Match && Valid)begin

				PReady = 1'b0;

				Write  = 1'b1;
				CacheDataSelect = 1'b1;
				PDataSelect = 1'b0; 

				SysDataOE = 1'b0;
				PDataOE = 1'b0;

				SysStrobe = 1'b0; 
				SysRW = 1'b0;

				NextState = `STATE_WRITEHIT;
			end
			else begin

				PReady = 1'b0;

				Write  = 1'b0;
				CacheDataSelect = 1'b0;
				PDataSelect = 1'b0; 

				SysDataOE = 1'b0;
				PDataOE = 1'b0;

				SysStrobe = 1'b0; 
				SysRW = 1'b0;

				NextState = `STATE_READMISS; 
			end
		end
		`STATE_WRITEHIT : begin

			PReady = 1'b0;

			Write  = 1'b1;
			CacheDataSelect = 1'b1;
			PDataSelect = 1'b0; 

			SysDataOE = 1'b0;
			PDataOE = 1'b0;

			SysStrobe = 1'b0; 
			SysRW = 1'b0;

			NextState = `STATE_WRITESYS; 
		end
		`STATE_WRITEMISS : begin

			NextState = `STATE_WRITESYS; 
		end
		`STATE_WRITESYS : begin
			if (WaitStateCtrCarry)begin 

				PReady = 1'b0;

				Write  = 1'b0;
				CacheDataSelect = 1'b0;
				PDataSelect = 1'b0; 

				SysDataOE = 1'b1;
				PDataOE = 1'b0;

				SysStrobe = 1'b1; 
				SysRW = 1'b1;

				NextState = `STATE_WRITEDATA;
			end
			else begin 

				NextState = `STATE_WRITESYS;
			end
		end

		`STATE_WRITEDATA : begin

			PReady = 1'b1;

			Write  = 1'b0;
			CacheDataSelect = 1'b0;
			PDataSelect = 1'b0; 

			SysDataOE = 1'b0;
			PDataOE = 1'b0;

			SysStrobe = 1'b0; 
			SysRW = 1'b0;


			NextState = `STATE_IDLE;
		end

		default:

			NextState = `STATE_IDLE;

		endcase
	end

		/*task OutputVec;
			input [9:0] vector;
			begin
			vector =			
			{	LoadWaitStateCtr, PReadyEnable,
				Ready, Write, SysStrobe, SysRW,
				CacheDataSelect,
				DataSelect, PDataOE, SysDataOE	};
			end
		endtask*/

endmodule