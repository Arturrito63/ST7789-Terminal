/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
 
#include "stm8s.h"
#include "stm8s_spi.h"
#include "st7789.h"
//#include <stdio.h>

enum step_boolean{false, true};
enum item_menu{baudios, longitud, parada, paridad, salir};
enum step_baudios{_9600, _19200, _38400, _57600, _115200};
enum step_longbit{_8bit, _9bit};
enum step_stopbit{_1bit, _2bit};
enum step_paridad{disable, enable};
enum step_tipopar{par, impar};
enum step_status{pausa, run, menu, submenu};
enum step_ancho{corto, largo};

#define serial_on  UART1->CR1 &= 0xDF //UART1 Enabled
#define serial_off UART1->CR1 |= 0x20 //UART1 disable

#define beep_on  BEEP->CSR |= 0x20 
#define beep_off BEEP->CSR &= 0xDF

@eeprom char _menu[5][9] = {
    "Baudios",
    "DataBits",
    "StopBits",
		"Paridad",
		"-Salir-"
};

@eeprom char _objeto[4][6] = {
    "BPS:",
    "Dato:",
		"Stop:",
		"TPar:"
};

@eeprom char _baudios[6][7] = {
    "9600",
		"19200",
		"38400",
		"57600",
		"115200",
		"<Atras"
};

@eeprom char _datab[3][7] = {
    "8 Bits",
    "9 Bits",
		"<Atras"
};

@eeprom char _stopb[3][7] = {
    "1 Bits",
    "2 Bits",
		"<Atras"
};

@eeprom char _paridad[4][7] = {
    "Nulo",
    "Par",
		"Impar",
		"<Atras"
};

typedef struct {
	uint8_t baud: 3;  //Baudios: 0=9600, 1=19200, 2=38400,3=57600, 4=115200
	uint8_t lbit: 1;  //Longitud: 0=8bits, 1=9bits
	uint8_t stop: 1;  //Stop Bit: 0=1bits, 1=2bits, (1.5bits no aplica)
	uint8_t pari: 1;  //Paridad: 0=disable, 1=enable
	uint8_t tpar: 1;  //Tipo paridad: 0=par, 1=impar
	uint8_t none: 1;  // Sin Uso...
}S_CFG;

typedef struct {
	uint8_t elem: 4; //Elementos de la lista/menu
	uint8_t item: 4; //Item seleccionado de la lista/menu
}S_LST;

S_CFG s_conf;
S_LST lista;

uint32_t LSI_Frequency_Hz = 128000;
uint16_t capture1 = 0;
uint16_t capture2 = 0;
uint16_t periodticks = 0;

uint8_t cont, reg_sr, test, linea, scroll, status, menusel, item_sel;
uint8_t bbr1[] = {0x68, 0x34, 0x1A, 0x11, 0x08};
uint8_t bbr2[] = {0x03, 0x01, 0x00, 0x06, 0x0B};

bool new_boton, old_boton, push_boton, keyon;
bool new_encA, new_encB, old_encA, old_encB; enc_izq, enc_der, lat_encA;
bool is_read, setscr, print, salto, rx_err;

char texto[22];
char inChar;

void CLK_Config(void);
void GPIO_Config(void);
void EXTI_Config(void);
void SPI_Config(void);
void UART_config(void);
void LSI_Calibration(void);
void BEEP_Init_Calibrated(void);
void BorraFlags(void);
//void PulsoLED(void);
void PulsoBeep(bool ancho);
void FillTexto(void);
void Print_Inicio(void);
void Print_RX(void);
void PrintBlack(void);
void PrintMenu(void);
void SelItemMenu(uint8_t sel);
void SelItemSubMenu(uint8_t sel);
void PrintSubMenu(uint8_t lista);
void SelLista(uint8_t item);

