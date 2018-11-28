class stimuli_1;
	//  Address: <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic [31:0] Address;

  // Variables to be randomize
	rand logic [11:0] row;
	rand logic [1:0]	bank;
	rand logic [7:0]  column;
	rand logic [7:0]  burst_length;

  // Variables used as limits to avoid a page cross over
	logic [7:0] low_column;
	logic [7:0] hi_column;
	logic [7:0]  low_burst_length;
	logic [7:0]  hi_burst_length;

	// Restrictions to avoid a page cross over
  // The column and the burst_lenght must be in the range
	constraint column_range {
		column inside {[low_column:hi_column]};
	}
	constraint burst_lenght_range {
		burst_length inside {[low_burst_length:hi_burst_length]};
	}

	function new();
		this.low_column       = 8'h04;
		this.hi_column        = 8'hF0;
		this.low_burst_length = 8'h00;
		this.hi_burst_length  = 8'h0F;

	endfunction

	// Task to concatenate the row, bank, column, 2'b00 into the address
	task random_rowbank();
    begin
			address	= {row,bank,column,2'b00};
		end
	endtask

endclass:stimuli_1
