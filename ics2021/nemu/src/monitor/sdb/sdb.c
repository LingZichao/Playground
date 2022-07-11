#include <isa.h>
#include <cpu/cpu.h>
#include <readline/readline.h>
#include <readline/history.h>
#include "sdb.h"

static int is_batch_mode = false;
#define TestCorrect(x) if(x){printf("Invalid Command!\n");return 0;}

void init_regex();
void init_wp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(nemu) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 0;
}


static int cmd_q(char *args) {
  return -1;
}

static int cmd_help(char *args);

/*New*/
static int cmd_si(char *args) {
	uint64_t step;
	if (args == NULL) step = 1;
	else sscanf(args, "%lu", &step);
	cpu_exec(step);
	return 0;
}

static int cmd_info(char *args) {
	TestCorrect(args == NULL);
	if (args[0] == 'r') {
    isa_reg_display();
	} else if (args[0] == 'w') {
		print_w();
	}
	return 0;
}

#include <memory/paddr.h>

static int cmd_x(char *args) {
  uint32_t expr_n ;
  sscanf(args , "0x%x" , &expr_n);


	//for (int i = 0; i < 10; i++) {
		printf("0x%08x\t0x%08x\n", expr_n , paddr_read(expr_n , 4));
	//}
 	return 0;
}

static int cmd_p(char *args) {
	TestCorrect(args == NULL);
	uint32_t ans;
	bool flag;
	ans = expr(args, &flag);
	TestCorrect(!flag) 
	else {
		printf("%d\n", ans);
	}
	return 0;
}

static int cmd_w(char* args) {
	TestCorrect(args == NULL);
	bool flag = true;
	uint32_t v = expr(args, &flag);
	TestCorrect(!flag);
	WP *wp = new_wp();
	if (wp == NULL) {
		printf("No space to add an extra watchpoint!");
		return 0;
	}
	strcpy(wp -> exprs, args);
	wp -> val = v;
	printf("Succefully add watchpoint NO.%d\n", wp -> NO);
	return 0;
}
static int cmd_d(char* args) {
	TestCorrect(args == NULL);
	int id;
	sscanf(args, "%d", &id);
	bool flag = true;
	WP* wp = delete_wp(id, &flag);
	if (!flag) {
		printf("Cannot Find!\n");
		return 0;
	}
	free_wp(wp);
	printf("Succefully Delete!\n");
	return 0;
}


static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display informations about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },
	{ "si", "Execute some steps, initial -> 1 step", cmd_si},
	{ "info", "Print values of all registers", cmd_info},
	{ "x", "Calculate expressions, let it be the starting memery address, print continuous N 4 bytes.", cmd_x},
	{ "p", "Calculate expressions", cmd_p},
	{ "w", "Add watchpoint", cmd_w},
	{ "d", "Delete watchpoint", cmd_d},
  /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();

  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
