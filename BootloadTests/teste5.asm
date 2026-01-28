xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax

;Set video mode:	AH=00h	
;                   AL = video mode

mov al, 0x13  ;Tem uma tabela de modos de video
int 0x10

;Write graphics pixel:	AH=0Ch	
;                        AL = Color, 
;                        BH = Page Number, 
;                        CX = x, 
;                        DX = y

mov ah, 0x0c
mov al, 0x0f
mov bh, 0x00
;mov cx, 124
mov cx, 0x7c
;mov dx, 69
mov dx, 0x45
int 0x10

;mov cx, 124
mov cx, 131
;mov dx, 69
mov dx, 69
int 0x10

mov cx, 143
mov dx, 71
int 0x10

jmp $

times 510 - ($ - $$) db 0
dw 0xAA55