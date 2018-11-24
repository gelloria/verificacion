// stimuli to write in a random row and bank
class stimuli1_randaddr;
	// Address Decodeing:
	//  with cfg_col bit configured as: 00
	//    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
	logic  [31:0] 	Address		; 

	rand logic  [11:0]  row		; // Random row
	rand logic  [1:0]	bank		; // Random bank 
	rand logic	[11:0]	column	; // Random column
	rand logic  [7:0]  	bl		; // Random burst_lenght_width 
	
	logic [11:0] lo_column, hi_column; // Nonrandom variables used as limits
	logic [7:0] lo_bl, hi_bl; // Nonrandom variables used as limits
	
	//logic [1:0] cfgcolumn;
	// constraints to avoid a page cross over
	constraint column_range {
		column inside {[lo_column:hi_column]};
	}// lo <= column <= hi	
	constraint bl_range {
		bl inside {[lo_bl:hi_bl]};  
	}// lo <= bl <= hi

	function new();
		this.lo_column 	= 12'h004		; //min column value 
		this.hi_column	= 12'h0F0		; //max column value to avoid the page cross over (worst case)
		this.lo_bl 	= 8'h00		; //min burst lenght width
		this.hi_bl	= 8'h0F		; //max burst lenght to avoid the page cross over (worst case)
	
	endfunction
	
	//task to concatenate the row, bank, column, 2'b00 into the Address
	task	random_rowbank(logic [1:0] cfgcolumn); 
		begin
			if (cfgcolumn == 00) begin
			`ifdef SDR_32BIT 
				Address	= {row,bank,column[7:0],2'b00};
			`elsif SDR_16BIT
				Address	= {row,bank,column[7:0],1'b0};
			`else
				Address	= {row,bank,column[7:0]};
			`endif
			end // if (cfgcolumn == 00)
			else if (cfgcolumn == 01) begin
			`ifdef SDR_32BIT 
				Address	= {row,bank,column[8:0],2'b00};
			`elsif SDR_16BIT
				Address	= {row,bank,column[8:0],1'b0};
			`else
				Address	= {row,bank,column[8:0]};
			`endif
			end // if (cfgcolumn == 01 )
			else if (cfgcolumn == 10) begin
			`ifdef SDR_32BIT 
				Address	= {row,bank,column[9:0],2'b00};
			`elsif SDR_16BIT
				Address	= {row,bank,column[9:0],1'b0};
			`else
				Address	= {row,bank,column[9:0]};
			`endif
			end // if (cfgcolumn == 10 )
			else begin
			`ifdef SDR_32BIT 
				Address	= {row,bank,column[10:0],2'b00};
			`elsif SDR_16BIT
				Address	= {row,bank,column[10:0],1'b0};
			`else
				Address	= {row,bank,column[10:0]};
			`endif
			end // else (cfgcolumn == 11 )
		end
	endtask	

endclass:stimuli1_randaddr

