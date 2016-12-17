`timescale 1ns/10ps
`include "port_define.sv"

module cache(
				PStrobe, 
				Paddress,
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
	input [`ADDR] PAdress;
	input [`DATA] PData;
	input PRW;
	output PReady;

	//Cache <-> memory
	input [`DATA] SysData;
	output logic SysStrobe;
	output logic [`ADDR] SysAddress;
	output logic SysRW;
	

	// Bidirectional Buses
	logic PDataOE;
	logic SysDataOE;
	logic [`DATA] PDataOut;
	logic [`DATA] PData;
	logic [`TAG]  TagRamTag;
	logic Write;
	logic Valid;
	logic CacheDataSelect;
	logic PDataSelect;
	logic Match;

	logic [`DATA] DataRamDataOut;
	logic [`DATA] DataRamDataIn;

	always_comb begin
		PData = PDataOE ? PDataOut :`DATAWIDTH`bz;
		SysData = SysDataOE ? PData : `DATAWIDTH`bz;
		SysAddress = PAddress;
	end

	TagRam TagRam(
					.Address (PAddress[`INDEX]),
					.TagIn (PAddress[`TAG]),
					.TagOut (TagRamTag[`TAG]),
					.Write (Write),
					.Clk (Clk)
	);

	ValidTam ValidRam(
						.Address(PAddress[`INDEX]),
						.ValidIn (1'b1),
						.ValidOut (Valid),
						.Write (Write),
						.Reset (Reset),
						.Clk (Clk)
	);

	//Selecting write data source
	//write allocate ??
	//If write miss, from memory
	//else, from cpu 
	DataMux CacheDataInputMux(
		.S (CacheDataSelect),
		.A (SysData),
		.B (PData),
		.Z (DataRamDataIn)
	);

	//Selecting read data source
	//read through ??
	//If read miss, from memory
	//else, from cache
	DataMux PDatatMux(
		.S (PDataSelect),
		.A (SysData),
		.B (DataRamDataOut),
		.Z (PDataOut)
	);

	DataRam DataRam(
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