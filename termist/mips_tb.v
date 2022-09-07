`timescale 1ps/1ps

module mips_tb;

reg clk , rst;

initial begin
	clk = 0;
	rst = 1;
end

always @(clk) begin
	//$display("TIME : %g , CLK : %d" , $time , clk );
	#1 clk <= !clk;
end

initial begin 
	#2	rst = 0;
	#200 $finish;
end

initial begin
	$dumpfile("wace.vcd");
	$dumpvars(0 , mips_tb);
end

	mips mips(.clk(clk) , .rst(rst));
endmodule