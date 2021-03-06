

interface bus_interface #( DATA_WIDTH = 32, APP_AW = 26)(
	input wire sys_clk,sdram_clk
);



//****************************************
// Wish Bone Interface
//****************************************

logic             		wb_stb_i	;
logic  [APP_AW-1:0]             wb_addr_i	;
logic            		wb_we_i		; 
logic  [DATA_WIDTH-1:0]   	wb_dat_i	;
logic  [DATA_WIDTH/8-1:0] 	wb_sel_i	; 
logic             		wb_cyc_i	;
logic   [2:0]     		wb_cti_i	;
logic             		wb_ack_o	;
logic  [DATA_WIDTH-1:0]   	wb_dat_o	;




//****************************************
// SDRAM Interface
//****************************************

logic [1:0]			cfg_sdr_width	;
logic [1:0]			cfg_colbits     ;
logic [1:0]			cfg_req_depth	;
logic				cfg_sdr_en      ;
logic [12:0]			cfg_sdr_mode_reg;
logic [3:0]			cfg_sdr_tras_d	;
logic [3:0]			cfg_sdr_trp_d	;
logic [3:0]			cfg_sdr_trcd_d	;
logic [2:0]			cfg_sdr_cas	;
logic [3:0]			cfg_sdr_trcar_d	;
logic [3:0]			cfg_sdr_twr_d	;
logic [11:0]			cfg_sdr_rfsh	;  
logic [2:0]			cfg_sdr_rfmax	;  

logic				sdr_init_done	;
logic				sdram_resetn	;


//****************************************
// definiciones de modports
//****************************************

// -------------------------------------   
// PUERTOS PARA COMUNICACIONES CON WISHBONE

//FALTA EL ACESSO A ENVIRONMENT


// señales que recibe el modulo wishbone 
modport wishbone_port (
	input wb_stb_i, wb_addr_i, wb_we_i, wb_dat_i, wb_sel_i, wb_cyc_i, wb_cti_i,
		cfg_colbits, cfg_req_depth, cfg_sdr_cas, cfg_sdr_en, cfg_sdr_mode_reg, cfg_sdr_rfmax,
		cfg_sdr_rfsh, cfg_sdr_tras_d, cfg_sdr_trcar_d, cfg_sdr_trcd_d, cfg_sdr_trp_d, cfg_sdr_twr_d,
		cfg_sdr_width, sdram_resetn, sys_clk, sdram_clk,
	output wb_ack_o, wb_dat_o, sdr_init_done
	);	

modport sdram_port(
	output cfg_colbits, cfg_req_depth, cfg_sdr_cas, cfg_sdr_en, cfg_sdr_mode_reg, cfg_sdr_rfmax,
		cfg_sdr_rfsh, cfg_sdr_tras_d, cfg_sdr_trcar_d, cfg_sdr_trcd_d, cfg_sdr_trp_d, cfg_sdr_twr_d,
		cfg_sdr_width, sdram_resetn
	);

endinterface

