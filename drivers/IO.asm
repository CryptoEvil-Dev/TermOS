[BITS 32]
global char_out
global out_byte
global out_word
global cls
global new_line




char_out:
    ; al - символ
    push ecx
    mov ecx, [VIDMEM_PTR]
    
    mov [ecx], al
    inc ecx
    mov byte [ecx], 0x07
    inc ecx
    mov [VIDMEM_PTR], ecx
    pop ecx
    ret


out_string:
    ;mov ecx, msg               ; ECX - Указатель на строку.
    push ecx
    push esi
    push eax
    mov esi, [VIDMEM_PTR]
__out_string_loop:
    cmp byte [ecx], 0
    je __out_string_endloop
    cmp byte [ecx], 0x0a
    je __out_string_new_line

    mov al, [ecx]
    mov [esi], al
    inc esi
    mov al, 0x07
    mov [esi], al
    inc esi
    inc ecx
    jmp __out_string_loop


__out_string_endloop:
    mov [VIDMEM_PTR], esi
    pop eax
    pop esi
    pop ecx
    ret
__out_string_new_line:
    call new_line
    mov esi, [VIDMEM_PTR]
    inc ecx
    jmp __out_string_loop


out_word:
    ; ax - Вход
    push ax
    call out_byte
    pop ax
    push ax
    mov al, ah
    call out_byte
    pop ax
    ret

out_dword:
    ; eax - Вход
    push eax
    shr eax, 24
    call out_byte
    pop eax
    push eax
    shl eax, 8
    shr eax, 24
    call out_byte
    pop eax
    push eax
    mov al, ah
    call out_byte
    pop eax
    call out_byte
    ret


out_byte:
    ; Выводит байт на экран
    ; al - Вход
    push eax
    mov ah, al
; Левая тетрада
    shr al, 4
    cmp al, 9
    jg __l_char
    jmp __l_int

__l_char:
    ; 0x61 - 0x57
    add al, 0x57
    call char_out
    jmp __r_tetrada

__l_int:
    add al, 0x30
    call char_out
    jmp __r_tetrada



__r_tetrada:
    mov al, ah
    shl al, 4
    shr al ,4
    cmp al, 9
    jg __r_char
    jmp __r_int

__r_char:
    add al, 0x57
    call char_out
    pop eax
    ret

__r_int:
    add al, 0x30
    call char_out
    pop eax
    ret


cls:
    push eax
    push ebx
    mov ebx, [VIDMEM]
    mov ah, 0x07
    mov al, ' '
__cls_loop:
    cmp ebx, dword [VIDMEM_END]
    je __cls_endloop
    mov [ebx], al
    inc ebx
    mov [ebx], ah
    inc ebx
    jmp __cls_loop
__cls_endloop:
    pop ebx
    pop eax
    mov dword [VIDMEM_PTR], 0xb8000
    ret


new_line:
    push eax
    push ebx
    push ecx
    cmp byte [ACTIVE_STR], 25
    je __new_line_to_start
    
    inc byte [ACTIVE_STR]
    mov eax, [ACTIVE_STR]
    mov ebx, STRING_ARR

    mov ecx, [ebx + (eax * 4)]
    mov dword [VIDMEM_PTR], ecx

    pop ecx
    pop ebx
    pop eax

    ret
; eax = ebx[ecx];

; eax [ACTIVE_STR]
; ebx [STRING_ARR]
; 
; mov ecx, [ebx + eax * 4]
; VIDMEM_PTR = STRING_ARR[ACTIVE_STR];
; dq - 8 байта смещение в массиве
; dd - 4 байта смещение в массиве

__new_line_to_start:
    mov dword [VIDMEM_PTR], 0xb8000
    mov dword [ACTIVE_STR], 0x00
    pop ecx
    pop ebx
    pop eax
    ret




VIDMEM:      equ 0xb8000
VIDMEM_END:  equ 0xb8fa0
VIDMEM_PTR:  dd 0xb8000
ACTIVE_STR:  dd 0x0 ; 25
STRING_ARR:  dd 0xb8000, 0xb80a0, 0xb8140, 0xb81e0, 0xb8280, 0xb8320, 0xb83c0, 0xb8460, 0xb8500, 0xb85a0, 0xb8640, 0xb86e0, 0xb8780, 0xb8820, 0xb88c0, 0xb8960, 0xb8a00, 0xb8aa0, 0xb8b40, 0xb8be0, 0xb8c80, 0xb8d20, 0xb8dc0, 0xb8e60, 0xb8f00, 0xb8fa0

; 80*25*2
; 80 - Width
; 25 - height