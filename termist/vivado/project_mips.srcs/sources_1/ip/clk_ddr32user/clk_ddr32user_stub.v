// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Sep  7 00:02:24 2022
// Host        : AndrewLing running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/lingz/Desktop/Verilog/termist/vivado/project_mips.srcs/sources_1/ip/clk_ddr32user/clk_ddr32user_stub.v
// Design      : clk_ddr32user
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_ddr32user(clk_user, clk_ddr3)
/* synthesis syn_black_box black_box_pad_pin="clk_user,clk_ddr3" */;
  output clk_user;
  input clk_ddr3;
endmodule
