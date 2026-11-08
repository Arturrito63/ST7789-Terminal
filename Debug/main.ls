   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  15                     .eeprom:	section	.data
  16  0000               __menu:
  17  0000 42617564696f  	dc.b	"Baudios",0
  18  0008 00            	ds.b	1
  19  0009 446174614269  	dc.b	"DataBits",0
  20  0012 53746f704269  	dc.b	"StopBits",0
  21  001b 506172696461  	dc.b	"Paridad",0
  22  0023 00            	ds.b	1
  23  0024 2d53616c6972  	dc.b	"-Salir-",0
  24  002c 00            	ds.b	1
  25  002d               __objeto:
  26  002d 4250533a00    	dc.b	"BPS:",0
  27  0032 00            	ds.b	1
  28  0033 4461746f3a00  	dc.b	"Dato:",0
  29  0039 53746f703a00  	dc.b	"Stop:",0
  30  003f 545061723a00  	dc.b	"TPar:",0
  31  0045               __baudios:
  32  0045 3936303000    	dc.b	"9600",0
  33  004a 0000          	ds.b	2
  34  004c 313932303000  	dc.b	"19200",0
  35  0052 00            	ds.b	1
  36  0053 333834303000  	dc.b	"38400",0
  37  0059 00            	ds.b	1
  38  005a 353736303000  	dc.b	"57600",0
  39  0060 00            	ds.b	1
  40  0061 313135323030  	dc.b	"115200",0
  41  0068 3c4174726173  	dc.b	"<Atras",0
  42  006f               __datab:
  43  006f 382042697473  	dc.b	"8 Bits",0
  44  0076 392042697473  	dc.b	"9 Bits",0
  45  007d 3c4174726173  	dc.b	"<Atras",0
  46  0084               __stopb:
  47  0084 312042697473  	dc.b	"1 Bits",0
  48  008b 322042697473  	dc.b	"2 Bits",0
  49  0092 3c4174726173  	dc.b	"<Atras",0
  50  0099               __paridad:
  51  0099 4e756c6f00    	dc.b	"Nulo",0
  52  009e 0000          	ds.b	2
  53  00a0 50617200      	dc.b	"Par",0
  54  00a4 000000        	ds.b	3
  55  00a7 496d70617200  	dc.b	"Impar",0
  56  00ad 00            	ds.b	1
  57  00ae 3c4174726173  	dc.b	"<Atras",0
  58                     	bsct
  59  0000               _LSI_Frequency_Hz:
  60  0000 0001f400      	dc.l	128000
  61  0004               _capture1:
  62  0004 0000          	dc.w	0
  63  0006               _capture2:
  64  0006 0000          	dc.w	0
  65  0008               _periodticks:
  66  0008 0000          	dc.w	0
  67  000a               _bbr1:
  68  000a 68            	dc.b	104
  69  000b 34            	dc.b	52
  70  000c 1a            	dc.b	26
  71  000d 11            	dc.b	17
  72  000e 08            	dc.b	8
  73  000f               _bbr2:
  74  000f 03            	dc.b	3
  75  0010 01            	dc.b	1
  76  0011 00            	dc.b	0
  77  0012 06            	dc.b	6
  78  0013 0b            	dc.b	11
 155                     ; 123 void main(void) {
 157                     .text:	section	.text,new
 158  0000               _main:
 160  0000 5208          	subw	sp,#8
 161       00000008      OFST:	set	8
 164                     ; 124 	  s_conf.baud = _9600; //Baudios: 0=9600, 1=19200, 2=38400,3=57600, 4=115200
 166  0002 b633          	ld	a,_s_conf
 167  0004 a4f8          	and	a,#248
 168  0006 b733          	ld	_s_conf,a
 169                     ; 125 		s_conf.lbit = _8bit;
 171  0008 72170033      	bres	_s_conf,#3
 172                     ; 126 		s_conf.stop = _1bit;
 174  000c 72190033      	bres	_s_conf,#4
 175                     ; 127 		s_conf.pari = disable;
 177  0010 721b0033      	bres	_s_conf,#5
 178                     ; 128 		s_conf.tpar = par;
 180  0014 721d0033      	bres	_s_conf,#6
 181                     ; 130     CLK_Config();   // Reloj del sistema a 16MHz
 183  0018 cd0000        	call	_CLK_Config
 185                     ; 131     GPIO_Config();  // Direccionamiento de Pines 
 187  001b cd0000        	call	_GPIO_Config
 189                     ; 132     SPI_Config();   // Iniciar Periférico SPI por hardware
 191  001e cd0000        	call	_SPI_Config
 193                     ; 133 		UART_config();  // Iniciar Periferico UART 1
 195  0021 cd0000        	call	_UART_config
 197                     ; 134 		BEEP_Init_Calibrated();
 199  0024 cd0000        	call	_BEEP_Init_Calibrated
 201                     ; 135 		serial_off;
 203  0027 721a5234      	bset	21044,#5
 204                     ; 136 		EXTI_Config();  //Configura las interrupciones externas
 206  002b cd0000        	call	_EXTI_Config
 208                     ; 137     ST7789_Init();  // Iniciar Pantalla TFT
 210  002e cd0000        	call	_ST7789_Init
 212                     ; 138 		PulsoBeep(largo);
 214  0031 a601          	ld	a,#1
 215  0033 cd0000        	call	_PulsoBeep
 217                     ; 140 		Print_Inicio();
 219  0036 cd0000        	call	_Print_Inicio
 221                     ; 141 		old_boton = (GPIOC->IDR & 0x08) ? false : true; //PC3 Botón encoder
 223  0039 c6500b        	ld	a,20491
 224  003c a508          	bcp	a,#8
 225  003e 2703          	jreq	L6
 226  0040 4f            	clr	a
 227  0041 2002          	jra	L01
 228  0043               L6:
 229  0043 a601          	ld	a,#1
 230  0045               L01:
 231  0045 b728          	ld	_old_boton,a
 232                     ; 142 		old_encA = (GPIOD->IDR & 0x04) ? false : true;  //PD2 Encoder A
 234  0047 c65010        	ld	a,20496
 235  004a a504          	bcp	a,#4
 236  004c 2703          	jreq	L21
 237  004e 4f            	clr	a
 238  004f 2002          	jra	L41
 239  0051               L21:
 240  0051 a601          	ld	a,#1
 241  0053               L41:
 242  0053 b723          	ld	_old_encA,a
 243                     ; 143 		old_encB = (GPIOD->IDR & 0x08) ? false : true;  //PD3 Encoder B
 245  0055 c65010        	ld	a,20496
 246  0058 a508          	bcp	a,#8
 247  005a 2703          	jreq	L61
 248  005c 4f            	clr	a
 249  005d 2002          	jra	L02
 250  005f               L61:
 251  005f a601          	ld	a,#1
 252  0061               L02:
 253  0061 b722          	ld	_old_encB,a
 254                     ; 144 		push_boton = false;
 256  0063 3f27          	clr	_push_boton
 257                     ; 145 		lat_encA = false;
 259  0065 5f            	clrw	x
 260  0066 bf1c          	ldw	_lat_encA,x
 261                     ; 146 		enc_izq = false;
 263  0068 5f            	clrw	x
 264  0069 bf20          	ldw	_enc_izq,x
 265                     ; 147 		enc_der = false;
 267  006b 5f            	clrw	x
 268  006c bf1e          	ldw	_enc_der,x
 269                     ; 148 		item_sel = 0;
 271  006e 3f2a          	clr	_item_sel
 272                     ; 149 		menusel = 0;
 274  0070 3f2b          	clr	_menusel
 275                     ; 150 		is_read = false;
 277  0072 3f1b          	clr	_is_read
 278                     ; 151 		_asm("rim\n"); //Habilita interrupciones
 281  0074 9a            rim
 283                     ; 152 		cont = 0;
 285  0075 3f31          	clr	_cont
 286                     ; 153 		scroll = false;
 288  0077 3f2d          	clr	_scroll
 289                     ; 154 		status = pausa; //Inicia en modo "pausa"
 291  0079 3f2c          	clr	_status
 292                     ; 155 		ST7789_setScrollArea(0, 80);
 294  007b ae0050        	ldw	x,#80
 295  007e 89            	pushw	x
 296  007f 5f            	clrw	x
 297  0080 cd0000        	call	_ST7789_setScrollArea
 299  0083 85            	popw	x
 300                     ; 156 		keyon = true;
 302  0084 35010026      	mov	_keyon,#1
 303  0088               L13:
 304                     ; 159 			if(new_boton && !(GPIOC->IDR & 0x08)) {
 306  0088 3d29          	tnz	_new_boton
 307  008a 2719          	jreq	L53
 309  008c c6500b        	ld	a,20491
 310  008f a508          	bcp	a,#8
 311  0091 2612          	jrne	L53
 312                     ; 160 			  if(!old_boton) {
 314  0093 3d28          	tnz	_old_boton
 315  0095 260a          	jrne	L73
 316                     ; 161 				  push_boton = true;
 318  0097 35010027      	mov	_push_boton,#1
 319                     ; 162 					new_boton = false;
 321  009b 3f29          	clr	_new_boton
 322                     ; 163 					old_boton = false;
 324  009d 3f28          	clr	_old_boton
 326  009f 2004          	jra	L53
 327  00a1               L73:
 328                     ; 165 				  old_boton = true;
 330  00a1 35010028      	mov	_old_boton,#1
 331  00a5               L53:
 332                     ; 168 			if(push_boton){
 334  00a5 3d27          	tnz	_push_boton
 335  00a7 273f          	jreq	L34
 336                     ; 169 				PulsoBeep(largo);
 338  00a9 a601          	ld	a,#1
 339  00ab cd0000        	call	_PulsoBeep
 341                     ; 170 				switch(status){
 343  00ae b62c          	ld	a,_status
 345                     ; 174 				  case submenu: serial_off; SelItemSubMenu(item_sel); break;
 346  00b0 4d            	tnz	a
 347  00b1 270b          	jreq	L3
 348  00b3 4a            	dec	a
 349  00b4 2715          	jreq	L5
 350  00b6 4a            	dec	a
 351  00b7 271d          	jreq	L7
 352  00b9 4a            	dec	a
 353  00ba 2721          	jreq	L11
 354  00bc 2028          	jra	L74
 355  00be               L3:
 356                     ; 171 				  case pausa:  PrintBlack(); serial_on; status = run; break;
 358  00be cd0000        	call	_PrintBlack
 362  00c1 721b5234      	bres	21044,#5
 365  00c5 3501002c      	mov	_status,#1
 368  00c9 201b          	jra	L74
 369  00cb               L5:
 370                     ; 172 				  case run: serial_off; setscr = false; PrintMenu(); break;
 372  00cb 721a5234      	bset	21044,#5
 375  00cf 3f1a          	clr	_setscr
 378  00d1 cd0000        	call	_PrintMenu
 382  00d4 2010          	jra	L74
 383  00d6               L7:
 384                     ; 173 				  case menu: SelItemMenu(item_sel); break;
 386  00d6 b62a          	ld	a,_item_sel
 387  00d8 cd0000        	call	_SelItemMenu
 391  00db 2009          	jra	L74
 392  00dd               L11:
 393                     ; 174 				  case submenu: serial_off; SelItemSubMenu(item_sel); break;
 395  00dd 721a5234      	bset	21044,#5
 398  00e1 b62a          	ld	a,_item_sel
 399  00e3 cd0000        	call	_SelItemSubMenu
 403  00e6               L74:
 404                     ; 176 				push_boton = false;
 406  00e6 3f27          	clr	_push_boton
 407  00e8               L34:
 408                     ; 178 		  if(new_encA) {
 410  00e8 3d25          	tnz	_new_encA
 411  00ea 2728          	jreq	L15
 412                     ; 179   		  if(!old_encB) {
 414  00ec 3d22          	tnz	_old_encB
 415  00ee 2618          	jrne	L35
 416                     ; 180 				  if(!(GPIOD->IDR & 0x04) && !(GPIOD->IDR & 0x08)) {
 418  00f0 c65010        	ld	a,20496
 419  00f3 a504          	bcp	a,#4
 420  00f5 261d          	jrne	L15
 422  00f7 c65010        	ld	a,20496
 423  00fa a508          	bcp	a,#8
 424  00fc 2616          	jrne	L15
 425                     ; 181 						enc_izq = true;
 427  00fe ae0001        	ldw	x,#1
 428  0101 bf20          	ldw	_enc_izq,x
 429                     ; 182 				    BorraFlags();
 431  0103 cd0000        	call	_BorraFlags
 433  0106 200c          	jra	L15
 434  0108               L35:
 435                     ; 185 				  if(!(GPIOD->IDR & 0x04)) lat_encA = true;  //Habilitar old_encA más tarde
 437  0108 c65010        	ld	a,20496
 438  010b a504          	bcp	a,#4
 439  010d 2605          	jrne	L15
 442  010f ae0001        	ldw	x,#1
 443  0112 bf1c          	ldw	_lat_encA,x
 444  0114               L15:
 445                     ; 188 			if(new_encB) {
 447  0114 3d24          	tnz	_new_encB
 448  0116 2727          	jreq	L36
 449                     ; 189   			if(!old_encA) {
 451  0118 3d23          	tnz	_old_encA
 452  011a 2618          	jrne	L56
 453                     ; 190 				  if(!(GPIOD->IDR & 0x04) && !(GPIOD->IDR & 0x08)) {
 455  011c c65010        	ld	a,20496
 456  011f a504          	bcp	a,#4
 457  0121 261c          	jrne	L36
 459  0123 c65010        	ld	a,20496
 460  0126 a508          	bcp	a,#8
 461  0128 2615          	jrne	L36
 462                     ; 191 						enc_der = true;
 464  012a ae0001        	ldw	x,#1
 465  012d bf1e          	ldw	_enc_der,x
 466                     ; 192 						BorraFlags();
 468  012f cd0000        	call	_BorraFlags
 470  0132 200b          	jra	L36
 471  0134               L56:
 472                     ; 195 					if(!(GPIOD->IDR & 0x08)) old_encB = true;
 474  0134 c65010        	ld	a,20496
 475  0137 a508          	bcp	a,#8
 476  0139 2604          	jrne	L36
 479  013b 35010022      	mov	_old_encB,#1
 480  013f               L36:
 481                     ; 198 			if(lat_encA) {      //Si old_encA se activa antes de evaluar new_encB genera error
 483  013f be1c          	ldw	x,_lat_encA
 484  0141 2707          	jreq	L57
 485                     ; 199 				old_encA = true;
 487  0143 35010023      	mov	_old_encA,#1
 488                     ; 200 				lat_encA = false;
 490  0147 5f            	clrw	x
 491  0148 bf1c          	ldw	_lat_encA,x
 492  014a               L57:
 493                     ; 202 			if(enc_izq) {
 495  014a be20          	ldw	x,_enc_izq
 496  014c 274b          	jreq	L77
 497                     ; 203 				if((status > 1)|| setscr) PulsoBeep(corto);
 499  014e b62c          	ld	a,_status
 500  0150 a102          	cp	a,#2
 501  0152 2404          	jruge	L301
 503  0154 3d1a          	tnz	_setscr
 504  0156 2704          	jreq	L101
 505  0158               L301:
 508  0158 4f            	clr	a
 509  0159 cd0000        	call	_PulsoBeep
 511  015c               L101:
 512                     ; 204 				if(status > 1) {
 514  015c b62c          	ld	a,_status
 515  015e a102          	cp	a,#2
 516  0160 2517          	jrult	L501
 517                     ; 205 				  if(item_sel == lista.elem) {
 519  0162 b632          	ld	a,_lista
 520  0164 a40f          	and	a,#15
 521  0166 6b08          	ld	(OFST+0,sp),a
 523  0168 b62a          	ld	a,_item_sel
 524  016a 1108          	cp	a,(OFST+0,sp)
 525  016c 2604          	jrne	L701
 526                     ; 206 				    item_sel = 0;
 528  016e 3f2a          	clr	_item_sel
 530  0170 2002          	jra	L111
 531  0172               L701:
 532                     ; 208 						item_sel++;
 534  0172 3c2a          	inc	_item_sel
 535  0174               L111:
 536                     ; 210 					SelLista(item_sel);
 538  0174 b62a          	ld	a,_item_sel
 539  0176 cd0000        	call	_SelLista
 541  0179               L501:
 542                     ; 212 				if(setscr) {
 544  0179 3d1a          	tnz	_setscr
 545  017b 2719          	jreq	L311
 546                     ; 213 					if(scroll > 20) {
 548  017d b62d          	ld	a,_scroll
 549  017f a115          	cp	a,#21
 550  0181 2508          	jrult	L511
 551                     ; 214 						scroll -= 20;
 553  0183 b62d          	ld	a,_scroll
 554  0185 a014          	sub	a,#20
 555  0187 b72d          	ld	_scroll,a
 557  0189 2004          	jra	L711
 558  018b               L511:
 559                     ; 216 						scroll = 220;
 561  018b 35dc002d      	mov	_scroll,#220
 562  018f               L711:
 563                     ; 218 					ST7789_setScroll(scroll);
 565  018f b62d          	ld	a,_scroll
 566  0191 5f            	clrw	x
 567  0192 97            	ld	xl,a
 568  0193 cd0000        	call	_ST7789_setScroll
 570  0196               L311:
 571                     ; 220 				enc_izq = false;
 573  0196 5f            	clrw	x
 574  0197 bf20          	ldw	_enc_izq,x
 575  0199               L77:
 576                     ; 222 			if(enc_der) {
 578  0199 be1e          	ldw	x,_enc_der
 579  019b 2745          	jreq	L121
 580                     ; 223 				if((status > 1)|| setscr) PulsoBeep(corto);
 582  019d b62c          	ld	a,_status
 583  019f a102          	cp	a,#2
 584  01a1 2404          	jruge	L521
 586  01a3 3d1a          	tnz	_setscr
 587  01a5 2704          	jreq	L321
 588  01a7               L521:
 591  01a7 4f            	clr	a
 592  01a8 cd0000        	call	_PulsoBeep
 594  01ab               L321:
 595                     ; 224 				if(status > 1) {
 597  01ab b62c          	ld	a,_status
 598  01ad a102          	cp	a,#2
 599  01af 2513          	jrult	L721
 600                     ; 225 					if(item_sel == 0) {
 602  01b1 3d2a          	tnz	_item_sel
 603  01b3 2608          	jrne	L131
 604                     ; 226 						item_sel = lista.elem;
 606  01b5 b632          	ld	a,_lista
 607  01b7 a40f          	and	a,#15
 608  01b9 b72a          	ld	_item_sel,a
 610  01bb 2002          	jra	L331
 611  01bd               L131:
 612                     ; 228 						item_sel--;
 614  01bd 3a2a          	dec	_item_sel
 615  01bf               L331:
 616                     ; 230 					SelLista(item_sel);
 618  01bf b62a          	ld	a,_item_sel
 619  01c1 cd0000        	call	_SelLista
 621  01c4               L721:
 622                     ; 232 				if(setscr) {
 624  01c4 3d1a          	tnz	_setscr
 625  01c6 2717          	jreq	L531
 626                     ; 233 					if(scroll < 220) {
 628  01c8 b62d          	ld	a,_scroll
 629  01ca a1dc          	cp	a,#220
 630  01cc 2408          	jruge	L731
 631                     ; 234 						scroll += 20;
 633  01ce b62d          	ld	a,_scroll
 634  01d0 ab14          	add	a,#20
 635  01d2 b72d          	ld	_scroll,a
 637  01d4 2002          	jra	L141
 638  01d6               L731:
 639                     ; 236 						scroll = 0;
 641  01d6 3f2d          	clr	_scroll
 642  01d8               L141:
 643                     ; 238 					ST7789_setScroll(scroll);
 645  01d8 b62d          	ld	a,_scroll
 646  01da 5f            	clrw	x
 647  01db 97            	ld	xl,a
 648  01dc cd0000        	call	_ST7789_setScroll
 650  01df               L531:
 651                     ; 240 				enc_der = false;
 653  01df 5f            	clrw	x
 654  01e0 bf1e          	ldw	_enc_der,x
 655  01e2               L121:
 656                     ; 242 			if((status == run) && is_read) {
 658  01e2 b62c          	ld	a,_status
 659  01e4 a101          	cp	a,#1
 660  01e6 2703          	jreq	L66
 661  01e8 cc0088        	jp	L13
 662  01eb               L66:
 664  01eb 3d1b          	tnz	_is_read
 665  01ed 2603          	jrne	L07
 666  01ef cc0088        	jp	L13
 667  01f2               L07:
 668                     ; 243 				rx_err = ((reg_sr & 0x0F) > 0)? true : false;
 670  01f2 b630          	ld	a,_reg_sr
 671  01f4 a50f          	bcp	a,#15
 672  01f6 2704          	jreq	L22
 673  01f8 a601          	ld	a,#1
 674  01fa 2001          	jra	L42
 675  01fc               L22:
 676  01fc 4f            	clr	a
 677  01fd               L42:
 678  01fd b717          	ld	_rx_err,a
 679                     ; 244 				is_read = false;
 681  01ff 3f1b          	clr	_is_read
 682                     ; 245 			  test = (uint8_t)inChar;
 684  0201 45002f        	mov	_test,_inChar
 685                     ; 246 			  if(((test>0x1F)&(test<0x7F))|((test>0x9F)&(test<0xA6))|(test==0x82)) {
 687  0204 b62f          	ld	a,_test
 688  0206 a182          	cp	a,#130
 689  0208 2605          	jrne	L62
 690  020a ae0001        	ldw	x,#1
 691  020d 2001          	jra	L03
 692  020f               L62:
 693  020f 5f            	clrw	x
 694  0210               L03:
 695  0210 1f07          	ldw	(OFST-1,sp),x
 697  0212 b62f          	ld	a,_test
 698  0214 a1a6          	cp	a,#166
 699  0216 2405          	jruge	L23
 700  0218 ae0001        	ldw	x,#1
 701  021b 2001          	jra	L43
 702  021d               L23:
 703  021d 5f            	clrw	x
 704  021e               L43:
 705  021e 1f05          	ldw	(OFST-3,sp),x
 707  0220 b62f          	ld	a,_test
 708  0222 a1a0          	cp	a,#160
 709  0224 2505          	jrult	L63
 710  0226 ae0001        	ldw	x,#1
 711  0229 2001          	jra	L04
 712  022b               L63:
 713  022b 5f            	clrw	x
 714  022c               L04:
 715  022c 01            	rrwa	x,a
 716  022d 1406          	and	a,(OFST-2,sp)
 717  022f 01            	rrwa	x,a
 718  0230 1405          	and	a,(OFST-3,sp)
 719  0232 01            	rrwa	x,a
 720  0233 1f03          	ldw	(OFST-5,sp),x
 722  0235 b62f          	ld	a,_test
 723  0237 a17f          	cp	a,#127
 724  0239 2405          	jruge	L24
 725  023b ae0001        	ldw	x,#1
 726  023e 2001          	jra	L44
 727  0240               L24:
 728  0240 5f            	clrw	x
 729  0241               L44:
 730  0241 1f01          	ldw	(OFST-7,sp),x
 732  0243 b62f          	ld	a,_test
 733  0245 a120          	cp	a,#32
 734  0247 2505          	jrult	L64
 735  0249 ae0001        	ldw	x,#1
 736  024c 2001          	jra	L05
 737  024e               L64:
 738  024e 5f            	clrw	x
 739  024f               L05:
 740  024f 01            	rrwa	x,a
 741  0250 1402          	and	a,(OFST-6,sp)
 742  0252 01            	rrwa	x,a
 743  0253 1401          	and	a,(OFST-7,sp)
 744  0255 01            	rrwa	x,a
 745  0256 01            	rrwa	x,a
 746  0257 1a04          	or	a,(OFST-4,sp)
 747  0259 01            	rrwa	x,a
 748  025a 1a03          	or	a,(OFST-5,sp)
 749  025c 01            	rrwa	x,a
 750  025d 01            	rrwa	x,a
 751  025e 1a08          	or	a,(OFST+0,sp)
 752  0260 01            	rrwa	x,a
 753  0261 1a07          	or	a,(OFST-1,sp)
 754  0263 01            	rrwa	x,a
 755  0264 a30000        	cpw	x,#0
 756  0267 270a          	jreq	L541
 757                     ; 247 				  texto[cont] = inChar;
 759  0269 b631          	ld	a,_cont
 760  026b 5f            	clrw	x
 761  026c 97            	ld	xl,a
 762  026d b600          	ld	a,_inChar
 763  026f e701          	ld	(_texto,x),a
 764                     ; 248 				  cont++;
 766  0271 3c31          	inc	_cont
 767  0273               L541:
 768                     ; 251 			  if(((test == 0x0A)|(test==0x0D))&(cont>0)) print=true;
 770  0273 3d31          	tnz	_cont
 771  0275 2705          	jreq	L25
 772  0277 ae0001        	ldw	x,#1
 773  027a 2001          	jra	L45
 774  027c               L25:
 775  027c 5f            	clrw	x
 776  027d               L45:
 777  027d 1f07          	ldw	(OFST-1,sp),x
 779  027f b62f          	ld	a,_test
 780  0281 a10d          	cp	a,#13
 781  0283 2605          	jrne	L65
 782  0285 ae0001        	ldw	x,#1
 783  0288 2001          	jra	L06
 784  028a               L65:
 785  028a 5f            	clrw	x
 786  028b               L06:
 787  028b 1f05          	ldw	(OFST-3,sp),x
 789  028d b62f          	ld	a,_test
 790  028f a10a          	cp	a,#10
 791  0291 2605          	jrne	L26
 792  0293 ae0001        	ldw	x,#1
 793  0296 2001          	jra	L46
 794  0298               L26:
 795  0298 5f            	clrw	x
 796  0299               L46:
 797  0299 01            	rrwa	x,a
 798  029a 1a06          	or	a,(OFST-2,sp)
 799  029c 01            	rrwa	x,a
 800  029d 1a05          	or	a,(OFST-3,sp)
 801  029f 01            	rrwa	x,a
 802  02a0 01            	rrwa	x,a
 803  02a1 1408          	and	a,(OFST+0,sp)
 804  02a3 01            	rrwa	x,a
 805  02a4 1407          	and	a,(OFST-1,sp)
 806  02a6 01            	rrwa	x,a
 807  02a7 a30000        	cpw	x,#0
 808  02aa 2704          	jreq	L741
 811  02ac 35010019      	mov	_print,#1
 812  02b0               L741:
 813                     ; 252 			  if(cont==20) {
 815  02b0 b631          	ld	a,_cont
 816  02b2 a114          	cp	a,#20
 817  02b4 2610          	jrne	L151
 818                     ; 253 			    print=true;
 820  02b6 35010019      	mov	_print,#1
 821                     ; 254 				  salto=true;
 823  02ba 35010018      	mov	_salto,#1
 824                     ; 255 				  texto[cont] = '-';
 826  02be b631          	ld	a,_cont
 827  02c0 5f            	clrw	x
 828  02c1 97            	ld	xl,a
 829  02c2 a62d          	ld	a,#45
 830  02c4 e701          	ld	(_texto,x),a
 831  02c6               L151:
 832                     ; 257 				if (print) {
 834  02c6 3d19          	tnz	_print
 835  02c8 2603          	jrne	L27
 836  02ca cc0088        	jp	L13
 837  02cd               L27:
 838                     ; 258 				  Print_RX();
 840  02cd cd0000        	call	_Print_RX
 842                     ; 259 					FillTexto();
 844  02d0 cd0000        	call	_FillTexto
 846                     ; 260 				  cont = 0;
 848  02d3 3f31          	clr	_cont
 849                     ; 261 				  if(salto && !rx_err) {
 851  02d5 3d18          	tnz	_salto
 852  02d7 270a          	jreq	L551
 854  02d9 3d17          	tnz	_rx_err
 855  02db 2606          	jrne	L551
 856                     ; 262 				    texto[cont] = '-';
 858  02dd 352d0001      	mov	_texto,#45
 859                     ; 263 				  	cont++;
 861  02e1 3c31          	inc	_cont
 862  02e3               L551:
 863                     ; 265 				  print = false;
 865  02e3 3f19          	clr	_print
 866                     ; 266 				  salto = false;
 868  02e5 3f18          	clr	_salto
 869                     ; 267 				  if(setscr) {
 871  02e7 3d1a          	tnz	_setscr
 872  02e9 2719          	jreq	L751
 873                     ; 268 				  	scroll +=20;
 875  02eb b62d          	ld	a,_scroll
 876  02ed ab14          	add	a,#20
 877  02ef b72d          	ld	_scroll,a
 878                     ; 269 				  	if(scroll > 220) scroll = 0;
 880  02f1 b62d          	ld	a,_scroll
 881  02f3 a1dd          	cp	a,#221
 882  02f5 2502          	jrult	L161
 885  02f7 3f2d          	clr	_scroll
 886  02f9               L161:
 887                     ; 270 				  	ST7789_setScroll(scroll);
 889  02f9 b62d          	ld	a,_scroll
 890  02fb 5f            	clrw	x
 891  02fc 97            	ld	xl,a
 892  02fd cd0000        	call	_ST7789_setScroll
 895  0300 ac880088      	jpf	L13
 896  0304               L751:
 897                     ; 272 				  	if(linea < 220) {
 899  0304 b62e          	ld	a,_linea
 900  0306 a1dc          	cp	a,#220
 901  0308 240a          	jruge	L561
 902                     ; 273 					  	linea += 20;
 904  030a b62e          	ld	a,_linea
 905  030c ab14          	add	a,#20
 906  030e b72e          	ld	_linea,a
 908  0310 ac880088      	jpf	L13
 909  0314               L561:
 910                     ; 275 						  linea = 0;
 912  0314 3f2e          	clr	_linea
 913                     ; 276 						  setscr = true;
 915  0316 3501001a      	mov	_setscr,#1
 916  031a ac880088      	jpf	L13
 939                     ; 287 void CLK_Config(void) {
 940                     .text:	section	.text,new
 941  0000               _CLK_Config:
 945                     ; 290 	CLK->ICKR |= 0x01;           // HSI encendido (HSION)
 947  0000 721050c0      	bset	20672,#0
 949  0004               L302:
 950                     ; 291 	while (!(CLK->ICKR & 0x02)); // Esperar hasta que HSI esté listo (HSIRDY)
 952  0004 c650c0        	ld	a,20672
 953  0007 a502          	bcp	a,#2
 954  0009 27f9          	jreq	L302
 955                     ; 293 	CLK->SWR = 0xE1;             // Seleccionar HSI como origen del reloj maestro
 957  000b 35e150c4      	mov	20676,#225
 958                     ; 294 	CLK->CKDIVR = 0x00;          // Configurar divisor en 1 (reloj de CPU a 16 MHz)
 960  000f 725f50c6      	clr	20678
 961                     ; 295 }
 964  0013 81            	ret
 987                     ; 297 void GPIO_Config(void) {
 988                     .text:	section	.text,new
 989  0000               _GPIO_Config:
 993                     ; 298 		GPIOC->DDR = 0xF0;  // PC7, PC6, PC5 y PC4 como salidas/ PC3 como entrada
 995  0000 35f0500c      	mov	20492,#240
 996                     ; 299 		GPIOC->CR1 = 0xF8;  // PC7, PC6, PC5 y PC4 modo Push-Pull/ PC3 modo Pull-Up
 998  0004 35f8500d      	mov	20493,#248
 999                     ; 300 		GPIOC->CR2 = 0xF8;  // PC7, PC6, PC5 y PC4 modo High-Fast/ PC3 modo interrupcion
1001  0008 35f8500e      	mov	20494,#248
1002                     ; 302 		GPIOB->DDR = 0x20;  // PB5 como salida, PB4 como entrada (PB5=Led, PB4=Push)
1004  000c 35205007      	mov	20487,#32
1005                     ; 303 		GPIOB->CR1 = 0x00;  // PB5 modo Open Drain
1007  0010 725f5008      	clr	20488
1008                     ; 304 		GPIOB->CR2 = 0x00;  // PB5 Modo low fast
1010  0014 725f5009      	clr	20489
1011                     ; 305 		GPIOB->ODR |= 0x20; // PB5 Led apagado
1013  0018 721a5005      	bset	20485,#5
1014                     ; 307 		GPIOD->DDR = 0x10;  // PD2, PD3 y PD6 como entradas, PD4 como salida (PD2=EncA, PD3=EncB, PD4=Beep, PD6=RX)
1016  001c 35105011      	mov	20497,#16
1017                     ; 308 		GPIOD->CR1 = 0x4C;  // PD2, PD3 y PD6 modo Pull-up, PD4 modo Open-Drain
1019  0020 354c5012      	mov	20498,#76
1020                     ; 309 		GPIOD->CR2 = 0x4C;  // PD2 y PD3 modo interrupcion, PD6 modo High-Fast
1022  0024 354c5013      	mov	20499,#76
1023                     ; 310 } 
1026  0028 81            	ret
1049                     ; 312 void EXTI_Config(void) {
1050                     .text:	section	.text,new
1051  0000               _EXTI_Config:
1055                     ; 313 	  EXTI->CR1 = 0xA0;
1057  0000 35a050a0      	mov	20640,#160
1058                     ; 314 	}
1061  0004 81            	ret
1086                     ; 316 void SPI_Config(void) {
1087                     .text:	section	.text,new
1088  0000               _SPI_Config:
1092                     ; 321     SPI_Init(SPI_FIRSTBIT_MSB, 
1092                     ; 322              SPI_BAUDRATEPRESCALER_2, 
1092                     ; 323              SPI_MODE_MASTER, 
1092                     ; 324              SPI_CLOCKPOLARITY_HIGH, 
1092                     ; 325              SPI_CLOCKPHASE_2EDGE, 
1092                     ; 326              SPI_DATADIRECTION_1LINE_TX, 
1092                     ; 327              SPI_NSS_SOFT, 
1092                     ; 328              0x07);
1094  0000 4b07          	push	#7
1095  0002 4b02          	push	#2
1096  0004 4bc0          	push	#192
1097  0006 4b01          	push	#1
1098  0008 4b02          	push	#2
1099  000a 4b04          	push	#4
1100  000c 5f            	clrw	x
1101  000d cd0000        	call	_SPI_Init
1103  0010 5b06          	addw	sp,#6
1104                     ; 330     SPI_Cmd(ENABLE);
1106  0012 a601          	ld	a,#1
1107  0014 cd0000        	call	_SPI_Cmd
1109                     ; 331  }
1112  0017 81            	ret
1138                     ; 333 void UART_config(void) {
1139                     .text:	section	.text,new
1140  0000               _UART_config:
1144                     ; 334 	UART1->BRR1 = bbr1[s_conf.baud];
1146  0000 b633          	ld	a,_s_conf
1147  0002 a407          	and	a,#7
1148  0004 ab0a          	add	a,#_bbr1
1149  0006 5f            	clrw	x
1150  0007 97            	ld	xl,a
1151  0008 f6            	ld	a,(x)
1152  0009 c75232        	ld	21042,a
1153                     ; 335   UART1->BRR2 = bbr2[s_conf.baud];
1155  000c b633          	ld	a,_s_conf
1156  000e a407          	and	a,#7
1157  0010 ab0f          	add	a,#_bbr2
1158  0012 5f            	clrw	x
1159  0013 97            	ld	xl,a
1160  0014 f6            	ld	a,(x)
1161  0015 c75233        	ld	21043,a
1162                     ; 337 	UART1->CR3 &= 0xCF;
1164  0018 c65236        	ld	a,21046
1165  001b a4cf          	and	a,#207
1166  001d c75236        	ld	21046,a
1167                     ; 338 	if(s_conf.stop) UART1->CR3 |= 0x20; // 1 o 2 stop bit
1169  0020 b633          	ld	a,_s_conf
1170  0022 a510          	bcp	a,#16
1171  0024 2704          	jreq	L742
1174  0026 721a5236      	bset	21046,#5
1175  002a               L742:
1176                     ; 339 	UART1->CR2 |= 0x24; // RIEN + REN
1178  002a c65235        	ld	a,21045
1179  002d aa24          	or	a,#36
1180  002f c75235        	ld	21045,a
1181                     ; 341 	UART1->CR1 &= 0xC9;
1183  0032 c65234        	ld	a,21044
1184  0035 a4c9          	and	a,#201
1185  0037 c75234        	ld	21044,a
1186                     ; 342 	if(s_conf.lbit) UART1->CR1 |= 0x20; // 8bits o 9bits de longitud
1188  003a b633          	ld	a,_s_conf
1189  003c a508          	bcp	a,#8
1190  003e 2704          	jreq	L152
1193  0040 721a5234      	bset	21044,#5
1194  0044               L152:
1195                     ; 343 	if(s_conf.pari) UART1->CR1 |= 0x04; // paridad no o si
1197  0044 b633          	ld	a,_s_conf
1198  0046 a520          	bcp	a,#32
1199  0048 2704          	jreq	L352
1202  004a 72145234      	bset	21044,#2
1203  004e               L352:
1204                     ; 344 	if(s_conf.tpar) UART1->CR1 |= 0x02; // paridad par o impar
1206  004e b633          	ld	a,_s_conf
1207  0050 a540          	bcp	a,#64
1208  0052 2704          	jreq	L552
1211  0054 72125234      	bset	21044,#1
1212  0058               L552:
1213                     ; 345 }
1216  0058 81            	ret
1243                     ; 347 void LSI_Calibration(void)
1243                     ; 348 {
1244                     .text:	section	.text,new
1245  0000               _LSI_Calibration:
1247  0000 5204          	subw	sp,#4
1248       00000004      OFST:	set	4
1251                     ; 349     CLK->ICKR |= CLK_ICKR_LSIEN;   // 1. Habilitar el oscilador LSI
1253  0002 721650c0      	bset	20672,#3
1255  0006               L172:
1256                     ; 350     while ((CLK->ICKR & CLK_ICKR_LSIRDY) == 0); // Esperar a que se estabilice
1258  0006 c650c0        	ld	a,20672
1259  0009 a510          	bcp	a,#16
1260  000b 27f9          	jreq	L172
1261                     ; 354     AWU->CSR |= AWU_CSR_MSR;       // Conecta la medición AWU/LSI al Timer
1263  000d 721050f0      	bset	20720,#0
1264                     ; 357     TIM1->CCMR1 = 0x01; // CC1 asignado a la entrada TI1FP1
1266  0011 35015258      	mov	21080,#1
1267                     ; 358     TIM1->CCER1 = 0x01; // Captura en flanco de subida, habilitar captura
1269  0015 3501525c      	mov	21084,#1
1270                     ; 359     TIM1->CR1 |= TIM1_CR1_CEN; // Encender TIM1
1272  0019 72105250      	bset	21072,#0
1274  001d               L772:
1275                     ; 362     while ((TIM1->SR1 & TIM1_SR1_CC1IF) == 0);
1277  001d c65255        	ld	a,21077
1278  0020 a502          	bcp	a,#2
1279  0022 27f9          	jreq	L772
1280                     ; 363     capture1 = ((uint16_t)TIM1->CCR1H << 8) | TIM1->CCR1L;
1282  0024 c65265        	ld	a,21093
1283  0027 5f            	clrw	x
1284  0028 97            	ld	xl,a
1285  0029 c65266        	ld	a,21094
1286  002c 02            	rlwa	x,a
1287  002d bf04          	ldw	_capture1,x
1288                     ; 364     TIM1->SR1 &= ~TIM1_SR1_CC1IF; // Borrar bandera
1290  002f 72135255      	bres	21077,#1
1292  0033               L503:
1293                     ; 367     while ((TIM1->SR1 & TIM1_SR1_CC1IF) == 0);
1295  0033 c65255        	ld	a,21077
1296  0036 a502          	bcp	a,#2
1297  0038 27f9          	jreq	L503
1298                     ; 368     capture2 = ((uint16_t)TIM1->CCR1H << 8) | TIM1->CCR1L;
1300  003a c65265        	ld	a,21093
1301  003d 5f            	clrw	x
1302  003e 97            	ld	xl,a
1303  003f c65266        	ld	a,21094
1304  0042 02            	rlwa	x,a
1305  0043 bf06          	ldw	_capture2,x
1306                     ; 369     TIM1->SR1 &= ~TIM1_SR1_CC1IF; // Borrar bandera
1308  0045 72135255      	bres	21077,#1
1309                     ; 372     TIM1->CR1 &= ~TIM1_CR1_CEN;
1311  0049 72115250      	bres	21072,#0
1312                     ; 373     AWU->CSR &= ~AWU_CSR_MSR;
1314  004d 721150f0      	bres	20720,#0
1315                     ; 376     if (capture2 > capture1)
1317  0051 be06          	ldw	x,_capture2
1318  0053 b304          	cpw	x,_capture1
1319  0055 230a          	jrule	L113
1320                     ; 378         periodticks = capture2 - capture1;
1322  0057 be06          	ldw	x,_capture2
1323  0059 72b00004      	subw	x,_capture1
1324  005d bf08          	ldw	_periodticks,x
1326  005f 200e          	jra	L313
1327  0061               L113:
1328                     ; 382         periodticks = (0xFFFF - capture1) + capture2 + 1;
1330  0061 aeffff        	ldw	x,#65535
1331  0064 72b00004      	subw	x,_capture1
1332  0068 72bb0006      	addw	x,_capture2
1333  006c 5c            	incw	x
1334  006d bf08          	ldw	_periodticks,x
1335  006f               L313:
1336                     ; 387     LSI_Frequency_Hz = (uint32_t)(16000000UL / periodticks);
1338  006f be08          	ldw	x,_periodticks
1339  0071 cd0000        	call	c_uitolx
1341  0074 96            	ldw	x,sp
1342  0075 1c0001        	addw	x,#OFST-3
1343  0078 cd0000        	call	c_rtol
1346  007b ae2400        	ldw	x,#9216
1347  007e bf02          	ldw	c_lreg+2,x
1348  0080 ae00f4        	ldw	x,#244
1349  0083 bf00          	ldw	c_lreg,x
1350  0085 96            	ldw	x,sp
1351  0086 1c0001        	addw	x,#OFST-3
1352  0089 cd0000        	call	c_ludv
1354  008c ae0000        	ldw	x,#_LSI_Frequency_Hz
1355  008f cd0000        	call	c_rtol
1357                     ; 388 }
1360  0092 5b04          	addw	sp,#4
1361  0094 81            	ret
1398                     .const:	section	.text
1399  0000               L211:
1400  0000 00001f40      	dc.l	8000
1401                     ; 390 void BEEP_Init_Calibrated(void) //Inicia BEEP (salida en PD4)
1401                     ; 391 {
1402                     .text:	section	.text,new
1403  0000               _BEEP_Init_Calibrated:
1405  0000 88            	push	a
1406       00000001      OFST:	set	1
1409                     ; 392     uint8_t beep_div = 0;
1411                     ; 394     LSI_Calibration();    // Ejecutar calibración primero
1413  0001 cd0000        	call	_LSI_Calibration
1415                     ; 400 		beep_div = (uint8_t)(LSI_Frequency_Hz / 8000)-2; 
1417  0004 ae0000        	ldw	x,#_LSI_Frequency_Hz
1418  0007 cd0000        	call	c_ltor
1420  000a ae0000        	ldw	x,#L211
1421  000d cd0000        	call	c_ludv
1423  0010 b603          	ld	a,c_lreg+3
1424  0012 a002          	sub	a,#2
1425  0014 6b01          	ld	(OFST+0,sp),a
1427                     ; 403     if (beep_div == 0x1F) beep_div++; // Límite máximo de 5 bits (0 a 31)
1429  0016 7b01          	ld	a,(OFST+0,sp)
1430  0018 a11f          	cp	a,#31
1431  001a 2602          	jrne	L333
1434  001c 0c01          	inc	(OFST+0,sp)
1436  001e               L333:
1437                     ; 407     BEEP->CSR = (uint8_t)((BEEP->CSR & (uint8_t)(~BEEP_CSR_BEEPDIV)) | beep_div);
1439  001e c650f3        	ld	a,20723
1440  0021 a4e0          	and	a,#224
1441  0023 1a01          	or	a,(OFST+0,sp)
1442  0025 c750f3        	ld	20723,a
1443                     ; 410     BEEP->CSR |= (uint8_t)(1 << 6); 
1445  0028 721c50f3      	bset	20723,#6
1446                     ; 411 }
1449  002c 84            	pop	a
1450  002d 81            	ret
1514                     ; 422 void PulsoBeep(bool largo) {
1515                     .text:	section	.text,new
1516  0000               _PulsoBeep:
1518  0000 89            	pushw	x
1519       00000002      OFST:	set	2
1522                     ; 424 	beep_on;
1524  0001 721a50f3      	bset	20723,#5
1525                     ; 425 	for(i=(largo)? 50000: 15000; i>0; i--);
1527  0005 4d            	tnz	a
1528  0006 2705          	jreq	L611
1529  0008 aec350        	ldw	x,#50000
1530  000b 2003          	jra	L021
1531  000d               L611:
1532  000d ae3a98        	ldw	x,#15000
1533  0010               L021:
1534  0010 1f01          	ldw	(OFST-1,sp),x
1537  0012 2007          	jra	L373
1538  0014               L763:
1542  0014 1e01          	ldw	x,(OFST-1,sp)
1543  0016 1d0001        	subw	x,#1
1544  0019 1f01          	ldw	(OFST-1,sp),x
1546  001b               L373:
1549  001b 1e01          	ldw	x,(OFST-1,sp)
1550  001d 26f5          	jrne	L763
1551                     ; 426 	beep_off;
1553  001f 721b50f3      	bres	20723,#5
1554                     ; 427 }
1557  0023 85            	popw	x
1558  0024 81            	ret
1593                     ; 429 void FillTexto(void) {
1594                     .text:	section	.text,new
1595  0000               _FillTexto:
1597  0000 88            	push	a
1598       00000001      OFST:	set	1
1601                     ; 431 	for(i=0; i<21; i++) texto[i] = 0x00;
1603  0001 0f01          	clr	(OFST+0,sp)
1605  0003               L514:
1608  0003 7b01          	ld	a,(OFST+0,sp)
1609  0005 5f            	clrw	x
1610  0006 97            	ld	xl,a
1611  0007 6f01          	clr	(_texto,x)
1614  0009 0c01          	inc	(OFST+0,sp)
1618  000b 7b01          	ld	a,(OFST+0,sp)
1619  000d a115          	cp	a,#21
1620  000f 25f2          	jrult	L514
1621                     ; 432 }
1624  0011 84            	pop	a
1625  0012 81            	ret
1652                     ; 434 void BorraFlags(void) {
1653                     .text:	section	.text,new
1654  0000               _BorraFlags:
1658                     ; 435 	old_encA = false;
1660  0000 3f23          	clr	_old_encA
1661                     ; 436 	old_encB = false;
1663  0002 3f22          	clr	_old_encB
1664                     ; 437 	new_encB = false;
1666  0004 3f24          	clr	_new_encB
1667                     ; 438 	new_encA = false;
1669  0006 3f25          	clr	_new_encA
1670                     ; 439 }
1673  0008 81            	ret
1705                     ; 441 void Print_Inicio(void) {
1706                     .text:	section	.text,new
1707  0000               _Print_Inicio:
1711                     ; 443 		ST7789_Clear(BLACK);
1713  0000 5f            	clrw	x
1714  0001 cd0000        	call	_ST7789_Clear
1716                     ; 444 		ST7789_WriteString(20,0, "-------------------", Font_11x18, MAGENTA, BLACK);
1718  0004 5f            	clrw	x
1719  0005 89            	pushw	x
1720  0006 aef81f        	ldw	x,#63519
1721  0009 89            	pushw	x
1722  000a b603          	ld	a,_Font_11x18+3
1723  000c 88            	push	a
1724  000d b602          	ld	a,_Font_11x18+2
1725  000f 88            	push	a
1726  0010 b601          	ld	a,_Font_11x18+1
1727  0012 88            	push	a
1728  0013 b600          	ld	a,_Font_11x18
1729  0015 88            	push	a
1730  0016 ae0042        	ldw	x,#L344
1731  0019 89            	pushw	x
1732  001a 5f            	clrw	x
1733  001b 89            	pushw	x
1734  001c ae0014        	ldw	x,#20
1735  001f cd0000        	call	_ST7789_WriteString
1737  0022 5b0c          	addw	sp,#12
1738                     ; 445 		ST7789_WriteString(20,20, "Terminal", Font_11x18, MAGENTA, BLACK);
1740  0024 5f            	clrw	x
1741  0025 89            	pushw	x
1742  0026 aef81f        	ldw	x,#63519
1743  0029 89            	pushw	x
1744  002a b603          	ld	a,_Font_11x18+3
1745  002c 88            	push	a
1746  002d b602          	ld	a,_Font_11x18+2
1747  002f 88            	push	a
1748  0030 b601          	ld	a,_Font_11x18+1
1749  0032 88            	push	a
1750  0033 b600          	ld	a,_Font_11x18
1751  0035 88            	push	a
1752  0036 ae0039        	ldw	x,#L544
1753  0039 89            	pushw	x
1754  003a ae0014        	ldw	x,#20
1755  003d 89            	pushw	x
1756  003e ae0014        	ldw	x,#20
1757  0041 cd0000        	call	_ST7789_WriteString
1759  0044 5b0c          	addw	sp,#12
1760                     ; 447 		ST7789_WriteString(30,40, _objeto[0], Font_11x18, GRAY, BLACK);
1762  0046 5f            	clrw	x
1763  0047 89            	pushw	x
1764  0048 ae8430        	ldw	x,#33840
1765  004b 89            	pushw	x
1766  004c b603          	ld	a,_Font_11x18+3
1767  004e 88            	push	a
1768  004f b602          	ld	a,_Font_11x18+2
1769  0051 88            	push	a
1770  0052 b601          	ld	a,_Font_11x18+1
1771  0054 88            	push	a
1772  0055 b600          	ld	a,_Font_11x18
1773  0057 88            	push	a
1774  0058 ae002d        	ldw	x,#__objeto
1775  005b 89            	pushw	x
1776  005c ae0028        	ldw	x,#40
1777  005f 89            	pushw	x
1778  0060 ae001e        	ldw	x,#30
1779  0063 cd0000        	call	_ST7789_WriteString
1781  0066 5b0c          	addw	sp,#12
1782                     ; 448 		ST7789_WriteString(96,40, _baudios[s_conf.baud], Font_11x18, GRAY, BLACK);
1784  0068 5f            	clrw	x
1785  0069 89            	pushw	x
1786  006a ae8430        	ldw	x,#33840
1787  006d 89            	pushw	x
1788  006e b603          	ld	a,_Font_11x18+3
1789  0070 88            	push	a
1790  0071 b602          	ld	a,_Font_11x18+2
1791  0073 88            	push	a
1792  0074 b601          	ld	a,_Font_11x18+1
1793  0076 88            	push	a
1794  0077 b600          	ld	a,_Font_11x18
1795  0079 88            	push	a
1796  007a b633          	ld	a,_s_conf
1797  007c a407          	and	a,#7
1798  007e 5f            	clrw	x
1799  007f 02            	rlwa	x,a
1800  0080 a607          	ld	a,#7
1801  0082 cd0000        	call	c_bmulx
1803  0085 1c0045        	addw	x,#__baudios
1804  0088 89            	pushw	x
1805  0089 ae0028        	ldw	x,#40
1806  008c 89            	pushw	x
1807  008d ae0060        	ldw	x,#96
1808  0090 cd0000        	call	_ST7789_WriteString
1810  0093 5b0c          	addw	sp,#12
1811                     ; 450 		ST7789_WriteString(30,60, _objeto[1], Font_11x18, GRAY, BLACK);
1813  0095 5f            	clrw	x
1814  0096 89            	pushw	x
1815  0097 ae8430        	ldw	x,#33840
1816  009a 89            	pushw	x
1817  009b b603          	ld	a,_Font_11x18+3
1818  009d 88            	push	a
1819  009e b602          	ld	a,_Font_11x18+2
1820  00a0 88            	push	a
1821  00a1 b601          	ld	a,_Font_11x18+1
1822  00a3 88            	push	a
1823  00a4 b600          	ld	a,_Font_11x18
1824  00a6 88            	push	a
1825  00a7 ae0033        	ldw	x,#__objeto+6
1826  00aa 89            	pushw	x
1827  00ab ae003c        	ldw	x,#60
1828  00ae 89            	pushw	x
1829  00af ae001e        	ldw	x,#30
1830  00b2 cd0000        	call	_ST7789_WriteString
1832  00b5 5b0c          	addw	sp,#12
1833                     ; 451 		ST7789_WriteString(96,60, _datab[s_conf.lbit], Font_11x18, GRAY, BLACK);
1835  00b7 5f            	clrw	x
1836  00b8 89            	pushw	x
1837  00b9 ae8430        	ldw	x,#33840
1838  00bc 89            	pushw	x
1839  00bd b603          	ld	a,_Font_11x18+3
1840  00bf 88            	push	a
1841  00c0 b602          	ld	a,_Font_11x18+2
1842  00c2 88            	push	a
1843  00c3 b601          	ld	a,_Font_11x18+1
1844  00c5 88            	push	a
1845  00c6 b600          	ld	a,_Font_11x18
1846  00c8 88            	push	a
1847  00c9 4f            	clr	a
1848                     	btst	_s_conf,#3
1849  00cf 49            	rlc	a
1850  00d0 5f            	clrw	x
1851  00d1 02            	rlwa	x,a
1852  00d2 a607          	ld	a,#7
1853  00d4 cd0000        	call	c_bmulx
1855  00d7 1c006f        	addw	x,#__datab
1856  00da 89            	pushw	x
1857  00db ae003c        	ldw	x,#60
1858  00de 89            	pushw	x
1859  00df ae0060        	ldw	x,#96
1860  00e2 cd0000        	call	_ST7789_WriteString
1862  00e5 5b0c          	addw	sp,#12
1863                     ; 453 		ST7789_WriteString(30,80, _objeto[2], Font_11x18, GRAY, BLACK);
1865  00e7 5f            	clrw	x
1866  00e8 89            	pushw	x
1867  00e9 ae8430        	ldw	x,#33840
1868  00ec 89            	pushw	x
1869  00ed b603          	ld	a,_Font_11x18+3
1870  00ef 88            	push	a
1871  00f0 b602          	ld	a,_Font_11x18+2
1872  00f2 88            	push	a
1873  00f3 b601          	ld	a,_Font_11x18+1
1874  00f5 88            	push	a
1875  00f6 b600          	ld	a,_Font_11x18
1876  00f8 88            	push	a
1877  00f9 ae0039        	ldw	x,#__objeto+12
1878  00fc 89            	pushw	x
1879  00fd ae0050        	ldw	x,#80
1880  0100 89            	pushw	x
1881  0101 ae001e        	ldw	x,#30
1882  0104 cd0000        	call	_ST7789_WriteString
1884  0107 5b0c          	addw	sp,#12
1885                     ; 454 		ST7789_WriteString(96,80, _stopb[s_conf.stop], Font_11x18, GRAY, BLACK);
1887  0109 5f            	clrw	x
1888  010a 89            	pushw	x
1889  010b ae8430        	ldw	x,#33840
1890  010e 89            	pushw	x
1891  010f b603          	ld	a,_Font_11x18+3
1892  0111 88            	push	a
1893  0112 b602          	ld	a,_Font_11x18+2
1894  0114 88            	push	a
1895  0115 b601          	ld	a,_Font_11x18+1
1896  0117 88            	push	a
1897  0118 b600          	ld	a,_Font_11x18
1898  011a 88            	push	a
1899  011b 4f            	clr	a
1900                     	btst	_s_conf,#4
1901  0121 49            	rlc	a
1902  0122 5f            	clrw	x
1903  0123 02            	rlwa	x,a
1904  0124 a607          	ld	a,#7
1905  0126 cd0000        	call	c_bmulx
1907  0129 1c0084        	addw	x,#__stopb
1908  012c 89            	pushw	x
1909  012d ae0050        	ldw	x,#80
1910  0130 89            	pushw	x
1911  0131 ae0060        	ldw	x,#96
1912  0134 cd0000        	call	_ST7789_WriteString
1914  0137 5b0c          	addw	sp,#12
1915                     ; 456 		ST7789_WriteString(30,100, _objeto[3], Font_11x18, GRAY, BLACK);
1917  0139 5f            	clrw	x
1918  013a 89            	pushw	x
1919  013b ae8430        	ldw	x,#33840
1920  013e 89            	pushw	x
1921  013f b603          	ld	a,_Font_11x18+3
1922  0141 88            	push	a
1923  0142 b602          	ld	a,_Font_11x18+2
1924  0144 88            	push	a
1925  0145 b601          	ld	a,_Font_11x18+1
1926  0147 88            	push	a
1927  0148 b600          	ld	a,_Font_11x18
1928  014a 88            	push	a
1929  014b ae003f        	ldw	x,#__objeto+18
1930  014e 89            	pushw	x
1931  014f ae0064        	ldw	x,#100
1932  0152 89            	pushw	x
1933  0153 ae001e        	ldw	x,#30
1934  0156 cd0000        	call	_ST7789_WriteString
1936  0159 5b0c          	addw	sp,#12
1937                     ; 457 		if(s_conf.pari) {
1939  015b b633          	ld	a,_s_conf
1940  015d a520          	bcp	a,#32
1941  015f 2732          	jreq	L744
1942                     ; 458 			ST7789_WriteString(96,100, _paridad[s_conf.tpar + 1], Font_11x18, GRAY, BLACK);
1944  0161 5f            	clrw	x
1945  0162 89            	pushw	x
1946  0163 ae8430        	ldw	x,#33840
1947  0166 89            	pushw	x
1948  0167 b603          	ld	a,_Font_11x18+3
1949  0169 88            	push	a
1950  016a b602          	ld	a,_Font_11x18+2
1951  016c 88            	push	a
1952  016d b601          	ld	a,_Font_11x18+1
1953  016f 88            	push	a
1954  0170 b600          	ld	a,_Font_11x18
1955  0172 88            	push	a
1956  0173 4f            	clr	a
1957                     	btst	_s_conf,#6
1958  0179 49            	rlc	a
1959  017a 5f            	clrw	x
1960  017b 02            	rlwa	x,a
1961  017c a607          	ld	a,#7
1962  017e cd0000        	call	c_bmulx
1964  0181 1c00a0        	addw	x,#__paridad+7
1965  0184 89            	pushw	x
1966  0185 ae0064        	ldw	x,#100
1967  0188 89            	pushw	x
1968  0189 ae0060        	ldw	x,#96
1969  018c cd0000        	call	_ST7789_WriteString
1971  018f 5b0c          	addw	sp,#12
1973  0191 2022          	jra	L154
1974  0193               L744:
1975                     ; 460 			ST7789_WriteString(96,100, _paridad[0], Font_11x18, GRAY, BLACK);
1977  0193 5f            	clrw	x
1978  0194 89            	pushw	x
1979  0195 ae8430        	ldw	x,#33840
1980  0198 89            	pushw	x
1981  0199 b603          	ld	a,_Font_11x18+3
1982  019b 88            	push	a
1983  019c b602          	ld	a,_Font_11x18+2
1984  019e 88            	push	a
1985  019f b601          	ld	a,_Font_11x18+1
1986  01a1 88            	push	a
1987  01a2 b600          	ld	a,_Font_11x18
1988  01a4 88            	push	a
1989  01a5 ae0099        	ldw	x,#__paridad
1990  01a8 89            	pushw	x
1991  01a9 ae0064        	ldw	x,#100
1992  01ac 89            	pushw	x
1993  01ad ae0060        	ldw	x,#96
1994  01b0 cd0000        	call	_ST7789_WriteString
1996  01b3 5b0c          	addw	sp,#12
1997  01b5               L154:
1998                     ; 462 		ST7789_WriteString(20,120, "-------------------", Font_11x18, MAGENTA, BLACK);
2000  01b5 5f            	clrw	x
2001  01b6 89            	pushw	x
2002  01b7 aef81f        	ldw	x,#63519
2003  01ba 89            	pushw	x
2004  01bb b603          	ld	a,_Font_11x18+3
2005  01bd 88            	push	a
2006  01be b602          	ld	a,_Font_11x18+2
2007  01c0 88            	push	a
2008  01c1 b601          	ld	a,_Font_11x18+1
2009  01c3 88            	push	a
2010  01c4 b600          	ld	a,_Font_11x18
2011  01c6 88            	push	a
2012  01c7 ae0042        	ldw	x,#L344
2013  01ca 89            	pushw	x
2014  01cb ae0078        	ldw	x,#120
2015  01ce 89            	pushw	x
2016  01cf ae0014        	ldw	x,#20
2017  01d2 cd0000        	call	_ST7789_WriteString
2019  01d5 5b0c          	addw	sp,#12
2020                     ; 463 		ST7789_WriteString(10,160, "Pausa...", Font_11x18, LIGHTBLUE, BLACK);
2022  01d7 5f            	clrw	x
2023  01d8 89            	pushw	x
2024  01d9 ae7d7c        	ldw	x,#32124
2025  01dc 89            	pushw	x
2026  01dd b603          	ld	a,_Font_11x18+3
2027  01df 88            	push	a
2028  01e0 b602          	ld	a,_Font_11x18+2
2029  01e2 88            	push	a
2030  01e3 b601          	ld	a,_Font_11x18+1
2031  01e5 88            	push	a
2032  01e6 b600          	ld	a,_Font_11x18
2033  01e8 88            	push	a
2034  01e9 ae0030        	ldw	x,#L354
2035  01ec 89            	pushw	x
2036  01ed ae00a0        	ldw	x,#160
2037  01f0 89            	pushw	x
2038  01f1 ae000a        	ldw	x,#10
2039  01f4 cd0000        	call	_ST7789_WriteString
2041  01f7 5b0c          	addw	sp,#12
2042                     ; 464 }
2045  01f9 81            	ret
2073                     ; 466 void PrintBlack(void) {
2074                     .text:	section	.text,new
2075  0000               _PrintBlack:
2079                     ; 467 	keyon = disable;
2081  0000 3f26          	clr	_keyon
2082                     ; 468 	ST7789_Clear(BLACK);
2084  0002 5f            	clrw	x
2085  0003 cd0000        	call	_ST7789_Clear
2087                     ; 469 	ST7789_WriteString(0,20, ">", Font_11x18, GREEN, BLACK);
2089  0006 5f            	clrw	x
2090  0007 89            	pushw	x
2091  0008 ae07e0        	ldw	x,#2016
2092  000b 89            	pushw	x
2093  000c b603          	ld	a,_Font_11x18+3
2094  000e 88            	push	a
2095  000f b602          	ld	a,_Font_11x18+2
2096  0011 88            	push	a
2097  0012 b601          	ld	a,_Font_11x18+1
2098  0014 88            	push	a
2099  0015 b600          	ld	a,_Font_11x18
2100  0017 88            	push	a
2101  0018 ae002e        	ldw	x,#L564
2102  001b 89            	pushw	x
2103  001c ae0014        	ldw	x,#20
2104  001f 89            	pushw	x
2105  0020 5f            	clrw	x
2106  0021 cd0000        	call	_ST7789_WriteString
2108  0024 5b0c          	addw	sp,#12
2109                     ; 470 	linea = 20;
2111  0026 3514002e      	mov	_linea,#20
2112                     ; 471 	keyon = enable;
2114  002a 35010026      	mov	_keyon,#1
2115                     ; 472 }
2118  002e 81            	ret
2150                     ; 474 void Print_RX(void) {
2151                     .text:	section	.text,new
2152  0000               _Print_RX:
2154  0000 88            	push	a
2155       00000001      OFST:	set	1
2158                     ; 476 		ST7789_WriteString(0,linea+scroll, ">                    ", Font_11x18, GRAY, BLACK);
2160  0001 5f            	clrw	x
2161  0002 89            	pushw	x
2162  0003 ae8430        	ldw	x,#33840
2163  0006 89            	pushw	x
2164  0007 b603          	ld	a,_Font_11x18+3
2165  0009 88            	push	a
2166  000a b602          	ld	a,_Font_11x18+2
2167  000c 88            	push	a
2168  000d b601          	ld	a,_Font_11x18+1
2169  000f 88            	push	a
2170  0010 b600          	ld	a,_Font_11x18
2171  0012 88            	push	a
2172  0013 ae0018        	ldw	x,#L774
2173  0016 89            	pushw	x
2174  0017 b62e          	ld	a,_linea
2175  0019 5f            	clrw	x
2176  001a bb2d          	add	a,_scroll
2177  001c 2401          	jrnc	L431
2178  001e 5c            	incw	x
2179  001f               L431:
2180  001f 02            	rlwa	x,a
2181  0020 89            	pushw	x
2182  0021 01            	rrwa	x,a
2183  0022 5f            	clrw	x
2184  0023 cd0000        	call	_ST7789_WriteString
2186  0026 5b0c          	addw	sp,#12
2187                     ; 477 		if(rx_err) {
2189  0028 3d17          	tnz	_rx_err
2190  002a 2603          	jrne	L251
2191  002c cc012a        	jp	L105
2192  002f               L251:
2193                     ; 478 			PulsoBeep(largo);
2195  002f a601          	ld	a,#1
2196  0031 cd0000        	call	_PulsoBeep
2198                     ; 479 			GPIOB->ODR &= 0xDF;  //Led error On
2200  0034 721b5005      	bres	20485,#5
2201                     ; 480 		  ST7789_WriteString(11,linea+scroll, "Error: ", Font_11x18, RED, BLACK);
2203  0038 5f            	clrw	x
2204  0039 89            	pushw	x
2205  003a aef800        	ldw	x,#63488
2206  003d 89            	pushw	x
2207  003e b603          	ld	a,_Font_11x18+3
2208  0040 88            	push	a
2209  0041 b602          	ld	a,_Font_11x18+2
2210  0043 88            	push	a
2211  0044 b601          	ld	a,_Font_11x18+1
2212  0046 88            	push	a
2213  0047 b600          	ld	a,_Font_11x18
2214  0049 88            	push	a
2215  004a ae0010        	ldw	x,#L305
2216  004d 89            	pushw	x
2217  004e b62e          	ld	a,_linea
2218  0050 5f            	clrw	x
2219  0051 bb2d          	add	a,_scroll
2220  0053 2401          	jrnc	L631
2221  0055 5c            	incw	x
2222  0056               L631:
2223  0056 02            	rlwa	x,a
2224  0057 89            	pushw	x
2225  0058 01            	rrwa	x,a
2226  0059 ae000b        	ldw	x,#11
2227  005c cd0000        	call	_ST7789_WriteString
2229  005f 5b0c          	addw	sp,#12
2230                     ; 481 		 	if(reg_sr & 0x02) {  //Frame error
2232  0061 b630          	ld	a,_reg_sr
2233  0063 a502          	bcp	a,#2
2234  0065 2729          	jreq	L505
2235                     ; 482 			  ST7789_WriteString(85,linea+scroll, "FE", Font_11x18, RED, BLACK);
2237  0067 5f            	clrw	x
2238  0068 89            	pushw	x
2239  0069 aef800        	ldw	x,#63488
2240  006c 89            	pushw	x
2241  006d b603          	ld	a,_Font_11x18+3
2242  006f 88            	push	a
2243  0070 b602          	ld	a,_Font_11x18+2
2244  0072 88            	push	a
2245  0073 b601          	ld	a,_Font_11x18+1
2246  0075 88            	push	a
2247  0076 b600          	ld	a,_Font_11x18
2248  0078 88            	push	a
2249  0079 ae000d        	ldw	x,#L705
2250  007c 89            	pushw	x
2251  007d b62e          	ld	a,_linea
2252  007f 5f            	clrw	x
2253  0080 bb2d          	add	a,_scroll
2254  0082 2401          	jrnc	L041
2255  0084 5c            	incw	x
2256  0085               L041:
2257  0085 02            	rlwa	x,a
2258  0086 89            	pushw	x
2259  0087 01            	rrwa	x,a
2260  0088 ae0055        	ldw	x,#85
2261  008b cd0000        	call	_ST7789_WriteString
2263  008e 5b0c          	addw	sp,#12
2264  0090               L505:
2265                     ; 484 			if(reg_sr & 0x04) {  //Noise error
2267  0090 b630          	ld	a,_reg_sr
2268  0092 a504          	bcp	a,#4
2269  0094 2729          	jreq	L115
2270                     ; 485 				ST7789_WriteString(115,linea+scroll, "NE", Font_11x18, RED, BLACK);
2272  0096 5f            	clrw	x
2273  0097 89            	pushw	x
2274  0098 aef800        	ldw	x,#63488
2275  009b 89            	pushw	x
2276  009c b603          	ld	a,_Font_11x18+3
2277  009e 88            	push	a
2278  009f b602          	ld	a,_Font_11x18+2
2279  00a1 88            	push	a
2280  00a2 b601          	ld	a,_Font_11x18+1
2281  00a4 88            	push	a
2282  00a5 b600          	ld	a,_Font_11x18
2283  00a7 88            	push	a
2284  00a8 ae000a        	ldw	x,#L315
2285  00ab 89            	pushw	x
2286  00ac b62e          	ld	a,_linea
2287  00ae 5f            	clrw	x
2288  00af bb2d          	add	a,_scroll
2289  00b1 2401          	jrnc	L241
2290  00b3 5c            	incw	x
2291  00b4               L241:
2292  00b4 02            	rlwa	x,a
2293  00b5 89            	pushw	x
2294  00b6 01            	rrwa	x,a
2295  00b7 ae0073        	ldw	x,#115
2296  00ba cd0000        	call	_ST7789_WriteString
2298  00bd 5b0c          	addw	sp,#12
2299  00bf               L115:
2300                     ; 487 			if(reg_sr & 0x08) {  //OverRun error
2302  00bf b630          	ld	a,_reg_sr
2303  00c1 a508          	bcp	a,#8
2304  00c3 2729          	jreq	L515
2305                     ; 488 				ST7789_WriteString(135,linea+scroll, "OE", Font_11x18, RED, BLACK);
2307  00c5 5f            	clrw	x
2308  00c6 89            	pushw	x
2309  00c7 aef800        	ldw	x,#63488
2310  00ca 89            	pushw	x
2311  00cb b603          	ld	a,_Font_11x18+3
2312  00cd 88            	push	a
2313  00ce b602          	ld	a,_Font_11x18+2
2314  00d0 88            	push	a
2315  00d1 b601          	ld	a,_Font_11x18+1
2316  00d3 88            	push	a
2317  00d4 b600          	ld	a,_Font_11x18
2318  00d6 88            	push	a
2319  00d7 ae0007        	ldw	x,#L715
2320  00da 89            	pushw	x
2321  00db b62e          	ld	a,_linea
2322  00dd 5f            	clrw	x
2323  00de bb2d          	add	a,_scroll
2324  00e0 2401          	jrnc	L441
2325  00e2 5c            	incw	x
2326  00e3               L441:
2327  00e3 02            	rlwa	x,a
2328  00e4 89            	pushw	x
2329  00e5 01            	rrwa	x,a
2330  00e6 ae0087        	ldw	x,#135
2331  00e9 cd0000        	call	_ST7789_WriteString
2333  00ec 5b0c          	addw	sp,#12
2334  00ee               L515:
2335                     ; 490 			if((reg_sr & 0x01) & s_conf.pari) {  //Parity error
2337  00ee 4f            	clr	a
2338                     	btst	_s_conf,#5
2339  00f4 49            	rlc	a
2340  00f5 6b01          	ld	(OFST+0,sp),a
2342  00f7 b630          	ld	a,_reg_sr
2343  00f9 a401          	and	a,#1
2344  00fb 1401          	and	a,(OFST+0,sp)
2345  00fd 2758          	jreq	L525
2346                     ; 491 				ST7789_WriteString(155,linea+scroll, "PE", Font_11x18, RED, BLACK);
2348  00ff 5f            	clrw	x
2349  0100 89            	pushw	x
2350  0101 aef800        	ldw	x,#63488
2351  0104 89            	pushw	x
2352  0105 b603          	ld	a,_Font_11x18+3
2353  0107 88            	push	a
2354  0108 b602          	ld	a,_Font_11x18+2
2355  010a 88            	push	a
2356  010b b601          	ld	a,_Font_11x18+1
2357  010d 88            	push	a
2358  010e b600          	ld	a,_Font_11x18
2359  0110 88            	push	a
2360  0111 ae0004        	ldw	x,#L325
2361  0114 89            	pushw	x
2362  0115 b62e          	ld	a,_linea
2363  0117 5f            	clrw	x
2364  0118 bb2d          	add	a,_scroll
2365  011a 2401          	jrnc	L641
2366  011c 5c            	incw	x
2367  011d               L641:
2368  011d 02            	rlwa	x,a
2369  011e 89            	pushw	x
2370  011f 01            	rrwa	x,a
2371  0120 ae009b        	ldw	x,#155
2372  0123 cd0000        	call	_ST7789_WriteString
2374  0126 5b0c          	addw	sp,#12
2375  0128 202d          	jra	L525
2376  012a               L105:
2377                     ; 494 			GPIOB->ODR |= 0x20; //Led error Off
2379  012a 721a5005      	bset	20485,#5
2380                     ; 495 		  ST7789_WriteString(10,linea+scroll, texto, Font_11x18, GRAY, BLACK);
2382  012e 5f            	clrw	x
2383  012f 89            	pushw	x
2384  0130 ae8430        	ldw	x,#33840
2385  0133 89            	pushw	x
2386  0134 b603          	ld	a,_Font_11x18+3
2387  0136 88            	push	a
2388  0137 b602          	ld	a,_Font_11x18+2
2389  0139 88            	push	a
2390  013a b601          	ld	a,_Font_11x18+1
2391  013c 88            	push	a
2392  013d b600          	ld	a,_Font_11x18
2393  013f 88            	push	a
2394  0140 ae0001        	ldw	x,#_texto
2395  0143 89            	pushw	x
2396  0144 b62e          	ld	a,_linea
2397  0146 5f            	clrw	x
2398  0147 bb2d          	add	a,_scroll
2399  0149 2401          	jrnc	L051
2400  014b 5c            	incw	x
2401  014c               L051:
2402  014c 02            	rlwa	x,a
2403  014d 89            	pushw	x
2404  014e 01            	rrwa	x,a
2405  014f ae000a        	ldw	x,#10
2406  0152 cd0000        	call	_ST7789_WriteString
2408  0155 5b0c          	addw	sp,#12
2409  0157               L525:
2410                     ; 498 }
2413  0157 84            	pop	a
2414  0158 81            	ret
2469                     ; 500 void SelLista(uint8_t item) { //muestra elemento de una lista en modo PartArea
2470                     .text:	section	.text,new
2471  0000               _SelLista:
2473  0000 88            	push	a
2474  0001 5205          	subw	sp,#5
2475       00000005      OFST:	set	5
2478                     ; 502 		keyon = disable;
2480  0003 3f26          	clr	_keyon
2481                     ; 503 		if(item > lista.elem) item = lista.elem;
2483  0005 b632          	ld	a,_lista
2484  0007 a40f          	and	a,#15
2485  0009 6b01          	ld	(OFST-4,sp),a
2487  000b 7b06          	ld	a,(OFST+1,sp)
2488  000d 1101          	cp	a,(OFST-4,sp)
2489  000f 2306          	jrule	L555
2492  0011 b632          	ld	a,_lista
2493  0013 a40f          	and	a,#15
2494  0015 6b06          	ld	(OFST+1,sp),a
2495  0017               L555:
2496                     ; 504 		lista.item = item;
2498  0017 7b06          	ld	a,(OFST+1,sp)
2499  0019 4e            	swap	a
2500  001a b832          	xor	a,_lista
2501  001c a4f0          	and	a,#240
2502  001e b832          	xor	a,_lista
2503  0020 b732          	ld	_lista,a
2504                     ; 505 		item++;
2506  0022 0c06          	inc	(OFST+1,sp)
2507                     ; 506 	  sr = 20 * item;
2509  0024 7b06          	ld	a,(OFST+1,sp)
2510  0026 97            	ld	xl,a
2511  0027 a614          	ld	a,#20
2512  0029 42            	mul	x,a
2513  002a 1f04          	ldw	(OFST-1,sp),x
2515                     ; 507 		er = 20 + sr;
2517  002c 1e04          	ldw	x,(OFST-1,sp)
2518  002e 1c0014        	addw	x,#20
2519  0031 1f02          	ldw	(OFST-3,sp),x
2521                     ; 508 		ST7789_setPartArea(sr, er);
2523  0033 1e02          	ldw	x,(OFST-3,sp)
2524  0035 89            	pushw	x
2525  0036 1e06          	ldw	x,(OFST+1,sp)
2526  0038 cd0000        	call	_ST7789_setPartArea
2528  003b 85            	popw	x
2529                     ; 509 		keyon = enable;
2531  003c 35010026      	mov	_keyon,#1
2532                     ; 510 }
2535  0040 5b06          	addw	sp,#6
2536  0042 81            	ret
2580                     ; 512 void PrintMenu(void) {
2581                     .text:	section	.text,new
2582  0000               _PrintMenu:
2584  0000 88            	push	a
2585       00000001      OFST:	set	1
2588                     ; 514 	  keyon = disable;
2590  0001 3f26          	clr	_keyon
2591                     ; 515 	  ST7789_Clear(BLACK);
2593  0003 5f            	clrw	x
2594  0004 cd0000        	call	_ST7789_Clear
2596                     ; 516 		for(i=0;i<5;i++) {
2598  0007 0f01          	clr	(OFST+0,sp)
2600  0009               L575:
2601                     ; 517 			ST7789_WriteString(10,20 + (20*i), _menu[i], Font_11x18, GREEN, BLACK);
2603  0009 5f            	clrw	x
2604  000a 89            	pushw	x
2605  000b ae07e0        	ldw	x,#2016
2606  000e 89            	pushw	x
2607  000f b603          	ld	a,_Font_11x18+3
2608  0011 88            	push	a
2609  0012 b602          	ld	a,_Font_11x18+2
2610  0014 88            	push	a
2611  0015 b601          	ld	a,_Font_11x18+1
2612  0017 88            	push	a
2613  0018 b600          	ld	a,_Font_11x18
2614  001a 88            	push	a
2615  001b 7b09          	ld	a,(OFST+8,sp)
2616  001d 97            	ld	xl,a
2617  001e a609          	ld	a,#9
2618  0020 42            	mul	x,a
2619  0021 1c0000        	addw	x,#__menu
2620  0024 89            	pushw	x
2621  0025 7b0b          	ld	a,(OFST+10,sp)
2622  0027 97            	ld	xl,a
2623  0028 a614          	ld	a,#20
2624  002a 42            	mul	x,a
2625  002b 1c0014        	addw	x,#20
2626  002e 89            	pushw	x
2627  002f ae000a        	ldw	x,#10
2628  0032 cd0000        	call	_ST7789_WriteString
2630  0035 5b0c          	addw	sp,#12
2631                     ; 516 		for(i=0;i<5;i++) {
2633  0037 0c01          	inc	(OFST+0,sp)
2637  0039 7b01          	ld	a,(OFST+0,sp)
2638  003b a105          	cp	a,#5
2639  003d 25ca          	jrult	L575
2640                     ; 519 		lista.elem = 4;
2642  003f b632          	ld	a,_lista
2643  0041 a4f0          	and	a,#240
2644  0043 aa04          	or	a,#4
2645  0045 b732          	ld	_lista,a
2646                     ; 520 		item_sel = 0;
2648  0047 3f2a          	clr	_item_sel
2649                     ; 521 		SelLista(0);
2651  0049 4f            	clr	a
2652  004a cd0000        	call	_SelLista
2654                     ; 522 		ST7789_swPartArea(enable);
2656  004d a601          	ld	a,#1
2657  004f cd0000        	call	_ST7789_swPartArea
2659                     ; 523 		status = menu;
2661  0052 3502002c      	mov	_status,#2
2662                     ; 524 		keyon = enable;
2664  0056 35010026      	mov	_keyon,#1
2665                     ; 525 }
2668  005a 84            	pop	a
2669  005b 81            	ret
2709                     ; 527 void SelItemMenu(uint8_t sel) {
2710                     .text:	section	.text,new
2711  0000               _SelItemMenu:
2713  0000 88            	push	a
2714       00000000      OFST:	set	0
2717                     ; 528 	keyon = disable;
2719  0001 3f26          	clr	_keyon
2720                     ; 529 	if(sel == 4) {
2722  0003 a104          	cp	a,#4
2723  0005 260b          	jrne	L126
2724                     ; 530 		status = pausa;
2726  0007 3f2c          	clr	_status
2727                     ; 531 		ST7789_swPartArea(disable);
2729  0009 4f            	clr	a
2730  000a cd0000        	call	_ST7789_swPartArea
2732                     ; 532 		Print_Inicio();
2734  000d cd0000        	call	_Print_Inicio
2737  0010 200d          	jra	L326
2738  0012               L126:
2739                     ; 534 		status = submenu;
2741  0012 3503002c      	mov	_status,#3
2742                     ; 535 		menusel = sel;
2744  0016 7b01          	ld	a,(OFST+1,sp)
2745  0018 b72b          	ld	_menusel,a
2746                     ; 536 		PrintSubMenu(sel);
2748  001a 7b01          	ld	a,(OFST+1,sp)
2749  001c cd0000        	call	_PrintSubMenu
2751  001f               L326:
2752                     ; 538 	keyon = enable;
2754  001f 35010026      	mov	_keyon,#1
2755                     ; 539 }
2758  0023 84            	pop	a
2759  0024 81            	ret
2814                     ; 541 void PrintSubMenu(uint8_t sm_lst) {
2815                     .text:	section	.text,new
2816  0000               _PrintSubMenu:
2818  0000 88            	push	a
2819  0001 89            	pushw	x
2820       00000002      OFST:	set	2
2823                     ; 543 	ST7789_swPartArea(disable);
2825  0002 4f            	clr	a
2826  0003 cd0000        	call	_ST7789_swPartArea
2828                     ; 544 	ST7789_Clear(BLACK);
2830  0006 5f            	clrw	x
2831  0007 cd0000        	call	_ST7789_Clear
2833                     ; 545 	if(sm_lst == 0) {
2835  000a 0d03          	tnz	(OFST+1,sp)
2836  000c 264f          	jrne	L746
2837                     ; 546 		lista.elem = 5;
2839  000e b632          	ld	a,_lista
2840  0010 a4f0          	and	a,#240
2841  0012 aa05          	or	a,#5
2842  0014 b732          	ld	_lista,a
2843                     ; 547 		for(i=0; i<6;i++) {
2845  0016 0f02          	clr	(OFST+0,sp)
2847  0018               L156:
2848                     ; 548 			ST7789_WriteString(32,20 + (20*i), _baudios[i], Font_11x18, GREEN, BLACK);
2850  0018 5f            	clrw	x
2851  0019 89            	pushw	x
2852  001a ae07e0        	ldw	x,#2016
2853  001d 89            	pushw	x
2854  001e b603          	ld	a,_Font_11x18+3
2855  0020 88            	push	a
2856  0021 b602          	ld	a,_Font_11x18+2
2857  0023 88            	push	a
2858  0024 b601          	ld	a,_Font_11x18+1
2859  0026 88            	push	a
2860  0027 b600          	ld	a,_Font_11x18
2861  0029 88            	push	a
2862  002a 7b0a          	ld	a,(OFST+8,sp)
2863  002c 97            	ld	xl,a
2864  002d a607          	ld	a,#7
2865  002f 42            	mul	x,a
2866  0030 1c0045        	addw	x,#__baudios
2867  0033 89            	pushw	x
2868  0034 7b0c          	ld	a,(OFST+10,sp)
2869  0036 97            	ld	xl,a
2870  0037 a614          	ld	a,#20
2871  0039 42            	mul	x,a
2872  003a 1c0014        	addw	x,#20
2873  003d 89            	pushw	x
2874  003e ae0020        	ldw	x,#32
2875  0041 cd0000        	call	_ST7789_WriteString
2877  0044 5b0c          	addw	sp,#12
2878                     ; 547 		for(i=0; i<6;i++) {
2880  0046 0c02          	inc	(OFST+0,sp)
2884  0048 7b02          	ld	a,(OFST+0,sp)
2885  004a a106          	cp	a,#6
2886  004c 25ca          	jrult	L156
2887                     ; 550 		item_sel = s_conf.baud;
2889  004e b633          	ld	a,_s_conf
2890  0050 a407          	and	a,#7
2891  0052 b72a          	ld	_item_sel,a
2892                     ; 551 		SelLista(item_sel);
2894  0054 b62a          	ld	a,_item_sel
2895  0056 cd0000        	call	_SelLista
2898  0059 ac7b017b      	jpf	L756
2899  005d               L746:
2900                     ; 552 	} else if(sm_lst == 1) {
2902  005d 7b03          	ld	a,(OFST+1,sp)
2903  005f a101          	cp	a,#1
2904  0061 2652          	jrne	L166
2905                     ; 553 		lista.elem = 2;
2907  0063 b632          	ld	a,_lista
2908  0065 a4f0          	and	a,#240
2909  0067 aa02          	or	a,#2
2910  0069 b732          	ld	_lista,a
2911                     ; 554 		for(i=0; i<3;i++) {
2913  006b 0f02          	clr	(OFST+0,sp)
2915  006d               L366:
2916                     ; 555 			ST7789_WriteString(10,20 + (20*i), _datab[i], Font_11x18, GREEN, BLACK);
2918  006d 5f            	clrw	x
2919  006e 89            	pushw	x
2920  006f ae07e0        	ldw	x,#2016
2921  0072 89            	pushw	x
2922  0073 b603          	ld	a,_Font_11x18+3
2923  0075 88            	push	a
2924  0076 b602          	ld	a,_Font_11x18+2
2925  0078 88            	push	a
2926  0079 b601          	ld	a,_Font_11x18+1
2927  007b 88            	push	a
2928  007c b600          	ld	a,_Font_11x18
2929  007e 88            	push	a
2930  007f 7b0a          	ld	a,(OFST+8,sp)
2931  0081 97            	ld	xl,a
2932  0082 a607          	ld	a,#7
2933  0084 42            	mul	x,a
2934  0085 1c006f        	addw	x,#__datab
2935  0088 89            	pushw	x
2936  0089 7b0c          	ld	a,(OFST+10,sp)
2937  008b 97            	ld	xl,a
2938  008c a614          	ld	a,#20
2939  008e 42            	mul	x,a
2940  008f 1c0014        	addw	x,#20
2941  0092 89            	pushw	x
2942  0093 ae000a        	ldw	x,#10
2943  0096 cd0000        	call	_ST7789_WriteString
2945  0099 5b0c          	addw	sp,#12
2946                     ; 554 		for(i=0; i<3;i++) {
2948  009b 0c02          	inc	(OFST+0,sp)
2952  009d 7b02          	ld	a,(OFST+0,sp)
2953  009f a103          	cp	a,#3
2954  00a1 25ca          	jrult	L366
2955                     ; 557 		item_sel = s_conf.lbit;
2957  00a3 4f            	clr	a
2958                     	btst	_s_conf,#3
2959  00a9 49            	rlc	a
2960  00aa b72a          	ld	_item_sel,a
2961                     ; 558 		SelLista(item_sel);
2963  00ac b62a          	ld	a,_item_sel
2964  00ae cd0000        	call	_SelLista
2967  00b1 ac7b017b      	jpf	L756
2968  00b5               L166:
2969                     ; 559 	} else if(sm_lst == 2) {
2971  00b5 7b03          	ld	a,(OFST+1,sp)
2972  00b7 a102          	cp	a,#2
2973  00b9 2650          	jrne	L376
2974                     ; 560 		lista.elem = 2;
2976  00bb b632          	ld	a,_lista
2977  00bd a4f0          	and	a,#240
2978  00bf aa02          	or	a,#2
2979  00c1 b732          	ld	_lista,a
2980                     ; 561 		for(i=0; i<3;i++) {
2982  00c3 0f02          	clr	(OFST+0,sp)
2984  00c5               L576:
2985                     ; 562 			ST7789_WriteString(10,20 + (20*i), _stopb[i], Font_11x18, GREEN, BLACK);
2987  00c5 5f            	clrw	x
2988  00c6 89            	pushw	x
2989  00c7 ae07e0        	ldw	x,#2016
2990  00ca 89            	pushw	x
2991  00cb b603          	ld	a,_Font_11x18+3
2992  00cd 88            	push	a
2993  00ce b602          	ld	a,_Font_11x18+2
2994  00d0 88            	push	a
2995  00d1 b601          	ld	a,_Font_11x18+1
2996  00d3 88            	push	a
2997  00d4 b600          	ld	a,_Font_11x18
2998  00d6 88            	push	a
2999  00d7 7b0a          	ld	a,(OFST+8,sp)
3000  00d9 97            	ld	xl,a
3001  00da a607          	ld	a,#7
3002  00dc 42            	mul	x,a
3003  00dd 1c0084        	addw	x,#__stopb
3004  00e0 89            	pushw	x
3005  00e1 7b0c          	ld	a,(OFST+10,sp)
3006  00e3 97            	ld	xl,a
3007  00e4 a614          	ld	a,#20
3008  00e6 42            	mul	x,a
3009  00e7 1c0014        	addw	x,#20
3010  00ea 89            	pushw	x
3011  00eb ae000a        	ldw	x,#10
3012  00ee cd0000        	call	_ST7789_WriteString
3014  00f1 5b0c          	addw	sp,#12
3015                     ; 561 		for(i=0; i<3;i++) {
3017  00f3 0c02          	inc	(OFST+0,sp)
3021  00f5 7b02          	ld	a,(OFST+0,sp)
3022  00f7 a103          	cp	a,#3
3023  00f9 25ca          	jrult	L576
3024                     ; 564 		item_sel = s_conf.stop;
3026  00fb 4f            	clr	a
3027                     	btst	_s_conf,#4
3028  0101 49            	rlc	a
3029  0102 b72a          	ld	_item_sel,a
3030                     ; 565 		SelLista(item_sel);
3032  0104 b62a          	ld	a,_item_sel
3033  0106 cd0000        	call	_SelLista
3036  0109 2070          	jra	L756
3037  010b               L376:
3038                     ; 566 	 } else if(sm_lst == 3) {
3040  010b 7b03          	ld	a,(OFST+1,sp)
3041  010d a103          	cp	a,#3
3042  010f 266a          	jrne	L756
3043                     ; 567 		lista.elem = 3;
3045  0111 b632          	ld	a,_lista
3046  0113 a4f0          	and	a,#240
3047  0115 aa03          	or	a,#3
3048  0117 b732          	ld	_lista,a
3049                     ; 568 		for(i=0; i<4;i++) {
3051  0119 0f02          	clr	(OFST+0,sp)
3053  011b               L707:
3054                     ; 569 			ST7789_WriteString(10,20 + (20*i), _paridad[i], Font_11x18, GREEN, BLACK);
3056  011b 5f            	clrw	x
3057  011c 89            	pushw	x
3058  011d ae07e0        	ldw	x,#2016
3059  0120 89            	pushw	x
3060  0121 b603          	ld	a,_Font_11x18+3
3061  0123 88            	push	a
3062  0124 b602          	ld	a,_Font_11x18+2
3063  0126 88            	push	a
3064  0127 b601          	ld	a,_Font_11x18+1
3065  0129 88            	push	a
3066  012a b600          	ld	a,_Font_11x18
3067  012c 88            	push	a
3068  012d 7b0a          	ld	a,(OFST+8,sp)
3069  012f 97            	ld	xl,a
3070  0130 a607          	ld	a,#7
3071  0132 42            	mul	x,a
3072  0133 1c0099        	addw	x,#__paridad
3073  0136 89            	pushw	x
3074  0137 7b0c          	ld	a,(OFST+10,sp)
3075  0139 97            	ld	xl,a
3076  013a a614          	ld	a,#20
3077  013c 42            	mul	x,a
3078  013d 1c0014        	addw	x,#20
3079  0140 89            	pushw	x
3080  0141 ae000a        	ldw	x,#10
3081  0144 cd0000        	call	_ST7789_WriteString
3083  0147 5b0c          	addw	sp,#12
3084                     ; 568 		for(i=0; i<4;i++) {
3086  0149 0c02          	inc	(OFST+0,sp)
3090  014b 7b02          	ld	a,(OFST+0,sp)
3091  014d a104          	cp	a,#4
3092  014f 25ca          	jrult	L707
3093                     ; 571 		if(!s_conf.pari && s_conf.tpar) s_conf.tpar = 0;
3095  0151 b633          	ld	a,_s_conf
3096  0153 a520          	bcp	a,#32
3097  0155 260a          	jrne	L517
3099  0157 b633          	ld	a,_s_conf
3100  0159 a540          	bcp	a,#64
3101  015b 2704          	jreq	L517
3104  015d 721d0033      	bres	_s_conf,#6
3105  0161               L517:
3106                     ; 572 		item_sel = (s_conf.pari<<1)|s_conf.tpar;
3108  0161 4f            	clr	a
3109                     	btst	_s_conf,#6
3110  0167 49            	rlc	a
3111  0168 6b01          	ld	(OFST-1,sp),a
3113  016a 4f            	clr	a
3114                     	btst	_s_conf,#5
3115  0170 49            	rlc	a
3116  0171 48            	sll	a
3117  0172 1a01          	or	a,(OFST-1,sp)
3118  0174 b72a          	ld	_item_sel,a
3119                     ; 573 		SelLista(item_sel);
3121  0176 b62a          	ld	a,_item_sel
3122  0178 cd0000        	call	_SelLista
3124  017b               L756:
3125                     ; 575 	ST7789_swPartArea(enable);
3127  017b a601          	ld	a,#1
3128  017d cd0000        	call	_ST7789_swPartArea
3130                     ; 576 }
3133  0180 5b03          	addw	sp,#3
3134  0182 81            	ret
3175                     ; 578 void SelItemSubMenu(uint8_t sel) {
3176                     .text:	section	.text,new
3177  0000               _SelItemSubMenu:
3179  0000 88            	push	a
3180  0001 88            	push	a
3181       00000001      OFST:	set	1
3184                     ; 579 	if(lista.elem != sel) {
3186  0002 b632          	ld	a,_lista
3187  0004 a40f          	and	a,#15
3188  0006 6b01          	ld	(OFST+0,sp),a
3190  0008 7b02          	ld	a,(OFST+1,sp)
3191  000a 1101          	cp	a,(OFST+0,sp)
3192  000c 2753          	jreq	L547
3193                     ; 580 		switch(menusel){
3195  000e b62b          	ld	a,_menusel
3197                     ; 584 			case 3: s_conf.pari = (sel > 0)? 1:0; s_conf.tpar = (sel == 0x2)? 1: 0; break;
3198  0010 4d            	tnz	a
3199  0011 270b          	jreq	L717
3200  0013 4a            	dec	a
3201  0014 2714          	jreq	L127
3202  0016 4a            	dec	a
3203  0017 271a          	jreq	L327
3204  0019 4a            	dec	a
3205  001a 2720          	jreq	L527
3206  001c 2040          	jra	L157
3207  001e               L717:
3208                     ; 581 			case 0: s_conf.baud = sel; break;
3210  001e 7b02          	ld	a,(OFST+1,sp)
3211  0020 b833          	xor	a,_s_conf
3212  0022 a407          	and	a,#7
3213  0024 b833          	xor	a,_s_conf
3214  0026 b733          	ld	_s_conf,a
3217  0028 2034          	jra	L157
3218  002a               L127:
3219                     ; 582 			case 1: s_conf.lbit = sel; break;
3221  002a 7b02          	ld	a,(OFST+1,sp)
3222  002c 44            	srl	a
3223  002d 90170033      	bccm	_s_conf,#3
3226  0031 202b          	jra	L157
3227  0033               L327:
3228                     ; 583 			case 2: s_conf.stop = sel; break;
3230  0033 7b02          	ld	a,(OFST+1,sp)
3231  0035 44            	srl	a
3232  0036 90190033      	bccm	_s_conf,#4
3235  003a 2022          	jra	L157
3236  003c               L527:
3237                     ; 584 			case 3: s_conf.pari = (sel > 0)? 1:0; s_conf.tpar = (sel == 0x2)? 1: 0; break;
3239  003c 0d02          	tnz	(OFST+1,sp)
3240  003e 2602          	jrne	L671
3241  0040 2006          	jp	L661
3242  0042               L671:
3243  0042 721a0033      	bset	_s_conf,#5
3244  0046 2004          	jra	L071
3245  0048               L661:
3246  0048 721b0033      	bres	_s_conf,#5
3247  004c               L071:
3250  004c 7b02          	ld	a,(OFST+1,sp)
3251  004e a102          	cp	a,#2
3252  0050 2702          	jreq	L002
3253  0052 2006          	jp	L271
3254  0054               L002:
3255  0054 721c0033      	bset	_s_conf,#6
3256  0058 2004          	jra	L471
3257  005a               L271:
3258  005a 721d0033      	bres	_s_conf,#6
3259  005e               L471:
3262  005e               L157:
3263                     ; 586 		UART_config();
3265  005e cd0000        	call	_UART_config
3267  0061               L547:
3268                     ; 588 	status = menu;
3270  0061 3502002c      	mov	_status,#2
3271                     ; 589 	ST7789_swPartArea(disable);
3273  0065 4f            	clr	a
3274  0066 cd0000        	call	_ST7789_swPartArea
3276                     ; 590 	PrintMenu();
3278  0069 cd0000        	call	_PrintMenu
3280                     ; 591 }
3283  006c 85            	popw	x
3284  006d 81            	ret
3310                     ; 593 @far @interrupt void EXTI_PORTC_IRQHandler(void) {
3312                     .text:	section	.text,new
3313  0000               f_EXTI_PORTC_IRQHandler:
3317                     ; 594   if(keyon) new_boton = (GPIOC->IDR & 0x08) ? false : true; //PC3 Pulsador del encoder
3319  0000 3d26          	tnz	_keyon
3320  0002 270e          	jreq	L367
3323  0004 c6500b        	ld	a,20491
3324  0007 a508          	bcp	a,#8
3325  0009 2703          	jreq	L402
3326  000b 4f            	clr	a
3327  000c 2002          	jra	L602
3328  000e               L402:
3329  000e a601          	ld	a,#1
3330  0010               L602:
3331  0010 b729          	ld	_new_boton,a
3332  0012               L367:
3333                     ; 595 	return;
3336  0012 80            	iret
3362                     ; 598 @far @interrupt void EXTI_PORTD_IRQHandler(void) {
3363                     .text:	section	.text,new
3364  0000               f_EXTI_PORTD_IRQHandler:
3368                     ; 599 	if(keyon) {
3370  0000 3d26          	tnz	_keyon
3371  0002 271c          	jreq	L577
3372                     ; 600 	  new_encA = (GPIOD->IDR & 0x04) ? false : true;  //PD2 Encoder A
3374  0004 c65010        	ld	a,20496
3375  0007 a504          	bcp	a,#4
3376  0009 2703          	jreq	L212
3377  000b 4f            	clr	a
3378  000c 2002          	jra	L412
3379  000e               L212:
3380  000e a601          	ld	a,#1
3381  0010               L412:
3382  0010 b725          	ld	_new_encA,a
3383                     ; 601 	  new_encB = (GPIOD->IDR & 0x08) ? false : true;  //PD3 Encoder B
3385  0012 c65010        	ld	a,20496
3386  0015 a508          	bcp	a,#8
3387  0017 2703          	jreq	L612
3388  0019 4f            	clr	a
3389  001a 2002          	jra	L022
3390  001c               L612:
3391  001c a601          	ld	a,#1
3392  001e               L022:
3393  001e b724          	ld	_new_encB,a
3394  0020               L577:
3395                     ; 603 	return;
3398  0020 80            	iret
3424                     ; 606 @far @interrupt void UART1_RX_IRQHandler(void) {
3425                     .text:	section	.text,new
3426  0000               f_UART1_RX_IRQHandler:
3430                     ; 607 	reg_sr = UART1->SR;
3432  0000 5552300030    	mov	_reg_sr,21040
3433                     ; 608 	if(reg_sr & 0x20) {
3435  0005 b630          	ld	a,_reg_sr
3436  0007 a520          	bcp	a,#32
3437  0009 2709          	jreq	L7001
3438                     ; 609 	  inChar = UART1->DR;
3440  000b 5552310000    	mov	_inChar,21041
3441                     ; 610 		is_read = true;
3443  0010 3501001b      	mov	_is_read,#1
3444  0014               L7001:
3445                     ; 612 	return;
3448  0014 80            	iret
3946                     	xdef	f_UART1_RX_IRQHandler
3947                     	xdef	f_EXTI_PORTD_IRQHandler
3948                     	xdef	f_EXTI_PORTC_IRQHandler
3949                     	xdef	_main
3950                     	xdef	_SelLista
3951                     	xdef	_PrintSubMenu
3952                     	xdef	_SelItemSubMenu
3953                     	xdef	_SelItemMenu
3954                     	xdef	_PrintMenu
3955                     	xdef	_PrintBlack
3956                     	xdef	_Print_RX
3957                     	xdef	_Print_Inicio
3958                     	xdef	_FillTexto
3959                     	xdef	_PulsoBeep
3960                     	xdef	_BorraFlags
3961                     	xdef	_BEEP_Init_Calibrated
3962                     	xdef	_LSI_Calibration
3963                     	xdef	_UART_config
3964                     	xdef	_SPI_Config
3965                     	xdef	_EXTI_Config
3966                     	xdef	_GPIO_Config
3967                     	xdef	_CLK_Config
3968                     	switch	.ubsct
3969  0000               _inChar:
3970  0000 00            	ds.b	1
3971                     	xdef	_inChar
3972  0001               _texto:
3973  0001 000000000000  	ds.b	22
3974                     	xdef	_texto
3975  0017               _rx_err:
3976  0017 00            	ds.b	1
3977                     	xdef	_rx_err
3978  0018               _salto:
3979  0018 00            	ds.b	1
3980                     	xdef	_salto
3981  0019               _print:
3982  0019 00            	ds.b	1
3983                     	xdef	_print
3984  001a               _setscr:
3985  001a 00            	ds.b	1
3986                     	xdef	_setscr
3987  001b               _is_read:
3988  001b 00            	ds.b	1
3989                     	xdef	_is_read
3990  001c               _lat_encA:
3991  001c 0000          	ds.b	2
3992                     	xdef	_lat_encA
3993  001e               _enc_der:
3994  001e 0000          	ds.b	2
3995                     	xdef	_enc_der
3996  0020               _enc_izq:
3997  0020 0000          	ds.b	2
3998                     	xdef	_enc_izq
3999  0022               _old_encB:
4000  0022 00            	ds.b	1
4001                     	xdef	_old_encB
4002  0023               _old_encA:
4003  0023 00            	ds.b	1
4004                     	xdef	_old_encA
4005  0024               _new_encB:
4006  0024 00            	ds.b	1
4007                     	xdef	_new_encB
4008  0025               _new_encA:
4009  0025 00            	ds.b	1
4010                     	xdef	_new_encA
4011  0026               _keyon:
4012  0026 00            	ds.b	1
4013                     	xdef	_keyon
4014  0027               _push_boton:
4015  0027 00            	ds.b	1
4016                     	xdef	_push_boton
4017  0028               _old_boton:
4018  0028 00            	ds.b	1
4019                     	xdef	_old_boton
4020  0029               _new_boton:
4021  0029 00            	ds.b	1
4022                     	xdef	_new_boton
4023                     	xdef	_bbr2
4024                     	xdef	_bbr1
4025  002a               _item_sel:
4026  002a 00            	ds.b	1
4027                     	xdef	_item_sel
4028  002b               _menusel:
4029  002b 00            	ds.b	1
4030                     	xdef	_menusel
4031  002c               _status:
4032  002c 00            	ds.b	1
4033                     	xdef	_status
4034  002d               _scroll:
4035  002d 00            	ds.b	1
4036                     	xdef	_scroll
4037  002e               _linea:
4038  002e 00            	ds.b	1
4039                     	xdef	_linea
4040  002f               _test:
4041  002f 00            	ds.b	1
4042                     	xdef	_test
4043  0030               _reg_sr:
4044  0030 00            	ds.b	1
4045                     	xdef	_reg_sr
4046  0031               _cont:
4047  0031 00            	ds.b	1
4048                     	xdef	_cont
4049                     	xdef	_periodticks
4050                     	xdef	_capture2
4051                     	xdef	_capture1
4052                     	xdef	_LSI_Frequency_Hz
4053  0032               _lista:
4054  0032 00            	ds.b	1
4055                     	xdef	_lista
4056  0033               _s_conf:
4057  0033 00            	ds.b	1
4058                     	xdef	_s_conf
4059                     	xdef	__paridad
4060                     	xdef	__stopb
4061                     	xdef	__datab
4062                     	xdef	__baudios
4063                     	xdef	__objeto
4064                     	xdef	__menu
4065                     	xref	_ST7789_WriteString
4066                     	xref	_ST7789_setScrollArea
4067                     	xref	_ST7789_swPartArea
4068                     	xref	_ST7789_setPartArea
4069                     	xref	_ST7789_setScroll
4070                     	xref	_ST7789_Clear
4071                     	xref	_ST7789_Init
4072                     	xref.b	_Font_11x18
4073                     	xref	_SPI_Cmd
4074                     	xref	_SPI_Init
4075                     	switch	.const
4076  0004               L325:
4077  0004 504500        	dc.b	"PE",0
4078  0007               L715:
4079  0007 4f4500        	dc.b	"OE",0
4080  000a               L315:
4081  000a 4e4500        	dc.b	"NE",0
4082  000d               L705:
4083  000d 464500        	dc.b	"FE",0
4084  0010               L305:
4085  0010 4572726f723a  	dc.b	"Error: ",0
4086  0018               L774:
4087  0018 3e2020202020  	dc.b	">                 "
4088  002a 20202000      	dc.b	"   ",0
4089  002e               L564:
4090  002e 3e00          	dc.b	">",0
4091  0030               L354:
4092  0030 50617573612e  	dc.b	"Pausa...",0
4093  0039               L544:
4094  0039 5465726d696e  	dc.b	"Terminal",0
4095  0042               L344:
4096  0042 2d2d2d2d2d2d  	dc.b	"------------------"
4097  0054 2d00          	dc.b	"-",0
4098                     	xref.b	c_lreg
4099                     	xref.b	c_x
4119                     	xref	c_bmulx
4120                     	xref	c_ltor
4121                     	xref	c_ludv
4122                     	xref	c_rtol
4123                     	xref	c_uitolx
4124                     	end
