#ifndef STDIO_H
#define STDIO_H

#include "stdint.h"

uint32_t VIDMEM_STRS[] = {0xb8000, 0xb80a0, 0xb8140, 0xb81e0, 0xb8280, 0xb8320, 0xb83c0, 0xb8460, 0xb8500, 0xb85a0, 0xb8640, 0xb86e0, 0xb8780, 0xb8820, 0xb88c0, 0xb8960, 0xb8a00, 0xb8aa0, 0xb8b40, 0xb8be0, 0xb8c80, 0xb8d20, 0xb8dc0, 0xb8e60, 0xb8f00, 0xb8fa0};
uint8_t* VIDMEM_POINT = (uint8_t*) 0xb8000;

void printf(uint16_t* message);
extern uint8_t* scanf();

#endif