`include "common.vh"

module regFile (
	input wire clk, 

	input wire [`REG_WIDTH-1 : 0] raddr1 ,
	input wire [`REG_WIDTH-1 : 0] raddr2 ,

	output wire [`WIDTH-1 : 0] rdata1 ,
	output wire [`WIDTH-1 : 0] rdata2 ,

	input wire wen ,
	input wire [`REG_WIDTH-1: 0] waddr ,
	input wire [`WIDTH-1 : 0] wdata
);
	reg [`WIDTH-1 : 0] regs [0 : `REG_NUM-1];

	assign rdata1 = (| raddr1) ? regs[raddr1] : `WIDTH'b0;
	assign rdata2 = (| raddr2) ? regs[raddr2] : `WIDTH'b0;

	always @(negedge clk ) begin // or negtive ?
		if (wen && (| waddr)) begin
			regs[waddr] <= wdata;
		end
	end

endmodule