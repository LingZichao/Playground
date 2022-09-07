`include "common.vh"

module alu (
	input wire [`WIDTH-1 : 0] A ,
	input wire [`WIDTH-1 : 0] B ,

	input wire [`ALU_OP_LEN-1 : 0] alu_op ,
	output reg [`WIDTH-1 : 0] out ,
	output reg overflow
);
	wire [4 : 0] shamt = B[4 : 0];
	reg [`WIDTH-1 : 0] sum ;
	reg cmp;

	always @(*) begin
		sum <= alu_op[0] ? (A - B) : (A + B);
		cmp <= A[`WIDTH-1] == B[`WIDTH-1] ? sum[`WIDTH-1] :
				alu_op[1] ? B[`WIDTH-1] : A[`WIDTH-1];
	end

	always @(*) begin
		case (alu_op)
			`ALU_ADD : out <= sum;
			`ALU_SUB : out <= sum;
      		`ALU_SRA : out <= $signed(A) >>> shamt; 
			// WARNING : SignInt , Is this Synthesizable ?
      		`ALU_SRL : out <= A >> shamt;
      		`ALU_SLL : out <= A << shamt;
      		`ALU_SLT : out <= cmp; // SignInt
     		`ALU_SLTU: out <= cmp;
     	 	`ALU_AND : out <= A & B;
     	 	`ALU_OR  : out <= A | B;
      		`ALU_XOR : out <= A ^ B;
      		`ALU_COPY_A :out <= A;
			`ALU_COPY_B :out <= B;
      		`ALU_NOR : out <= ~(A | B);
			default : out <= `WIDTH'b0;
		endcase
	end

	always @(*) begin
		overflow <= (A[`WIDTH-1] == B[`WIDTH-1] && A[`WIDTH-1] ^ sum[`WIDTH-1]);
	end

endmodule