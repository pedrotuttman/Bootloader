mov ax, 0x13
int 0x10
;Define como modo de vídeo:     AL: 13h     Text Resol: 40x25   Box size:0x8  Pixel Resol: 320x200     Colors: 256  Pages: 1
;Para preencher a tela com as 256 cores, basta fazer um retangulo com 16 linhas e 16 colunas, sendo cada bloco uma cor

push 0xa000
pop es

xor ax, ax  ;zerando os registradores
xor bx, bx
xor cx, cx
xor di, di

;----------------------------ALGORITMO---------------------------------;

;Principal:

;mover a cor para a memoria de video
;incrementar um contador (2 vezes caso passemos 2 em 2 pixels)
;verificar se o contador eh 20 (ou 10 caso passemos de 2 em 2 pixels)
;Se for 20, MudaCor
;Se nao for, volta para o Principal 

;MudaCor:

;incrementar a cor (0x0101, caso estejamos teabalhando com 2 pixels)
;incrementar Numero de quadrados no horizonte
;Tenho 16 quadrados na horizontal?
;Se sim, pulaLinha
;zera contador
;Pula para Principal

;pulaLinha:

;incrementar Numero_Linhas
;cmp Numero_Linhas com 12
;Se for igual, Incrementa_Quadrado_Y
;Pega cor inicial
;Zera contador
;Zera quadrados na horizontal

;Incrementa_Quadrado_Y:
;Pega cor base anterior
;Adiciona 16 (0x10, ou 0x1010 se forem 2 bytes)
;Empurra para a pilha
;Zera contador
;Zera quadrados horizontais
;Incrementa quadrados_vertical
;cmp quadrados_vertical com 16
;Se for, vai para o Final
;Se nao, salta para Principal

;-----------------------------ELEMENTOS----------------------------------;

;Contador: cl
;Numero de linhas: ch
;Quadrados_y: dh
;Quadrados_x: dl
;Memória placa: es:di
;Cor: ax

;320(0x140) - 16 quadrados por linha - Cada um com 20 pixels de largura 
;192(0xc0) - 16 quadrados por coluna - Cada um com 12 pixels de altura 
;Escreverei 2 bytes de uma vez!

;------------------------------------------------------------------------;

push ax ;empurrando cor para pilha

Principal:
mov [es:di], ax 
inc di
inc di
inc cl
inc cl
cmp cl, 0x14
je MudaCor
jmp Principal

MudaCor:
add ax, 0x0101
inc dl
cmp dl, 0x10 ; 16 em decimal 
je pulaLinha
xor cl, cl
jmp Principal

pulaLinha:
inc ch
cmp ch, 0x0c ; 12 em decimal
je Incrementa_Quadrado_Y
pop ax
push ax
xor cl, cl
xor dl, dl
jmp Principal

Incrementa_Quadrado_Y:
pop ax
add ax, 0x1010
push ax
xor cx, cx
xor dl, dl
inc dh
cmp dh, 0x10
je Final
jmp Principal

Final:
jmp $

times 510 - ($-$$) db 0
dw 0xAA55
