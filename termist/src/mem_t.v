`include "common.vh"

`define IDLE 1'b1
`define BUSY 1'b0

module mem_t (
	input wire rst , clk ,
	/* Request */
	input wire req_valid ,
	input wire [`WIDTH-1 : 0] req_addr ,
	input wire [`WIDTH-1 : 0] req_data ,
	input wire [`WIDTH/8-1: 0] req_mask , 

	/* Response */
	output wire resp_valid ,
	output reg [`WIDTH-1 : 0] resp_data
);
	reg state;
	assign resp_valid = state;
	
	initial state = `IDLE;

	/* Temp Mem */
	reg [`WIDTH-1 : 0] mem [0 : 1024]; //1024b

initial begin
	$readmemh("C:/Users/lingz/Desktop/Verilog/termist/testcase/inst/add.hex" , mem);

	// for (integer i = 0; i < 16 ; i = i + 1)
	// 	$display("MEM : %h" , mem[i]);
end

	always @(posedge clk) begin
		if (rst) begin
			state <= `IDLE;
		end else if (req_valid) begin

			if (state == `IDLE) 
				state <= `BUSY;

		end
	end

	always @(posedge clk) begin
		if (state == `IDLE) begin
			;
		end else if (state == `BUSY) begin
			if ( |req_mask ) // WARNING
					mem[req_addr] <= req_data;

				resp_data <= mem[req_addr >> 2];
				//$display("MEM :%h - %h" ,req_addr, mem[req_addr >> 2]);
			state <= `IDLE;
		end
	end
endmodule