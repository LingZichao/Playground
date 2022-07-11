#ifndef __SDB_H__
#define __SDB_H__

#include <common.h>
typedef struct watchpoint {
	int NO;
	struct watchpoint *next;

	/* TODO: Add more members if necessary */
	uint32_t val;
	char exprs[32];
	
} WP;
word_t expr(char *e, bool *success);
WP* new_wp();
void free_wp(WP*);
void print_w();
WP* delete_wp(int, bool*);
void check_wp(bool*);
#endif
