`include "common.vh"


module brCond (
	input wire[`WIDTH-1 : 0] rs1 ,
	input wire[`WIDTH-1 : 0] rs2 ,
	input wire[`BR_OP_LEN-1 : 0] br_type ,

	output wire taken
);

	wire eq = rs1 == rs2;
	wire neq = ~eq;

	wire neg = rs1[`WIDTH-1];
	wire ez = ~(| rs1);
	wire lz = (~ez) & neg;
	wire le = (ez | neg);
	wire gz = ~le;
	wire ge = ~lz;

	assign taken = ((br_type === `BR_EQ) && eq) ||
				((br_type === `BR_NE) && neq)||
				((br_type === `BR_LZ) && lz) ||
				((br_type === `BR_GZ) && gz) ||
				((br_type === `BR_GE) && ge) ||
				((br_type === `BR_LE) && le) ;
endmodule