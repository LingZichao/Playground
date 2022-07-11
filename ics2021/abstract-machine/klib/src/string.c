#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  size_t i = 0;
  while(s[i] != '\0') i++;
  return i;
}

char *strcpy(char *dst, const char *src) {
  char *ret = dst;
  while( *src != '\0' || (*dst = 0) ) *dst++ = *src++;
  return ret;
}

char *strncpy(char *dst, const char *src, size_t n) {
  char *ret = dst;
  size_t i = 0;
  while( *src != '\0' && i < n) *dst++ = src[i++];
  return ret;
}

char *strcat(char *dst, const char *src) {
  dst += strlen(dst);
  while(*src != '\0' || (*dst = '\0') ) *dst++ = *src++;
  return dst;
}

int strcmp(const char *s1, const char *s2) {
  size_t i = 0;
  while(s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0') i++;
  return (s1[i] - s2[i]);
}

int strncmp(const char *s1, const char *s2, size_t n) {
  size_t i = 0;
  while(s1[i] == s2[i] && s1[i] != '\0' && s2[i] != '\0' && i < n) i++;
  if(i == n) i--;
  return (s1[i] - s2[i]);
}

void *memset(void *s, int c, size_t n) {
  c &= 0xff;
  int cccc = c | c << 8 | c << 16 | c << 24;
  size_t i = 0;
  int *st = (int *)s;
  while( i < n / 4 )st[i++] = cccc;

  switch(n % 4) {
    case 3 :st[i++] = c;
    case 2 :st[i++] = c;
    case 1 :st[i++] = c;
    default:break;
  }
  return s;
}

void *memmove(void *s1, const void *s2, size_t n) {
  char *dst = (char *)s1 , *src = (char *)s2 ;
  strncpy( dst , src , n);
  return s1;
}

void *memcpy(void *out, const void *in, size_t n) {
  char *dst = (char *)out , *src = (char *)in ;
  strncpy( dst , src , n);
  return out;

}

int memcmp(const void *s1, const void *s2, size_t n) {
  char *dst = (char *)s1 , *src = (char *)s2 ;
  return strncmp( dst , src , n);
}

#endif
