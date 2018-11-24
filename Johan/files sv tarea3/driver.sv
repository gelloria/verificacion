`ifndef DRV
`define DRV

`include "scoreboard.sv"
`include "stimuli1.sv"
`include "stimuli2.sv"
`include "stimuli3.sv"

//---------------------------------
// Classes Definition
//--------------------------------
/* driver */
class class_driver;
	int		i;
	logic  [31:0] 	Address;
 	logic  [7:0]    bl;
	// scoreboard
	class_scoreboard 		scb_drv	;
	// stimulus is an object into the driver
	stimuli1_randaddr 		st1_drv	; //random bank and row
	stimuli2_pagecrossover st2_drv; //address to page cross over
	stimuli3_specaddr 		st3_drv	; //specific bank and row
	
	// interface
	virtual tb_interface intf_drv	;
	// function
	function new(virtual tb_interface intf_ext, 
			class_scoreboard scb_ext, 
			stimuli1_randaddr st1_ext,
			stimuli2_pagecrossover st2_ext, 
			stimuli3_specaddr st3_ext
			);
		this.intf_drv		= intf_ext	;
		this.i					= 0		;
		this.scb_drv		= scb_ext	;
		this.st1_drv		= st1_ext	;
		this.st2_drv		= st2_ext	;
		this.st3_drv		= st3_ext	;
	endfunction
	
	// task driver
	extern task reset_dram()	; // reset the dram memory
	extern task burst_write(logic [31:0] Address, logic [7:0] bl); // write in DRAM and save the information in the scoreboard
	// task stimulus
	extern task write_randaddr(logic [1:0] cfgcolumn); //stimuli 1:write random row & bank
	extern task write_pgco(); //stimuli 2: write page cross over
	extern task write_rowbank(logic [11:0] row, logic [1:0] bank); //stimuli 3: write in a specific row & bank 
	
endclass:class_driver					


//---------------------------------
// Stimulus task to generate the Address and bl, then it call the busrt_write task
//--------------------------------
/* stimuli 1*/
task class_driver::write_randaddr(logic [1:0] cfgcolumn);
	begin 
		//st1_drv		= new();
		void'(st1_drv.randomize());
		st1_drv.random_rowbank(cfgcolumn);
		Address = st1_drv.Address;
		bl = st1_drv.bl;
		
		this.burst_write(Address,bl);
	end
endtask //random row and bank

/* stimuli 2*/
task class_driver::write_pgco();
	begin 
		//st2_drv		= new();	
		void'(st2_drv.randomize());
		st2_drv.pageco_rowbank();
		Address = st2_drv.Address;
		bl = st2_drv.bl;
		
		this.burst_write(Address,bl);
	end
endtask //page cross over

/* stimuli 3*/
task class_driver::write_rowbank(
								logic [11:0] row,
								logic [1:0] bank
								);
	begin 
		//st3_drv		= new();
		void'(st3_drv.randomize());
		st3_drv.rowbank_spec(row,bank);
		Address = st3_drv.Address;
		bl = st3_drv.bl;
		
		this.burst_write(Address,bl);
	end
endtask //specific row and bank

//---------------------------------
// Tasks for burst_write and reset_dram
//--------------------------------
//---------------------------------
// Tasks Definition
//--------------------------------
/* burst write */
task class_driver::burst_write(
				logic [31:0] Address,
				logic [7:0] bl
				);
	begin
		scb_drv.afifo.push_back(Address);
		scb_drv.bfifo.push_back(bl)		;

		@ (negedge intf_drv.sys_clk_d)	;
			$display("Write Address: %x, Burst Size: %d",Address,bl);
	
		for(i=0; i < bl; i++) begin
	 		intf_drv.infa_wishbone.wb_stb_i        = 1						;
			intf_drv.infa_wishbone.wb_cyc_i        = 1						;
	      		intf_drv.infa_wishbone.wb_we_i         = 1						;
	      		intf_drv.infa_wishbone.wb_sel_i        = 4'b1111				;
	      		intf_drv.infa_wishbone.wb_addr_i       = Address[31:2]+i		;
	      		intf_drv.infa_wishbone.wb_dat_i        = $random & 32'hFFFFFFFF	;	
	      	
			scb_drv.dfifo.push_back(intf_drv.infa_wishbone.wb_dat_i)						;
	
			do begin
				@ (posedge intf_drv.sys_clk_d)		;
			end while(intf_drv.infa_wishbone.wb_ack_o == 1'b0)	;
				@ (negedge intf_drv.sys_clk_d)		;
	   
		       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,intf_drv.infa_wishbone.wb_addr_i,intf_drv.infa_wishbone.wb_dat_i);
		end

		intf_drv.infa_wishbone.wb_stb_i        = 0	;
		intf_drv.infa_wishbone.wb_cyc_i        = 0	;
		intf_drv.infa_wishbone.wb_we_i         = 'hx	;
		intf_drv.infa_wishbone.wb_sel_i        = 'hx	;
		intf_drv.infa_wishbone.wb_addr_i       = 'hx	;
		intf_drv.infa_wishbone.wb_dat_i        = 'hx	;
	end
endtask

/* reset dram */
task class_driver::reset_dram();
	begin
		intf_drv.ErrCnt				      			  = 0	;
		intf_drv.infa_wishbone.wb_addr_i      = 0	;
		intf_drv.infa_wishbone.wb_dat_i       = 0	;
		intf_drv.infa_wishbone.wb_sel_i       = 4'h0	;
		intf_drv.infa_wishbone.wb_we_i        = 0	;
		intf_drv.infa_wishbone.wb_stb_i       = 0	;
		intf_drv.infa_wishbone.wb_cyc_i       = 0	;
	
		intf_drv.resetn_d    = 1'h1;
		#1;
		// Applying reset
		intf_drv.resetn_d    = 1'h0;
		#100000;
		// Releasing reset
		intf_drv.resetn_d    = 1'h1;
		#1000;
		wait(intf_drv.infa_sdram.sdr_init_done == 1);
		#1000;
	end
endtask
`endif