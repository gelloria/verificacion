// Stimuli designed to write in a specific row and bank
class stimuli_3;
  //  With cfg_col bit configured as: 00
	//  <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic [31:0] address;

  // Variables to randomize
	rand logic [7:0] column;
	rand logic [7:0] burst_length;

  // Variables used as limits to avoid a page cross over
	logic [7:0] low_column, hi_column;
	logic [7:0] low_burst_length, hi_burst_length;

  // Restrictions to avoid a page cross over
  // The column and the burst_lenght must be in the range
	constraint column_range {
		column inside {[low_column:hi_column]};
	}
	constraint burst_lenght_range {
		burst_length inside {[low_burst_length:hi_burst_length]};
	}

  function new();
		this.low_column = 8'h04;
		this.hi_column = 8'h0F0;
		this.low_burst_length = 8'h00;
		this.hi_burst_length = 8'h0F;
	endfunction

	// The row and bank are passed as parameters
	extern task row_bank_set(logic [11:0] row, logic [1:0] bank);

endclass:stimuli_3

task stimuli_3::row_bank_set(logic [11:0] row, logic [1:0] bank);
	begin
	   address = {row,bank,column,2'b00};
	end
endtask
