`include "whitebox_interface.sv"

module coverage();
	  whitebox intf_wh();
// Define logic variables
		logic [11:0] row_temp;
		logic [11:0] col_temp;
		logic [1:0] bank_temp;
    /*logic                         whbox_Clk;
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
*/
    logic run_cfgcolbits2banks;
  	logic run_eachbank;
		logic run_random;

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

/* **** coverage to write in the same row and column but different bank **** */
	covergroup cg_cfg2difbank @(posedge intf_wh.whbox_Clk iff run_cfgcolbits2banks);
		cfgcolbits: coverpoint intf_wh.whbox_cfgcolbits[1:0]{
			bins cfg_0 =  {2'b00};
			bins cfg_1 =  {2'b01};
			bins cfg_2 =  {2'b10};
			bins cfg_3 =  {2'b11};
		}
		column: coverpoint col_temp{
			bins col_req = {64,126};
		}
		bank: coverpoint bank_temp[1:0]{
			bins bank_0 =  {2'b00};
			bins bank_1 =  {2'b01};
			bins bank_2 =  {2'b10};
			bins bank_3 =  {2'b11};
		}
		row: coverpoint row_temp[11:0]{
			//bins row_req = {0,128};
		}
		endgroup
	cg_cfg2difbank cg_cgfcol2banks= new;

/* **** coverage to write in the 4 rows and 4 banks but random column  **** */
		covergroup cg_eachbank2fourrow @(posedge intf_wh.whbox_Clk iff run_eachbank);
		column: coverpoint col_temp{
			//bins col_random = {};
		}
		bank: coverpoint bank_temp[1:0]{
			bins bank_0 =  {2'b00};
			bins bank_1 =  {2'b01};
			bins bank_2 =  {2'b10};
			bins bank_3 =  {2'b11};
		}
		row: coverpoint row_temp[11:0]{
			bins row_0 = {0};
			bins row_1 = {1};
			bins row_2 = {2};
			bins row_3 = {3};
		}
		endgroup
	cg_eachbank2fourrow  cg_4row4bank= new;

/* **** coverage to write random address  **** */
		covergroup cg_addrrandom @(posedge intf_wh.whbox_Clk iff run_random);
		cfgcolbits: coverpoint intf_wh.whbox_cfgcolbits[1:0]{
			//bins cfg_random =  {};
		}
		column: coverpoint col_temp{
			//bins col_random = {};
		}
		bank: coverpoint bank_temp[1:0]{
			//bins bank_random = {};
		}
		row: coverpoint row_temp[11:0]{
			//bins row_random = {};
		}
		endgroup
	cg_addrrandom cg_random= new;

/* **** coverage of request count (write and read) **** */
	covergroup cg_wrReq @(posedge intf_wh.whbox_Clk);
		wrreqs: coverpoint intf_wh.whbox_wren{
			bins wr = {1};
			bins rd = {0};
}
		endgroup
	cg_wrReq cg_wrenReq = new;

/* **** coverage of bank ready and pending **** */
	covergroup cg_BankReq @(posedge intf_wh.whbox_Clk iff intf_wh.whbox_wren);
		bankready: coverpoint intf_wh.whbox_bankready{
			bins bankok = {1};
			bins pending = {0};
}
		endgroup
	cg_BankReq cg_bankOk = new;

endmodule