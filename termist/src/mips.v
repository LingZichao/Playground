`include "common.vh"

module mips (
	input wire clk , rst ,
		// AXI write address channel signals
	input wire axi_awready, // Indicates slave is ready to accept a 
													// write address
	output wire [`AXI_ID_WIDTH-1:0]     axi_awid,    // Write ID
	output wire [`AXI_ADDR_WIDTH-1:0]   axi_awaddr,  // Write address
	output wire [7:0]                   axi_awlen,   // Write Burst Length
	output wire [2:0]                   axi_awsize,  // Write Burst size
	output wire							axi_awvalid, // Write address valid

	// AXI write data channel signals

	input wire                          axi_wready,		// Write data ready
	output wire [`AXI_DATA_WIDTH-1:0]   axi_wdata,		// Write data
	output wire [`AXI_DATA_WIDTH/8-1:0] axi_wstrb,		// Write strobes
	output wire                         axi_wlast,		// Last write transaction   
	output wire                         axi_wvalid,		// Write valid

	// AXI write response channel signals
	input wire [`AXI_ID_WIDTH-1:0]      axi_bid,		// Response ID
	input wire [1:0]                    axi_bresp,		// Write response
	input wire                          axi_bvalid,		// Write reponse valid
	output wire                       	axi_bready,		// Response ready

	// AXI read address channel signals
	input wire                          axi_arready,	// Read address ready
	output wire [`AXI_ID_WIDTH-1:0]     axi_arid,		// Read ID
	output wire [`AXI_ADDR_WIDTH-1:0]   axi_araddr,		// Read address
	output wire [7:0]                   axi_arlen,		// Read Burst Length
	output wire [2:0]                   axi_arsize,		// Read Burst size      // Read Protection type
	output wire                         axi_arvalid,	// Read address valid

	// AXI read data channel signals   
	input wire [`AXI_ID_WIDTH-1:0]      axi_rid,     // Response ID
	input wire [1:0]                    axi_rresp,   // Read response
	input wire                          axi_rvalid,  // Read reponse valid
	input wire [`AXI_DATA_WIDTH-1:0]    axi_rdata,   // Read data
	input wire                          axi_rlast,   // Read last
	output wire                       	axi_rready  // Read Response ready

);
	/* Contrllor signal */ 
	wire [`WIDTH-1 : 0] ctrl_inst;
	wire [`SIGNAL_LEN-1 : 0] ctrl_sig ;

	control ctrl(
		.inst	 (ctrl_inst),

		.controlSignal (ctrl_sig)
	);
	
	/* --------- Non cache IO --------- */
	wire n_req_valid ;
	wire [`WIDTH-1 : 0] n_req_addr ;
	wire [`WIDTH-1 : 0] n_req_data ;
	wire [`WIDTH/8-1: 0] n_req_mask ;

	wire n_resp_valid ;
	wire [`WIDTH-1 : 0] n_resp_data ;

	wire n_m_req_valid ;
	wire [`WIDTH-1 : 0] n_m_req_addr ;
	wire [`WIDTH-1 : 0] n_m_req_data ;
	wire [`WIDTH/8-1: 0] n_m_req_mask ;

	wire n_m_resp_valid ;
	wire [`WIDTH-1 : 0] n_m_resp_data ;

	/* ------------ I$ IO ------------ */
	wire i_req_valid ;
	wire [`WIDTH-1 : 0] i_req_addr ;
	wire [`WIDTH-1 : 0] i_req_data ;
	wire [`WIDTH/8-1: 0] i_req_mask ;

	wire i_resp_valid ;
	wire [`WIDTH-1 : 0] i_resp_data ;

	wire i_m_req_valid ;
	wire [`WIDTH-1 : 0] i_m_req_addr ;
	wire [`WIDTH-1 : 0] i_m_req_data ;
	wire [`WIDTH/8-1: 0] i_m_req_mask ;

	wire i_m_resp_valid ;
	wire [`WIDTH-1 : 0] i_m_resp_data ;

	/* ------------ D$ IO ------------ */
	wire d_req_valid ;
	wire [`WIDTH-1 : 0] d_req_addr ;
	wire [`WIDTH-1 : 0] d_req_data ;
	wire [`WIDTH/8-1: 0] d_req_mask ;

	wire d_resp_valid ;
	wire [`WIDTH-1 : 0] d_resp_data;

	wire d_m_req_valid ;
	wire [`WIDTH-1 : 0] d_m_req_addr ;
	wire [`WIDTH-1 : 0] d_m_req_data ;
	wire [`WIDTH/8-1: 0] d_m_req_mask ;

	wire d_m_resp_valid ;
	wire [`WIDTH-1 : 0] d_m_resp_data;

/* --------------- Used for Testing ------------- */

	mem_t icache (
		.clk(clk) ,
		.rst(rst) ,

		.req_valid	(i_req_valid) ,
		.req_addr	(i_req_addr ) ,
		.req_data	(i_req_data ) ,
		.req_mask	(i_req_mask ) ,

		.resp_valid	(i_resp_valid) ,
		.resp_data	(i_resp_data )
	);

