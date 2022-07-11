#include <cpu/decode.h>
#include "../local-include/rtl.h"

#define INSTR_LIST(f) \
        f(lui) f(lw) f(sw) f(sb) f(sh) f(lb) f(lbu) f(lhu) f(inv) \
        f(li) f(auipc) f(addi) f(slli) f(srli) f(srai) f(andi) f(xori) f(ori)\
        f(add) f(sub) f(mull) f(mulh) f(mulhu) f(divs) f(divu) f(rem) f(remu) f(or) f(and) f(xor)\
        f(slt) f(slti) f(sltu) f(sltiu) f(sra) f(srl) f(sll)\
        f(beq) f(bne) f(bge) f(bgeu) f(blt) f(bltu) f(jal) f(jalr) \
        f(nemu_trap)

def_all_EXEC_ID();
