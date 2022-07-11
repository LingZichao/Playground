#include <am.h>
#include <klib.h>
#include <klib-macros.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)
static unsigned long int next = 1;

int rand(void) {
  // RAND_MAX assumed to be 32767
  next = next * 1103515245 + 12345;
  return (unsigned int)(next/65536) % 32768;
}

void srand(unsigned int seed) {
  next = seed;
}

int abs(int x) {
  return (x < 0 ? -x : x);
}

int atoi(const char* nptr) {
  int x = 0;
  while (*nptr == ' ') { nptr ++; }
  while (*nptr >= '0' && *nptr <= '9') {
    x = x * 10 + *nptr - '0';
    nptr ++;
  }
  return x;
}

char *itos(int num) {
  const char units[] = "0123456789";
  static char buf[32] = {0}; 
  int pos = 32 - 2 , tmp = num;

  while( tmp ) {
    if(pos < 0) panic("Buff Overflow!"); 
    buf[pos--] = units[tmp % 10];
    tmp /= 10;
  }
  if(num == 0) {buf[pos--] = '0';}
  else if(num < 0) {buf[pos--] = '-';}
  return buf + pos + 1;
}

char *ctos(char ch) {
  static char buf[2];
  buf[0] = ch;
  return buf;
}
static bool malloc_flag = 0;
static char *hn;
void *malloc(size_t size) {
  // On native, malloc() will be called during initializaion of C runtime.
  // Therefore do not call panic() here, else it will yield a dead recursion:
  //   panic() -> putchar() -> (glibc) -> malloc() -> panic()
  if( !malloc_flag )   hn = (void *)ROUNDUP(heap.start, 8) , malloc_flag = 1;
  size  = (size_t)ROUNDUP(size, 8);
  char *old = hn;
  hn += size;
  assert((uintptr_t)heap.start <= (uintptr_t)hn && (uintptr_t)hn < (uintptr_t)heap.end);

  return old;
}

void free(void *ptr) {
}

#endif
