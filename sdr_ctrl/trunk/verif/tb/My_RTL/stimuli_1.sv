class stimuli_1;

	//  with cfg_col bit configured as: 00
	//  <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic [31:0] Address;

  // Variables to randomize
	rand logic [11:0] row;
	rand logic [1:0]	bank;
	rand logic [11:0] column;
	rand logic [7:0]  burst_length;

  // Variables used as limits to avoid a page cross over
	logic [11:0] low_column, hi_column;
	logic [7:0] low_burst_length, hi_burst_length;

	// Restrictions to avoid a page cross over
  // The column and the burst_lenght must be in the range
	constraint column_range {
		column inside {[low_column:hi_column]};
	}
	constraint burst_lenght_range {
		bl inside {[low_burst_length:hi_burst_length]};
	}

	function new();
		this.low_column = 12'h004;
		this.hi_column = 12'h0F0;
		this.low_burst_length = 8'h00;
		this.hi_burst_length = 8'h0F;

	endfunction

	// Task to concatenate the row, bank, column, 2'b00 into the Address
	task random_rowbank();
    begin
			Address	= {row,bank,column[7:0],2'b00};
		end
	endtask

endclass:stimuli_1