void main(void) {
	  s_conf.baud = _9600; //Baudios: 0=9600, 1=19200, 2=38400,3=57600, 4=115200
		s_conf.lbit = _8bit;
		s_conf.stop = _1bit;
		s_conf.pari = disable;
		s_conf.tpar = par;
		
    CLK_Config();   // Reloj del sistema a 16MHz
    GPIO_Config();  // Direccionamiento de Pines 
    SPI_Config();   // Iniciar Periférico SPI por hardware
		UART_config();  // Iniciar Periferico UART 1
		BEEP_Init_Calibrated();
		serial_off;
		EXTI_Config();  //Configura las interrupciones externas
    ST7789_Init();  // Iniciar Pantalla TFT
		PulsoBeep(largo);
		//ST7789_SetRotation(0);
		Print_Inicio();
		old_boton = (GPIOC->IDR & 0x08) ? false : true; //PC3 Botón encoder
		old_encA = (GPIOD->IDR & 0x04) ? false : true;  //PD2 Encoder A
		old_encB = (GPIOD->IDR & 0x08) ? false : true;  //PD3 Encoder B
		push_boton = false;
		lat_encA = false;
		enc_izq = false;
		enc_der = false;
		item_sel = 0;
		menusel = 0;
		is_read = false;
		_asm("rim\n"); //Habilita interrupciones
		cont = 0;
		scroll = false;
		status = pausa; //Inicia en modo "pausa"
		ST7789_setScrollArea(0, 80);
		keyon = true;

    while (1) {
			if(new_boton && !(GPIOC->IDR & 0x08)) {
			  if(!old_boton) {
				  push_boton = true;
					new_boton = false;
					old_boton = false;
				} else {
				  old_boton = true;
				}
			}
			if(push_boton){
				PulsoBeep(largo);
				switch(status){
				  case pausa:  PrintBlack(); serial_on; status = run; break;
				  case run: serial_off; setscr = false; PrintMenu(); break;
				  case menu: SelItemMenu(item_sel); break;
				  case submenu: serial_off; SelItemSubMenu(item_sel); break;
				}
				push_boton = false;
			}
		  if(new_encA) {
  		  if(!old_encB) {
				  if(!(GPIOD->IDR & 0x04) && !(GPIOD->IDR & 0x08)) {
						enc_izq = true;
				    BorraFlags();
					}
			  } else {
				  if(!(GPIOD->IDR & 0x04)) lat_encA = true;  //Habilitar old_encA más tarde
			  }
		  }
			if(new_encB) {
  			if(!old_encA) {
				  if(!(GPIOD->IDR & 0x04) && !(GPIOD->IDR & 0x08)) {
						enc_der = true;
						BorraFlags();
					}
			  } else {
					if(!(GPIOD->IDR & 0x08)) old_encB = true;
				}
			}
			if(lat_encA) {      //Si old_encA se activa antes de evaluar new_encB genera error
				old_encA = true;
				lat_encA = false;
			}
			if(enc_izq) {
				if((status > 1)|| setscr) PulsoBeep(corto);
				if(status > 1) {
				  if(item_sel == lista.elem) {
				    item_sel = 0;
				  } else {
						item_sel++;
					}
					SelLista(item_sel);
				}
				if(setscr) {
					if(scroll > 20) {
						scroll -= 20;
					} else {
						scroll = 220;
					}
					ST7789_setScroll(scroll);
				}
				enc_izq = false;
			}
			if(enc_der) {
				if((status > 1)|| setscr) PulsoBeep(corto);
				if(status > 1) {
					if(item_sel == 0) {
						item_sel = lista.elem;
					} else {
						item_sel--;
					}
					SelLista(item_sel);
				}
				if(setscr) {
					if(scroll < 220) {
						scroll += 20;
					} else {
						scroll = 0;
					}
					ST7789_setScroll(scroll);
				}
				enc_der = false;
			}
			if((status == run) && is_read) {
				rx_err = ((reg_sr & 0x0F) > 0)? true : false;
				is_read = false;
			  test = (uint8_t)inChar;
			  if(((test>0x1F)&(test<0x7F))|((test>0x9F)&(test<0xA6))|(test==0x82)) {
				  texto[cont] = inChar;
				  cont++;
				  //PulsoLED();
			  }
			  if(((test == 0x0A)|(test==0x0D))&(cont>0)) print=true;
			  if(cont==20) {
			    print=true;
				  salto=true;
				  texto[cont] = '-';
				}
				if (print) {
				  Print_RX();
					FillTexto();
				  cont = 0;
				  if(salto && !rx_err) {
				    texto[cont] = '-';
				  	cont++;
				  }
				  print = false;
				  salto = false;
				  if(setscr) {
				  	scroll +=20;
				  	if(scroll > 220) scroll = 0;
				  	ST7789_setScroll(scroll);
			    } else {
				  	if(linea < 220) {
					  	linea += 20;
				  	} else {
						  linea = 0;
						  setscr = true;
					  }
				 }
			  }
      }
		}
}

