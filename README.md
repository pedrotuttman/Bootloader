# 🖥️ Projeto Bootloader x86 com Imagem BMP Comprimida

Este repositório apresenta o desenvolvimento de um **bootloader x86 em real mode**, capaz de exibir uma **imagem bitmap personalizada durante o processo de boot**, utilizando exclusivamente recursos fornecidos pela **BIOS**.

Devido às limitações severas do ambiente de boot — em especial o limite de **512 bytes do boot sector** — o projeto inclui a implementação de um **compressor BMP próprio**, baseado em **Run-Length Encoding (RLE)**, além de uma rotina de **descompressão e renderização gráfica em Assembly**.

O projeto foi desenvolvido no contexto de estudos sobre **Arquitetura de Computadores**, **sistemas de baixo nível** e **processo de inicialização de computadores x86**.

---

## 🎯 Objetivos

- Desenvolver um **bootloader funcional** em Assembly x86.  
- Estudar o funcionamento das **interrupções da BIOS**.  
- Implementar renderização gráfica direta no **modo de vídeo 13h**.  
- Criar um **compressor BMP** para viabilizar o uso de imagens no boot.  
- Integrar código **C (ferramentas)** com **Assembly (sistema)**.  
- Compreender o processo de boot em nível de hardware.  

---

## ⚙️ Visão Geral do Bootloader

O bootloader é dividido em **dois estágios**, seguindo práticas comuns em sistemas de baixo nível.

### Stage 1 – Boot Sector (512 bytes)

- Carregado pela BIOS no endereço físico `0x7C00`.  
- Contém assinatura válida `0xAA55`.  
- Compatível com **FAT12** (BIOS Parameter Block válido).  
- Inicializa registradores de segmento (`DS`, `ES`, `SS`) e pilha.  
- Alterna para o **modo gráfico 13h (320×200, 256 cores)**.  
- Desenha fundo e texto inicial.  
- Lê setores adicionais do disco usando `INT 13h`.  
- Transfere o controle para o Stage 2.  

### Stage 2

- Executado após o carregamento em memória.  
- Realiza a **descompressão da imagem RLE**.  
- Renderiza a imagem **pixel a pixel** usando a BIOS.  
- Controla manualmente as coordenadas `(x, y)`.  
- Finaliza corretamente ao atingir o fim dos dados.  

---

## 🎨 Renderização Gráfica

- **Modo de vídeo:** 13h  
- **Resolução:** 320×200  
- **Profundidade:** 8 bits (256 cores)  

Cada pixel é desenhado diretamente via BIOS.

## 🧩 Compressão da Imagem (RLE)

### Motivação

- O boot sector possui apenas 512 bytes.
- Mesmo com múltiplos estágios, o espaço disponível é extremamente limitado.
- Imagens BMP sem compressão são grandes demais para esse ambiente.

### Algoritmo de Compressão

Foi implementado um algoritmo simples de Run-Length Encoding (RLE), adaptado para uso em bootloaders:

- Cada byte representa a quantidade de pixels consecutivos.
- A cor não é armazenada nos dados.
- A cor é alternada automaticamente no código Assembly durante a renderização.

Exemplo conceitual:
[10 pixels][5 pixels][20 pixels]

Dados gerados pelo compressor:
10, 5, 20

## 🧾 Formato dos Dados Comprimidos

- Cada byte indica a quantidade de pixels da cor atual.
- A cor alterna automaticamente entre claro e escuro.
- O valor especial 255 (0xFF) indica o fim da imagem.

### Observação Importante

- O byte 255 é obrigatório no final dos dados comprimidos.

Exemplo correto:
dados:
    db 10,5,20,7,12
    db 255
Sem esse byte, o bootloader continua lendo memória inválida, causando artefatos visuais, como listras pretas na tela.

## 🛑 Bug Encontrado e Correção

### Sintoma

A imagem era desenhada corretamente no início.
Após o término, surgiam listras pretas cobrindo a tela.

### Causa

Os dados RLE não possuíam o byte final 255.
A rotina de descompressão não sabia quando interromper a leitura.

### Correção

Adicionar o byte 255 ao final dos dados:
db 255

Ou no compressor em C:
buffer[pos++] = 255;

## 🧪 Testes em Assembly

Os arquivos teste*.asm foram desenvolvidos para estudar e validar:

- Interrupções da BIOS:
  INT 10h (vídeo)
  INT 13h (disco)
- Segmentação em real mode (CS, DS, ES).
- Endereçamento físico vs. lógico.
- Uso de registradores (SI, DI, CX).
- Strings, loops e indexação.
- Escrita direta de caracteres e pixels.

Esses testes serviram como base para a implementação do bootloader final.

## 🖼️ Formato BMP Aceito

O compressor espera imagens BMP com:

- 8 bits por pixel (256 cores).
- Sem compressão BMP interna.
- Paleta compatível com o modo 13h.
- Padding por linha respeitado.

## 📂 Estrutura do Repositório
├── BMPFinal/
│   └── eu.bmp
│
├── BMPTests/
│   ├── FormulaTamanhoLinha.bmp
│   ├── teste1.bmp
│   ├── teste2.bmp
│   └── teste3.bmp
│
├── BootloadTests/
│   ├── teste.asm
│   ├── teste.bin
│   ├── teste2.asm
│   ├── teste2.bin
│   ├── teste3.asm
│   ├── teste3.bin
│   ├── teste4.asm
│   ├── teste4.bin
│   ├── teste5.asm
│   ├── teste5.bin
│   ├── teste5_1.asm
│   ├── teste5_1.bin
│   ├── teste6.asm
│   ├── teste6.bin
│   ├── teste6_1.asm
│   └── teste6_1.bin
│
├── BootloaderFinal/
│   ├── dados.txt
│   ├── final
│   ├── final.asm
│   ├── final.bin
│   └── final_sem_particao.asm
│
├── CompressorBMP/
│   ├── CompressorBMP.exe
│   ├── bmp.c
│   ├── bmp.h
│   └── main.c
│
└── README.md


## ▶️ Como Compilar e Executar

### Montagem do Bootloader
```bash
nasm -f bin final.asm -o boot.bin
```

### Execução no VMware

1. Criar uma nova máquina virtual.
2. Adicionar um Floppy Drive.
3. Selecionar Use floppy image file.
4. Anexar diretamente o arquivo boot.bin.
5. Iniciar a máquina virtual.

O VMware trata o arquivo .bin como um disquete bruto, permitindo que a BIOS carregue o setor de boot diretamente.

### 📌 Conclusão

Este projeto demonstra, de forma prática:

- O funcionamento real do processo de boot em x86.
- Uso direto das interrupções da BIOS.
- Programação gráfica em baixo nível.
- Compressão e descompressão manual de dados.
- Integração entre C (ferramentas) e Assembly (sistema).
- Depuração de erros reais em sistemas de baixo nível.

## 👤 Autor

Projeto desenvolvido por Rafael Sousa, da hackingnaweb, e adaptado por Pedro Tuttman.
