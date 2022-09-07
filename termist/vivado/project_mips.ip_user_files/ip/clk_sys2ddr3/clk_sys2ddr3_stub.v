// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Sep  7 01:07:26 2022
// Host        : AndrewLing running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/lingz/Desktop/Verilog/termist/vivado/project_mips.srcs/sources_1/ip/clk_sys2ddr3/clk_sys2ddr3_stub.v
// Design      : clk_sys2ddr3
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_sys2ddr3(clk_ddr3, clk_sys)
/* synthesis syn_black_box black_box_pad_pin="clk_ddr3,clk_sys" */;
  output clk_ddr3;
  input clk_sys;
endmodule
