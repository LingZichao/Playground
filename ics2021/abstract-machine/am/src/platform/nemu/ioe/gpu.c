#include <am.h>
#include <nemu.h>
#include <klib.h>

#define SYNC_ADDR (VGACTL_ADDR + 4)

static uint16_t screen_w = 0 , screen_h = 0;
void __am_gpu_init() {
  screen_w = inw(VGACTL_ADDR + 2);
  screen_h = inw(VGACTL_ADDR);
}

void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
  screen_w = inw(VGACTL_ADDR + 2);
  screen_h = inw(VGACTL_ADDR);
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .width = screen_w, .height = screen_h,
    .vmemsz = 0
  };
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
  uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  uint32_t *pd = (uint32_t *)ctl->pixels;
  uint32_t offset = ctl->x + ctl->y * screen_w;
//  printf("INFO : %d %d %d %d\n" ,ctl->x , ctl->y , ctl->w ,ctl->h);

  for(size_t i = 0 ; i < ctl->h ; i++) for(size_t j = 0 ; j < ctl->w ; j++) {
    fb[offset + i* screen_w + j] = pd[i* ctl->w + j];
  }

  if (ctl->sync) outl(SYNC_ADDR, 1);
  else outl(SYNC_ADDR, 0);   
}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
  status->ready = true;
}
