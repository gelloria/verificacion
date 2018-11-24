`include "whitebox_interface.sv"

module assertions();
	  whitebox intf_wh();
//Define logic variables
		logic [11:0] row_temp;
		logic [11:0] col_temp;
		logic [1:0] bank_temp;

    logic run_cfgcolbits;
    logic run_pageovfl;
		
		/*initial begin
			
		end*/

/* **** Assertion to pregrammable column address **** */
	always @ (posedge intf_wh.whbox_Clk) begin
		if (intf_wh.whbox_cfgcolbits == 00) begin 
				assign col_temp[11:0] = intf_wh.whbox_map_addr[7:0];
				assign bank_temp[1:0] = intf_wh.whbox_map_addr[9:8];
				assign row_temp[11:0] = intf_wh.whbox_map_addr[21:10];
		end // if (intf_wh.whbox_run_cfgcolbits == 00)
		else if (intf_wh.whbox_cfgcolbits == 01) begin 
				assign col_temp[11:0] = intf_wh.whbox_map_addr[8:0];
				assign bank_temp[1:0] = intf_wh.whbox_map_addr[10:9];
				assign row_temp[11:0] = intf_wh.whbox_map_addr[22:11];
		end // if (intf_wh.whbox_run_cfgcolbits == 01)
		else if (intf_wh.whbox_cfgcolbits == 10) begin 
				assign col_temp[11:0] = intf_wh.whbox_map_addr[9:0];
				assign bank_temp[1:0] = intf_wh.whbox_map_addr[11:10];
				assign row_temp[11:0] = intf_wh.whbox_map_addr[23:12];
		end // if (intf_wh.whbox_run_cfgcolbits == 10)
		else begin 
				assign col_temp[11:0] = intf_wh.whbox_map_addr[10:0];
				assign bank_temp[1:0] = intf_wh.whbox_map_addr[12:11];
				assign row_temp[11:0] = intf_wh.whbox_map_addr[24:13];
		end // if (intf_wh.whbox_run_cfgcolbits == 11)
	end // always

// sequences
	sequence req_cfg;
		$rose(intf_wh.whbox_wren);
	endsequence
	
	sequence samecol;
		(intf_wh.whbox_column[11:2] == col_temp[11:2]) [=1];
	endsequence
	
	sequence samebank;
		(intf_wh.whbox_bank[1:0] == bank_temp[1:0]) [=1];
	endsequence

	sequence samerow;
		(intf_wh.whbox_row[11:0] == row_temp[11:0]) [=1];
	endsequence
	
	sequence matchaddr;
		(samecol and samebank and samerow);
	endsequence

// Assertion to verify the expected row, colum, bank in the request is the same
	CfgcolumCh: assert property (@(posedge intf_wh.whbox_Clk) disable iff(~run_cfgcolbits) (req_cfg |=> matchaddr))
		$display("Programming the config column bits can be write the data in the same row, bank and column");
	else
		$error("ERROR: Programming the config column bits can't be write the data in the same row, bank and column");

// coverage
	
	covergroup cg_cfgaddrReq @(posedge intf_wh.whbox_Clk iff run_cfgcolbits);
		column: coverpoint col_temp{
			bins col_a = {12'h80};
		}
		bank: coverpoint bank_temp[1:0]{
			bins bank_a =  {0};
		}
		row: coverpoint row_temp[11:0]{
			bins row_a =  {12'h06};
		}
		endgroup
	cg_cfgaddrReq cg_addReq = new;

	cov_CfgcolumCh: cover property (@(posedge intf_wh.whbox_Clk) disable iff(~run_cfgcolbits) (req_cfg |=> matchaddr));


/* ****  Assertion to notify the page cross over flow  **** */		
// sequence
	sequence write_req;
		(intf_wh.whbox_wren);
	endsequence

	sequence change_bank0;
		($rose(bank_temp[0]) or $fell(bank_temp[0]));
	endsequence

	sequence change_bank1;
		($rose(bank_temp[1]) or $fell(bank_temp[1]));
	endsequence

	sequence change_bank;
		(change_bank1 or change_bank0);
	endsequence

	sequence req_gen_notify;
		$stable(~(intf_wh.whbox_page_ovflw_r) && ~(intf_wh.whbox_lcl_wrap)) [=1];
	endsequence

	sequence write_req_off;
		$fell(intf_wh.whbox_wren) [=1];
	endsequence

	sequence pagecrossover;
		change_bank;
	endsequence

	PageOvfwCh: assert property (@(posedge intf_wh.whbox_Clk)  disable iff(~run_pageovfl) (write_req |=> pagecrossover |=> req_gen_notify))
		$error("page over flow has not been notify for SDRAM request generator to split the request");
	else
		$display("page over flow has been notify for SDRAM request generator to split the request");

//coverage
	cov_pagecrossover: cover property (@(posedge intf_wh.whbox_Clk) disable iff(~run_pageovfl) (change_bank));

/* **** Assertion: bank ready to write **** */
// seqeunce 
	sequence bank_ready;
		intf_wh.whbox_bankready;
	endsequence
// assert 
	ReadyBankCh: assert property (@(posedge intf_wh.whbox_Clk) disable iff(~intf_wh.whbox_Reset) (write_req |=> bank_ready))
	else
		$display("bank into the SDRAM not ready to allow write request");

	cov_ReadyBank: cover property (@(posedge intf_wh.whbox_Clk) disable iff(~intf_wh.whbox_Reset) (write_req |=> bank_ready));

endmodule:assertions