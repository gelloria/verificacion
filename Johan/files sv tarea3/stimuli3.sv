// stimuli to write in a specific row and bank
class stimuli3_specaddr;
	// Address Decodeing:
	//  with cfg_col bit configured as: 00
	//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic  [31:0] 	Address		; 

	rand logic	[7:0]	column	; // Random column
	rand logic  [7:0]  	bl		; // Random burst_lenght_width 
	
	logic [7:0] lo_column, hi_column; // Nonrandom variables used as limits
	logic [7:0] lo_bl, hi_bl; // Nonrandom variables used as limits
	
	// constraints to avoid a page cross over
	constraint column_range {
		column inside {[lo_column:hi_column]}; 
	}// lo <= column <= hi	
	constraint bl_range {
		bl inside {[lo_bl:hi_bl]}; 
	}// lo <= bl <= hi
	
	function new();
		this.lo_column 	= 8'h04		; //min column value 
		this.hi_column	= 8'hF0		; //max column value to avoid the page cross over (worst case)
		this.lo_bl 	= 8'h00		; //min burst lenght width
		this.hi_bl	= 8'h0F		; //max burst lenght to avoid the page cross over (worst case)
	endfunction

	//task has as inputa specific row and bank to generate the Address
	extern task rowbank_spec(logic  [11:0]  row, // specific row
				logic  [1:0]   bank // specific bank 
				);
	
endclass:stimuli3_specaddr

//---------------------------------
// Tasks Definition
//--------------------------------
/* burst write */

task stimuli3_specaddr::rowbank_spec(	logic  [11:0]  row, // specific row
					logic  [1:0]   bank // specific bank 
				);
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
