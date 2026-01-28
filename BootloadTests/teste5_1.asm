xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax

;Set video mode:	AH=00h	
;                   AL = video mode

mov al, 0x13  ;Tem uma tabela de modos de video
int 0x10

;Write graphics pixel:	 AH=0Ch	
;                        AL = Color, 
;                        BH = Page Number, 
;                        CX = x, 
;                        DX = y

mov ah, 0x0c
mov al, 0x00
mov bh, 0x00
xor cx, cx
xor dx, dx

loop1:
int 0x10
inc al
inc cx
cmp cx, 319 
jl loop1

loop2:
int 0x10
dec al
inc dx
cmp dx, 199
jl loop2

xor cx, cx
mov dx, 199
mov al, 0x0f
loop3:
int 0x10
inc cx
cmp cx, 319 
jl loop3

xor cx, cx
xor dx, dx
loop4:
int 0x10
inc dx
cmp dx, 199
jl loop4

jmp $

times 510 - ($ - $$) db 0
dw 0xAA55