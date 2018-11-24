`include "interfaces.sv"

`ifndef _DEF_SCB_
`define _DEF_SCB_

class class_scoreboard;
	int dfifo[$]				; // data fifo
	int afifo[$]				; // address  fifo
	int bfifo[$]				; // Burst Length fifo
	
	virtual tb_interface intf_scb;
	
	function new(virtual tb_interface intf_ext)	;
		this.intf_scb	= intf_ext	;
		this.dfifo		= {}		; 	// Borra el queue por completo
		this.afifo		= {}		; 	// Borra el queue por completo
		this.bfifo		= {}		; 	// Borra el queue por completo
	endfunction
endclass:class_scoreboard

`endif 