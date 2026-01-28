#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

BFHeader bf;
//char **repBMP; //Representacao do BMP na memoria


int main(int argc, char *argv[]) {

    FILE *fp;
    char arg[] = "C:\\Users\\pedro\\programacao\\UniversidadeHacker\\ArquivosPoliglotas\\eu.bmp";
    int larguratotal = 0;
    int bytesPerRow;
    int byteatual = 0;
    int y, x;
    int cont = 0;
    int quantBits = 0;
    int quantBitsSeguidos = 0;
    unsigned char temp = 0;
    unsigned char bitAtual = 1; //Meu Run Lenth Encode já começa considerando o bit de cor definido como branco 

    if (argc<2) {
        fp = fopen(arg, "rb");
    }

    else {
        fp = fopen(argv[1], "rb");
    }
    
    if(!fp) {
        printf("Não foi possivel abrir o arquivo.\n");
        return(0);
    }

    fillHeader(&bf, fp);

    // printf("%c%c\n", bf.signature[0], bf.signature[1]);
    // printf("%d\n", bf.imagesize);
    // printf("%hd\n", bf.reserved1);
    // printf("%hd\n", bf.reserved2);
    // printf("%d\n", bf.pixelDataOffset);

    if (bf.BIHeader.bitsPerPixel != 1) {
        printf("So funciono com imagens monocromaticas.");
        fclose(fp);
        return(0);
    }

    //Visualizador de imagem no modo terminal:

    // larguratotal = bf.BIHeader.bitsPerPixel * bf.BIHeader.imageWidth;
    // bytesPerRow = celling(larguratotal, 32) * 4;
    // repBMP = (unsigned char **)malloc(bf.BIHeader.imageHeight * sizeof(unsigned char *));

    // fseek(fp, bf.pixelDataOffset, SEEK_SET);

    // for (y = 0 ;  y < bf.BIHeader.imageHeight ; y++) {
    //     repBMP[y] = (unsigned char **)malloc(larguratotal * sizeof(char) + 1);
    //     memset(repBMP[y], '\0', sizeof(char) * larguratotal + 1);
    //     quantBits = 0;

    //     for (x = 0 ; x < bytesPerRow ; x++) {
    //         fread(&byteatual, 1, 1, fp);
    //         for (cont = 7 ; cont >= 0 ; cont--) {
    //             //printf("%d\n", checkBit(&byteatual, cont));
    //             if (quantBits < larguratotal) {
    //                 if (checkBit(&byteatual, cont) == 1) repBMP[y][quantBits] = "+";
    //                 else repBMP[y][quantBits] = "-";
    //             }
    //             quantBits ++;
    //         }
    //     }
    // }


    // for (y = bf.BIHeader.imageHeight - 1 ;  y >= 0 ; y--) {
    //     printf("%s\n", repBMP[y]);
    // }

    larguratotal = bf.BIHeader.bitsPerPixel * bf.BIHeader.imageWidth;
    bytesPerRow = celling(larguratotal, 32) * 4;
    //repBMP = (unsigned char **)malloc(bf.BIHeader.imageHeight * sizeof(unsigned char *));

    fseek(fp, bf.pixelDataOffset, SEEK_SET);

    for (y = 0 ;  y < bf.BIHeader.imageHeight ; y++) {
        //repBMP[y] = (unsigned char **)malloc(larguratotal * sizeof(char) + 1);
        //memset(repBMP[y], '\0', sizeof(char) * larguratotal + 1);
        quantBits = quantBitsSeguidos = 0;
        for (x = 0 ; x < bytesPerRow ; x++) {
            fread(&byteatual, 1, 1, fp);
            for (cont = 7 ; cont >= 0 ; cont--) {
                //printf("%d\n", checkBit(&byteatual, cont));
                if (quantBits < larguratotal) {
                    temp = checkBit(&byteatual, cont);
                    if (temp == bitAtual) quantBitsSeguidos++;
                    else {
                        printf("%d,",quantBitsSeguidos);
                        quantBitsSeguidos = 1;
                        bitAtual = temp;
                    }
                    if (quantBitsSeguidos >= 0xff) {    //Caso ja tenha passado 255 bits seguidos, significa que grande parte da imagem é igual, logo, não há mais nada nela
                        return(0);
                    }
                }
                quantBits ++;
            }
        }
        printf("%d,",quantBitsSeguidos);
    }


    // for (y = bf.BIHeader.imageHeight - 1 ;  y >= 0 ; y--) {
    //     printf("%s\n", repBMP[y]);
    // }

    // printf("Largura Total: %d\n", larguratotal);
    // printf("Bytes Por Linha: %d\n", bytesPerRow);

    return(0);
}


