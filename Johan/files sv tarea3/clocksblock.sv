//-------------------------------------------
// Define global parameters
//-------------------------------------------  
`timescale 1ns/1ps

//-------------------------------------------
// Define block of clocks
//-------------------------------------------  
module clks_block(
	output logic	RESETN		,
	output logic	sdram_clk	,
	output logic	sys_clk			
	);
	
	parameter	P_SYS	=	10		;     //    200MHz
	parameter	P_SDR	=	20		;     //    100MHz

	/* General */
	initial	sys_clk		= 0		;
	initial	sdram_clk	= 0		;

	always #(P_SYS/2) sys_clk	= !sys_clk	;
	always #(P_SDR/2) sdram_clk	= !sdram_clk;
endmodule:clks_block