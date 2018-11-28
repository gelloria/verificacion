
`include "My_RTL/stimuli_1.sv"

//---------------------------------
// Classes Definition
//--------------------------------

/* driver */
class driver;

	logic  [31:0] 	Address;
	logic  [7:0]    burst_length;

	// scoreboard
	scoreboard            system_scoreboard;
	// interface
	virtual bus_interface system_bus_interface;
	// stimuli
	stimuli_1 		        st1_drv	;

	function new(
		virtual bus_interface system_bus_interface,
		scoreboard system_scoreboard,
		stimuli_1 st1_ext
		);

		this.system_bus_interface =system_bus_interface;
		this.system_scoreboard    =system_scoreboard;
		this.st1_drv		          =st1_ext;

	endfunction

	//---------------------------------
	// Stimulus task to generate the Address and burst_length, then it call the busrt_write task
	//--------------------------------
	/* stimuli 1*/
	task write_randaddr();
		begin

			void'(st1_drv.randomize());
			st1_drv.random_rowbank();
			Address = st1_drv.address;
			burst_length = st1_drv.burst_length;

			this.burst_write(Address,burst_length);
		end
	endtask //random row and bank

	task Reset();
		//ErrCnt          = 0;
		this.system_bus_interface.wb_addr_i    = 0;
		this.system_bus_interface.wb_dat_i     = 0;
		this.system_bus_interface.wb_sel_i     = 4'h0;
		this.system_bus_interface.wb_we_i      = 0;
		this.system_bus_interface.wb_stb_i     = 0;
		this.system_bus_interface.wb_cyc_i     = 0;
		this.system_bus_interface.sdram_resetn = 1'h1;
		#100
		// Applying reset
		this.system_bus_interface.sdram_resetn = 1'h0;
		#10000;
		// Releasing reset
		this.system_bus_interface.sdram_resetn = 1'h1;
		#1000;
		wait(this.system_bus_interface.sdr_init_done == 1);
		#1000;

	endtask

	task burst_write();
		input [31:0] Address;
		input [7:0]  burst_length;
		int i;
		begin
		  this.system_scoreboard.push_address(Address);
		  this.system_scoreboard.push_burst(burst_length);

		   @ (negedge this.system_bus_interface.sys_clk);
		   $display("Write Address: %x, Burst Size: %d",Address,burst_length);

		   for(i=0; i < burst_length; i++) begin
		      this.system_bus_interface.wb_stb_i        = 1;
		      this.system_bus_interface.wb_cyc_i        = 1;
		      this.system_bus_interface.wb_we_i         = 1;
		      this.system_bus_interface.wb_sel_i        = 4'b1111;
		      this.system_bus_interface.wb_addr_i       = Address[31:2]+i;
		      this.system_bus_interface.wb_dat_i        = $random & 32'hFFFFFFFF;
		      this.system_scoreboard.push_data(this.system_bus_interface.wb_dat_i);

		      do begin
				  @ (posedge this.system_bus_interface.sys_clk);
			      end while(this.system_bus_interface.wb_ack_o == 1'b0);
				  @ (negedge this.system_bus_interface.sys_clk);

		       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,this.system_bus_interface.wb_addr_i,this.system_bus_interface.wb_dat_i);
		   end

		   this.system_bus_interface.wb_stb_i        = 0;
		   this.system_bus_interface.wb_cyc_i        = 0;
		   this.system_bus_interface.wb_we_i         = 'hx;
		   this.system_bus_interface.wb_sel_i        = 'hx;
		   this.system_bus_interface.wb_addr_i       = 'hx;
		   this.system_bus_interface.wb_dat_i        = 'hx;
		end

	endtask
endclass
