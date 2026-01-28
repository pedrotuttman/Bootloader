mov ah, 0x0e
mov al, 'O'
mov bl, 0x0A
mov bh, 0
int 0x10

times ((512-2) - ($ - $$)) db 0x00
dw 0xAA55
