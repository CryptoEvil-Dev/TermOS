#define __WORDSIZE 32

#include "lib/stdint.h"
#include "lib/stdio.h"

void kernel(){

    char *vidptr = (char*) 0xb8000;
    const char *str = "Welcome to C =)"; // 80*25*2   0x07

    unsigned int i = 0;
    unsigned int j = 0;

    while(j < 80*25*2){
        vidptr[j] = ' ';
        vidptr[j+1] = 0x07;
        j = j + 2;
    }

    j = 0;

    while(str[j] != '\0'){
        vidptr[i] = str[j];
        vidptr[i+1] = 0x07;
        ++j;
        i = i + 2;
    }
    

    return;
}

void _start(){
    kernel();
}