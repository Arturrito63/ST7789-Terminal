#ifndef __ST7789_H
#define __ST7789_H

#include "stm8s.h"
#include "fonts.h"

// --- MAPEADO DE PINES EN STVD ---
// SPI Pines Fijos en STM8S105K4: PC5 (SCK) y PC6 (MOSI)
// SPI Pines Fijos en STM8S103F3: PC5 (SCK) y PC6 (MOSI)
#define ST7789_SPI_PORT   GPIOC

// Pines GPIO configurables para Control
//#define ST7789_CS_PORT   GPIOC
//#define ST7789_CS_PIN    0x08 //PC3

#define ST7789_DC_PORT    GPIOC
#define ST7789_DC_PIN     0x10 //PC4

#define ST7789_RST_PORT   GPIOC
#define ST7789_RST_PIN    0x80 //PC7

// Comandos Principales ST7789
#define ST7789_SWRESET    0x01
#define ST7789_SLPOUT     0x11
#define ST7789_PTLON      0x12
#define ST7789_NORON      0x13
#define ST7789_INVOFF     0x20
#define ST7789_INVON      0x21
#define ST7789_DISPON     0x29
#define ST7789_CASET      0x2A
#define ST7789_RASET      0x2B
#define ST7789_RAMWR      0x2C
#define ST7789_MADCTL     0x36
#define ST7789_COLMOD     0x3A

#define ST7789_MADCTL_MY  0x80
#define ST7789_MADCTL_MX  0x40
#define ST7789_MADCTL_MV  0x20
#define ST7789_MADCTL_ML  0x10
#define ST7789_MADCTL_RGB 0x00

#define ST7789_PTLAR      0x30   // partial start/end
#define ST7789_VSCRDEF    0x33   // SETSCROLLAREA
#define ST7789_VSCRSADD   0x37

#define DC_DAT GPIOC->ODR |= ST7789_DC_PIN
#define DC_CMD GPIOC->ODR &= (~ST7789_DC_PIN)

//#define CS_DIS GPIOC->ODR |= ST7789_CS_PIN
//#define CS_ENA GPIOC->ODR &= (~ST7789_CS_PIN)

#define RST_H  GPIOC->ODR |= ST7789_RST_PIN
#define RST_L  GPIOC->ODR &= (~ST7789_RST_PIN)

#define WHITE       0xFFFF
#define BLACK       0x0000
#define BLUE        0x001F
#define RED         0xF800
#define MAGENTA     0xF81F
#define GREEN       0x07E0
#define CYAN        0x7FFF
#define YELLOW      0xFFE0
#define GRAY        0X8430
#define BRED        0XF81F
#define GRED        0XFFE0
#define GBLUE       0X07FF
#define BROWN       0XBC40
#define BRRED       0XFC07
#define DARKBLUE    0X01CF
#define LIGHTBLUE   0X7D7C
#define GRAYBLUE    0X5458


// Prototipos de funciones
void ST7789_Init(void);
void delay_ms(uint16_t ms);
void ST7789_Clear(uint16_t color);
void ST7789_SetRotation(uint8_t m);
void ST7789_setScroll(uint16_t vsp);
void ST7789_setPartArea(uint16_t sr, uint16_t er);
void ST7789_swPartArea(bool active); //active: 0=off, 1=on
void ST7789_setScrollArea(uint16_t tfa, uint16_t bfa);
void ST7789_DrawPixel(uint16_t x, uint16_t y, uint16_t color);
void ST7789_SetWindow(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1);
void ST7789_WriteChar(uint16_t x, uint16_t y, char ch, FontDef font, uint16_t color, uint16_t bgcolor);
void ST7789_WriteString(uint16_t x, uint16_t y, const char *str, FontDef font, uint16_t color, uint16_t bgcolor);

#endif
