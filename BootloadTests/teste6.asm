xor ax, ax  ;Zerando os registradores de segmento 
mov es, ax
mov ds, ax
;mov cs, ax  

;Set video mode:	AH=00h	
;                   AL = video mode
 
mov al, 0x13
int 0x10
;Nesse momento já estamos em video mode
;Memória de Vídeo: 0xA0000
xor di, di
mov ax, 0xA000
mov es, ax

mov cx, 0xA0 ; mov para cx 160
mov ax, 0x0000 ; cor
aquiLoop:
mov [es:di], ax    ;estamos escrevendo de 2 em 2 bits, por isso mov 160 e nao 320 para ax. 
inc di             ;Se quiséssemos de 1 em 1, passaríamos al para [es:di], incrementariamos di apenas 1 vez e mov para cx 360
inc di
add ax, 0x0101
dec cx
cmp cx, 0
jne aquiLoop

jmp $

times 510 - ($ - $$) db 0
dw 0xAA55