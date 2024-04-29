#include "stdio.h"

void printf(uint16_t* message){
    uint16_t i = 0;
    uint16_t j = 0;

    while (message[j] != '\0')
    {
        VIDMEM_POINT[i] = message[j];
        VIDMEM_POINT[i+1] = 0x07;
        ++j;
        i = i+2;
    }
    return;
}

extern uint8_t scanf();