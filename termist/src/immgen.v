`include "common.vh"

module immGen (
	input wire [`WIDTH-1 : 0] inst ,
	input wire [`WIDTH-1 : 0] pc ,
	input wire [`IMM_OP_LEN-1 : 0] imm_type ,

	output reg [`WIDTH-1 : 0] out
);

	wire [`WIDTH-1 : 0] Iimm = { {16{inst[15]}} , inst[15 : 0] };

	wire [`WIDTH-1 : 0] Uimm = inst[15 : 0];

	wire [`WIDTH-1 : 0] Himm = { inst[15 : 0] , 16'b0 };

	wire [`WIDTH-1 : 0] Bimm = { {14{inst[15]}} , inst[15 : 0] , 2'b0 };

	wire [`WIDTH-1 : 0] Simm = { {27{inst[10]}} , inst[10 : 6] };

	wire [`WIDTH-1 : 0] Jimm = { pc[`WIDTH-1 : `WIDTH-4] , inst[25 : 0] , 2'b0 };

	always @(*) begin
		case(imm_type) 
			`IMM_I : out <= Iimm;
			`IMM_U : out <= Uimm;
			`IMM_H : out <= Himm;
			`IMM_S : out <= Simm;
			`IMM_B : out <= Bimm;
			`IMM_J : out <= Jimm;
			default : out <= `WIDTH'b0;
		endcase
	end
endmodule