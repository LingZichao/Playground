`include "common.vh"

module datapath (
	input wire clk,
	input wire rst,

	/* Controller Signal */
	output wire [`WIDTH-1 : 0] ctrl_inst ,

	input wire [`SIGNAL_LEN-1 : 0] ctrl ,

	/* Non cache IO */
	output wire n_req_valid ,
	output wire [`WIDTH-1 : 0] n_req_addr ,
	output wire [`WIDTH-1 : 0] n_req_data ,
	output wire [`WIDTH/8-1: 0] n_req_mask ,

	input wire n_resp_valid ,
	input wire [`WIDTH-1 : 0] n_resp_data ,


	/* I-cache IO */
	output wire i_req_valid ,
	output wire [`WIDTH-1 : 0] i_req_addr ,
	output wire [`WIDTH-1 : 0] i_req_data ,
	output wire [`WIDTH/8-1: 0] i_req_mask ,

	input wire i_resp_valid ,
	input wire [`WIDTH-1 : 0] i_resp_data ,

	/* D-cache IO */
	output wire d_req_valid ,
	output wire [`WIDTH-1 : 0] d_req_addr ,
	output wire [`WIDTH-1 : 0] d_req_data ,
	output wire [`WIDTH/8-1: 0] d_req_mask ,

	input wire d_resp_valid ,
	input wire [`WIDTH-1 : 0] d_resp_data
);
	/* =========== Pipeline spliting register =========== */
	/* fetch | decode | execute | mem_access | write_back */

	reg [`WIDTH-1 : 0] fd_inst , fd_pc;

	/* -------------------------------------------------- */
	reg [`WIDTH-1 : 0] de_inst , de_pc , de_rs1 , de_rs2 , de_imm ;
	reg [`SIGNAL_LEN-1 : 0] de_ctrl;
	reg [ `REG_WIDTH-1 : 0] de_rd_addr;

	/* -------------------------------------------------- */
	reg [`WIDTH-1 : 0] ea_inst , ea_pc , ea_alu , ea_rs2;
	reg [`SIGNAL_LEN-1 : 0] ea_ctrl;
	reg [ `REG_WIDTH-1 : 0] ea_rd_addr;

	reg ea_of , ea_br_taken;

	/* -------------------------------------------------- */
	reg [`WIDTH-1 : 0] aw_inst , aw_pc , aw_mem , aw_alu;
	reg [`SIGNAL_LEN-1 : 0] aw_ctrl;
	reg [ `REG_WIDTH-1 : 0] aw_rd_addr;

	/* -------------------------------------------------- */
	reg [`WIDTH-1 : 0] wb_data;
	reg [`REG_WIDTH-1 : 0] wb_rd_addr;
	reg wb_en;
	/* ================================================== */


	/* Pipeline Pause & Bubble signal */
	wire stall = !(i_resp_valid && d_resp_valid);
	wire bubble = ((|ea_ctrl[`BR_TYPE]) && ea_br_taken);

	/* PC & NEXT_PC */
	reg  [`WIDTH-1 : 0] pc ;
	wire [`WIDTH-1 : 0] next_pc;

	assign next_pc = (stall) ? pc : 
					(ea_ctrl[`PC_SEL] == `PC_0) ? pc : 
					(de_ctrl[`PC_SEL] == `PC_ALU) ? alu_out :
					pc + `WIDTH'd4; //WARNING

	always @(posedge clk , posedge rst) begin
		if ( rst ) 
			pc <= `PC_START - `WIDTH'd4;
		else 
			pc <= next_pc;
	end
	
	//WARNING!
	wire [`WIDTH-1 : 0] inst = (rst || de_ctrl[`INST_KILL]) ? 
							`WIDTH'b0 : i_resp_data;

	assign i_req_valid = !stall;
	assign i_req_addr = next_pc;
	assign i_req_data = 0;
	assign i_req_mask = 0;

	/* ============== Pipeline {Fetch - Decode} ============== */
	always @(posedge clk) begin
		if ( rst ) begin
		  fd_inst <= 0;

		end else if (!stall) begin
			fd_pc <= pc;
			fd_inst <= inst;
		end
	end
	/* ======================================================== */


	/* Controller */
	assign ctrl_inst = fd_inst;

	/* Regfile */
	wire [`REG_WIDTH-1 : 0] rs1_addr , rs2_addr , rd_addr;
	wire [`WIDTH-1 : 0] rs1_data , rs2_data , immgen_out;

	assign rs1_addr = fd_inst[25 : 21];
	assign rs2_addr = fd_inst[20 : 16];

	assign  rd_addr = (ctrl[ `WB_SEL] == `WB_PC8) ? `REG_WIDTH'h1f :
					  (ctrl[`IMM_SEL] == `IMM_X || ctrl[`IMM_SEL] == `IMM_S) ?
					   fd_inst[15 : 11] : fd_inst[20 : 16];

	/* Data Hazard Judger */
	wire rs1_wb_hazard = wb_en && (|rs1_addr) && (aw_rd_addr == rs1_addr) && (aw_ctrl[`WB_SEL] == `WB_ALU);
	wire rs2_wb_hazard = wb_en && (|rs2_addr) && (aw_rd_addr == rs2_addr) && (aw_ctrl[`WB_SEL] == `WB_ALU);

	wire rs1_ma_hazard = ea_ctrl[`WB_EN] && (|rs1_addr) && (ea_rd_addr == rs1_addr) && (ea_ctrl[`WB_SEL] == `WB_ALU);
	wire rs2_ma_hazard = ea_ctrl[`WB_EN] && (|rs2_addr) && (ea_rd_addr == rs2_addr) && (ea_ctrl[`WB_SEL] == `WB_ALU);

	wire rs1_ex_hazard = de_ctrl[`WB_EN] && (|rs1_addr) && (de_rd_addr == rs1_addr) && (de_ctrl[`WB_SEL] == `WB_ALU);
	wire rs2_ex_hazard = de_ctrl[`WB_EN] && (|rs2_addr) && (de_rd_addr == rs2_addr) && (de_ctrl[`WB_SEL] == `WB_ALU);

	regFile rf(
		.clk(clk),

		.raddr1(rs1_addr) , 
		.raddr2(rs2_addr) , 
		.rdata1(rs1_data) , 
		.rdata2(rs2_data) ,
		
		.wen  (wb_en) ,
		.waddr(aw_rd_addr) ,
		.wdata(wb_data)
	);

	/*Immediate Generator*/
	immGen ig(
		.inst(fd_inst) , 
		.pc	 (fd_pc) , 
		.imm_type(ctrl[`IMM_SEL]) ,
		.out(immgen_out)
	);


	/* ============== Pipeline {Decode - Execute} ============== */
	always @(posedge clk , posedge rst) begin
		if ( rst || (!stall && bubble) ) begin
			de_ctrl <= 0;
			de_inst <= 0;

		end else if ( !stall ) begin
			de_pc 	<= fd_pc;
			de_inst <= fd_inst;
			de_ctrl <= ctrl;

			de_imm <= immgen_out;
			de_rd_addr <= rd_addr;

			de_rs1 <= (rs1_ex_hazard) ? alu_out :
					  (rs1_ma_hazard) ? ea_alu  :
					  (rs1_wb_hazard) ? wb_data :
					  rs1_data;

			de_rs2 <= (rs2_ex_hazard) ? alu_out : 
					  (rs2_ma_hazard) ? ea_alu  :
					  (rs2_ex_hazard) ? wb_data :
					  rs2_data;
		end
	end
	/* ======================================================== */

	/* Alu */
	wire [`WIDTH-1 : 0] alu_A , alu_B ;
	wire [`WIDTH-1 : 0] alu_out;
	wire alu_of;

	assign alu_A = (de_ctrl[`A_SEL] == `A_RS1) ? de_rs1 :
				   (de_ctrl[`A_SEL] == `A_RS2) ? de_rs2 :
				   (de_ctrl[`A_SEL] == `A_PC ) ? de_pc  :
				   0;
	

	assign alu_B = (de_ctrl[`B_SEL] == `B_RS1) ? de_rs1 :
				   (de_ctrl[`B_SEL] == `B_RS2) ? de_rs2 :
				   (de_ctrl[`B_SEL] == `B_IMM) ? de_imm :
				   0;
	
	alu alu(
		.A(alu_A) ,
		.B(alu_B) ,
		.alu_op(de_ctrl[`ALU_OP]) ,
		.out(alu_out) ,
		.overflow(alu_of)
	);

	/* Branch Judger */
	wire br_taken ;

	brCond br(
		.rs1(de_rs1),
		.rs2(de_rs2), 
		.br_type(de_ctrl[`BR_TYPE]), 
		.taken(br_taken)
	);

	/* ============ Pipeline {Execute - Mem_Access} ============ */
	always @(posedge clk , posedge rst) begin
		if ( rst ) begin
			ea_ctrl <= 0; //NULL
			ea_br_taken <= `N;

		end else if ( !stall ) begin
			ea_pc 	<= de_pc;
			ea_inst <= de_inst;
			ea_ctrl <= de_ctrl;
			
			ea_rs2  <= de_rs2;
			ea_alu 	<= alu_out;
			ea_of 	<= alu_of;
			ea_br_taken <= (de_ctrl[`PC_SEL] == `PC_ALU || br_taken);
			ea_rd_addr  <= de_rd_addr;
		end
	end
	/* ======================================================== */

	assign d_req_valid = !stall && ( |ea_ctrl[`ST_TYPE] || |ea_ctrl[`LD_TYPE]);
	assign d_req_addr = ea_alu;
	assign d_req_data = ea_rs2;
	assign d_req_mask = (ea_ctrl[`ST_TYPE] == `ST_SW) ? 4'b1111 : // W 32bits
						(ea_ctrl[`ST_TYPE] == `ST_SH) ? 4'b0011 : // W 16bits
						(ea_ctrl[`ST_TYPE] == `ST_SB) ? 4'b0001 : // W  8bits
						4'b0000; // R


	wire [`WIDTH-1 : 0] lshift = d_resp_data;
	wire [`WIDTH-1 : 0] load;

	assign load = (ea_ctrl[`LD_TYPE] == `LD_LH) ? { {16{lshift[15]}} , lshift } : //signext
				  (ea_ctrl[`LD_TYPE] == `LD_LB) ? { {24{lshift[ 7]}} , lshift } : //signext
				  (ea_ctrl[`LD_TYPE] == `LD_LHU)? { 16'b0 , lshift} : //zeroext
				  (ea_ctrl[`LD_TYPE] == `LD_LBU)? { 24'b0 , lshift} : //zeroext
				  lshift;

	/* =========== Pipeline {Mem_Access - Write_Back} =========== */
	always @(posedge clk , posedge rst) begin
		if ( rst ) begin
			aw_ctrl <= 0; //NULL

		end else if ( !stall ) begin
			aw_pc 	<= ea_pc;
			aw_inst <= ea_inst;
			aw_ctrl <= ea_ctrl;

			aw_alu  <= ea_alu;
			aw_mem  <= load;
			aw_rd_addr <= ea_rd_addr;
		end
	end
	/* ======================================================== */

	/* Write Back */
	always @(*) begin
		wb_en <= aw_ctrl[`WB_EN];

		case (aw_ctrl[`WB_SEL])
			`WB_MEM : wb_data <= aw_mem;
			`WB_PC8 : wb_data <= aw_pc + `WIDTH'd8;
			default : wb_data <= aw_alu;
		endcase
	end

	/* DEBUG */
	always @(posedge clk ) begin
		if (wb_en && !stall && |aw_rd_addr) begin
			$display("PC : %h | WB : %h => %h", aw_pc , aw_rd_addr ,wb_data);
		end
	end
endmodule