`timescale 1ns/10ps
`include "port_define.sv"
`include "cache_ctrl.sv"
`include "cache_mux.sv"
`include "cache_wait.sv"
`include "cache_valid.sv"
`include "cache_data.sv"
`include "cache_tag.sv"
`include "cache_cmp.sv"

module cache(
				PStrobe, 
				PAddress,
				PData, 
				PRW, 
				PReady,
				SysStrobe, 
				SysAddress,
				SysData, 
				SysRW,
				Reset, 
				Clk
);

	input Reset;
	input Clk;

	//CPU <-> Cache
	input PStrobe;
	input [`ADDR] PAddress;
	inout [`DATA] PData; //inout!!!
	input PRW;
	output PReady;

	//Cache <-> memory
	inout [`DATA] SysData; //inout
	output logic SysStrobe;
	output logic [`ADDR] SysAddress;
	output logic SysRW;
	

	// Bidirectional Buses
	logic PDataOE;
	logic SysDataOE;
	logic [`DATA] PDataOut;
	logic [`TAG]  TagRamTag;
	logic Write;
	logic Valid;
	logic CacheDataSelect;
	logic PDataSelect;
	logic Match;

	logic [`DATA] DataRamDataOut;
	logic [`DATA] DataRamDataIn;

	//always_comb begin
	assign	PData = PDataOE ? PDataOut :`DATAWIDTH'bz;
	assign	SysData = SysDataOE ? PData : `DATAWIDTH'bz;
	assign	SysAddress = PAddress;
	//end

	TagRam tagram(
					.Address (PAddress[`INDEX]),
					.TagIn (PAddress[`TAG]),
					.TagOut (TagRamTag[`TAG]),
					.Write (Write),
					.Clk (Clk)
	);

	ValidRam validram(
						.Address(PAddress[`INDEX]),
						.ValidIn (1'b1),
						.ValidOut (Valid),
						.Write (Write),
						.Reset (Reset),
						.Clk (Clk)
	);

	//Selecting write data source
	//If write miss, from memory
	//else, from cpu 
	DataMux CacheDataInputMux(
		.S (CacheDataSelect),
		.A (SysData),
		.B (PData),
		.Z (DataRamDataIn)
	);

	//Selecting read data source
	//If read miss, from memory
	//else, from cache
	DataMux PDatatMux(
		.S (PDataSelect),
		.A (SysData),
		.B (DataRamDataOut),
		.Z (PDataOut)
	);

	DataRam dataram(
		.Address (PAddress[`INDEX]),
		.DataIn (DataRamDataIn),
		.DataOut (DataRamDataOut),
		.Write (Write),
		.Clk (Clk)
	);

	Comparator Comparator(
		.Tag1 (PAddress[`TAG]),
		.Tag2 (TagRamTag),
		.Match (Match)
	);

	Control Control(
		.PStrobe (PStrobe),
		.PRW (PRW),
		.PReady (PReady),
		.Match(Match),
		.Valid (Valid),
		.CacheDataSelect (CacheDataSelect),//write selection
		.PDataSelect (PDataSelect),//read selection
		.SysDataOE (SysDataOE),
		.Write (Write),
		.PDataOE (PDataOE),
		.SysStrobe (SysStrobe),
		.SysRW (SysRW),
		.Reset (Reset),
		.Clk (Clk)
	);

endmodule