//***********************************************************************************


void CLK_Config(void) {
    // Configurar el reloj interno HSI con prescaler de 1 (F_CPU = 16 MHz)
    //CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
	CLK->ICKR |= 0x01;           // HSI encendido (HSION)
	while (!(CLK->ICKR & 0x02)); // Esperar hasta que HSI esté listo (HSIRDY)
    
	CLK->SWR = 0xE1;             // Seleccionar HSI como origen del reloj maestro
	CLK->CKDIVR = 0x00;          // Configurar divisor en 1 (reloj de CPU a 16 MHz)
}

void GPIO_Config(void) {
		GPIOC->DDR = 0xF0;  // PC7, PC6, PC5 y PC4 como salidas/ PC3 como entrada
		GPIOC->CR1 = 0xF8;  // PC7, PC6, PC5 y PC4 modo Push-Pull/ PC3 modo Pull-Up
		GPIOC->CR2 = 0xF8;  // PC7, PC6, PC5 y PC4 modo High-Fast/ PC3 modo interrupcion
		
		GPIOB->DDR = 0x20;  // PB5 como salida, PB4 como entrada (PB5=Led, PB4=Push)
		GPIOB->CR1 = 0x00;  // PB5 modo Open Drain
		GPIOB->CR2 = 0x00;  // PB5 Modo low fast
		GPIOB->ODR |= 0x20; // PB5 Led apagado
		
		GPIOD->DDR = 0x10;  // PD2, PD3 y PD6 como entradas, PD4 como salida (PD2=EncA, PD3=EncB, PD4=Beep, PD6=RX)
		GPIOD->CR1 = 0x4C;  // PD2, PD3 y PD6 modo Pull-up, PD4 modo Open-Drain
		GPIOD->CR2 = 0x4C;  // PD2 y PD3 modo interrupcion, PD6 modo High-Fast
} 

void EXTI_Config(void) {
	  EXTI->CR1 = 0xA0;
	}

void SPI_Config(void) {
    // Inicializar SPI: Maestro, 16MHz/2 = 8MHz Baudrate, Modo 3 (CPOL High, CPHA 2edge)
    // El ST7789 soporta hasta 16-20MHz en SPI, por lo que 8MHz es totalmente seguro y rápido.
		
		
    SPI_Init(SPI_FIRSTBIT_MSB, 
             SPI_BAUDRATEPRESCALER_2, 
             SPI_MODE_MASTER, 
             SPI_CLOCKPOLARITY_HIGH, 
             SPI_CLOCKPHASE_2EDGE, 
             SPI_DATADIRECTION_1LINE_TX, 
             SPI_NSS_SOFT, 
             0x07);
             
    SPI_Cmd(ENABLE);
 }

