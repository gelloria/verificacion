

`include "sdrc_define.v"
class monitor #(

	int BIT_ADDRESS 	= 32,
	int BIT_DATA		= 32
	
);
	reg [31:0] ErrCnt;
	virtual bus_interface system_bus_interface;
	scoreboard system_scoreboard;
	function new(virtual bus_interface system_bus_interface, scoreboard system_scoreboard);
		this.system_bus_interface=system_bus_interface;
		this.system_scoreboard=system_scoreboard;
		this.ErrCnt=0;
	endfunction 
	
	task burst_read();
		//ref input reg [31:0] ErrCnt;
		reg [BIT_ADDRESS-1:0] Address;
		reg [7:0]  bl;

		int i,j;
		reg [BIT_DATA-1:0]   exp_data;
		begin
			`ifdef Test_fail
				Address = 32'h4_bbbb; 
			`else
				system_scoreboard.pop_address(Address);
			`endif
		   system_scoreboard.pop_burst(bl); 
		   
		   @ (negedge system_bus_interface.sys_clk);


			  for(j=0; j < bl; j++) begin
				 system_bus_interface.wb_stb_i        = 1;
				 system_bus_interface.wb_cyc_i        = 1;
				 system_bus_interface.wb_we_i         = 0;
				 system_bus_interface.wb_addr_i       = Address[BIT_ADDRESS-1:2]+j;

				 system_scoreboard.pop_data(exp_data); // Expected Read Data
				 do begin
					 @ (posedge system_bus_interface.sys_clk);
				 end 
				 
				 while(system_bus_interface.wb_ack_o == 1'b0);
					 if(system_bus_interface.wb_dat_o !== exp_data) 
						begin
							$display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,system_bus_interface.wb_addr_i,system_bus_interface.wb_dat_o,exp_data);
							ErrCnt = ErrCnt+1;
						end 

					else 
						begin
							 $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,system_bus_interface.wb_addr_i,system_bus_interface.wb_dat_o);
						 end 
					 @ (negedge system_bus_interface.sdram_clk);
				end
		   system_bus_interface.wb_stb_i        = 0;
		   system_bus_interface.wb_cyc_i        = 0;
		   system_bus_interface.wb_we_i         = 'hx;
		   system_bus_interface.wb_addr_i       = 'hx;
		end
	endtask
	
	task get_errcnt;
		
		output [31:0] ErrCntOut;
		ErrCntOut = ErrCnt;
		
	endtask

endclass 
