`include "common.vh"

`define STATE_WIDTH 4
`define IDLE  	`STATE_WIDTH'd0 // 空闲
`define N_READ  `STATE_WIDTH'd1 // 无Cache读取
`define N_WRITE `STATE_WIDTH'd2 // 无Cache写入
`define I_READ  `STATE_WIDTH'd3 // I$ 读取
`define I_RBRST `STATE_WIDTH'd4 // I$ BURST
`define D_READ 	`STATE_WIDTH'd5 // D$ 写入
`define D_RBRST `STATE_WIDTH'd6 // 
`define D_WRITE `STATE_WIDTH'd7 //
`define D_WBRST `STATE_WIDTH'd8 // 
`define WAIT	`STATE_WIDTH'd9

`define MAX_LEN 16
/* --------------------------- 
	IDLE => READ (ar) => WAIT (r) * 16 => IDLE
	IDLE => WRITE(aw) => WAIT (w -> b) * 16 => IDLE

   --------------------------- */

module axi_drive (
    //DDR3 Interfaces
    input wire clk ,
    input wire rst ,

	// AXI write address channel signals
	input wire axi_awready, // Indicates slave is ready to accept a 
													// write address
	output wire [`AXI_ID_WIDTH-1:0]		axi_awid,    // Write ID
	output reg  [`AXI_ADDR_WIDTH-1:0]	axi_awaddr,  // Write address
	output reg  [ 7 : 0]				axi_awlen,   // Write Burst Length
	output wire [ 2 : 0]				axi_awsize,  // Write Burst size
	output wire							axi_awvalid, // Write address valid

	// AXI write data channel signals

	input wire							axi_wready,		// Write data ready
	output reg [`AXI_DATA_WIDTH-1:0]	axi_wdata,		// Write data
	output reg [`AXI_DATA_WIDTH/8-1:0]	axi_wstrb,		// Write strobes
	output wire							axi_wlast,		// Last write transaction   
	output reg							axi_wvalid,		// Write valid

	// AXI write response channel signals
	input wire [`AXI_ID_WIDTH-1:0]		axi_bid,		// Response ID
	input wire [1:0]					axi_bresp,		// Write response
	input wire							axi_bvalid,		// Write reponse valid
	output wire							axi_bready,		// Response ready

	// AXI read address channel signals
	input wire							axi_arready,	// Read address ready
	output wire [`AXI_ID_WIDTH-1:0]		axi_arid,		// Read ID
	output reg  [`AXI_ADDR_WIDTH-1:0]	axi_araddr,		// Read address
	output reg  [7:0]					axi_arlen,		// Read Burst Length
	output wire [2:0]					axi_arsize,		// Read Burst size      // Read Protection type
	output wire							axi_arvalid,	// Read address valid

	// AXI read data channel signals   
	input wire [`AXI_ID_WIDTH-1:0]		axi_rid,     // Response ID
	input wire [1:0]					axi_rresp,   // Read response
	input wire							axi_rvalid,  // Read reponse valid
	input wire [`AXI_DATA_WIDTH-1:0]	axi_rdata,   // Read data
	input wire							axi_rlast,   // Read last
	output reg							axi_rready,  // Read Response ready

	/* Non Cache Request */
	input wire 						n_req_valid ,
	input wire [`WIDTH-1 : 0] 		n_req_addr  ,
	input wire [`WIDTH-1 : 0] 		n_req_data  ,
	input wire [`WIDTH/8-1 : 0] 	n_req_mask  , 

	/* Non Cache Response */
	output wire						n_resp_valid ,
	output reg [`WIDTH-1 : 0] 		n_resp_data  ,

	/* I-Cache Request */
	input wire 						i_req_valid ,
	input wire [`WIDTH-1 : 0] 		i_req_addr  ,
	input wire [`WIDTH-1 : 0] 		i_req_data  ,
	input wire [`WIDTH/8-1 : 0] 	i_req_mask  , 

	/* I-Cache Response */
	output wire						i_resp_valid ,
	output reg [`WIDTH-1 : 0] 		i_resp_data  ,

	/* D-Cache Request */
	input wire 						d_req_valid ,
	input wire [`WIDTH-1 : 0] 		d_req_addr ,
	input wire [`WIDTH-1 : 0] 		d_req_data ,
	input wire [`WIDTH/8-1 : 0] 	d_req_mask , 

	/* D-Cache Response */
	output wire						d_resp_valid ,
	output reg [`WIDTH-1 : 0] 		d_resp_data
);
	/* =============================================== */
	reg [`STATE_WIDTH-1 : 0] state;

	wire isIdle = (state == `IDLE) ;
	wire isStop = (state == `WAIT) ;
	wire isWrit = (state == `D_WRITE) || (state == `N_WRITE) ;
	wire isWbst = (state == `D_WBRST) ;
	wire isRbst = (state == `I_RBRST) || (state == `D_RBRST) ;
	wire isRead = (state == `I_READ ) || (state == `D_READ ) || (state == `N_READ);

	reg [5 : 0] off;


	/* AXI Write Address Connection */
	wire aw_fire = axi_awready && axi_awvalid;

	assign axi_awvalid 	= isWrit;
	assign axi_awid 	= 4'h1;    		// Write ID
	assign axi_awsize 	= 3'h2;  		// Write Burst size 2^2 = 4Bytes

	always @(*) begin
		axi_awaddr <= (state == `D_WRITE) ? d_req_addr[`AXI_ADDR_WIDTH-1 : 0] : 
					  (state == `N_WRITE) ? n_req_addr[`AXI_ADDR_WIDTH-1 : 0] :
					  0;
		axi_awlen  <= (state == `D_WRITE) ? 8'hf : // Write Burst Length
					  (state == `N_WRITE) ? 8'h0 :
					  0;
	end

	/* AXI Write Data Connection */
	wire w_fire = axi_wready && axi_wvalid;

    assign axi_wlast = (off == `MAX_LEN-1);	// Last write transaction

	always @(*) begin
		axi_wdata <= (state == `N_WRITE) ? n_req_data:
					 d_req_data;

		axi_wstrb <= (state == `N_WRITE) ? n_req_mask:
					 d_req_mask; 	// Write strobes
	end

	always @(posedge clk) begin
		axi_wvalid <= (isWbst && off < `MAX_LEN) || isStop; // Write valid
	end

	/* AXI Write Response Connection */
	wire b_fire = axi_bready && axi_bvalid;

	assign axi_bready = isStop || isWbst;  // Response ready

	/* AXI Read Address Connection */
	wire ar_fire = axi_arready && axi_arvalid;

	assign axi_arvalid 	= isRead; // Read address valid
	assign axi_arid		= 4'h2;   // Read ID
	assign axi_arsize 	= 3'h2;   // Read Burst size

	always @(*) begin
		axi_araddr <= (state == `I_READ) ? i_req_addr[`AXI_DATA_WIDTH-1:0]:
					  (state == `D_READ) ? d_req_addr[`AXI_DATA_WIDTH-1:0]:
					  (state == `N_READ) ? n_req_addr[`AXI_DATA_WIDTH-1:0]:
					  0;
		axi_arlen  <= (state == `N_READ) ? 8'h0 : 8'hf;
	end

	/* AXI Read Data Connetion */
	wire r_fire = axi_rvalid && axi_rready;

	always @(posedge clk) begin
		axi_rready <= isStop || isRbst;
	end

	/* =============================================== */

	assign n_resp_valid = isIdle;
	assign d_resp_valid = isIdle || (state == `D_WBRST && w_fire ) || (state == `D_RBRST && r_fire);
	assign i_resp_valid = isIdle || (state == `I_RBRST && r_fire );

	always @(*) begin
		i_resp_data <= axi_rdata;
		d_resp_data <= axi_rdata;
		n_resp_data <= axi_rdata;
	end

	/* =============================================== */

	always @(posedge clk) begin
		if (rst) begin
			state <= `IDLE;
			off <= 0; // -1

		end else case (state)
			`IDLE :  begin
				if 		(n_req_valid) state <= (|n_req_mask) ? `N_WRITE : `N_READ;
				else if (d_req_valid) state <= (|d_req_mask) ? `D_WRITE : `D_READ;
				else if (i_req_valid) state <= `I_READ;
			end
			/* #1 */
			`N_READ  : if (ar_fire) state <= `WAIT;
			/* #2 */
			`N_WRITE : if (aw_fire)	state <= `WAIT;
			/* #3 */
			`I_READ  : begin
				off <= 0;
				if (ar_fire) state <= `I_RBRST;
			end
			/* #4 */
			`I_RBRST : begin
				if (r_fire && off < `MAX_LEN) off <= off + 1;
				if (axi_rlast && off == `MAX_LEN-1) state <= `IDLE;
			end
			/* #5 */
			`D_READ  : begin
				off <= 0;
				if (ar_fire) state <= `D_RBRST;
			end
			/* #6 */
			`D_RBRST : begin
				if (r_fire && off < `MAX_LEN) off <= off + 1;
				if (axi_rlast && off == `MAX_LEN-1) state <= `IDLE;
			end
			/* #7 */
			`D_WRITE : begin
				off <= 0;
				if (aw_fire) state <= `D_WBRST;
			end
			/* #8 */
			`D_WBRST : begin
				if (w_fire && off < `MAX_LEN) off <= off + 1;
				if (b_fire) state <= `IDLE;
			end
			/* #9 */	
			`WAIT	 : begin
				if (b_fire || r_fire)	state <= `IDLE;
			end
		endcase
	end


endmodule

