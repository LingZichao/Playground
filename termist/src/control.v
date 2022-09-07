`include "common.vh"

module control (
	input  wire [`WIDTH-1 : 0] inst ,

	output reg [`SIGNAL_LEN-1 : 0] controlSignal
);
	wire [5 : 0] opcode = inst[31 : 26];
	wire [5 : 0] funt1  = inst[ 5 :  0];
	wire [4 : 0] funt2  = inst[20 : 16];
	wire [4 : 0] funt3  = inst[25 : 21];

	always @(*) begin
		case (opcode)
			6'b000000 : 
			case (funt1)
			6'b100000 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ADD
			6'b100001 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ADDU
			6'b100010 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_SUB ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SUB
			6'b100011 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_SUB ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SUBU
			6'b101010 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_SLT ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLT
			6'b101011 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_SLTU,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLTU
			6'b100100 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_AND ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//AND
			6'b100101 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_OR  ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//OR  
			6'b100110 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_XOR ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//XOR 
			6'b100111 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_RS2 ,`IMM_X ,`ALU_NOR ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//NOR 
			6'b000100 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_RS1 ,`IMM_X ,`ALU_SLL ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLLV
			6'b000000 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_IMM ,`IMM_S ,`ALU_SLL ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLL
			6'b000111 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_RS1 ,`IMM_X ,`ALU_SRA ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SRAV
			6'b000011 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_IMM ,`IMM_S ,`ALU_SRA ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SRA
			6'b000110 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_RS1 ,`IMM_X ,`ALU_SRL ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SRLV
			6'b000010 : controlSignal <= {`PC_4 ,`A_RS2 ,`B_IMM ,`IMM_S ,`ALU_SRL ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SRL
			6'b001000 : controlSignal <= {`PC_ALU ,`A_RS1 ,`B_XXX ,`IMM_X ,`ALU_COPY_A ,`BR_GO , `ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//JR
			6'b001001 : controlSignal <= {`PC_ALU ,`A_RS1 ,`B_XXX ,`IMM_X ,`ALU_COPY_A ,`BR_GO , `ST_XXX ,`LD_XXX ,`WB_PC8 ,`Y ,`N ,`N};//JALR
			6'b001101 : ;//BREAK
			6'b001100 : ;//SYSCALL
			6'b011010 : ;//DIV   
			6'b011011 : ;//DIVU  
			6'b011000 : ;//MULT  
			6'b011001 : ;//MULTU 
			6'b010001 : ;//MTHI
			6'b010011 : ;//MTLO
			6'b010000 : ;//MFHI
			6'b010010 : ;//MFLO
			endcase
			
			6'b000001 : 
			case (funt2)
			5'b00001 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_GE ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BGEZ
			5'b00000 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_LZ ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BLTZ
			5'b10001 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_GE ,`ST_XXX ,`LD_XXX ,`WB_PC8 ,`Y ,`N ,`N};//BGEZAL
			5'b10000 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_LZ ,`ST_XXX ,`LD_XXX ,`WB_PC8 ,`Y ,`N ,`N};//BLTZAL
			endcase		

			6'b010000 : 
			case (funt3)
			5'b00000 : ;//MFC0
			5'b00100 : ;//MTC0
			5'b10000 : ;//ERET ignored
			endcase
			
			6'b001000 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ADDI
			6'b001001 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ADDIU
			6'b001100 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_U ,`ALU_AND ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ANDI
			6'b001101 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_U ,`ALU_OR  ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//ORI
			6'b001110 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_U ,`ALU_XOR ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//XORI
			6'b001010 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_SLT ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLTI 
			6'b001011 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_SLTU,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//SLTIU
			6'b000100 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_EQ ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BEQ
			6'b000101 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_NE ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BNE
			6'b000111 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_GZ ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BGTZ
			6'b000110 : controlSignal <= {`PC_4 ,`A_PC ,`B_IMM ,`IMM_B ,`ALU_ADD ,`BR_LE ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//BLEZ
			6'b000010 : controlSignal <= {`PC_ALU ,`A_XXX ,`B_IMM ,`IMM_J ,`ALU_COPY_B ,`BR_GO ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//J
			6'b000011 : controlSignal <= {`PC_ALU ,`A_XXX ,`B_IMM ,`IMM_J ,`ALU_COPY_B ,`BR_GO ,`ST_XXX ,`LD_XXX ,`WB_PC8 ,`Y ,`N ,`N};//JAL
			6'b100000 : controlSignal <= {`PC_0 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_LB  ,`WB_MEM ,`Y ,`N ,`Y};//LB 
			6'b100100 : controlSignal <= {`PC_0 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_LBU ,`WB_MEM ,`Y ,`N ,`Y};//LBU
			6'b100001 : controlSignal <= {`PC_0 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_LH  ,`WB_MEM ,`Y ,`N ,`Y};//LH 
			6'b100101 : controlSignal <= {`PC_0 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_LHU ,`WB_MEM ,`Y ,`N ,`Y};//LHU
			6'b100011 : controlSignal <= {`PC_0 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_XXX ,`LD_LW  ,`WB_MEM ,`Y ,`N ,`Y};//LW 
			6'b101000 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_SB  ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//SB 
			6'b101001 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_SH  ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//SH 
			6'b101011 : controlSignal <= {`PC_4 ,`A_RS1 ,`B_IMM ,`IMM_I ,`ALU_ADD ,`BR_XXX ,`ST_SW  ,`LD_XXX ,`WB_ALU ,`N ,`N ,`N};//SW 
			6'b001111 : controlSignal <= {`PC_4 ,`A_XXX ,`B_IMM ,`IMM_H ,`ALU_COPY_B ,`BR_XXX ,`ST_XXX ,`LD_XXX ,`WB_ALU ,`Y ,`N ,`N};//LUI
		endcase
  	end
endmodule