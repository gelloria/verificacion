`include "environment.sv"
//---------------------------------
// Test
//--------------------------------
`timescale 1ns/1ps
program test(tb_interface infa_ext);
	reg [31:0] read_data	;
	int k;
	reg [31:0] StartAddr;
	class_environment env	= new(infa_ext);	
/////////////////////////////////////////////////////////////////////////
// Test Case
/////////////////////////////////////////////////////////////////////////
	// write in a specific row & bank: write_rowbank([11:0] row,[1:0] bank)
							
	initial begin //{
		env.drv.reset_dram();
		$display($time," ns, Initilization Done");
		assertions_dut.run_cfgcolbits = 0;
		assertions_dut.run_pageovfl = 0;
		coverage_dut.run_cfgcolbits2banks = 0;
		coverage_dut.run_eachbank = 0;
		coverage_dut.run_random = 0;
		//$stop;
		#1000;

		// Deterministic test cases
		`ifdef SDR_32BIT
		$display("-------------------------------------------------------------------------------------------------- ");
		$display(" Case 1: Single Write/Read Case For the same Address with different bits of column configuration   ");
		$display("-------------------------------------------------------------------------------------------------- ");
		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h006,2'b00,8'h80,2'b00},8'h4);
    #10;
		env.mon.burst_read();
		assertions_dut.run_cfgcolbits = 0;
		#10;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h006,2'b00,9'h080,2'b00},8'h4);
		#10;
		env.mon.burst_read();
		assertions_dut.run_cfgcolbits = 0;
		#10;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h006,2'b00,10'h080,2'b00},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#10;
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h006,2'b00,11'h080,2'b00},8'h4);
		#10;
		env.mon.burst_read();
		assertions_dut.run_cfgcolbits = 0; 
		#10;

		$display("--------------------------------------------------------------------------------------------------------------");
		$display(" Case 2: Single Write/Read Case For the same row and colum but different row and bits of column configuration ");
		$display("--------------------------------------------------------------------------------------------------------------");

		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h08,2'b00,8'h40,2'b00},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h08,2'b01,9'h40,2'b00},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h08,2'b10,11'h40,2'b00},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h08,2'b11,11'h40,2'b00},8'h4);
		env.mon.burst_read();
  	coverage_dut.run_cfgcolbits2banks = 0;
		

		`elsif SDR_16BIT
		$display("-------------------------------------------------------------------------------------------------- ");
		$display(" Case 1: Single Write/Read Case For the same Address with different bits of column configuration   ");
		$display("-------------------------------------------------------------------------------------------------- ");
		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h006,2'b00,8'h80,1'b0},8'h4);
		#10;
	  env.mon.burst_read(); 
		assertions_dut.run_cfgcolbits = 0;
		#10;   
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h006,2'b00,9'h080,1'b0},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#10;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h006,2'b00,10'h080,1'b0},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#10;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h006,2'b00,11'h080,1'b0},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#10;  
	
		$display("--------------------------------------------------------------------------------------------------------------");
		$display(" Case 2: Single Write/Read Case For the same row and colum but different row and bits of column configuration ");
		$display("--------------------------------------------------------------------------------------------------------------");

		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h08,2'b00,8'h40,1'b0},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h08,2'b01,9'h004,1'b0},8'h4);
		env.mon.burst_read(); 
		coverage_dut.run_cfgcolbits2banks = 0; 
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h08,2'b10,11'h00,1'b0},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h08,2'b11,11'h040,1'b0},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		`else
		$display("-------------------------------------------------------------------------------------------------- ");
		$display(" Case 1: Single Write/Read Case For the same Address with different bits of column configuration   ");
		$display("-------------------------------------------------------------------------------------------------- ");
		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h006,2'b00,8'h80},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#50;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h006,2'b00,9'h080},8'h4);
		#10;
		env.mon.burst_read(); 
		assertions_dut.run_cfgcolbits = 0;
		#50;  		
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		assertions_dut.run_cfgcolbits = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h006,2'b00,11'h080},8'h4);
		#10;
		env.mon.burst_read();  
		assertions_dut.run_cfgcolbits = 0;
		#50;  
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		assertions_dut.run_cfgcolbits = 1; 
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h006,2'b00,11'h080},8'h4);
		#10;
		env.mon.burst_read(); 
		assertions_dut.run_cfgcolbits = 0; 
		#50;  
		$display("--------------------------------------------------------------------------------------------------------------");
		$display(" Case 2: Single Write/Read Case For the same row and colum but different bank and bits of column configuration ");
		$display("--------------------------------------------------------------------------------------------------------------");

		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <+2'b00,{} SDR8/ +1'b0,{1'b0} SDR16/ na,{2b'00} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b00;
		env.drv.burst_write({12'h08,2'b00,8'h40},8'h4);
		env.mon.burst_read();
		coverage_dut.run_cfgcolbits2banks = 0;		
		// Address Decodeing:
		//  with cfg_col bit configured as: 01
		//    <12 Bit Row> <2 Bit Bank> <9 Bit Column> <+2'b01,{} SDR8/ +1'b0,{1'b1} SDR16/ na,{2b'01} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b01;
		env.drv.burst_write({12'h08,2'b01,9'h40},8'h4);
		env.mon.burst_read(); 
		coverage_dut.run_cfgcolbits2banks = 0;		 
		// Address Decodeing:
		//  with cfg_col bit configured as: 10
		//    <12 Bit Row> <2 Bit Bank> <10 Bit Column> <+2'b10,{} SDR8/ +1'b1,{1'b0} SDR16/ na,{2b'10} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b10;
		env.drv.burst_write({12'h08,2'b10,11'h40},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		// Address Decodeing:
		//  with cfg_col bit configured as: 11
		//    <12 Bit Row> <2 Bit Bank> <11 Bit Column> <+2'b11,{} SDR8/ +1'b1,{1'b1} SDR16/ na,{2b'11} SDR 32>
		coverage_dut.run_cfgcolbits2banks = 1;
		infa_ext.cfg_colbits = 2'b11;
		env.drv.burst_write({12'h08,2'b11,11'h40},8'h4);
		env.mon.burst_read();  
		coverage_dut.run_cfgcolbits2banks = 0;
		`endif

		$display("----------------------------------------");
		$display(" Case 3: Create a Page Cross Over        ");
		$display("----------------------------------------");
		//----------------------------------------
		// Address Decodeing:
		//  with cfg_col bit configured as: 00

		infa_ext.cfg_colbits = 2'b00;
	
		assertions_dut.run_pageovfl	= 1;
		env.drv.write_pgco();
		assertions_dut.run_pageovfl	= 0;
		#10;
		assertions_dut.run_pageovfl	= 1;
		env.drv.write_pgco();
		assertions_dut.run_pageovfl	= 0;
		#10;
		assertions_dut.run_pageovfl	= 1;
		env.drv.write_pgco();
		assertions_dut.run_pageovfl	= 0;
		#10;
		assertions_dut.run_pageovfl	= 1;
		env.drv.write_pgco();
		assertions_dut.run_pageovfl	= 0;
		#10;
		//read
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  

		$display("---------------------------------------");
		$display(" Case 4: 16 Write & 16 Read With Different Bank and Row ");
		$display("---------------------------------------");
		//----------------------------------------
		// Address Decodeing:
		//  with cfg_col bit configured as: 00
		//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
		//
		
		coverage_dut.run_eachbank = 1;
		env.drv.write_rowbank(12'h000,2'b00);   // Row: 0 Bank : 0
		env.drv.write_rowbank(12'h000,2'b01);   // Row: 0 Bank : 1
		env.drv.write_rowbank(12'h000,2'b10);   // Row: 0 Bank : 2
		env.drv.write_rowbank(12'h000,2'b11);   // Row: 0 Bank : 3
		env.drv.write_rowbank(12'h001,2'b00);   // Row: 1 Bank : 0
		env.drv.write_rowbank(12'h001,2'b01);   // Row: 1 Bank : 1
		env.drv.write_rowbank(12'h001,2'b10);   // Row: 1 Bank : 2
		env.drv.write_rowbank(12'h001,2'b11);   // Row: 1 Bank : 3
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		
		env.drv.write_rowbank(12'h002,2'b00);   // Row: 2 Bank : 0
		env.drv.write_rowbank(12'h002,2'b01);   // Row: 2 Bank : 1
		env.drv.write_rowbank(12'h002,2'b10);   // Row: 2 Bank : 2
		env.drv.write_rowbank(12'h002,2'b11);   // Row: 2 Bank : 3
		env.drv.write_rowbank(12'h003,2'b00);   // Row: 3 Bank : 0
		env.drv.write_rowbank(12'h003,2'b01);   // Row: 3 Bank : 1
		env.drv.write_rowbank(12'h003,2'b10);   // Row: 3 Bank : 2
		env.drv.write_rowbank(12'h003,2'b11);   // Row: 3 Bank : 3

		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  
		env.mon.burst_read();  

		coverage_dut.run_eachbank = 0;
		$display("---------------------------------------------------------");
		$display(" Case 5:  Random 5 write and 5 read random for each cfg");
		$display("---------------------------------------------------------");
		coverage_dut.run_random = 1;
		for(k=0; k < 5; k++) begin
			infa_ext.cfg_colbits = 2'b00;
			env.drv.write_randaddr(infa_ext.cfg_colbits);  
			#10;
			env.mon.burst_read();  
			#10;
				
			infa_ext.cfg_colbits = 2'b01;
			env.drv.write_randaddr(infa_ext.cfg_colbits);  
			#10;
			env.mon.burst_read();  
			#10;
		
			infa_ext.cfg_colbits = 2'b10;
		  env.drv.write_randaddr(infa_ext.cfg_colbits);  
			#10;
			env.mon.burst_read();  
			#10;
		
			infa_ext.cfg_colbits = 2'b11;
		  env.drv.write_randaddr(infa_ext.cfg_colbits);  
			#10;
			env.mon.burst_read();  
			#10;
		end
		coverage_dut.run_random = 0;

		#10000;
		
		$display("###############################");
		if(infa_ext.ErrCnt == 0)
			$display("STATUS: SDRAM Write/Read TEST PASSED");
		else
			$display("ERROR:  SDRAM Write/Read TEST FAILED");
			$display("###############################");
		
		$finish;
	end
endprogram:test