/* ---------------------------------------------- */
	// cache icache (
	// 	.clk(clk) ,
	// 	.rst(rst) ,

	// 	.req_valid	(i_req_valid) ,
	// 	.req_addr	(i_req_addr ) ,
	// 	.req_data	(i_req_data ) ,
	// 	.req_mask	(i_req_mask ) ,

	// 	.resp_valid	(i_resp_valid) ,
	// 	.resp_data	(i_resp_data ) ,

	// 	.m_req_valid(i_m_req_valid) ,
	// 	.m_req_addr	(i_m_req_addr ) ,
	// 	.m_req_data	(i_m_req_data ) ,
	// 	.m_req_mask	(i_m_req_mask ) , 
	
	// 	.m_resp_valid(i_m_resp_valid) ,
	// 	.m_resp_data (i_m_resp_data ) 
	// );

	cache dcache (
		.clk(clk) ,
		.rst(rst) ,

		.req_valid(d_req_valid) ,
		.req_addr (d_req_addr ) ,
		.req_data (d_req_data ) ,
		.req_mask (d_req_mask ) ,

		.resp_valid(d_resp_valid) ,
		.resp_data (d_resp_data ) ,
		
		.m_req_valid(d_m_req_valid) ,
		.m_req_addr	(d_m_req_addr ) ,
		.m_req_data	(d_m_req_data ) ,
		.m_req_mask	(d_m_req_mask ) , 
	
		.m_resp_valid(d_m_resp_valid) ,
		.m_resp_data (d_m_resp_data ) 
	);

	/* Datapath of 5-staged MIPS */
	datapath dp(
		.clk(clk),
		.rst(rst),
		/* Controller IO */
		.ctrl_inst(ctrl_inst) ,
		.ctrl(ctrl_sig) ,

		/* Non cache IO*/
		.n_req_valid(n_m_req_valid),
		.n_req_addr (n_m_req_addr ),
		.n_req_data (n_m_req_data ),
		.n_req_mask (n_m_req_mask ),

		.n_resp_valid(n_m_resp_valid),
		.n_resp_data (n_m_resp_data ),

		/* I-cache IO*/
		.i_req_valid(i_req_valid),
		.i_req_addr (i_req_addr ),
		.i_req_data (i_req_data ),
		.i_req_mask (i_req_mask ),

		.i_resp_valid(i_resp_valid),
		.i_resp_data (i_resp_data),

		/* D-cache IO */
		.d_req_valid(d_req_valid),
		.d_req_addr (d_req_addr ),
		.d_req_data (d_req_data ),
		.d_req_mask (d_req_mask ),

		.d_resp_valid(d_resp_valid),
		.d_resp_data (d_resp_data)
	);

	axi_drive axi_drive_inst(
		//DDR3 Interfaces
		.clk(clk),
		.rst(rst),

		// AXI write address channel signals
		.axi_awready	(axi_awready),	// Indicates slave is ready to accept a write address
		.axi_awid		(axi_awid	),	// Write ID
		.axi_awaddr		(axi_awaddr	),	// Write address
		.axi_awlen		(axi_awlen	),	// Write Burst Length
		.axi_awsize		(axi_awsize	),	// Write Burst size
		.axi_awvalid	(axi_awvalid),	// Write address valid

		// AXI write data channel signals
		.axi_wready		(axi_wready	),	// Write data ready
		.axi_wdata		(axi_wdata	),	// Write data
		.axi_wstrb		(axi_wstrb	),	// Write strobes
		.axi_wlast		(axi_wlast	),	// Last write transaction   
		.axi_wvalid		(axi_wvalid	),	// Write valid

		// AXI write response channel signals
		.axi_bid		(axi_bid	),	// Response ID
		.axi_bresp		(axi_bresp	),	// Write response
		.axi_bvalid		(axi_bvalid	),	// Write reponse valid
		.axi_bready		(axi_bready	),	// Response ready

		// AXI read address channel signals
		.axi_arready	(axi_arready),	// Read address ready
		.axi_arid		(axi_arid	),	// Read ID
		.axi_araddr		(axi_araddr	),	// Read address
		.axi_arlen		(axi_arlen	),	// Read Burst Length
		.axi_arsize		(axi_arsize	),	// Read Burst size
		.axi_arvalid	(axi_arvalid),	// Read address valid

		// AXI read data channel signals   
		.axi_rid		(axi_rid	),	// Response ID
		.axi_rresp		(axi_rresp	),	// Read response
		.axi_rvalid		(axi_rvalid	),	// Read reponse valid
		.axi_rdata		(axi_rdata	),	// Read data
		.axi_rlast		(axi_rlast	),	// Read last
		.axi_rready		(axi_rready	),	// Read Response ready

		/* Non Cache MEM IO */
		.n_req_valid	(n_m_req_valid),
		.n_req_addr		(n_m_req_addr ),
		.n_req_data		(n_m_req_data ),
		.n_req_mask		(n_m_req_mask ), 

		.n_resp_valid	(n_m_resp_valid),
		.n_resp_data	(n_m_resp_data ),

		/* I-Cache MEM IO */
		.i_req_valid	(i_m_req_valid	),
		.i_req_addr		(i_m_req_addr	),
		.i_req_data		(i_m_req_data	),
		.i_req_mask		(i_m_req_mask	), 

		.i_resp_valid	(i_m_resp_valid	),
		.i_resp_data	(i_m_resp_data	),

		/* D-Cache MEM IO */
		.d_req_valid	(d_m_req_valid	),
		.d_req_addr		(d_m_req_addr	),
		.d_req_data		(d_m_req_data	),
		.d_req_mask		(d_m_req_mask	), 

		.d_resp_valid	(d_m_resp_valid	),
		.d_resp_data	(d_m_resp_data	)
	);

endmodule