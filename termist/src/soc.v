`include "common.vh"

module soc (
	// Inouts
	inout  [15:0]   ddr3_dq,
	inout  [ 1:0]   ddr3_dqs_n,
	inout  [ 1:0]   ddr3_dqs_p,

	// Outputs
	output [14:0]   ddr3_addr,
	output [ 2:0]   ddr3_ba,
	output          ddr3_ras_n,
	output          ddr3_cas_n,
	output          ddr3_we_n,
	output          ddr3_reset_n,
	output 	  		ddr3_ck_p,
	output 	  		ddr3_ck_n,
	output 	  		ddr3_cke,

	output          ddr3_cs_n,
	output [1:0]    ddr3_dm,
	output          ddr3_odt,

	// Inputs
	// System reset - Default polarity of sys_rst pin is Active Low.
	// System reset polarity will change based on the option 
	// selected in GUI.
	input           sys_rst ,
	// Differential system clocks
	input           clk_i_100mhz,

	output          init_calib_complete
);
wire 							clk_ddr3;
wire                            clk_user;
wire							ui_clk;
	clk_sys2ddr3 clk_gen(
		.clk_sys(clk_i_100mhz),
		.clk_ddr3(clk_ddr3)
	);

	clk_ddr32user clk_bridge (
		.clk_ddr3(ui_clk) ,
		.clk_user(clk_user)
	);
wire                            rst;
wire                            mmcm_locked;

wire                            mem_pattern_init_done;

wire                            cmd_err;
wire                            data_msmatch_err;
wire                            write_err;
wire                            read_err;
wire                            test_cmptd;
wire                            write_cmptd;
wire                            read_cmptd;
wire                            cmptd_one_wr_rd;

// Slave Interface Write Address Ports
wire [`AXI_ID_WIDTH-1:0]       	s_axi_awid;
wire [`AXI_ADDR_WIDTH-1:0]     	s_axi_awaddr;
wire [7:0]                   	s_axi_awlen;
wire [2:0]                      s_axi_awsize;
wire [1:0]                      s_axi_awburst;
wire 		               		s_axi_awlock;
wire [3:0]                      s_axi_awcache;
wire [2:0]                      s_axi_awprot;
wire                            s_axi_awvalid;
wire                            s_axi_awready;
// Slave Interface Write Data Ports
wire [`AXI_DATA_WIDTH-1:0]     	s_axi_wdata;
wire [(`AXI_DATA_WIDTH/8)-1:0] 	s_axi_wstrb;
wire                            s_axi_wlast;
wire                            s_axi_wvalid;
wire                            s_axi_wready;
// Slave Interface Write Response Ports
wire                            s_axi_bready;
wire [`AXI_ID_WIDTH-1:0]       	s_axi_bid;
wire [1:0]                      s_axi_bresp;
wire                            s_axi_bvalid;
// Slave Interface Read Address Ports
wire [`AXI_ID_WIDTH-1:0]      	s_axi_arid;
wire [`AXI_ADDR_WIDTH-1:0]     	s_axi_araddr;
wire [7:0]                      s_axi_arlen;
wire [2:0]                      s_axi_arsize;
wire [1:0]                      s_axi_arburst;
wire [0:0]                      s_axi_arlock;
wire [3:0]                      s_axi_arcache;
wire [2:0]                      s_axi_arprot;
wire                            s_axi_arvalid;
wire                            s_axi_arready;
// Slave Interface Read Data Ports
wire                           s_axi_rready;
wire [`AXI_ID_WIDTH-1:0]       s_axi_rid;
wire [`AXI_DATA_WIDTH-1:0]     s_axi_rdata;
wire [1:0]                     s_axi_rresp;
wire                           s_axi_rlast;
wire                           s_axi_rvalid;

	mig_7series_0 u_mig_7series_0 (
		// Memory interface ports
		.ddr3_addr                      (ddr3_addr       ),
		.ddr3_ba                        (ddr3_ba         ),
		.ddr3_cas_n                     (ddr3_cas_n      ),
		.ddr3_ck_n                      (ddr3_ck_n       ),
		.ddr3_ck_p                      (ddr3_ck_p       ),
		.ddr3_cke                       (ddr3_cke        ),
		.ddr3_ras_n                     (ddr3_ras_n      ),
		.ddr3_we_n                      (ddr3_we_n       ),
		.ddr3_dq                        (ddr3_dq         ),
		.ddr3_dqs_n                     (ddr3_dqs_n      ),
		.ddr3_dqs_p                     (ddr3_dqs_p      ),
		.ddr3_reset_n                   (ddr3_reset_n    ),
		.init_calib_complete            (init_calib_complete),
		
		.ddr3_cs_n                      (ddr3_cs_n),
		.ddr3_dm                        (ddr3_dm  ),
		.ddr3_odt                       (ddr3_odt ),
		// Application interface ports
		.ui_clk                         (ui_clk),
		.ui_clk_sync_rst                (rst),

		.mmcm_locked                    (mmcm_locked),
		.aresetn                        (1'b1     ),
		.app_sr_req                     (1'b0     ),
		.app_ref_req                    (1'b0     ),
		.app_zq_req                     (1'b0     ),
		.app_sr_active                  (         ),
		.app_ref_ack                    (         ),
		.app_zq_ack                     (         ),

		// Slave Interface Write Address Ports
		.s_axi_awid                     (s_axi_awid     ),
		.s_axi_awaddr                   (s_axi_awaddr   ),
		.s_axi_awlen                    (s_axi_awlen	),
		.s_axi_awsize                   (s_axi_awsize   ),
		.s_axi_awburst                  (2'h1		), // BUST INCR
		.s_axi_awlock                   (1'h0		),
		.s_axi_awcache                  (4'h0		),
		.s_axi_awprot                   (3'h0		),
		.s_axi_awqos                    (4'h0		),
		.s_axi_awvalid                  (s_axi_awvalid),
		.s_axi_awready                  (s_axi_awready),
		// Slave Interface Write Data Ports
		.s_axi_wdata                    (s_axi_wdata    ),
		.s_axi_wstrb                    (s_axi_wstrb    ),
		.s_axi_wlast                    (s_axi_wlast    ),
		.s_axi_wvalid                   (s_axi_wvalid   ),
		.s_axi_wready                   (s_axi_wready   ),
		// Slave Interface Write Response Ports
		.s_axi_bid                      (s_axi_bid      ),
		.s_axi_bresp                    (s_axi_bresp    ),
		.s_axi_bvalid                   (s_axi_bvalid   ),
		.s_axi_bready                   (s_axi_bready   ),
		// Slave Interface Read Address Ports
		.s_axi_arid                     (s_axi_arid	),
		.s_axi_araddr                   (s_axi_araddr   ),
		.s_axi_arlen                    (s_axi_arlen	),
		.s_axi_arsize                   (s_axi_arsize   ),
		.s_axi_arburst                  (2'h1		),
		.s_axi_arlock                   (1'h0		),
		.s_axi_arcache                  (4'h0		),
		.s_axi_arprot                   (3'h0		),
		.s_axi_arqos                    (4'h0      	),
		.s_axi_arvalid                  (s_axi_arvalid),
		.s_axi_arready                  (s_axi_arready),
		// Slave Interface Read Data Ports
		.s_axi_rid                      (s_axi_rid      ),
		.s_axi_rdata                    (s_axi_rdata    ),
		.s_axi_rresp                    (s_axi_rresp    ),
		.s_axi_rlast                    (s_axi_rlast    ),
		.s_axi_rvalid                   (s_axi_rvalid   ),
		.s_axi_rready                   (s_axi_rready   ),


		// System Clock Ports
		.sys_clk_i                      (clk_ddr3   	),
		.sys_rst                        (sys_rst        ),
		.device_temp                    (device_temp    )
	);

	wire tile_valid = !rst && init_calib_complete;

	mips mips_tile (
		.clk(clk_user), 
		.rst(tile_valid),

		// AXI write address channel signals
		.axi_awready  (s_axi_awready),
		.axi_awid     (s_axi_awid   ),
		.axi_awaddr   (s_axi_awaddr ),
		.axi_awlen    (s_axi_awlen  ),
		.axi_awsize   (s_axi_awsize ),
		.axi_awvalid  (s_axi_awvalid),

		// AXI write data channel signals
		.axi_wready   (s_axi_wready ),
		.axi_wdata    (s_axi_wdata  ),
		.axi_wstrb    (s_axi_wstrb  ),
		.axi_wlast    (s_axi_wlast  ),
		.axi_wvalid   (s_axi_wvalid ),

		// AXI write response channel signals
		.axi_bid      (s_axi_bid    ),
		.axi_bresp    (s_axi_bresp  ),
		.axi_bvalid   (s_axi_bvalid ),
		.axi_bready   (s_axi_bready ),

		// AXI read address channel signals
		.axi_arready  (s_axi_arready),
		.axi_arid     (s_axi_arid   ),
		.axi_araddr   (s_axi_araddr ),
		.axi_arlen    (s_axi_arlen  ),
		.axi_arsize   (s_axi_arsize ),
		.axi_arvalid  (s_axi_arvalid),

		// AXI read data channel signals
		.axi_rid      (s_axi_rid    ),
		.axi_rresp    (s_axi_rresp  ),
		.axi_rvalid   (s_axi_rvalid ),
		.axi_rdata    (s_axi_rdata  ),
		.axi_rlast    (s_axi_rlast  ),
		.axi_rready   (s_axi_rready )
	);

endmodule