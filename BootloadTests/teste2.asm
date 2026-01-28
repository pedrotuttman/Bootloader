mov bx, 0x7c0
mov ds, bx

mov ah, 0x0e

mov al, '1'
int 0x10

mov al, segredo
int 0x10
;Apareceu? Acho que não

mov al, '2'
int 0x10

mov al, [segredo]
int 0x10
;Apareceu? Será?\

mov al, '3'
int 0x10

mov bx, segredo
;add bx, 0x7c00
mov al, [bx]
xor bx, bx
int 0x10
;Agora apareceu?

mov al, '4'
int 0x10

mov al, [0x2e]
int 0x10
;E agora? 


segredo: db 'X'
times 510 - ($ - $$) db 0
dw 0xAA55
