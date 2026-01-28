mov bx, 0x7c0
mov ds, bx

mov ah, 0x0e
xor cx, cx

inicio:
    mov si, cx       ; move cx para si (registrador de índice)
    mov al, [nome + si]
    int 0x10
    cmp cx, 4
    jne incremento
    jmp fim

incremento:
    inc cx
    jmp inicio

fim:
    jmp fim

nome: db 'Pedro'
times 510 - ($ - $$) db 0
dw 0xAA55
