#include <am.h>
#include <nemu.h>

#include <sys/time.h>
#include <time.h>

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  uptime->us = inl(RTC_ADDR);
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  // time_t t = time(NULL);
  // struct tm *tm = localtime(&t);
  // rtc->second = tm->tm_sec;
  // rtc->minute = tm->tm_min;
  // rtc->hour   = tm->tm_hour;
  // rtc->day    = tm->tm_mday;
  // rtc->month  = tm->tm_mon + 1;
  // rtc->year   = tm->tm_year + 1900;
}
