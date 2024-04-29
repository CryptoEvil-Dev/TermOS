# TermOS
 Terminal Operation System with NASM and C

# building
###  Windows: ###
nasm -f bin boot32.asm -o TermOS.bin
copy /b TermOS.bin+Kernel_ELF.o

For building kernel you need WSL or Virtual machine
gcc -ffreestanding -nostdlib kernel/kernel.c -o Kernel_ELF.o

# Running
qemu-system-x86_64 TermOS.bin

