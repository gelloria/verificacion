class test;
	environment system_environment;
	task set_interface;
		input virtual bus_interface system_interface;
		this.system_environment= new(system_interface);
	endtask
	int k;
	reg [31:0] StartAddr;
	reg [31:0] ErrCnt=0;
	task startSimulation();
		this.system_environment.startSimulation();
		#1000;
		$display("---------------------------------------------------------");
		$display(" Case 7:  Random");
		$display("---------------------------------------------------------");
		for(k=0; k < 1; k++) begin
			this.system_environment.system_driver.write_randaddr();
			#10;
			this.system_environment.system_monitor.burst_read();
			#10;
		end

		$display("###############################");
	    	if(ErrCnt == 0)
			$display("STATUS: SDRAM Write/Read TEST PASSED");
	    	else
			$display("ERROR:  SDRAM Write/Read TEST FAILED");
			$display("###############################");

	    $finish;

	endtask


endclass
