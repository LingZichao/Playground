`include "common.vh"

`define cSTATE_WIDTH 3

`define cIDLE 	 `cSTATE_WIDTH'h0
`define READ 	 `cSTATE_WIDTH'h1
`define WRITE 	 `cSTATE_WIDTH'h2
`define RF_READY `cSTATE_WIDTH'h3 // Refill preperation
`define RF_DIRTY `cSTATE_WIDTH'h4 // Write dirty line back
`define RF_FLUSH `cSTATE_WIDTH'h5 // Refill cache line 

`define WAY_NUM  4
`define LINE_SIZE 512

`define TAG_WIDTH 13
`define SET_WIDTH 10
`define OFF_WIDTH  9

`define _TAG 	31 : 19
`define _SET 	18 :  9
`define _OFF  	 8 :  0
/*
	We have 2mb(2^21) total byte size per cache
	and 32bits mem address bits ;

	In this example , we construct a 4-ways
	set associative cache , with 512bytes(2^9) per line.

	So finally we get 2^21 / (2^2 * 2^9) = 2^10 sets

	|____Tag____|___Sets___|___offset___|
	|____13b____|___10b____|_____9b_____|
	|__31 : 19__|__18 : 9__|____8 : 0___|
*/

module cache (
	input wire rst , clk ,
	/* Request */
	input wire req_valid ,
	input wire [`WIDTH-1 : 0] req_addr ,
	input wire [`WIDTH-1 : 0] req_data ,
	input wire [`WIDTH/8-1: 0] req_mask , 

	/* Response */
	output wire resp_valid ,
	output reg [`WIDTH-1 : 0] resp_data ,

	/* Mem Request */
	output wire m_req_valid ,
	output reg [`WIDTH-1 : 0] m_req_addr ,
	output reg [`WIDTH-1 : 0] m_req_data ,
	output reg [`WIDTH/8-1: 0] m_req_mask , 
	
	/* Mem Response */
	input wire m_resp_valid ,
	input wire [`WIDTH-1 : 0] m_resp_data 
);
	integer i;
	parameter SET_NUM 	 = (1 << `SET_WIDTH);
	parameter LINE_WIDTH = `LINE_SIZE << 3;
	parameter LINE_NUM 	 = SET_NUM * `WAY_NUM;
	parameter LINE_NUM_B = $clog2(LINE_NUM);
	parameter WAY_NUM_B  = $clog2(`WAY_NUM);
	parameter OFF_MASK 	 = {{`TAG_WIDTH{1'b1}} , {`SET_WIDTH{1'b1}} , {`OFF_WIDTH{1'b0}}};
	parameter OFF_NUM	 = `LINE_SIZE / `WIDTH;
	parameter OFF_NUM_B  = $clog2(OFF_NUM);
	/* State Register */
	reg [`cSTATE_WIDTH-1 : 0] state;		

	/* Cache Controllor */
	reg [LINE_WIDTH-1 : 0] cache_data [0 : LINE_NUM-1];

		/* EXAMPLE 4-ways
			{set a} line 0 _____[ 512B ]_____ setIdx
		 			line 1 _____[ 512B ]_____ setIdx + 1
					line 2 _____[ 512B ]_____ setIdx + 2
					line 3 _____[ 512B ]_____ setIdx + 3

			{set b} line 0 _____[ 512B ]_____ 
		 			line 1 _____[ 512B ]_____ 
					line 2 _____[ 512B ]_____ 
					line 3 _____[ 512B ]_____ 
		
			  ...          .................
		*/
	reg [`TAG_WIDTH-1 : 0] cache_tag [0 : LINE_NUM-1];   
	reg cache_valid [0 : LINE_NUM-1];  
	reg cache_dirty [0 : LINE_NUM-1]; 

	wire [`SET_WIDTH-1 : 0] setIdx  = req_addr[`_SET] << 2;
	wire [LINE_NUM_B-1 : 0] lineIdx = setIdx + hit_target;

	wire offBits = req_addr[`_OFF] << 3;
	/* Response Channel */

	assign resp_valid = (state == `cIDLE);


	/* Radom Cursor */
	reg [WAY_NUM_B-1 : 0] rand;
	always @(posedge clk) begin
		if (rst) rand <= 2'h0;
		else rand <= rand + 2'h1;
	end

	/* ----------------------------------------------------- */
	reg [ WAY_NUM_B-1 : 0] rf_target;
	reg [`OFF_WIDTH-1 : 0] rf_cur;

	assign m_req_valid = ((state == `RF_FLUSH) || (state == `RF_DIRTY)) && m_resp_valid;

	/* ----------------------------------------------------- */

	/* Set Hit Controllor */
	reg hit;
	reg [WAY_NUM_B-1 : 0] hit_target;

	/* ==================================================== */

	always @(posedge clk) begin

		if (state != `cIDLE) begin
			for ( i = 0 ; i < `WAY_NUM ; i = i + 1) begin
				if (cache_valid[setIdx + i] && 
					cache_tag[setIdx + i] == req_addr[`_TAG]) begin
						hit <= `Y;
						hit_target <= i;
					end
			end
		end

		if (rst) begin
			state <= `cIDLE;
			hit <= `N;

			for (i = 0; i < LINE_NUM ; i = i + 1) begin
				cache_tag[i] = `TAG_WIDTH'b0; 
				cache_valid[i] = `N; 
				cache_dirty[i] = `N;
			end

		end case (state)
			`cIDLE : begin
				hit <= `N;
				if (req_valid) state <= (|req_mask) ? `WRITE : `READ;
			end
			/* #1 Handle Read Request */
			`READ : begin
				/* Cache hit */
				if (hit) begin
					resp_data <= cache_data[lineIdx][offBits +: 32];
					state <= `cIDLE;

				/* Cache miss */
				end else begin
					rf_target <= setIdx + rand;
					state <= `RF_READY;
				end
			end
			
			/* #2 Handle Write Request */
			`WRITE : begin
				/* Cache hit */
				if (hit) begin
					cache_dirty[lineIdx] <= `Y;
					case (req_mask)
						4'b1111: cache_data[lineIdx][offBits +: 32] <= req_data[31 : 0];
						4'b0011: cache_data[lineIdx][offBits +: 16] <= req_data[15 : 0]; 
						4'b0001: cache_data[lineIdx][offBits +:  8] <= req_data[ 7 : 0]; 
						default: ;
					endcase
					state <= `cIDLE;

				/* Cache miss */
				end else begin
					rf_target <= setIdx + rand;
					state <= `RF_READY;
				end
			end

			/* #3 Prepare for refilling */
			`RF_READY : begin
				rf_cur <= {`OFF_WIDTH{1'b1}}; // -1;
				m_req_addr <= (req_addr & OFF_MASK);
				if (cache_dirty[rf_target]) begin
					m_req_mask <= {(`WIDTH/8){1'b1}};
					state <= `RF_DIRTY;
				end else begin
					m_req_mask <= 0;
					state <= `RF_FLUSH;
				end
								
			end

			/* #4 Write dirty cache line back to mem */
			`RF_DIRTY : begin
				if (rf_cur == OFF_NUM) begin 
					cache_dirty[rf_target] <= `N; 
					state <= `RF_READY;
				end

				if (m_resp_valid) begin
					m_req_data <= cache_data[rf_target][rf_cur << 5 +: 32];
					rf_cur <= rf_cur + 1;
				end
			end

			/* #5 Refill line from mem */
			`RF_FLUSH : begin
				if (rf_cur == OFF_NUM) begin 
					cache_valid[rf_target] <= `Y;
					state <= (|req_mask) ? `WRITE : `READ;
				end

				if (m_resp_valid) begin
					cache_data[rf_target][rf_cur << 5 +: 32] <= m_resp_data;
					rf_cur <= rf_cur + 1;
				end
			end

		endcase
	end

endmodule