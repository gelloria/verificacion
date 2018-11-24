`ifndef _DEF_WBOX_
`define _DEF_WBOX_


interface whitebox();
    logic                         whbox_Clk;
	  logic                         whbox_Reset;
    logic                         whbox_req;
    logic [1:0]                   whbox_bank;
    logic [12:0]                  whbox_row;
    logic [12:0]                  whbox_column;
    logic                         whbox_wren;
    logic                         whbox_bankready;
    logic [1:0]                   whbox_cfgcolbits;
    logic [25:0]                  whbox_req_addr;
    logic [25:0]                  whbox_map_addr;
    logic [1:0]                   whbox_sdr_width;
    logic                         whbox_page_ovflw_r;
    logic                         whbox_lcl_wrap;
	
  `define DUT tbtop.u_dut
	`define DUT_REQGEN tbtop.u_dut.u_sdrc_core.u_req_gen	
	
	// assigns to DUT (Clk, Cke, Cs_n, Ras_n, Cas_n, We_n);
	assign whbox_Clk   = `DUT.sdram_clk	    ; //clk sdram
	assign whbox_Reset = `DUT.sdram_resetn	; //reset
	assign whbox_req 	 = `DUT_REQGEN.req	  ; //request
	assign whbox_bank	 = `DUT_REQGEN.r2b_ba	; //bank address requested
	assign whbox_row  = `DUT_REQGEN.r2b_raddr	; //row address requested
	assign whbox_column  = `DUT_REQGEN.r2b_caddr	; //column address requested
	assign whbox_wren	 = `DUT_REQGEN.r2b_write	; //write request = 1 / read request = 0
	assign whbox_bankready	= `DUT_REQGEN.b2r_arb_ok	;//Bank controller fifo is not full and ready to accept the command

	assign whbox_cfgcolbits	= `DUT_REQGEN.cfg_colbits	;//
	assign whbox_req_addr	= `DUT_REQGEN.req_addr	;//
	assign whbox_map_addr	= `DUT_REQGEN.map_address	;//
	assign whbox_sdr_width	= `DUT_REQGEN.sdr_width	;//
	// If the wrap = 0 and current application burst length is crossing the page boundary, 
  // then request will be split into two with corresponding change in request address and request length.
	assign whbox_page_ovflw_r	= `DUT_REQGEN.page_ovflw_r	;//
	assign whbox_lcl_wrap	= `DUT_REQGEN.lcl_wrap	;//

endinterface:whitebox //whit_box interface

`endif