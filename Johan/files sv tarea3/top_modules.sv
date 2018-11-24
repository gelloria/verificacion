`include "interfaces.sv"
`include "clocksblock.sv"

module top_duv(tb_interface tb_infa);
	//--------------------------------------------
	// Connections to DUT
	//--------------------------------------------
	/* sdram */
	`ifdef SDR_32BIT
	   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
	`elsif SDR_16BIT 
	   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
	`else  // 8 BIT SDRAM
	   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
	`endif

	/* system */ 
	`ifdef SDR_32BIT
			  .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
	`elsif SDR_16BIT
			  .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
	`else 
			  .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
	`endif
       //.cfg_colbits        (2'b00              ), // 8 Bit Column Address
        .cfg_colbits        (tb_infa.cfg_colbits), // JRSA: Programmable Column Address -> 2'b00: 8bits / 2'b01: 9bits /2'b00: 10bits /2'b00: 11bits /

	/* Interface to WISH BONE */
			  .wb_rst_i           (!tb_infa.resetn_d			),
			  .wb_clk_i           (tb_infa.sys_clk_d			),

			  .wb_stb_i           (tb_infa.infa_wishbone.wb_stb_i	       ),
			  .wb_ack_o           (tb_infa.infa_wishbone.wb_ack_o           ),
			  .wb_addr_i          (tb_infa.infa_wishbone.wb_addr_i          ),
			  .wb_we_i            (tb_infa.infa_wishbone.wb_we_i            ),
			  .wb_dat_i           (tb_infa.infa_wishbone.wb_dat_i           ),
			  .wb_sel_i           (tb_infa.infa_wishbone.wb_sel_i           ),
			  .wb_dat_o           (tb_infa.infa_wishbone.wb_dat_o           ),
			  .wb_cyc_i           (tb_infa.infa_wishbone.wb_cyc_i           ),
			  .wb_cti_i           (tb_infa.infa_wishbone.wb_cti_i           ), 

	/* Interface to SDRAMs */
			  .sdram_clk          (tb_infa.sdram_clk_d			),
			  .sdram_resetn       (tb_infa.resetn_d    	   		),
			  .sdr_cs_n           (sdr_cs_n		),
			  .sdr_cke            (sdr_cke		),
			  .sdr_ras_n          (sdr_ras_n		),
			  .sdr_cas_n          (sdr_cas_n		),
			  .sdr_we_n           (sdr_we_n		),
			  .sdr_dqm            (tb_infa.infa_sdram.sdr_dqm	        ),
			  .sdr_ba             (tb_infa.infa_sdram.sdr_ba		),
			  .sdr_addr           (tb_infa.infa_sdram.sdr_addr		), 
			  .sdr_dq             (tb_infa.infa_sdram.Dq			),

	/* Parameters */
			  .sdr_init_done      (tb_infa.infa_sdram.sdr_init_done      ),
			  .cfg_req_depth      (2'h3               ),	        //how many req. buffer should hold
			  .cfg_sdr_en         (1'b1               ),
			  .cfg_sdr_mode_reg   (13'h033            ),
			  .cfg_sdr_tras_d     (4'h4               ),
			  .cfg_sdr_trp_d      (4'h2               ),
			  .cfg_sdr_trcd_d     (4'h2               ),
			  .cfg_sdr_cas        (3'h3               ),
			  .cfg_sdr_trcar_d    (4'h7               ),
			  .cfg_sdr_twr_d      (4'h1               ),
			  .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
			  .cfg_sdr_rfmax      (3'h6               )
		);

	`ifdef SDR_32BIT
	mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
			  .Dq                 (tb_infa.infa_sdram.Dq				), 
			  .Addr               (tb_infa.infa_sdram.sdr_addr[10:0]		), 
			  .Ba                 (tb_infa.infa_sdram.sdr_ba        		), 
			  .Clk                (tb_infa.infa_sdram.sdram_clk_ds				), 
			  .Cke                (sdr_cke   			), 
			  .Cs_n               (sdr_cs_n 			), 
			  .Ras_n              (sdr_ras_n			), 
			  .Cas_n              (sdr_cas_n			), 
			  .We_n               (sdr_we_n			), 
			  .Dqm                (tb_infa.infa_sdram.sdr_dqm  		     	)
		);

	`elsif SDR_16BIT

	IS42VM16400K u_sdram16 (
			  .dq                 (tb_infa.infa_sdram.Dq			), 
			  .addr               (tb_infa.infa_sdram.sdr_addr[11:0]	), 
			  .ba                 (tb_infa.infa_sdram.sdr_ba     	        ), 
			  .clk                (tb_infa.infa_sdram.sdram_clk_ds			), 
			  .cke                (sdr_cke		), 
			  .csb                (sdr_cs_n		), 
			  .rasb               (sdr_ras_n		), 
			  .casb               (sdr_cas_n		), 
			  .web                (sdr_we_n		), 
			  .dqm                (tb_infa.infa_sdram.sdr_dqm		)
		);
	`else 

	mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
			  .Dq                 (tb_infa.infa_sdram.Dq                 ), 
			  .Addr               (tb_infa.infa_sdram.sdr_addr[11:0]     ), 
			  .Ba                 (tb_infa.infa_sdram.sdr_ba             ), 
			  .Clk                (tb_infa.infa_sdram.sdram_clk_ds       ), 
			  .Cke                (sdr_cke            ), 
			  .Cs_n               (sdr_cs_n           ), 
			  .Ras_n              (sdr_ras_n          ), 
			  .Cas_n              (sdr_cas_n          ), 
			  .We_n               (sdr_we_n           ), 
			  .Dqm                (tb_infa.infa_sdram.sdr_dqm            )
		);
	`endif

	//--------------------------------------------
	// Connections to block of clocks
	//--------------------------------------------
	clks_block clocks(	tb_infa.resetn_d	,
						tb_infa.sdram_clk_d	,
						tb_infa.sys_clk_d	);
endmodule:top_duv