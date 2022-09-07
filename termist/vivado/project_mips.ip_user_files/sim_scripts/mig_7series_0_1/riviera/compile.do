vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_addr_decode.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_read.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_reg.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_reg_bank.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_top.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_ctrl_write.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_ar_channel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_aw_channel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_b_channel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_cmd_arbiter.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_cmd_fsm.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_cmd_translator.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_fifo.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_incr_cmd.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_r_channel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_simple_fifo.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_wrap_cmd.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_wr_cmd_fsm.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_axi_mc_w_channel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_axic_register_slice.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_axi_register_slice.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_axi_upsizer.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_a_upsizer.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_carry_and.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_carry_latch_and.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_carry_latch_or.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_carry_or.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_command_fifo.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_comparator.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_comparator_sel.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_comparator_sel_static.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_r_upsizer.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/axi/mig_7series_v4_0_ddr_w_upsizer.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/clocking/mig_7series_v4_0_clk_ibuf.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/clocking/mig_7series_v4_0_infrastructure.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/clocking/mig_7series_v4_0_iodelay_ctrl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/clocking/mig_7series_v4_0_tempmon.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_arb_mux.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_arb_row_col.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_arb_select.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_cntrl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_common.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_compare.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_mach.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_queue.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_bank_state.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_col_mach.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_mc.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_rank_cntrl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_rank_common.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_rank_mach.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/controller/mig_7series_v4_0_round_robin_arb.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ecc/mig_7series_v4_0_ecc_buf.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ecc/mig_7series_v4_0_ecc_dec_fix.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ecc/mig_7series_v4_0_ecc_gen.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ecc/mig_7series_v4_0_ecc_merge_enc.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ecc/mig_7series_v4_0_fi_xor.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ip_top/mig_7series_v4_0_memc_ui_top_axi.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ip_top/mig_7series_v4_0_mem_intfc.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_byte_group_io.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_byte_lane.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_calib_top.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_if_post_fifo.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_mc_phy.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_mc_phy_wrapper.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_of_pre_fifo.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_4lanes.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_dqs_found_cal.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_dqs_found_cal_hr.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_init.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_cntlr.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_data.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_edge.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_lim.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_mux.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_po_cntlr.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_ocd_samp.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_oclkdelay_cal.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_prbs_rdlvl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_rdlvl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_tempmon.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_top.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_wrcal.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_wrlvl.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_phy_wrlvl_off_delay.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_prbs_gen.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_ddr_skip_calib_tap.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_cc.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_edge_store.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_meta.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_pd.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_tap_base.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/phy/mig_7series_v4_0_poc_top.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ui/mig_7series_v4_0_ui_cmd.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ui/mig_7series_v4_0_ui_rd_data.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ui/mig_7series_v4_0_ui_top.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/ui/mig_7series_v4_0_ui_wr_data.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/mig_7series_0_mig_sim.v" \
"../../../../project_mips.srcs/sources_1/ip/mig_7series_0_1/mig_7series_0/user_design/rtl/mig_7series_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

