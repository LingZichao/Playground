def_EHelper(lui) {
  rtl_li(s, ddest, id_src1->imm);
}
def_EHelper(li) {
  rtl_li(s, ddest, id_src1->imm);
}

def_EHelper(auipc) {
  rtl_addi(s, ddest, &(s->pc), id_src1->imm );
}

def_EHelper(addi) {
  rtl_addi(s, ddest, dsrc1 , id_src2->simm );
}
def_EHelper(slli) {
  rtl_slli(s, ddest, dsrc1 , id_src2->simm );
}
def_EHelper(srli) {
  rtl_srli(s, ddest, dsrc1 , id_src2->simm );
}
def_EHelper(srai) {
  rtl_srai(s, ddest, dsrc1 , id_src2->simm );
}

def_EHelper(andi) {
  rtl_andi(s, ddest, dsrc1 , id_src2->simm );
}
def_EHelper(xori) {
  rtl_xori(s, ddest, dsrc1 , id_src2->simm );
}
def_EHelper(ori) {
  rtl_ori(s, ddest, dsrc1 , id_src2->simm );
}

def_EHelper(slt) {
  *ddest = (int)*dsrc1 < (int)*dsrc2 ? 1 : 0;
}
def_EHelper(sltu) {
  *ddest = *dsrc1 < *dsrc2 ? 1 : 0;
}
def_EHelper(slti) {
  *ddest = (int)*dsrc1 < id_src2->simm ? 1 : 0;
}
def_EHelper(sltiu) {
  //printf("SLTU : %d , %d / %u\n" ,*(dsrc1) , id_src2->simm , (uint32_t)id_src2->simm);
  *ddest = *(dsrc1) < (uint32_t)id_src2->simm ? 1 : 0;
}

def_EHelper(add) {
  rtl_add(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(sub) {
  rtl_sub(s, ddest, dsrc1 , dsrc2 );
}

def_EHelper(mull) {
  rtl_mulu_lo(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(mulh) {
  rtl_muls_hi(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(mulhu) {
  rtl_mulu_hi(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(divs) {
  rtl_divs_q(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(divu) {
  rtl_divu_q(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(rem) {
  rtl_divs_r(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(remu) {
  rtl_divu_r(s, ddest, dsrc1 , dsrc2 );
}

def_EHelper(sra) {
  rtl_sra(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(srl) {
  rtl_srl(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(sll) {
  rtl_sll(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(xor) {
  rtl_xor(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(or) {
  rtl_or(s, ddest, dsrc1 , dsrc2 );
}
def_EHelper(and) {
  rtl_and(s, ddest, dsrc1 , dsrc2 );
}


def_EHelper(beq) {
  if( *dsrc1 == *ddest ) rtl_j(s , s->pc + id_src2->simm );
}
def_EHelper(bne) {
  if( *dsrc1 != *ddest ) rtl_j(s , s->pc + id_src2->simm );
}
def_EHelper(bltu) {
  if( *dsrc1 <  *ddest ) rtl_j(s , s->pc + id_src2->simm );  
}
def_EHelper(bgeu) {
  if( *dsrc1 >= *ddest ) rtl_j(s , s->pc + id_src2->simm );  
}
def_EHelper(bge) {
  if(  (int)(*dsrc1) >= (int)(*ddest) ) 
                         rtl_j(s , s->pc + id_src2->simm );  
}
def_EHelper(blt) {
  if(  (int)(*dsrc1) <  (int)(*ddest) )  
                         rtl_j(s , s->pc + id_src2->simm );
}
def_EHelper(jal) {
  id_src1->simm >>= 12;
  id_src1->simm = ( (id_src1->simm & 0x7FE00) >> 8 | (id_src1->simm & 0x100) << 3 | (id_src1->simm & 0xFF) << 12 | (id_src1->simm & ~0x7FFFF) );
  rtl_j(s , s->pc + id_src1->simm );
  rtl_li(s, ddest, (s->pc) + 4);
}
def_EHelper(jalr) {
  rtl_j(s , *dsrc1 + id_src2->simm  );
  rtl_li(s, ddest, (s->pc) + 4);
}