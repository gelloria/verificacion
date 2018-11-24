/* This testbench verify with SDRAM TOP */
`include "program_test_p2.sv"
`include "top_modules.sv"
`include "assertions.sv"

//-------------------------------------------
// Define global parameters
//-------------------------------------------  
`define SRC_32BITS;
`timescale 1ns/1ps
module testbench_top();
	tb_interface inftb();
	top_duv	tbtop(inftb);

	test 	runtest(inftb)	;

	assertions assertions_dut();
	coverage coverage_dut();
endmodule:testbench_top