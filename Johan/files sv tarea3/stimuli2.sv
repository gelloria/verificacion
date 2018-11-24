// stimuli to write in a page cross over 
class stimuli2_pagecrossover;
	// Address Decodeing:
	//  with cfg_col bit configured as: 00
	//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic  [31:0] 	Address		; 
	rand logic  [11:0]  row		; // Random row
	rand logic  [1:0]	bank	; // Random bank 
	rand logic	[7:0]	column	; // Random column
	rand logic  [7:0]  	bl		; // Random burst_lenght_width 
	
	logic [7:0] lo_column, hi_column; // Nonrandom variables used as limits
	logic [7:0]  lo_bl, hi_bl; // Nonrandom variables used as limits
	
	// constraints to generate a page cross over
	constraint column_range {
		column inside {[lo_column:hi_column]};
	} // lo <= column <= hi	
	constraint bl_range {
		bl inside {[lo_bl:hi_bl]}; 
	}// lo <= bl <= hi
		
	function new();
		this.lo_column 	= 8'hF4		; //min colomn value to guarantee the page cross over (worst case)
		this.hi_column	= 8'hFF		; //max column value to guarantee the page cross over
    this.lo_bl 	= 8'h0F		;//min bl value to guarantee the page cross over (worst case)
		this.hi_bl	= 8'hFF		;//max column value to guarantee the page cross over
	endfunction
	
 //task to concatenate the row, bank, column and 2'b00/1'b0/na into the address
	task	pageco_rowbank(); 
		begin
			`ifdef SDR_32BIT 
				Address	= {row,bank,column,2'b00};
			`elsif SDR_16BIT
				Address	= {row,bank,column,1'b0};
			`else
				Address	= {row,bank,column};
			`endif
		end
	endtask	

endclass:stimuli2_pagecrossover

