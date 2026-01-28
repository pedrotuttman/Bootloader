#include "bmp.h"

int celling(int x, int y) {
    // if (x % y > 0 ) { 
    //     return (x/y + 1);
    // }

    // return (x / y);

    return(x % y ? x/y + 1 : x / y);
}

void fillHeader(BFHeader *bf, FILE *fp) {
    //BitmapfileHeader
    fread(&bf->signature, 2, 1, fp);
    fread(&bf->imagesize, 4, 1, fp);
    fread(&bf->reserved1, 2, 1, fp);
    fread(&bf->reserved2, 2, 1, fp);
    fread(&bf->pixelDataOffset, 4, 1, fp);

    //BitmapInfoHeader 
    fread(&bf->BIHeader.headerSize, 4, 1, fp); 
    fread(&bf->BIHeader.imageWidth, 4, 1, fp); 
    fread(&bf->BIHeader.imageHeight, 4, 1, fp); 
    fread(&bf->BIHeader.planes, 2, 1, fp); 
    fread(&bf->BIHeader.bitsPerPixel, 2, 1, fp);
    fread(&bf->BIHeader.compression, 4, 1, fp);
    fread(&bf->BIHeader.imageRawSize, 4, 1, fp);
    fread(&bf->BIHeader.horizontalResolution, 4, 1, fp);
    fread(&bf->BIHeader.verticalResolution, 4, 1, fp);
    fread(&bf->BIHeader.colorPallete, 4, 1, fp);
    fread(&bf->BIHeader.importantColors, 4, 1, fp);
}

int checkBit(unsigned char *ch, int posicao) {
    int result;
    __asm__ (
        ".intel_syntax noprefix;\n"
        "mov ebx, %[pos];\n"
        "mov eax, BYTE PTR [%[ch]];\n"
        "bt eax, ebx;\n"
        "jc 1f;\n"
        "xor eax, eax;\n"
        "jmp 2f;\n"
        "1:\n"
        "mov eax, 1;\n"
        "2:\n"
        "mov %[res], eax;\n"
        ".att_syntax;"
        : [res] "=r" (result)             // saída
        : [ch] "r" (ch), [pos] "r" (posicao) // entradas
        : "eax", "ebx"                    // registradores modificados
    );
    return result;
}
