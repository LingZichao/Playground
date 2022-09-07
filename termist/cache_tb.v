module cache_tb;

reg clk , rst;

initial begin
	clk = 0;
	rst = 1;
end

always #1 clk <= ~clk;

initial begin 
	#4	rst = 0;
	#200 $finish;
end

initial begin
	$dumpfile("wace.vcd");
	$dumpvars(0 , cache_tb);
end


wire req_valid;
reg [31 : 0] req_addr;
reg [31 : 0] req_data;
reg [ 3 : 0] req_mask;

wire resp_valid;
wire [31 : 0] resp_data;


reg [31 : 0] mem [0 : 512];

initial begin
	$readmemh("C:/Users/lingz/Desktop/Verilog/termist/testcase/mem/mem_data.txt" , mem);
end

/* Mem Request */
wire m_req_valid;
wire [31 : 0] m_req_addr;
wire [31 : 0] m_req_data;
wire [ 3 : 0] m_req_mask; 
	
/* Mem Response */
wire m_resp_valid;
reg [ 6 : 0] cur;
wire [31 : 0] m_resp_data;


initial begin
	#4 state = 2'h1;
end

reg [ 1: 0] state;

assign req_valid = state == 2'h1;

always @(*) begin
	if ( state == 2'h1) begin
		req_addr <= 32'h0;
		req_mask <=  4'h0;
	end
end

always @(posedge clk ) begin
	if (rst) begin
		state <= 2'h0;
	end else case (state)
		2'h1 : begin
			if ( resp_valid )state <= 2'h3;
		end

		2'h3 : begin
			if (resp_valid) begin
				state <= 2'h0;
			
			end
		end
	endcase
end


cache test_cache (
	.rst(rst),
	.clk(clk),

	.req_valid	(req_valid),
	.req_addr	(req_addr),
	.req_data	(req_data),
	.req_mask	(req_mask),

	.resp_valid	(resp_valid),
	.resp_data	(resp_data),

	.m_req_valid(m_req_valid) ,
	.m_req_addr	(m_req_addr) ,
	.m_req_data	(m_req_data) ,
	.m_req_mask	(m_req_mask) , 
	
	.m_resp_valid	(m_resp_valid) ,
	.m_resp_data	(m_resp_data) 
);

reg [ 3: 0] m_state;
reg [ 5: 0] off;

always @(*) begin
	if (m_state == 4'h0) begin
	end
end

assign m_resp_valid = (m_state == 4'h0) || (m_state == 4'h3);
assign m_resp_data = mem[off];

always @(posedge clk) begin
	if (rst) m_state <= 4'h0;
	else begin
		case (m_state)
			4'h0 : begin
				if (m_req_valid) m_state <= (|m_req_mask) ? 4'h1 : 4'h2;
			end 
			/* Write */
			4'h1 : begin
				;
			end

			/* Read  */
			4'h2 : begin
				/* some prepare */
				off <= 0;
				m_state <= 4'h3;
			end

			/* Burst Read (512B) */
			4'h3 : begin
				if (off == 15) m_state <= 4'h0;
				else off <= off + 1;

			end
		endcase
	end
end

endmodule