void UART_config(void) {
	UART1->BRR1 = bbr1[s_conf.baud];
  UART1->BRR2 = bbr2[s_conf.baud];
	
	UART1->CR3 &= 0xCF;
	if(s_conf.stop) UART1->CR3 |= 0x20; // 1 o 2 stop bit
	UART1->CR2 |= 0x24; // RIEN + REN
	
	UART1->CR1 &= 0xC9;
	if(s_conf.lbit) UART1->CR1 |= 0x20; // 8bits o 9bits de longitud
	if(s_conf.pari) UART1->CR1 |= 0x04; // paridad no o si
	if(s_conf.tpar) UART1->CR1 |= 0x02; // paridad par o impar
}

void LSI_Calibration(void)
{
    CLK->ICKR |= CLK_ICKR_LSIEN;   // 1. Habilitar el oscilador LSI
    while ((CLK->ICKR & CLK_ICKR_LSIRDY) == 0); // Esperar a que se estabilice

    // Conecta internamente LSI a la captura de TIM1 (Input Capture 1)
    //CLK->CCOR |= CLK_CCOR_BEEPCLK; // Enruta LSI a la redirección interna
    AWU->CSR |= AWU_CSR_MSR;       // Conecta la medición AWU/LSI al Timer

    //Configura TIM1 Canal 1 para capturar el flanco de subida
    TIM1->CCMR1 = 0x01; // CC1 asignado a la entrada TI1FP1
    TIM1->CCER1 = 0x01; // Captura en flanco de subida, habilitar captura
    TIM1->CR1 |= TIM1_CR1_CEN; // Encender TIM1

    //Captura el primer flanco
    while ((TIM1->SR1 & TIM1_SR1_CC1IF) == 0);
    capture1 = ((uint16_t)TIM1->CCR1H << 8) | TIM1->CCR1L;
    TIM1->SR1 &= ~TIM1_SR1_CC1IF; // Borrar bandera

    //Captura el segundo flanco (un ciclo completo de LSI)
    while ((TIM1->SR1 & TIM1_SR1_CC1IF) == 0);
    capture2 = ((uint16_t)TIM1->CCR1H << 8) | TIM1->CCR1L;
    TIM1->SR1 &= ~TIM1_SR1_CC1IF; // Borrar bandera

    //Apaga la medición y el Timer
    TIM1->CR1 &= ~TIM1_CR1_CEN;
    AWU->CSR &= ~AWU_CSR_MSR;

    //Calcula la diferencia de ticks (fmaster sin divisiones, ej. HSI a 16MHz)
    if (capture2 > capture1)
    {
        periodticks = capture2 - capture1;
    }
    else
    {
        periodticks = (0xFFFF - capture1) + capture2 + 1;
    }

    //Calcula la frecuencia exacta del LSI (f_LSI = f_master / ticks)
    // Cambiar 16000000UL si f_master es diferente (ej. 2000000UL ::divisor por 8)
    LSI_Frequency_Hz = (uint32_t)(16000000UL / periodticks);
}

void BEEP_Init_Calibrated(void) //Inicia BEEP (salida en PD4)
{
    uint8_t beep_div = 0;

    LSI_Calibration();    // Ejecutar calibración primero

    // Calcular el divisor óptimo para un BEEP de 1 kHz (f_LSI / 64) o la más cercana
    // La fórmula para BEEPDIV es: (f_LSI / (32 * f_target))
    // Para un objetivo de 2kHz: beep_div = LSI_Frequency_Hz / 64000;
    //beep_div = (uint8_t)(LSI_Frequency_Hz / 64000);
		beep_div = (uint8_t)(LSI_Frequency_Hz / 8000)-2; 
		

    if (beep_div == 0x1F) beep_div++; // Límite máximo de 5 bits (0 a 31)

    // Configurar registro BEEP_CSR (Divisor calculado y seleccionar frecuencia de salida)
    // Limpia bits previos y escribe el nuevo divisor conservando selección de frecuencia
    BEEP->CSR = (uint8_t)((BEEP->CSR & (uint8_t)(~BEEP_CSR_BEEPDIV)) | beep_div);
    
    // Seleccionar tono (ejemplo: BEEP_FREQUENCY_2KHZ)
    BEEP->CSR |= (uint8_t)(1 << 6); 
}

