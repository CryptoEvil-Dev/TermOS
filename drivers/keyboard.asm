global getch

getch:
    push edx
    push edx
    mov dl, 0x01 ; pressed
    call __getch
    pop edx
    mov dl, 0x02 ; released
    call __getch
    pop edx
    ret
__getch: ; dl - 0x01 - click 0x02 - unclick
    mov al, 0xf4      ; Включаем клавиатуру
    out 0x60, al

    mov al, 0xf3      ; Устанавливаем скорость и задержку
    out 0x60, al
    mov al, 0x01      ; Скорость
    out 0x60, al
    mov al, 0x3c      ; Задержка
    out 0x60, al

__getch_loop:
    in al, 0x60       ; Считываем скан-код клавиши
    cmp al, 0xfe
    je __getch_loop
    cmp dl, 0x02
    je __getch_nop
    mov cl, al
    call __getch_print_char
    mov al, 0xf4
    out 0x60, al
    ret
__getch_nop:
    mov al, 0xf4
    out 0x60, al
    ret

__getch_print_char:
    mov edx, ch_CODES
    mov cl, al
__getch_print_char_l:
    cmp cl, 0x01
    jne __dec
    jz __end_dec
__dec:
    dec cl
    inc edx
    jmp __getch_print_char_l

__end_dec:
    mov al, [edx]
    call char_out
    ret


ch_CODES: db " 1234567890-=  QWERTYUIOP[]  ASDFGHJKL;'` \ZXCVBNM,./ *               789-456+1230.  "