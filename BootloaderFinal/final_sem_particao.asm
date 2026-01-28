xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax

;------------------------------------------------------------------

;Gerar o modo de vídeo
;No Mode   Text Res    Size Box    Res Pixel   Colors         No. Paginas     Buffer Addr    System Adapter
;13h       40x25       8x8         320x200     256/256K        1              A000           VGA,MCGA
mov al, 0x13
int 0x10
;Finalizado


;Chamar Fundo Branco

call DesenhaFundoBranco

;Agora que o fundo está branco, precisa escrever a frase

call BotaFrase


;Desenha

;call Desenha

;Acabou

jmp $

;------------------------------------------------------------------

DesenhaFundoBranco:
push bp
mov bp, sp
pusha

;Int 10h, 0Ch            Write Pixel
;
;    Writes a pixel dot of a specified color at a specified screen
;    coordinate.
;
;        Entry   AH = 0Ch
;                AL = Pixel color
;                CX = Horizontal position of pixel
;                DX = Vertical position of pixel
;                BH = Display page number (graphics modes with more
;                     than 1 page)
;
;        Return  Nothing
;No Mode   Text Res    Size Box    Res Pixel   Colors         No. Paginas     Buffer Addr    System Adapter
;13h       40x25       8x8         320x200     256/256K        1              A000           VGA,MCGA
xor cx, cx; posição horizontal -> 0
mov dx, 0x1e ;posição vertical -> 30
mov ah, 0x0c
mov al, 0x0f
recomeca:
int 0x10
inc cx
cmp cx, 0x140 ;320 em decimal
je zeraHorizontal
jmp recomeca

fim:
popa
mov sp, bp
pop bp
ret

;------------------------------------------------------------------

zeraHorizontal:
xor cx, cx
inc dx
cmp dx, 0xc8 ;200 em decimal
je fim
jmp recomeca

;------------------------------------------------------------------

BotaFrase:
push bp
mov bp, sp
pusha

;Int 10h, 13h            Write Character String
;Writes a string of characters with specified attributes to any
;    display page.

;        Entry   AH    = 13h
;                AL    = Subservice (0-3)
;                BH    = Display page number
;                BL    = Attribute (Subservices 0 and 1)
;                CX    = Length of string
;                DH    = Row position where string is to be written
;                DL    = Column position where string is to be written
;                ES:BP = Pointer to string to write

;        Return  Nothing


 ;The service has four subservices, as follows:

;        AL=00h: Assign all characters the attribute in BL; do not
;                update cursor
;        AL=01h: Assign all characters the attribute in BL; update
;                cursor
;        AL=02h: Use attributes in string; do not update cursor
;        AL=03h: Use attributes in string; update cursor
mov ah, 0x13
mov al, 0x01
xor bx, bx
mov bl, 0x0f
mov cx, 0x0f
mov dh, 0x1c
mov dl, 0x04
mov bp, mensagem
add bp, 0x7c00
int 0x10

popa
mov sp, bp
pop bp
ret

;------------------------------------------------------------------

