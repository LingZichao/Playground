-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../project_mips.srcs/sources_1/ip/clk_ddr32user/clk_ddr32user_clk_wiz.v" \
  "../../../../project_mips.srcs/sources_1/ip/clk_ddr32user/clk_ddr32user.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