/*
void PulsoLED(void) {
	uint16_t i;
	GPIOB->ODR &= (~0x20);
	for(i=0;i<35000;i++); //.05Seg
	GPIOB->ODR = 0x20;
}
*/

void PulsoBeep(bool largo) {
	uint16_t i;
	beep_on;
	for(i=(largo)? 50000: 15000; i>0; i--);
	beep_off;
}

void FillTexto(void) {
	uint8_t i;
	for(i=0; i<21; i++) texto[i] = 0x00;
}

void BorraFlags(void) {
	old_encA = false;
	old_encB = false;
	new_encB = false;
	new_encA = false;
}

void Print_Inicio(void) {
	  char tmpCh;
		ST7789_Clear(BLACK);
		ST7789_WriteString(20,0, "-------------------", Font_11x18, MAGENTA, BLACK);
		ST7789_WriteString(20,20, "Terminal", Font_11x18, MAGENTA, BLACK);
		
		ST7789_WriteString(30,40, _objeto[0], Font_11x18, GRAY, BLACK);
		ST7789_WriteString(96,40, _baudios[s_conf.baud], Font_11x18, GRAY, BLACK);
		
		ST7789_WriteString(30,60, _objeto[1], Font_11x18, GRAY, BLACK);
		ST7789_WriteString(96,60, _datab[s_conf.lbit], Font_11x18, GRAY, BLACK);
		
		ST7789_WriteString(30,80, _objeto[2], Font_11x18, GRAY, BLACK);
		ST7789_WriteString(96,80, _stopb[s_conf.stop], Font_11x18, GRAY, BLACK);
		
		ST7789_WriteString(30,100, _objeto[3], Font_11x18, GRAY, BLACK);
		if(s_conf.pari) {
			ST7789_WriteString(96,100, _paridad[s_conf.tpar + 1], Font_11x18, GRAY, BLACK);
		} else{
			ST7789_WriteString(96,100, _paridad[0], Font_11x18, GRAY, BLACK);
		}
		ST7789_WriteString(20,120, "-------------------", Font_11x18, MAGENTA, BLACK);
		ST7789_WriteString(10,160, "Pausa...", Font_11x18, LIGHTBLUE, BLACK);
}

void PrintBlack(void) {
	keyon = disable;
	ST7789_Clear(BLACK);
	ST7789_WriteString(0,20, ">", Font_11x18, GREEN, BLACK);
	linea = 20;
	keyon = enable;
}
	
void Print_RX(void) {
	  //BEEP->CSR = 0x20;
		ST7789_WriteString(0,linea+scroll, ">                    ", Font_11x18, GRAY, BLACK);
		if(rx_err) {
			PulsoBeep(largo);
			GPIOB->ODR &= 0xDF;  //Led error On
		  ST7789_WriteString(11,linea+scroll, "Error: ", Font_11x18, RED, BLACK);
		 	if(reg_sr & 0x02) {  //Frame error
			  ST7789_WriteString(85,linea+scroll, "FE", Font_11x18, RED, BLACK);
			}
			if(reg_sr & 0x04) {  //Noise error
				ST7789_WriteString(115,linea+scroll, "NE", Font_11x18, RED, BLACK);
			}
			if(reg_sr & 0x08) {  //OverRun error
				ST7789_WriteString(135,linea+scroll, "OE", Font_11x18, RED, BLACK);
			}
			if((reg_sr & 0x01) & s_conf.pari) {  //Parity error
				ST7789_WriteString(155,linea+scroll, "PE", Font_11x18, RED, BLACK);
			}
		} else {
			GPIOB->ODR |= 0x20; //Led error Off
		  ST7789_WriteString(10,linea+scroll, texto, Font_11x18, GRAY, BLACK);
		}
		//BEEP->CSR &= (~0x20);
}

