`ifndef _DEF_INTF_
`define _DEF_INTF_

`timescale 1ns/1ps
parameter      dw              = 32	;  // data width
parameter      tw              = 8	;   // tag id width
parameter      bl              = 5	;   // burst_lenght_width 

//-------------------------------------------
// WISH BONE Interface
//-------------------------------------------  
interface wishbone();
	logic           	wb_stb_i   ;
	logic			wb_ack_o   ;
	logic  [25:0]   	wb_addr_i  ;
	logic           	wb_we_i    ; // 1 - Write, 0 - Read
	logic  [dw-1:0] 	wb_dat_i   ;
	logic  [dw/8-1:0]	wb_sel_i   ; // Byte enable
	logic  [dw-1:0]		wb_dat_o   ;
	logic			wb_cyc_i   ;
	logic   [2:0]		wb_cti_i   ;
endinterface:wishbone

//--------------------------------------------
// SDRAM I/F Interface
//--------------------------------------------
interface sdram(input logic sdram_clk);
	`ifdef SDR_32BIT
	   wire [31:0]      Dq      	        ; // SDRAM Read/Write Data Bus
	   wire [3:0]       sdr_dqm	        ; // SDRAM DATA Mask
	`elsif SDR_16BIT 
	   wire [15:0]      Dq                 	; // SDRAM Read/Write Data Bus
	   wire [1:0]       sdr_dqm         	; // SDRAM DATA Mask
	`else 
	   wire [7:0]       Dq          	; // SDRAM Read/Write Data Bus
	   wire [0:0]       sdr_dqm    	        ; // SDRAM DATA Mask
	`endif
	
	wire [1:0]          sdr_ba             	; // SDRAM Bank Select
	wire [12:0]         sdr_addr           	; // SDRAM ADRESS
	wire                sdr_init_done      	; // SDRAM Init Done     

	/* to fix the sdram interface timing issue */
	wire #(2.0) sdram_clk_ds   = sdram_clk   ;
endinterface:sdram

//--------------------------------------------
// Interface I/O test bench 
//--------------------------------------------
interface tb_interface();
	logic 		resetn_d	;
	logic			sys_clk_d	;
	logic 		sdram_clk_d	;
	logic [1:0]		cfg_colbits ;
	logic [31:0] ErrCnt		;

	wishbone 	infa_wishbone()			;
	sdram		infa_sdram(sdram_clk_d)		;

endinterface:tb_interface
`endif