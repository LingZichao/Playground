-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Wed Sep  7 01:07:26 2022
-- Host        : AndrewLing running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/lingz/Desktop/Verilog/termist/vivado/project_mips.srcs/sources_1/ip/clk_sys2ddr3/clk_sys2ddr3_stub.vhdl
-- Design      : clk_sys2ddr3
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_sys2ddr3 is
  Port ( 
    clk_ddr3 : out STD_LOGIC;
    clk_sys : in STD_LOGIC
  );

end clk_sys2ddr3;

architecture stub of clk_sys2ddr3 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_ddr3,clk_sys";
begin
end;