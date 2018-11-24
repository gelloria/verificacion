`include "scoreboard.sv"

/* monitor */
class class_monitor;
	logic [31:0] 	Address	;
	logic [7:0]  	bl			;
	int						j				;
	logic [31:0]  exp_data;

	class_scoreboard scb_mon			;
	virtual tb_interface intf_mon	;
	
	function new(virtual tb_interface intf_ext,class_scoreboard scb_ext);
		this.Address 	= 32'b0	;
		this.bl 	= 8'b0			;
		this.j 		= 0					;
		this.exp_data 	= 32'b0		;
		this.intf_mon	= intf_ext	;
		this.scb_mon	= scb_ext		;
	endfunction

	extern task burst_read();	
endclass:class_monitor

/* burst read */
task class_monitor::burst_read()	;
	begin
		Address = scb_mon.afifo.pop_front()		; 
		bl      = scb_mon.bfifo.pop_front()		; 
		
		intf_mon.ErrCnt = 0;
		
		@ (negedge intf_mon.sys_clk_d)				;
	
		for(j=0; j < bl; j++) begin
				intf_mon.infa_wishbone.wb_stb_i		= 1					;
		    intf_mon.infa_wishbone.wb_cyc_i		= 1					;
		    intf_mon.infa_wishbone.wb_we_i    = 0					;
		    intf_mon.infa_wishbone.wb_addr_i	= Address[31:2]+j	;
	
		    exp_data        = scb_mon.dfifo.pop_front()			; // Expected Read Data
		        
				do begin
			      @ (posedge intf_mon.sys_clk_d)	;
		        end while(intf_mon.infa_wishbone.wb_ack_o == 1'b0)	;
	
		        if(intf_mon.infa_wishbone.wb_dat_o !== exp_data) begin
			        $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,intf_mon.infa_wishbone.wb_addr_i,intf_mon.infa_wishbone.wb_dat_o,exp_data);
			        intf_mon.ErrCnt = intf_mon.ErrCnt+1				;
		        end else begin
			       $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,intf_mon.infa_wishbone.wb_addr_i,intf_mon.infa_wishbone.wb_dat_o);
		        end 
		        @ (negedge intf_mon.sdram_clk_d)				;
		end

		intf_mon.infa_wishbone.wb_stb_i        = 0	;
		intf_mon.infa_wishbone.wb_cyc_i        = 0	;
		intf_mon.infa_wishbone.wb_we_i         = 'hx	;
		intf_mon.infa_wishbone.wb_addr_i       = 'hx	;
	end
endtask
