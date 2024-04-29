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
    mov al, 1 ; Секторы на чтение
    mov ch, 0x00
    mov cl, 0x02    ; С какого сектора читать
    mov dh, 0x00
    mov dl, 0x80
    mov bx, 0x7e00 ; Адрес сохранения 0x7e00
    int 0x13
    jc read_error



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

OS:
    mov ah, 0x0e
    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'o'
    int 0x10
    jmp $