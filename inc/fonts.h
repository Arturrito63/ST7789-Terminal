#ifndef __FONT_H
#define __FONT_H

//#include "stdint.h"
#include "stm8s.h"

typedef struct {
    const uint8_t width;
    uint8_t height;
    const uint16_t *data;
} FontDef;

//Font lib.
//extern FontDef Font_7x10;
extern FontDef Font_11x18;

#endif