void SelLista(uint8_t item) { //muestra elemento de una lista en modo PartArea
	  uint16_t sr, er;
		keyon = disable;
		if(item > lista.elem) item = lista.elem;
		lista.item = item;
		item++;
	  sr = 20 * item;
		er = 20 + sr;
		ST7789_setPartArea(sr, er);
		keyon = enable;
}

void PrintMenu(void) {
	  uint8_t i;
	  keyon = disable;
	  ST7789_Clear(BLACK);
		for(i=0;i<5;i++) {
			ST7789_WriteString(10,20 + (20*i), _menu[i], Font_11x18, GREEN, BLACK);
		}
		lista.elem = 4;
		item_sel = 0;
		SelLista(0);
		ST7789_swPartArea(enable);
		status = menu;
		keyon = enable;
}

void SelItemMenu(uint8_t sel) {
	keyon = disable;
	if(sel == 4) {
		status = pausa;
		ST7789_swPartArea(disable);
		Print_Inicio();
	} else {
		status = submenu;
		menusel = sel;
		PrintSubMenu(sel);
	}
	keyon = enable;
}

void PrintSubMenu(uint8_t sm_lst) {
	uint8_t i;
	ST7789_swPartArea(disable);
	ST7789_Clear(BLACK);
	if(sm_lst == 0) {
		lista.elem = 5;
		for(i=0; i<6;i++) {
			ST7789_WriteString(32,20 + (20*i), _baudios[i], Font_11x18, GREEN, BLACK);
		}
		item_sel = s_conf.baud;
		SelLista(item_sel);
	} else if(sm_lst == 1) {
		lista.elem = 2;
		for(i=0; i<3;i++) {
			ST7789_WriteString(10,20 + (20*i), _datab[i], Font_11x18, GREEN, BLACK);
		}
		item_sel = s_conf.lbit;
		SelLista(item_sel);
	} else if(sm_lst == 2) {
		lista.elem = 2;
		for(i=0; i<3;i++) {
			ST7789_WriteString(10,20 + (20*i), _stopb[i], Font_11x18, GREEN, BLACK);
		}
		item_sel = s_conf.stop;
		SelLista(item_sel);
	 } else if(sm_lst == 3) {
		lista.elem = 3;
		for(i=0; i<4;i++) {
			ST7789_WriteString(10,20 + (20*i), _paridad[i], Font_11x18, GREEN, BLACK);
		}
		if(!s_conf.pari && s_conf.tpar) s_conf.tpar = 0;
		item_sel = (s_conf.pari<<1)|s_conf.tpar;
		SelLista(item_sel);
	}
	ST7789_swPartArea(enable);
}

void SelItemSubMenu(uint8_t sel) {
	if(lista.elem != sel) {
		switch(menusel){
			case 0: s_conf.baud = sel; break;
			case 1: s_conf.lbit = sel; break;
			case 2: s_conf.stop = sel; break;
			case 3: s_conf.pari = (sel > 0)? 1:0; s_conf.tpar = (sel == 0x2)? 1: 0; break;
		}
		UART_config();
	}
	status = menu;
	ST7789_swPartArea(disable);
	PrintMenu();
}

@far @interrupt void EXTI_PORTC_IRQHandler(void) {
  if(keyon) new_boton = (GPIOC->IDR & 0x08) ? false : true; //PC3 Pulsador del encoder
	return;
}

@far @interrupt void EXTI_PORTD_IRQHandler(void) {
	if(keyon) {
	  new_encA = (GPIOD->IDR & 0x04) ? false : true;  //PD2 Encoder A
	  new_encB = (GPIOD->IDR & 0x08) ? false : true;  //PD3 Encoder B
	}
	return;
}

@far @interrupt void UART1_RX_IRQHandler(void) {
	reg_sr = UART1->SR;
	if(reg_sr & 0x20) {
	  inChar = UART1->DR;
		is_read = true;
	}
	return;
}


#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line) { while (1); }
#endif

