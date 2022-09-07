/* Global config */

`define WIDTH 32

`define REG_NUM 32
`define REG_WIDTH 5

`define Y 1'b1
`define N 1'b0

`define PC_START `WIDTH'h00000004
//`define PC_START `WIDTH'hbfc00000
`define PC_EVEC  `WIDTH'hbfc00380

/* Next PC */
`define PC_OP_LEN 2

`define PC_4    `PC_OP_LEN'd0 // pc + 1
`define PC_ALU  `PC_OP_LEN'd1 // pc = alu
`define PC_0    `PC_OP_LEN'd2 // pc = pc
`define PC_EPC  `PC_OP_LEN'd3

`define ALU_PORT_LEN 2
/* A_sel */
/* ALU A端口的数据来源 */
`define A_XXX  `ALU_PORT_LEN'd0//没有来源
`define A_PC   `ALU_PORT_LEN'd0//pc
`define A_RS1  `ALU_PORT_LEN'd1//RS1寄存器
`define A_RS2  `ALU_PORT_LEN'd3

/* B_sel */
/* ALU B端口的数据来源 */
`define B_XXX  `ALU_PORT_LEN'd0
`define B_IMM  `ALU_PORT_LEN'd0//立即数
`define B_RS2  `ALU_PORT_LEN'd1//RS2寄存器
`define B_RS1  `ALU_PORT_LEN'd3

`define IMM_OP_LEN 3
`define IMM_X `IMM_OP_LEN'd0 // 不构造立即数
`define IMM_I `IMM_OP_LEN'd1 // 有符号扩展至 32 位的立即数
`define IMM_U `IMM_OP_LEN'd2 // 零扩展至 32 位的立即数
`define IMM_H `IMM_OP_LEN'd3 // 16位高位为该16位立即数 16位低位填零
`define IMM_S `IMM_OP_LEN'd4 // 用于移位指令中的SA立即数
`define IMM_B `IMM_OP_LEN'd5 // 左移 2 位并进行有符号扩展
`define IMM_J `IMM_OP_LEN'd6  

/* Branch Instructions */ 
`define BR_OP_LEN 3

`define BR_XXX `BR_OP_LEN'd0 //不执行跳转
`define BR_LZ  `BR_OP_LEN'd1 //小于0时发生跳转
`define BR_LE  `BR_OP_LEN'd2 //小于等于0时发生跳转
`define BR_EQ  `BR_OP_LEN'd3 //相等发生跳转
`define BR_GZ  `BR_OP_LEN'd4 //大于0时发生跳转
`define BR_GE  `BR_OP_LEN'd5 //大于等于0时发生跳转
`define BR_NE  `BR_OP_LEN'd6 //不相等发生跳转
`define BR_GO  `BR_OP_LEN'd7 //无条件跳转


/* Alu operation code */
`define ALU_OP_LEN 5

`define ALU_ADD 	`ALU_OP_LEN'd0
`define ALU_SUB 	`ALU_OP_LEN'd1
`define ALU_AND 	`ALU_OP_LEN'd2
`define ALU_OR  	`ALU_OP_LEN'd3
`define ALU_XOR 	`ALU_OP_LEN'd4
`define ALU_SLT 	`ALU_OP_LEN'd5
`define ALU_SLL 	`ALU_OP_LEN'd6
`define ALU_SLTU 	`ALU_OP_LEN'd7
`define ALU_SRL  	`ALU_OP_LEN'd8
`define ALU_SRA  	`ALU_OP_LEN'd9
`define ALU_COPY_A 	`ALU_OP_LEN'd10
`define ALU_COPY_B 	`ALU_OP_LEN'd11
`define ALU_NOR    	`ALU_OP_LEN'd12
`define ALU_XXX   	`ALU_OP_LEN'd15

/* Store to Mem */
`define ST_OP_LEN 2

`define ST_XXX `ST_OP_LEN'd0//不执行写入内存
`define ST_SW  `ST_OP_LEN'd1//将32位数值写入内存
`define ST_SH  `ST_OP_LEN'd2//将16位数值写入内存
`define ST_SB  `ST_OP_LEN'd3//将8位数值写入内存

/* Load to Reg */
`define LD_OP_LEN 3

`define LD_XXX `LD_OP_LEN'd0 // 不执行读取内存
`define LD_LW  `LD_OP_LEN'd1 // 读取内存中32位数值保存到rd中
`define LD_LH  `LD_OP_LEN'd2 // 读取内存中16位数值,进行符号扩展到32位,再保存到rd中
`define LD_LB  `LD_OP_LEN'd3 // 读取内存中8位数值,进行符号扩展到32位,再保存到rd中
`define LD_LHU `LD_OP_LEN'd4 // 读取内存中16位数值,进行零扩展到32位,再保存到rd中
`define LD_LBU `LD_OP_LEN'd5 // 读取内存中8位数值,进行零扩展到32位,再保存到rd中

/* Write back to Reg */
// 选择写入对应寄存器的数据来源
`define WB_OP_LEN 2
`define WB_ALU  `WB_OP_LEN'd0 //从ALU进行写回
`define WB_MEM  `WB_OP_LEN'd1
`define WB_PC8  `WB_OP_LEN'd2 //从pc + 8进行写回
`define WB_CSR  `WB_OP_LEN'd3

/* Control Signal Vector */
/* pc_sel | A_sel | B_sel | imm_sel | alu_op | br_type | st_type | ld_type | wb_sel | wb_en | illegal | inst_kill */
/* 26 :25 | 24 :23| 22 :21| 20 : 18 | 17 :13 | 12 : 10 | 9 : 8   | 7 : 5   | 4 : 3  |  2    |  1      |   0     | */
`define SIGNAL_LEN 27

`define  PC_SEL 26 : 25
`define   A_SEL 24 : 23
`define   B_SEL 22 : 21
`define IMM_SEL 20 : 18
`define  ALU_OP 17 : 13
`define BR_TYPE 12 : 10
`define ST_TYPE  9 :  8
`define LD_TYPE  7 :  5
`define  WB_SEL  4 :  3
`define   WB_EN  2
`define ILLEGAL  1
`define INST_KILL 0


//***************************************************************************
// AXI4 Shim parameters
//***************************************************************************
`define AXI_ID_WIDTH 4
		// Width of all master and slave ID signals.
		// # = >= 1.
`define AXI_ADDR_WIDTH 29
		// Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
		// M_AXI_ARADDR for all SI/MI slots.
		// # = 32.
`define AXI_DATA_WIDTH 32
		// Width of WDATA and RDATA on SI slot.
		// Must be <= APP_DATA_WIDTH.
		// # = 32, 64, 128, 256.