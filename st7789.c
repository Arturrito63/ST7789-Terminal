#include "st7789.h"
#include "stm8s_spi.h"

// Función simple de retardo aproximado (asumiendo CPU a 16MHz)
void delay_ms(uint16_t ms) {
    uint16_t i;
    while (ms--) {
        for (i = 0; i < 1200; i++) {
            nop(); // Instrucción ensamblador 'no operation'
        }
    }
}

void ST7789_SendByte(uint8_t byte) {
	SPI_SendData(byte);
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
}

void ST7789_SendWord(uint16_t word) {
	SPI_SendData((uint8_t)(word >> 8));
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
	SPI_SendData((uint8_t)(word & 0xFF));
	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
}

// Envío de Comando (Línea D/C en BAJO)
void ST7789_WriteCommand(uint8_t cmd) {
	DC_CMD;
	ST7789_SendByte(cmd);
	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

// Envío de un Byte de Dato (Línea D/C en ALTO)
void ST7789_WriteData(uint8_t data) {
    DC_DAT;
    ST7789_SendByte(data);
	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

// Envío rápido de un color de 16 bits (2 bytes en RGB565)
void ST7789_WriteWord(uint16_t word) {
	DC_DAT;
	ST7789_SendWord(word);
	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

void ST7789_WriteDataArray(uint8_t *data, uint8_t zise){
	uint8_t i;
	DC_DAT;
	for(i=0; i<zise; i++)
	{
		ST7789_SendByte(data[i]);
	}
	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

// Inicialización de la pantalla
void ST7789_Init(void) {
	// 1. Reset por Hardware mediante pin RST
	RST_H;
	delay_ms(50);
	RST_L;
    delay_ms(50);
    RST_H;
    delay_ms(150);

    // 2. Secuencia obligatoria de comandos ST7789
    ST7789_WriteCommand(ST7789_SLPOUT); // Salir de Sleep
    delay_ms(120);

    ST7789_WriteCommand(ST7789_MADCTL); // Dirección de escaneo/Orientación
    ST7789_WriteData(0x00);             // Vista estándar (puedes variar según rotación)

    ST7789_WriteCommand(ST7789_COLMOD); // Formato de color de interfaz
    ST7789_WriteData(0x05);             // 16 bits/píxel (RGB565)

    // ***** comentar linea debajo si aparecen colores invertidos ****
	ST7789_WriteCommand(ST7789_INVON);  // Inversión de pantalla (Típico en módulos IPS negros)

	ST7789_WriteCommand(ST7789_NORON); // Display modo normal
		
	ST7789_WriteCommand(ST7789_DISPON); // Encender pantalla
    delay_ms(50);
}



// Define el área rectangular de dibujo (Ventana de memoria)
void ST7789_SetWindow(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1) {
    ST7789_WriteCommand(ST7789_CASET); // Columnas
	DC_DAT;
	ST7789_SendWord(x0);
	ST7789_SendWord(x1);
	ST7789_WriteCommand(ST7789_RASET); // Filas
	DC_DAT;
	ST7789_SendWord(y0);
	ST7789_SendWord(y1);
	ST7789_WriteCommand(ST7789_RAMWR); // Preparar para escribir en memoria
}

void ST7789_SetRotation(uint8_t m)
{
	ST7789_WriteCommand(ST7789_MADCTL);	// MADCTL
	switch (m) {
	case 0:
		ST7789_WriteData(ST7789_MADCTL_MX | ST7789_MADCTL_MY | ST7789_MADCTL_RGB);
		break;
	case 1:
		ST7789_WriteData(ST7789_MADCTL_MY | ST7789_MADCTL_MV | ST7789_MADCTL_RGB);
		break;
	case 2:
		ST7789_WriteData(ST7789_MADCTL_RGB);
		break;
	case 3:
		ST7789_WriteData(ST7789_MADCTL_MX | ST7789_MADCTL_MV | ST7789_MADCTL_RGB);
		break;
	default:
		break;
	}
}

void ST7789_setScrollArea(uint16_t tfa, uint16_t bfa) {
  uint16_t vsa = 320-(tfa+bfa); // ST7789 320x240 VRAM
  ST7789_WriteCommand(ST7789_VSCRDEF);
  DC_DAT;
  ST7789_SendWord(tfa);
  ST7789_SendWord(vsa);
  ST7789_SendWord(bfa);
  while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

void ST7789_setScroll(uint16_t vsp) {
  ST7789_WriteCommand(ST7789_VSCRSADD);
  ST7789_WriteWord(vsp);
}

void ST7789_setPartArea(uint16_t sr, uint16_t er) {
  ST7789_WriteCommand(ST7789_PTLAR);
  DC_DAT;
  ST7789_SendWord(sr);
  ST7789_SendWord(er);
  while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

void ST7789_swPartArea(bool active) {
	if(active) {
	  ST7789_WriteCommand(ST7789_PTLON); //Display modo �rea parcial
	} else {
		ST7789_WriteCommand(ST7789_NORON); // Display modo normal
	}
}

void ST7789_DrawPixel(uint16_t x, uint16_t y, uint16_t color) {
  ST7789_SetWindow(x, y, x, y);
  DC_DAT;
  ST7789_SendWord(color);
  while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

void ST7789_WriteChar(uint16_t x, uint16_t y, char ch, FontDef font, uint16_t color, uint16_t bgcolor) {
  uint32_t i, b, j;
  ST7789_SetWindow(x, y, x + font.width - 1, y + font.height - 1);
  for (i = 0; i < font.height; i++) {
	b = font.data[(ch - 32) * font.height + i];
	for (j = 0; j < font.width; j++) {
		if ((b << j) & 0x8000) {
			uint8_t data[] = {color >> 8, color & 0xFF};
			ST7789_WriteDataArray(data, sizeof(data));
		}
		else {
			uint8_t data[] = {bgcolor >> 8, bgcolor & 0xFF};
			ST7789_WriteDataArray(data, sizeof(data));
		}
	}
  }
  while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}

void ST7789_WriteString(uint16_t x, uint16_t y, const char *str, FontDef font, uint16_t color, uint16_t bgcolor)
{
	while (*str) {
		if (x + font.width >= 240) {
			x = 0;
			y += font.height;
			if (y + font.height >= 240) {
				break;
			}

			if (*str == ' ') {
				// skip spaces in the beginning of the new line
				str++;
				continue;
			}
		}
		ST7789_WriteChar(x, y, *str, font, color, bgcolor);
		x += font.width;
		str++;
	}
}

// Llena la pantalla entera con un único color
void ST7789_Clear(uint16_t color) {
    uint16_t i, j;
    // Ajustar a la resolución de tu ST7789 (Ej: 240x240 o 135x240)
    ST7789_SetWindow(0, 0, 239, 239); 

    DC_DAT; // Todo lo que sigue son datos
    
    for (i = 0; i < 240; i++) {
        for (j = 0; j < 240; j++) {
            // Envío optimizado inline sin rellamar a funciones para ganar velocidad
            ST7789_SendWord(color);
        }
    }
    while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
}
