[BITS 32]
global Read_ELF ; ecx - Address start elf file 0x7f 0x45 0x4c 0x46 ...

Read_ELF:
    cmp dword [ecx], 0x464c457f
    je __ELF_OK
    jmp __ELF_ERROR

__ELF_ERROR:
    mov ecx, ERROR_WORD
    call out_string
    jmp $
__ELF_OK:
    mov dword [ELF_HEAD], ecx
    push ecx
    mov ecx, ELF_WORD
    call out_string
    pop ecx

    jmp __ELF_BITS

__ELF_BITS:
    add ecx, 4
    cmp byte [ecx], 0x01
    je __ELF_32
    cmp byte [ecx], 0x02
    je __ELF_64
    jmp __ELF_ERROR


__ELF_32:
    mov al, 0x32
    call out_byte
    jmp __ELF_MAGICK

__ELF_64:
    mov al, 0x64
    call out_byte
    jmp __ELF_MAGICK

__ELF_MAGICK:
    push ecx
    mov ecx, MAGIC_WORD
    call out_string
    pop ecx

    sub ecx, 4
    mov bl, 0x00
__ELF_out_magick_nums:
    cmp bl, 0x10
    je __ELF_end_out_magick_nums
    mov al, byte [ecx]
    call out_byte
    mov al, ' '
    call char_out
    inc ecx
    inc bl
    jmp __ELF_out_magick_nums

__ELF_end_out_magick_nums:


__ELF_DATA_TYPE:
    mov ecx, DATA_WORD
    call out_string
    mov ecx, [ELF_HEAD]
    add ecx, 5
    cmp byte [ecx], 0x01
    je __ELF_DATA_TYPE_LE
    jmp __ELF_DATA_TYPE_BE

__ELF_DATA_TYPE_LE:
    mov ecx, DATA_LE
    call out_string
    jmp __ELF_VERSION
__ELF_DATA_TYPE_BE:
    mov ecx, DATA_BE
    call out_string
    jmp __ELF_VERSION

__ELF_VERSION:
    mov ecx, VERSION_WORD
    call out_string
    mov ecx, [ELF_HEAD]
    add ecx, 6
    cmp byte [ecx], 0x01
    jne __ELF_VERSION_NONE
    mov ecx, VERSION_1
    call out_string
    jmp __ELF_ENTRY_POINT
__ELF_VERSION_NONE:
    mov ecx, VERSION_NONE
    call out_string
    jmp __ELF_ENTRY_POINT


__ELF_ENTRY_POINT:
    ;mov eax, [ELF_HEAD]
    ;add eax, 0x10aa

    mov ecx, [ELF_HEAD]
    add ecx, 24
    mov ax, word [ecx]
    mov [ELF_ENTRY_OFFSET], ax

    mov ecx, [ELF_HEAD]
    add ecx, [ELF_ENTRY_OFFSET]
    call ecx

    mov ecx, COMPLETE_WORD
    call out_string

    jmp $

ELF_HEAD: dd 0x00
ELF_ENTRY_OFFSET: dd 0x00

COMPLETE_WORD: db 0x0a,"C code is completed!",0

ELF_WORD: db 'ELF',0
MAGIC_WORD: db 0x0a,' MAGIC:     ',0
ERROR_WORD: db "ERROR READ ELF",0

DATA_WORD: db 0x0a," DATA:                                                        ",0
DATA_LE: db "Little Endian",0x0a,0
DATA_BE: db "Big Endian",0x0a,0
VERSION_WORD: db " VERSION:                                                     ",0

VERSION_1: db "01 (currently)",0x0a,0
VERSION_NONE: db "None",0x0a,0
