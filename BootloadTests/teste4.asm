;zerando os registradores de seguimento
;xor ax, ax
;mov ds, ax
;mov es, ax
;mov ss, ax

;Colocando o seguimento para 0x7c0 para que quando seja shiftado 4 bits vire 0x7c00
mov ax, 0x7c0
mov es, ax


;AH=13h ---- AL = Write mode, 
;            BH = Page Number,
;            BL = Color, 
;            CX = Number of characters in string, 
;            DH = Row, 
;            DL = Column, 
;            ES:BP = Offset of string

mov ah, 0x13
mov al, 0x01
mov bh, 0x00
mov bl, 0x0f
mov cx, 0x17
mov dh, 0x0a
mov dl, 0x0a
mov bp, frase
;add bp, 0x7c00

int 0x10

mov ah, 0x13
mov al, 0x01
mov bh, 0x00
mov bl, 0x0f
mov cx, 0x16
mov dh, 0x0b
mov dl, 0x09
mov bp, frase2
;add bp, 0x7c00

int 0x10


jmp $
frase: db 'Meu nome eh Pedro! =D', 0x0a, 0x0d
frase2: db 'Meu nome eh Pedro2! =D'
times 510 - ($ - $$) db 0 
dw 0xAA55