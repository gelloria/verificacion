`include "driver.sv"
`include "monitor.sv"

/* environment contains objects of driver, scoreboard, monitor */
class class_environment;
	virtual tb_interface intf_env;
		
	class_scoreboard	scb;
	class_driver 		drv;
	class_monitor		mon;
	stimuli1_randaddr 		st1	; 
	stimuli2_pagecrossover st2; 
	stimuli3_specaddr 		st3;
		
	function new(virtual tb_interface intf_ext);
		this.intf_env 	= intf_ext;
		st1=new();
		st2=new();
		st3=new();
		scb = new(this.intf_env);
		drv = new(this.intf_env,this.scb,this.st1,this.st2,this.st3);
		mon = new(this.intf_env,this.scb);
		
	endfunction
endclass:class_environment

