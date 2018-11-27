// Stimuli designed to write in a page cross over
class stimuli_2;

  //  With cfg_col bit configured as: 00
	//  <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic [31:0] address;

  // Variables to randomize
  rand logic [11:0] row;
	rand logic [1:0]	bank;
	rand logic [7:0] column;
	rand logic [7:0]  burst_length;

	logic [7:0] low_column, hi_column;
	logic [7:0] low_burst_length, hi_burst_length;

	// Constraints to generate a page cross over
	constraint column_range {
		column inside {[low_column:hi_column]};
	}
	constraint burst_lenght_range {
		bl inside {[low_burst_length:hi_burst_length]};
	}

	function new();
    // Min value to guarantee the page cross over
		this.low_column = 8'hF4;
    // Max value to guarantee the page cross over
		this.hi_column = 8'hFF;
    // Min burst_lenght value to guarantee the page cross over
    this.low_burst_length = 8'h0F;
    // Max burst_lenght value to guarantee the page cross over
		this.hi_burst_length = 8'hFF;
	endfunction

  // Task to concatenate the row, bank, column into the address
	task	page_crossover_rowbank();
		begin
				address	= {row,bank,column,2'b00};
		end
	endtask

endclass:stimuli_2
