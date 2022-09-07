`timescale 1ps/100fs
`define     CLOCK   10000
// 5ns 0.2*10^9
module soc_tb;

  //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter COL_WIDTH             = 10;
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1;
                                     // # of unique CS outputs to memory.
   parameter DM_WIDTH              = 2;
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 16;
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 2;
   parameter DQS_CNT_WIDTH         = 1;
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8;
                                     // # of DQ per DQS
   parameter ECC                   = "OFF";
   parameter RANKS                 = 1;
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1;
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 15;
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 29;
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
reg	sclk;
reg srst;

wire [ROW_WIDTH-1:0] ddr3_addr;
wire [ 2:0] ddr3_ba;
wire ddr3_cas_n;
wire ddr3_ck_n;
wire ddr3_ck_p;
wire ddr3_cke;
wire ddr3_ras_n;
wire ddr3_reset_n;
wire ddr3_we_n;
wire [DQ_WIDTH-1:0] ddr3_dq;
wire [DQS_WIDTH-1:0] ddr3_dqs_n;
wire [DQS_WIDTH-1:0] ddr3_dqs_p;
wire init_calib_complete;
wire [(CS_WIDTH*1)-1:0]  ddr3_cs_n;
wire [DM_WIDTH-1:0] ddr3_dm;
wire [ODT_WIDTH-1:0] ddr3_odt;

wire clk;

initial begin
    sclk            =           1'b0;
    srst            =           1'b1;

    #(4*`CLOCK);
    srst	        =           1'b0;
end
always  #(`CLOCK / 2)  sclk = ~sclk;

soc soc_inst (
    //System Interfaces
    .clk_i_100mhz               (sclk                       ),
    .sys_rst                    (srst                       ),
    //DDR3 Interfaces           
    .ddr3_addr                  (ddr3_addr                  ),
    .ddr3_ba                    (ddr3_ba                    ),
    .ddr3_cas_n                 (ddr3_cas_n                 ),
    .ddr3_ck_n                  (ddr3_ck_n                  ),
    .ddr3_ck_p                  (ddr3_ck_p                  ),
    .ddr3_cke                   (ddr3_cke                   ),
    .ddr3_ras_n                 (ddr3_ras_n                 ),
    .ddr3_reset_n               (ddr3_reset_n               ),
    .ddr3_we_n                  (ddr3_we_n                  ),
    .ddr3_dq                    (ddr3_dq                    ),
    .ddr3_dqs_n                 (ddr3_dqs_n                 ),
    .ddr3_dqs_p                 (ddr3_dqs_p                 ),
    .init_calib_complete        (init_calib_complete        ),
    .ddr3_cs_n                  (ddr3_cs_n                  ),
    .ddr3_dm                    (ddr3_dm                    ),
    .ddr3_odt                   (ddr3_odt                   )
);

genvar i;
generate
for (i = 0; i < 1; i = i + 1) begin: gen_mem
    ddr3_model u_comp_ddr3(
        .rst_n                  (ddr3_reset_n                       ),
        .ck                     (ddr3_ck_p                          ),
        .ck_n                   (ddr3_ck_n                          ),
        .cke                    (ddr3_cke                           ),
        .cs_n                   (ddr3_cs_n                          ),
        .ras_n                  (ddr3_ras_n                         ),
        .cas_n                  (ddr3_cas_n                         ),
        .we_n                   (ddr3_we_n                          ),
        .dm_tdqs                (ddr3_dm[(2*(i+1)-1):(2*i)]         ),
        .ba                     (ddr3_ba                            ),
        .addr                   (ddr3_addr                          ),
        .dq                     (ddr3_dq[16*(i+1)-1:16*(i)]         ),
        .dqs                    (ddr3_dqs_p[(2*(i+1)-1):(2*i)]      ),
        .dqs_n                  (ddr3_dqs_n[(2*(i+1)-1):(2*i)]      ),
        .tdqs_n                 (                                   ),
        .odt                    (ddr3_odt                           )
    );
    end
endgenerate
endmodule
