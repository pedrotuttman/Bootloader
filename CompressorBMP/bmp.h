//Arquivo Cabeçalho para as estruturas do BMP

#pragma once
#include <stdio.h>

struct BitmapInfoHeader {
    unsigned int headerSize; //Precisa ser 40! Aqui diz o tamanho desse header. offset 0E
    unsigned int imageWidth; //offset 12h
    unsigned int imageHeight; //offset 16h
    unsigned short planes; //offset 1Ah. Precisa ser 1
    short bitsPerPixel; //"Color Depth". Valores típicos são 1,4,8,16,24,32. 
                        //Eu só quero as imagens monocromáticas. Então esse valor precisa ser 1
                        //Offset 1Ch
    unsigned int compression; //Compressão usada. Offset 1Eh
    unsigned int imageRawSize; //Pode ser zero. Offset 22h
    unsigned int horizontalResolution; //Pixel por metro. Offset 26h
    unsigned int verticalResolution; //Pixel por metro. Offset 2Ah
    unsigned int colorPallete; //Número de cores na palheta. A maioria só bota 0. Offset 2Eh
    unsigned int importantColors; //Geralmente ignorado. Offset 32h
};


struct BitmapfileHeader {
    unsigned char signature[2]; //offset 00
    unsigned int imagesize; //offset 02
    short reserved1; //offset 06
    short reserved2; //offset 08
    unsigned int pixelDataOffset; //offset 0A
    struct BitmapInfoHeader BIHeader;
};

typedef struct BitmapfileHeader BFHeader;
typedef struct BitmapInfoHeader BIHeader;

void fillHeader(BFHeader *bf, FILE *fp);
int celling(int x, int y);
int checkBit(unsigned char *ch, int posicao);