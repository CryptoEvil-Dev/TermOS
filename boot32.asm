[BITS 16]
[ORG 0x7c00]

boot:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
read_disc:
    mov ah, 0x02
    mov al, [SECTORS] ; Секторы на чтение
    mov ch, 0x00
    mov cl, 0x02    ; С какого сектора читать
    mov dh, 0x00
    mov dl, 0x80
    mov bx, 0x7e00 ; Адрес сохранения 0x7e00
    int 0x13
    jc sub_sec
    jmp 0x7e00

SECTORS: dd 100

sub_sec:
    cmp byte [SECTORS], 0
    je read_error
    dec byte [SECTORS]
    jmp read_disc
read_error:
    mov ah, 0x0e
    mov al, 'R'
    int 0x10
    mov al, 'E'
    int 0x10
    mov al, 'A'
    int 0x10
    mov al, 'D'
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'E'
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, 'O'
    int 0x10
    mov al, 'R'
    int 0x10
    mov al, '!'
    int 0x10
    jmp $


times 510 - ($-$$) db 0
dw 0xaa55




loaded:
    mov ax, 0x0003
    int 0x10

    cli
    lgdt [GDT]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODESEG:preload_kernel

    GDT_Start:
        null_descr:
            dd 0
            dd 0
        code_descr:
            dw 0xffff
            dw 0
            db 0
            db 10011010b
            db 11001111b
            db 0
        data_descr:
            dw 0xffff
            dw 0
            db 0
            db 10010010b
            db 11001111b
            db 0
    GDT_End:
    GDT:
        dw GDT_End - GDT_Start - 1
        dd GDT_Start

    CODESEG equ code_descr - GDT_Start
    DATASEG equ data_descr - GDT_Start


preload_kernel:
[BITS 32]
    mov esp, 0x7e00
    mov ecx, ELF
    call Read_ELF


%include 'drivers/IO.asm'
%include 'drivers/ELF32.asm'
%include 'drivers/keyboard.asm'


ELF:
