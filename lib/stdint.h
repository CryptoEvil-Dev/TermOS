#ifndef STDINT_H
#define STDINT_H

#define __WORDSIZE


typedef unsigned char       uint8_t;
typedef unsigned short int  uint16_t;
typedef unsigned int        uint32_t;
#if __WORDSIZE == 64
typedef unsigned long int   uint64_t;
#endif

typedef signed char         int8_t;
typedef signed short int    uint16_t;
typedef signed int          uint32_t;
#if __WORDSIZE == 64
typedef signed long int     uint64_t;
#endif


#endif