class environment;

	scoreboard system_scoreboard;
	monitor    system_monitor;
	driver     system_driver;

	/* Stimulus */
	stimuli1 	 st1;

	virtual bus_interface system_bus_interface;

	function new(virtual bus_interface system_bus_interface);

		this.system_bus_interface=system_bus_interface;
		st1=new();

		this.system_scoreboard=new;
		this.system_driver= new (this.system_bus_interface,this.system_scoreboard);
		this.system_monitor= new (this.system_bus_interface,this.system_scoreboard);

	endfunction

	task startSimulation();
		this.system_driver.Reset();
	endtask
endclass