dados:
    db 58,4,11,16,10,1,6,4,142,14,54,62,3,12,15,6,3,3,6,138,18,54,66,1,15,14,1,2,4,6
    db 139,17,55,69,1,16,15,1,7,139,16,56,89,21,139,14,57,96,14,141,11,58,97,13,113,3
    db 25,9,60,98,12,113,6,21,7,63,101,9,113,8,19,8,62,102,8,65,13,37,7,19,7,62,102,8
    db 46,3,34,10,22,8,16,8,63,102,8,33,15,46,10,11,10,14,7,64,102,8,26,13,61,9,3,1,2
    db 15,9,7,64,102,7,22,11,72,27,7,7,65,102,6,18,15,76,28,3,7,65,101,6,14,12,1,2,4,2
    db 77,25,2,8,66,101,4,11,16,1,1,2,3,80,27,3,5,66,100,4,8,15,8,2,84,23,2,1,2,5,66,99
    db 5,2,14,105,19,1,2,1,6,66,98,5,1,14,109,19,2,6,66,97,17,114,18,3,5,66,97,14,118
    db 17,3,5,66,96,11,123,17,2,5,66,95,10,126,23,66,94,9,129,22,66,93,8,12,1,30,4,85
    db 21,66,91,7,13,1,25,9,88,7,1,13,65,90,7,34,9,65,2,29,3,4,12,65,86,12,19,1,12,9,4
    db 3,60,8,24,1,5,12,64,82,12,1,3,4,1,14,1,89,9,23,2,5,11,63,87,6,2,1,21,2,91,8,23
    db 2,4,1,1,10,61,69,1,17,5,2,2,116,9,20,2,5,1,2,8,61,68,1,16,5,2,3,111,1,8,7,19,4
    db 3,2,2,7,61,67,1,16,6,1,2,113,18,18,4,7,7,60,63,3,16,5,3,3,129,3,18,6,3,8,60,61
    db 4,16,5,158,16,60,59,4,16,6,119,2,38,1,1,7,1,6,60,56,6,16,7,162,5,3,5,60,54,6,16
    db 9,162,5,2,7,59,53,5,17,11,161,5,2,9,1,4,52,51,5,4,1,13,11,162,5,2,7,2,6,51,50
    db 3,7,1,11,13,112,1,48,6,2,6,7,3,50,48,3,18,14,114,2,47,4,1,8,10,3,48,48,2,15,18
    db 113,2,47,4,3,7,12,2,47,48,1,12,22,105,2,2,4,49,3,4,6,13,2,47,47,2,9,25,103,7,51
    db 3,5,6,12,3,47,47,2,8,26,9,1,92,2,64,7,12,3,47,46,5,2,30,7,10,149,9,12,2,48,45
    db 37,10,25,61,3,68,9,11,3,48,40,42,13,11,4,16,22,2,27,5,65,11,11,3,48,39,44,14,10
    db 3,8,1,7,7,3,12,2,25,7,64,11,12,3,48,39,45,19,23,5,4,1,4,7,2,25,7,65,11,12,4,47
    db 38,51,21,2,1,19,2,6,3,4,26,6,67,11,13,3,47,37,60,28,19,28,6,67,12,14,2,47,36
    db 70,14,1,3,16,32,6,2,9,5,20,30,14,8,1,4,2,47,35,103,36,11,1,4,3,17,2,21,10,16,12
    db 2,47,34,103,39,24,1,9,4,19,9,17,12,2,47,32,101,43,48,17,20,10,1,48,31,62,84,16
    db 9,3,2,6,6,2,18,26,6,2,47,30,63,82,1,2,20,39,30,4,2,47,29,64,85,33,22,35,2,4,46
    db 30,61,91,91,47,30,59,103,81,47,30,58,113,71,48,30,56,123,63,48,30,58,123,60
    db 49,31,59,122,59,49,31,64,114,62,49,31,70,102,67,50,32,73,97,68,50,32,66,3,7
    db 94,1,2,65,50,33,67,5,5,93,66,51,34,70,2,7,87,69,51,34,84,79,72,51,35,94,68,71
    db 52,36,96,53,1,5,76,53,36,99,40,3,1,88,53,37,102,16,3,17,91,54,38,104,4,1,9,9
    db 1,3,5,89,57,39,109,2,5,1,22,2,81,59,40,110,6,8,1,13,1,80,61,42,113,1,103,61,44
    db 213,63,45,210,65,47,207,66,49,204,67,51,201,68,52,198,70,52,197,71,55,193
    db 72,59,185,76,63,179,78,66,175,79,68,171,81,70,166,84,73,161,86,82,144,94,86
    db 135,99,94,123,103,101,110,109,105,100,115,107,94,119,109,88,123,118,17,11
    db 47,127,126,5,20,23,146,162,8,150,166,2,152



;Variáveis
mensagem: db 'Me contrata! =D'

;finalizando
;times (510 - ($ - $$)) db 0x00
dw 0xAA55