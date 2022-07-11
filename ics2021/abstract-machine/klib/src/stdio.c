#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

static va_list ap;

static inline char* __arg_to_string(char type) {
    static char buff[256] = {0};

    switch ( type ) {
      case 'd' : strcpy( buff , itos(va_arg(ap , int)) );break;
      case 'c' : strcpy( buff , ctos(va_arg(ap , int)) );break;
      case 's' : strcpy( buff , va_arg(ap , char *) );   break;
      default : putch(type); panic("TYPE UNSUPPOSED!");
    } 
    
  return buff;
}

int printf(const char *fmt, ...) {
  va_start(ap , fmt);
  int ret = 0;

  for(int i = 0 ; i < strlen(fmt) ; i++) {
    if(fmt[i] != '%') { putch(fmt[i]); continue; }

      putstr( __arg_to_string( fmt[++i] ) );
      ret++;
  }
  va_end(ap);
  return ret;
}

int sprintf(char *out, const char *fmt, ...) {
  va_start(ap , fmt);
  int ret = 0;
  for(int i = 0 ; i <= strlen(fmt) ; i++) {
    if(fmt[i] != '%') { *out++ = fmt[i]; continue; }

    *out = 0; ret++;
    out = strcat(out ,   __arg_to_string(fmt[++i] ));
  }
  va_end(ap);
  return ret;
}
int snprintf(char *out, size_t n, const char *format, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *format , va_list vap) {
  panic("Not implemented");
}

#endif
