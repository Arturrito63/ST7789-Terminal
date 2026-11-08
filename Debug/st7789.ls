   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  64                     ; 5 void delay_ms(uint16_t ms) {
  66                     .text:	section	.text,new
  67  0000               _delay_ms:
  69  0000 89            	pushw	x
  70  0001 89            	pushw	x
  71       00000002      OFST:	set	2
  74  0002 2012          	jra	L53
  75  0004               L33:
  76                     ; 8         for (i = 0; i < 1200; i++) {
  78  0004 5f            	clrw	x
  79  0005 1f01          	ldw	(OFST-1,sp),x
  81  0007               L14:
  82                     ; 9             nop(); // Instrucción ensamblador 'no operation'
  85  0007 9d            nop
  87                     ; 8         for (i = 0; i < 1200; i++) {
  90  0008 1e01          	ldw	x,(OFST-1,sp)
  91  000a 1c0001        	addw	x,#1
  92  000d 1f01          	ldw	(OFST-1,sp),x
  96  000f 1e01          	ldw	x,(OFST-1,sp)
  97  0011 a304b0        	cpw	x,#1200
  98  0014 25f1          	jrult	L14
  99  0016               L53:
 100                     ; 7     while (ms--) {
 102  0016 1e03          	ldw	x,(OFST+1,sp)
 103  0018 1d0001        	subw	x,#1
 104  001b 1f03          	ldw	(OFST+1,sp),x
 105  001d 1c0001        	addw	x,#1
 106  0020 a30000        	cpw	x,#0
 107  0023 26df          	jrne	L33
 108                     ; 12 }
 111  0025 5b04          	addw	sp,#4
 112  0027 81            	ret
 148                     ; 14 void ST7789_SendByte(uint8_t byte) {
 149                     .text:	section	.text,new
 150  0000               _ST7789_SendByte:
 154                     ; 15 	SPI_SendData(byte);
 156  0000 cd0000        	call	_SPI_SendData
 159  0003               L76:
 160                     ; 16 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 162  0003 a602          	ld	a,#2
 163  0005 cd0000        	call	_SPI_GetFlagStatus
 165  0008 4d            	tnz	a
 166  0009 27f8          	jreq	L76
 167                     ; 17 }
 170  000b 81            	ret
 206                     ; 19 void ST7789_SendWord(uint16_t word) {
 207                     .text:	section	.text,new
 208  0000               _ST7789_SendWord:
 210  0000 89            	pushw	x
 211       00000000      OFST:	set	0
 214                     ; 20 	SPI_SendData((uint8_t)(word >> 8));
 216  0001 9e            	ld	a,xh
 217  0002 cd0000        	call	_SPI_SendData
 220  0005               L311:
 221                     ; 21 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 223  0005 a602          	ld	a,#2
 224  0007 cd0000        	call	_SPI_GetFlagStatus
 226  000a 4d            	tnz	a
 227  000b 27f8          	jreq	L311
 228                     ; 22 	SPI_SendData((uint8_t)(word & 0xFF));
 230  000d 7b02          	ld	a,(OFST+2,sp)
 231  000f a4ff          	and	a,#255
 232  0011 cd0000        	call	_SPI_SendData
 235  0014               L121:
 236                     ; 23 	while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 238  0014 a602          	ld	a,#2
 239  0016 cd0000        	call	_SPI_GetFlagStatus
 241  0019 4d            	tnz	a
 242  001a 27f8          	jreq	L121
 243                     ; 24 }
 246  001c 85            	popw	x
 247  001d 81            	ret
 284                     ; 27 void ST7789_WriteCommand(uint8_t cmd) {
 285                     .text:	section	.text,new
 286  0000               _ST7789_WriteCommand:
 290                     ; 28 	DC_CMD;
 292  0000 7219500a      	bres	20490,#4
 293                     ; 29 	ST7789_SendByte(cmd);
 295  0004 cd0000        	call	_ST7789_SendByte
 298  0007               L541:
 299                     ; 30 	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
 301  0007 a680          	ld	a,#128
 302  0009 cd0000        	call	_SPI_GetFlagStatus
 304  000c a101          	cp	a,#1
 305  000e 27f7          	jreq	L541
 306                     ; 31 }
 309  0010 81            	ret
 345                     ; 34 void ST7789_WriteData(uint8_t data) {
 346                     .text:	section	.text,new
 347  0000               _ST7789_WriteData:
 351                     ; 35     DC_DAT;
 353  0000 7218500a      	bset	20490,#4
 354                     ; 36     ST7789_SendByte(data);
 356  0004 cd0000        	call	_ST7789_SendByte
 359  0007               L171:
 360                     ; 37 	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
 362  0007 a680          	ld	a,#128
 363  0009 cd0000        	call	_SPI_GetFlagStatus
 365  000c a101          	cp	a,#1
 366  000e 27f7          	jreq	L171
 367                     ; 38 }
 370  0010 81            	ret
 406                     ; 41 void ST7789_WriteWord(uint16_t word) {
 407                     .text:	section	.text,new
 408  0000               _ST7789_WriteWord:
 412                     ; 42 	DC_DAT;
 414  0000 7218500a      	bset	20490,#4
 415                     ; 43 	ST7789_SendWord(word);
 417  0004 cd0000        	call	_ST7789_SendWord
 420  0007               L512:
 421                     ; 44 	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
 423  0007 a680          	ld	a,#128
 424  0009 cd0000        	call	_SPI_GetFlagStatus
 426  000c a101          	cp	a,#1
 427  000e 27f7          	jreq	L512
 428                     ; 45 }
 431  0010 81            	ret
 487                     ; 47 void ST7789_WriteDataArray(uint8_t *data, uint8_t zise){
 488                     .text:	section	.text,new
 489  0000               _ST7789_WriteDataArray:
 491  0000 89            	pushw	x
 492  0001 88            	push	a
 493       00000001      OFST:	set	1
 496                     ; 49 	DC_DAT;
 498  0002 7218500a      	bset	20490,#4
 499                     ; 50 	for(i=0; i<zise; i++)
 501  0006 0f01          	clr	(OFST+0,sp)
 504  0008 200d          	jra	L352
 505  000a               L742:
 506                     ; 52 		ST7789_SendByte(data[i]);
 508  000a 7b01          	ld	a,(OFST+0,sp)
 509  000c 5f            	clrw	x
 510  000d 97            	ld	xl,a
 511  000e 72fb02        	addw	x,(OFST+1,sp)
 512  0011 f6            	ld	a,(x)
 513  0012 cd0000        	call	_ST7789_SendByte
 515                     ; 50 	for(i=0; i<zise; i++)
 517  0015 0c01          	inc	(OFST+0,sp)
 519  0017               L352:
 522  0017 7b01          	ld	a,(OFST+0,sp)
 523  0019 1106          	cp	a,(OFST+5,sp)
 524  001b 25ed          	jrult	L742
 526  001d               L162:
 527                     ; 54 	while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
 529  001d a680          	ld	a,#128
 530  001f cd0000        	call	_SPI_GetFlagStatus
 532  0022 a101          	cp	a,#1
 533  0024 27f7          	jreq	L162
 534                     ; 55 }
 537  0026 5b03          	addw	sp,#3
 538  0028 81            	ret
 564                     ; 58 void ST7789_Init(void) {
 565                     .text:	section	.text,new
 566  0000               _ST7789_Init:
 570                     ; 60 	RST_H;
 572  0000 721e500a      	bset	20490,#7
 573                     ; 61 	delay_ms(50);
 575  0004 ae0032        	ldw	x,#50
 576  0007 cd0000        	call	_delay_ms
 578                     ; 62 	RST_L;
 580  000a 721f500a      	bres	20490,#7
 581                     ; 63     delay_ms(50);
 583  000e ae0032        	ldw	x,#50
 584  0011 cd0000        	call	_delay_ms
 586                     ; 64     RST_H;
 588  0014 721e500a      	bset	20490,#7
 589                     ; 65     delay_ms(150);
 591  0018 ae0096        	ldw	x,#150
 592  001b cd0000        	call	_delay_ms
 594                     ; 68     ST7789_WriteCommand(ST7789_SLPOUT); // Salir de Sleep
 596  001e a611          	ld	a,#17
 597  0020 cd0000        	call	_ST7789_WriteCommand
 599                     ; 69     delay_ms(120);
 601  0023 ae0078        	ldw	x,#120
 602  0026 cd0000        	call	_delay_ms
 604                     ; 71     ST7789_WriteCommand(ST7789_MADCTL); // Dirección de escaneo/Orientación
 606  0029 a636          	ld	a,#54
 607  002b cd0000        	call	_ST7789_WriteCommand
 609                     ; 72     ST7789_WriteData(0x00);             // Vista estándar (puedes variar según rotación)
 611  002e 4f            	clr	a
 612  002f cd0000        	call	_ST7789_WriteData
 614                     ; 74     ST7789_WriteCommand(ST7789_COLMOD); // Formato de color de interfaz
 616  0032 a63a          	ld	a,#58
 617  0034 cd0000        	call	_ST7789_WriteCommand
 619                     ; 75     ST7789_WriteData(0x05);             // 16 bits/píxel (RGB565)
 621  0037 a605          	ld	a,#5
 622  0039 cd0000        	call	_ST7789_WriteData
 624                     ; 78 	ST7789_WriteCommand(ST7789_INVON);  // Inversión de pantalla (Típico en módulos IPS negros)
 626  003c a621          	ld	a,#33
 627  003e cd0000        	call	_ST7789_WriteCommand
 629                     ; 80 	ST7789_WriteCommand(ST7789_NORON); // Display modo normal
 631  0041 a613          	ld	a,#19
 632  0043 cd0000        	call	_ST7789_WriteCommand
 634                     ; 82 	ST7789_WriteCommand(ST7789_DISPON); // Encender pantalla
 636  0046 a629          	ld	a,#41
 637  0048 cd0000        	call	_ST7789_WriteCommand
 639                     ; 83     delay_ms(50);
 641  004b ae0032        	ldw	x,#50
 642  004e cd0000        	call	_delay_ms
 644                     ; 84 }
 647  0051 81            	ret
 710                     ; 89 void ST7789_SetWindow(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1) {
 711                     .text:	section	.text,new
 712  0000               _ST7789_SetWindow:
 714  0000 89            	pushw	x
 715       00000000      OFST:	set	0
 718                     ; 90     ST7789_WriteCommand(ST7789_CASET); // Columnas
 720  0001 a62a          	ld	a,#42
 721  0003 cd0000        	call	_ST7789_WriteCommand
 723                     ; 91 	DC_DAT;
 725  0006 7218500a      	bset	20490,#4
 726                     ; 92 	ST7789_SendWord(x0);
 728  000a 1e01          	ldw	x,(OFST+1,sp)
 729  000c cd0000        	call	_ST7789_SendWord
 731                     ; 93 	ST7789_SendWord(x1);
 733  000f 1e07          	ldw	x,(OFST+7,sp)
 734  0011 cd0000        	call	_ST7789_SendWord
 736                     ; 94 	ST7789_WriteCommand(ST7789_RASET); // Filas
 738  0014 a62b          	ld	a,#43
 739  0016 cd0000        	call	_ST7789_WriteCommand
 741                     ; 95 	DC_DAT;
 743  0019 7218500a      	bset	20490,#4
 744                     ; 96 	ST7789_SendWord(y0);
 746  001d 1e05          	ldw	x,(OFST+5,sp)
 747  001f cd0000        	call	_ST7789_SendWord
 749                     ; 97 	ST7789_SendWord(y1);
 751  0022 1e09          	ldw	x,(OFST+9,sp)
 752  0024 cd0000        	call	_ST7789_SendWord
 754                     ; 98 	ST7789_WriteCommand(ST7789_RAMWR); // Preparar para escribir en memoria
 756  0027 a62c          	ld	a,#44
 757  0029 cd0000        	call	_ST7789_WriteCommand
 759                     ; 99 }
 762  002c 85            	popw	x
 763  002d 81            	ret
 799                     ; 101 void ST7789_SetRotation(uint8_t m)
 799                     ; 102 {
 800                     .text:	section	.text,new
 801  0000               _ST7789_SetRotation:
 803  0000 88            	push	a
 804       00000000      OFST:	set	0
 807                     ; 103 	ST7789_WriteCommand(ST7789_MADCTL);	// MADCTL
 809  0001 a636          	ld	a,#54
 810  0003 cd0000        	call	_ST7789_WriteCommand
 812                     ; 104 	switch (m) {
 814  0006 7b01          	ld	a,(OFST+1,sp)
 816                     ; 117 	default:
 816                     ; 118 		break;
 817  0008 4d            	tnz	a
 818  0009 270b          	jreq	L723
 819  000b 4a            	dec	a
 820  000c 270f          	jreq	L133
 821  000e 4a            	dec	a
 822  000f 2713          	jreq	L333
 823  0011 4a            	dec	a
 824  0012 2716          	jreq	L533
 825  0014 2019          	jra	L163
 826  0016               L723:
 827                     ; 105 	case 0:
 827                     ; 106 		ST7789_WriteData(ST7789_MADCTL_MX | ST7789_MADCTL_MY | ST7789_MADCTL_RGB);
 829  0016 a6c0          	ld	a,#192
 830  0018 cd0000        	call	_ST7789_WriteData
 832                     ; 107 		break;
 834  001b 2012          	jra	L163
 835  001d               L133:
 836                     ; 108 	case 1:
 836                     ; 109 		ST7789_WriteData(ST7789_MADCTL_MY | ST7789_MADCTL_MV | ST7789_MADCTL_RGB);
 838  001d a6a0          	ld	a,#160
 839  001f cd0000        	call	_ST7789_WriteData
 841                     ; 110 		break;
 843  0022 200b          	jra	L163
 844  0024               L333:
 845                     ; 111 	case 2:
 845                     ; 112 		ST7789_WriteData(ST7789_MADCTL_RGB);
 847  0024 4f            	clr	a
 848  0025 cd0000        	call	_ST7789_WriteData
 850                     ; 113 		break;
 852  0028 2005          	jra	L163
 853  002a               L533:
 854                     ; 114 	case 3:
 854                     ; 115 		ST7789_WriteData(ST7789_MADCTL_MX | ST7789_MADCTL_MV | ST7789_MADCTL_RGB);
 856  002a a660          	ld	a,#96
 857  002c cd0000        	call	_ST7789_WriteData
 859                     ; 116 		break;
 861  002f               L733:
 862                     ; 117 	default:
 862                     ; 118 		break;
 864  002f               L163:
 865                     ; 120 }
 868  002f 84            	pop	a
 869  0030 81            	ret
 925                     ; 122 void ST7789_setScrollArea(uint16_t tfa, uint16_t bfa) {
 926                     .text:	section	.text,new
 927  0000               _ST7789_setScrollArea:
 929  0000 89            	pushw	x
 930  0001 5204          	subw	sp,#4
 931       00000004      OFST:	set	4
 934                     ; 123   uint16_t vsa = 320-(tfa+bfa); // ST7789 320x240 VRAM
 936  0003 72fb09        	addw	x,(OFST+5,sp)
 937  0006 1f01          	ldw	(OFST-3,sp),x
 939  0008 ae0140        	ldw	x,#320
 940  000b 72f001        	subw	x,(OFST-3,sp)
 941  000e 1f03          	ldw	(OFST-1,sp),x
 943                     ; 124   ST7789_WriteCommand(ST7789_VSCRDEF);
 945  0010 a633          	ld	a,#51
 946  0012 cd0000        	call	_ST7789_WriteCommand
 948                     ; 125   DC_DAT;
 950  0015 7218500a      	bset	20490,#4
 951                     ; 126   ST7789_SendWord(tfa);
 953  0019 1e05          	ldw	x,(OFST+1,sp)
 954  001b cd0000        	call	_ST7789_SendWord
 956                     ; 127   ST7789_SendWord(vsa);
 958  001e 1e03          	ldw	x,(OFST-1,sp)
 959  0020 cd0000        	call	_ST7789_SendWord
 961                     ; 128   ST7789_SendWord(bfa);
 963  0023 1e09          	ldw	x,(OFST+5,sp)
 964  0025 cd0000        	call	_ST7789_SendWord
 967  0028               L314:
 968                     ; 129   while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
 970  0028 a680          	ld	a,#128
 971  002a cd0000        	call	_SPI_GetFlagStatus
 973  002d a101          	cp	a,#1
 974  002f 27f7          	jreq	L314
 975                     ; 130 }
 978  0031 5b06          	addw	sp,#6
 979  0033 81            	ret
1015                     ; 132 void ST7789_setScroll(uint16_t vsp) {
1016                     .text:	section	.text,new
1017  0000               _ST7789_setScroll:
1019  0000 89            	pushw	x
1020       00000000      OFST:	set	0
1023                     ; 133   ST7789_WriteCommand(ST7789_VSCRSADD);
1025  0001 a637          	ld	a,#55
1026  0003 cd0000        	call	_ST7789_WriteCommand
1028                     ; 134   ST7789_WriteWord(vsp);
1030  0006 1e01          	ldw	x,(OFST+1,sp)
1031  0008 cd0000        	call	_ST7789_WriteWord
1033                     ; 135 }
1036  000b 85            	popw	x
1037  000c 81            	ret
1083                     ; 137 void ST7789_setPartArea(uint16_t sr, uint16_t er) {
1084                     .text:	section	.text,new
1085  0000               _ST7789_setPartArea:
1087  0000 89            	pushw	x
1088       00000000      OFST:	set	0
1091                     ; 138   ST7789_WriteCommand(ST7789_PTLAR);
1093  0001 a630          	ld	a,#48
1094  0003 cd0000        	call	_ST7789_WriteCommand
1096                     ; 139   DC_DAT;
1098  0006 7218500a      	bset	20490,#4
1099                     ; 140   ST7789_SendWord(sr);
1101  000a 1e01          	ldw	x,(OFST+1,sp)
1102  000c cd0000        	call	_ST7789_SendWord
1104                     ; 141   ST7789_SendWord(er);
1106  000f 1e05          	ldw	x,(OFST+5,sp)
1107  0011 cd0000        	call	_ST7789_SendWord
1110  0014               L164:
1111                     ; 142   while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
1113  0014 a680          	ld	a,#128
1114  0016 cd0000        	call	_SPI_GetFlagStatus
1116  0019 a101          	cp	a,#1
1117  001b 27f7          	jreq	L164
1118                     ; 143 }
1121  001d 85            	popw	x
1122  001e 81            	ret
1178                     ; 145 void ST7789_swPartArea(bool active) {
1179                     .text:	section	.text,new
1180  0000               _ST7789_swPartArea:
1184                     ; 146 	if(active) {
1186  0000 4d            	tnz	a
1187  0001 2707          	jreq	L315
1188                     ; 147 	  ST7789_WriteCommand(ST7789_PTLON); //Display modo �rea parcial
1190  0003 a612          	ld	a,#18
1191  0005 cd0000        	call	_ST7789_WriteCommand
1194  0008 2005          	jra	L515
1195  000a               L315:
1196                     ; 149 		ST7789_WriteCommand(ST7789_NORON); // Display modo normal
1198  000a a613          	ld	a,#19
1199  000c cd0000        	call	_ST7789_WriteCommand
1201  000f               L515:
1202                     ; 151 }
1205  000f 81            	ret
1260                     ; 153 void ST7789_DrawPixel(uint16_t x, uint16_t y, uint16_t color) {
1261                     .text:	section	.text,new
1262  0000               _ST7789_DrawPixel:
1264  0000 89            	pushw	x
1265       00000000      OFST:	set	0
1268                     ; 154   ST7789_SetWindow(x, y, x, y);
1270  0001 1e05          	ldw	x,(OFST+5,sp)
1271  0003 89            	pushw	x
1272  0004 1e03          	ldw	x,(OFST+3,sp)
1273  0006 89            	pushw	x
1274  0007 1e09          	ldw	x,(OFST+9,sp)
1275  0009 89            	pushw	x
1276  000a 1e07          	ldw	x,(OFST+7,sp)
1277  000c cd0000        	call	_ST7789_SetWindow
1279  000f 5b06          	addw	sp,#6
1280                     ; 155   DC_DAT;
1282  0011 7218500a      	bset	20490,#4
1283                     ; 156   ST7789_SendWord(color);
1285  0015 1e07          	ldw	x,(OFST+7,sp)
1286  0017 cd0000        	call	_ST7789_SendWord
1289  001a               L745:
1290                     ; 157   while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
1292  001a a680          	ld	a,#128
1293  001c cd0000        	call	_SPI_GetFlagStatus
1295  001f a101          	cp	a,#1
1296  0021 27f7          	jreq	L745
1297                     ; 158 }
1300  0023 85            	popw	x
1301  0024 81            	ret
1304                     .const:	section	.text
1305  0000               L355_data:
1306  0000 0000          	ds.b	2
1307  0002               L555_data:
1308  0002 0000          	ds.b	2
1469                     ; 160 void ST7789_WriteChar(uint16_t x, uint16_t y, char ch, FontDef font, uint16_t color, uint16_t bgcolor) {
1470                     .text:	section	.text,new
1471  0000               _ST7789_WriteChar:
1473  0000 89            	pushw	x
1474  0001 520e          	subw	sp,#14
1475       0000000e      OFST:	set	14
1478                     ; 162   ST7789_SetWindow(x, y, x + font.width - 1, y + font.height - 1);
1480  0003 7b17          	ld	a,(OFST+9,sp)
1481  0005 5f            	clrw	x
1482  0006 97            	ld	xl,a
1483  0007 72fb13        	addw	x,(OFST+5,sp)
1484  000a 5a            	decw	x
1485  000b 89            	pushw	x
1486  000c 7b18          	ld	a,(OFST+10,sp)
1487  000e 5f            	clrw	x
1488  000f 97            	ld	xl,a
1489  0010 72fb11        	addw	x,(OFST+3,sp)
1490  0013 5a            	decw	x
1491  0014 89            	pushw	x
1492  0015 1e17          	ldw	x,(OFST+9,sp)
1493  0017 89            	pushw	x
1494  0018 1e15          	ldw	x,(OFST+7,sp)
1495  001a cd0000        	call	_ST7789_SetWindow
1497  001d 5b06          	addw	sp,#6
1498                     ; 163   for (i = 0; i < font.height; i++) {
1500  001f ae0000        	ldw	x,#0
1501  0022 1f09          	ldw	(OFST-5,sp),x
1502  0024 ae0000        	ldw	x,#0
1503  0027 1f07          	ldw	(OFST-7,sp),x
1506  0029 accc00cc      	jpf	L766
1507  002d               L366:
1508                     ; 164 	b = font.data[(ch - 32) * font.height + i];
1510  002d 7b15          	ld	a,(OFST+7,sp)
1511  002f 5f            	clrw	x
1512  0030 97            	ld	xl,a
1513  0031 1d0020        	subw	x,#32
1514  0034 7b17          	ld	a,(OFST+9,sp)
1515  0036 cd0000        	call	c_bmulx
1517  0039 72fb09        	addw	x,(OFST-5,sp)
1518  003c 58            	sllw	x
1519  003d 72fb18        	addw	x,(OFST+10,sp)
1520  0040 fe            	ldw	x,(x)
1521  0041 cd0000        	call	c_uitolx
1523  0044 96            	ldw	x,sp
1524  0045 1c0003        	addw	x,#OFST-11
1525  0048 cd0000        	call	c_rtol
1528                     ; 165 	for (j = 0; j < font.width; j++) {
1530  004b ae0000        	ldw	x,#0
1531  004e 1f0d          	ldw	(OFST-1,sp),x
1532  0050 ae0000        	ldw	x,#0
1533  0053 1f0b          	ldw	(OFST-3,sp),x
1536  0055 2059          	jra	L776
1537  0057               L376:
1538                     ; 166 		if ((b << j) & 0x8000) {
1540  0057 96            	ldw	x,sp
1541  0058 1c0003        	addw	x,#OFST-11
1542  005b cd0000        	call	c_ltor
1544  005e 7b0e          	ld	a,(OFST+0,sp)
1545  0060 cd0000        	call	c_llsh
1547  0063 b602          	ld	a,c_lreg+2
1548  0065 a580          	bcp	a,#128
1549  0067 2720          	jreq	L307
1550                     ; 167 			uint8_t data[] = {color >> 8, color & 0xFF};
1552  0069 c60000        	ld	a,L355_data
1553  006c 6b01          	ld	(OFST-13,sp),a
1554  006e c60001        	ld	a,L355_data+1
1555  0071 6b02          	ld	(OFST-12,sp),a
1556  0073 7b1a          	ld	a,(OFST+12,sp)
1557  0075 6b01          	ld	(OFST-13,sp),a
1559  0077 7b1b          	ld	a,(OFST+13,sp)
1560  0079 a4ff          	and	a,#255
1561  007b 6b02          	ld	(OFST-12,sp),a
1563                     ; 168 			ST7789_WriteDataArray(data, sizeof(data));
1565  007d 4b02          	push	#2
1566  007f 96            	ldw	x,sp
1567  0080 1c0002        	addw	x,#OFST-12
1568  0083 cd0000        	call	_ST7789_WriteDataArray
1570  0086 84            	pop	a
1572  0087 201e          	jra	L507
1573  0089               L307:
1574                     ; 171 			uint8_t data[] = {bgcolor >> 8, bgcolor & 0xFF};
1576  0089 c60002        	ld	a,L555_data
1577  008c 6b01          	ld	(OFST-13,sp),a
1578  008e c60003        	ld	a,L555_data+1
1579  0091 6b02          	ld	(OFST-12,sp),a
1580  0093 7b1c          	ld	a,(OFST+14,sp)
1581  0095 6b01          	ld	(OFST-13,sp),a
1583  0097 7b1d          	ld	a,(OFST+15,sp)
1584  0099 a4ff          	and	a,#255
1585  009b 6b02          	ld	(OFST-12,sp),a
1587                     ; 172 			ST7789_WriteDataArray(data, sizeof(data));
1589  009d 4b02          	push	#2
1590  009f 96            	ldw	x,sp
1591  00a0 1c0002        	addw	x,#OFST-12
1592  00a3 cd0000        	call	_ST7789_WriteDataArray
1594  00a6 84            	pop	a
1595  00a7               L507:
1596                     ; 165 	for (j = 0; j < font.width; j++) {
1598  00a7 96            	ldw	x,sp
1599  00a8 1c000b        	addw	x,#OFST-3
1600  00ab a601          	ld	a,#1
1601  00ad cd0000        	call	c_lgadc
1604  00b0               L776:
1607  00b0 7b16          	ld	a,(OFST+8,sp)
1608  00b2 b703          	ld	c_lreg+3,a
1609  00b4 3f02          	clr	c_lreg+2
1610  00b6 3f01          	clr	c_lreg+1
1611  00b8 3f00          	clr	c_lreg
1612  00ba 96            	ldw	x,sp
1613  00bb 1c000b        	addw	x,#OFST-3
1614  00be cd0000        	call	c_lcmp
1616  00c1 2294          	jrugt	L376
1617                     ; 163   for (i = 0; i < font.height; i++) {
1619  00c3 96            	ldw	x,sp
1620  00c4 1c0007        	addw	x,#OFST-7
1621  00c7 a601          	ld	a,#1
1622  00c9 cd0000        	call	c_lgadc
1625  00cc               L766:
1628  00cc 7b17          	ld	a,(OFST+9,sp)
1629  00ce b703          	ld	c_lreg+3,a
1630  00d0 3f02          	clr	c_lreg+2
1631  00d2 3f01          	clr	c_lreg+1
1632  00d4 3f00          	clr	c_lreg
1633  00d6 96            	ldw	x,sp
1634  00d7 1c0007        	addw	x,#OFST-7
1635  00da cd0000        	call	c_lcmp
1637  00dd 2303          	jrule	L44
1638  00df cc002d        	jp	L366
1639  00e2               L44:
1641  00e2               L117:
1642                     ; 176   while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
1644  00e2 a680          	ld	a,#128
1645  00e4 cd0000        	call	_SPI_GetFlagStatus
1647  00e7 a101          	cp	a,#1
1648  00e9 27f7          	jreq	L117
1649                     ; 177 }
1652  00eb 5b10          	addw	sp,#16
1653  00ed 81            	ret
1735                     ; 179 void ST7789_WriteString(uint16_t x, uint16_t y, const char *str, FontDef font, uint16_t color, uint16_t bgcolor)
1735                     ; 180 {
1736                     .text:	section	.text,new
1737  0000               _ST7789_WriteString:
1739  0000 89            	pushw	x
1740  0001 89            	pushw	x
1741       00000002      OFST:	set	2
1744  0002 206f          	jra	L167
1745  0004               L757:
1746                     ; 182 		if (x + font.width >= 240) {
1748  0004 7b0b          	ld	a,(OFST+9,sp)
1749  0006 5f            	clrw	x
1750  0007 97            	ld	xl,a
1751  0008 72fb03        	addw	x,(OFST+1,sp)
1752  000b a300f0        	cpw	x,#240
1753  000e 252f          	jrult	L567
1754                     ; 183 			x = 0;
1756  0010 5f            	clrw	x
1757  0011 1f03          	ldw	(OFST+1,sp),x
1758                     ; 184 			y += font.height;
1760  0013 7b0c          	ld	a,(OFST+10,sp)
1761  0015 5f            	clrw	x
1762  0016 97            	ld	xl,a
1763  0017 1f01          	ldw	(OFST-1,sp),x
1765  0019 1e07          	ldw	x,(OFST+5,sp)
1766  001b 72fb01        	addw	x,(OFST-1,sp)
1767  001e 1f07          	ldw	(OFST+5,sp),x
1768                     ; 185 			if (y + font.height >= 240) {
1770  0020 7b0c          	ld	a,(OFST+10,sp)
1771  0022 5f            	clrw	x
1772  0023 97            	ld	xl,a
1773  0024 72fb07        	addw	x,(OFST+5,sp)
1774  0027 a300f0        	cpw	x,#240
1775  002a 2503          	jrult	L767
1776                     ; 186 				break;
1777  002c               L367:
1778                     ; 199 }
1781  002c 5b04          	addw	sp,#4
1782  002e 81            	ret
1783  002f               L767:
1784                     ; 189 			if (*str == ' ') {
1786  002f 1e09          	ldw	x,(OFST+7,sp)
1787  0031 f6            	ld	a,(x)
1788  0032 a120          	cp	a,#32
1789  0034 2609          	jrne	L567
1790                     ; 191 				str++;
1792  0036 1e09          	ldw	x,(OFST+7,sp)
1793  0038 1c0001        	addw	x,#1
1794  003b 1f09          	ldw	(OFST+7,sp),x
1795                     ; 192 				continue;
1797  003d 2034          	jra	L167
1798  003f               L567:
1799                     ; 195 		ST7789_WriteChar(x, y, *str, font, color, bgcolor);
1801  003f 1e11          	ldw	x,(OFST+15,sp)
1802  0041 89            	pushw	x
1803  0042 1e11          	ldw	x,(OFST+15,sp)
1804  0044 89            	pushw	x
1805  0045 7b12          	ld	a,(OFST+16,sp)
1806  0047 88            	push	a
1807  0048 7b12          	ld	a,(OFST+16,sp)
1808  004a 88            	push	a
1809  004b 7b12          	ld	a,(OFST+16,sp)
1810  004d 88            	push	a
1811  004e 7b12          	ld	a,(OFST+16,sp)
1812  0050 88            	push	a
1813  0051 1e11          	ldw	x,(OFST+15,sp)
1814  0053 f6            	ld	a,(x)
1815  0054 88            	push	a
1816  0055 1e10          	ldw	x,(OFST+14,sp)
1817  0057 89            	pushw	x
1818  0058 1e0e          	ldw	x,(OFST+12,sp)
1819  005a cd0000        	call	_ST7789_WriteChar
1821  005d 5b0b          	addw	sp,#11
1822                     ; 196 		x += font.width;
1824  005f 7b0b          	ld	a,(OFST+9,sp)
1825  0061 5f            	clrw	x
1826  0062 97            	ld	xl,a
1827  0063 1f01          	ldw	(OFST-1,sp),x
1829  0065 1e03          	ldw	x,(OFST+1,sp)
1830  0067 72fb01        	addw	x,(OFST-1,sp)
1831  006a 1f03          	ldw	(OFST+1,sp),x
1832                     ; 197 		str++;
1834  006c 1e09          	ldw	x,(OFST+7,sp)
1835  006e 1c0001        	addw	x,#1
1836  0071 1f09          	ldw	(OFST+7,sp),x
1837  0073               L167:
1838                     ; 181 	while (*str) {
1840  0073 1e09          	ldw	x,(OFST+7,sp)
1841  0075 7d            	tnz	(x)
1842  0076 268c          	jrne	L757
1843  0078 20b2          	jra	L367
1898                     ; 202 void ST7789_Clear(uint16_t color) {
1899                     .text:	section	.text,new
1900  0000               _ST7789_Clear:
1902  0000 89            	pushw	x
1903  0001 5204          	subw	sp,#4
1904       00000004      OFST:	set	4
1907                     ; 205     ST7789_SetWindow(0, 0, 239, 239); 
1909  0003 ae00ef        	ldw	x,#239
1910  0006 89            	pushw	x
1911  0007 ae00ef        	ldw	x,#239
1912  000a 89            	pushw	x
1913  000b 5f            	clrw	x
1914  000c 89            	pushw	x
1915  000d 5f            	clrw	x
1916  000e cd0000        	call	_ST7789_SetWindow
1918  0011 5b06          	addw	sp,#6
1919                     ; 207     DC_DAT; // Todo lo que sigue son datos
1921  0013 7218500a      	bset	20490,#4
1922                     ; 209     for (i = 0; i < 240; i++) {
1924  0017 5f            	clrw	x
1925  0018 1f01          	ldw	(OFST-3,sp),x
1927  001a               L1201:
1928                     ; 210         for (j = 0; j < 240; j++) {
1930  001a 5f            	clrw	x
1931  001b 1f03          	ldw	(OFST-1,sp),x
1933  001d               L7201:
1934                     ; 212             ST7789_SendWord(color);
1936  001d 1e05          	ldw	x,(OFST+1,sp)
1937  001f cd0000        	call	_ST7789_SendWord
1939                     ; 210         for (j = 0; j < 240; j++) {
1941  0022 1e03          	ldw	x,(OFST-1,sp)
1942  0024 1c0001        	addw	x,#1
1943  0027 1f03          	ldw	(OFST-1,sp),x
1947  0029 1e03          	ldw	x,(OFST-1,sp)
1948  002b a300f0        	cpw	x,#240
1949  002e 25ed          	jrult	L7201
1950                     ; 209     for (i = 0; i < 240; i++) {
1952  0030 1e01          	ldw	x,(OFST-3,sp)
1953  0032 1c0001        	addw	x,#1
1954  0035 1f01          	ldw	(OFST-3,sp),x
1958  0037 1e01          	ldw	x,(OFST-3,sp)
1959  0039 a300f0        	cpw	x,#240
1960  003c 25dc          	jrult	L1201
1962  003e               L7301:
1963                     ; 215     while (SPI_GetFlagStatus(SPI_FLAG_BSY) == SET);
1965  003e a680          	ld	a,#128
1966  0040 cd0000        	call	_SPI_GetFlagStatus
1968  0043 a101          	cp	a,#1
1969  0045 27f7          	jreq	L7301
1970                     ; 216 }
1973  0047 5b06          	addw	sp,#6
1974  0049 81            	ret
1987                     	xdef	_ST7789_WriteDataArray
1988                     	xdef	_ST7789_WriteWord
1989                     	xdef	_ST7789_WriteData
1990                     	xdef	_ST7789_WriteCommand
1991                     	xdef	_ST7789_SendWord
1992                     	xdef	_ST7789_SendByte
1993                     	xref	_SPI_GetFlagStatus
1994                     	xref	_SPI_SendData
1995                     	xdef	_ST7789_WriteString
1996                     	xdef	_ST7789_WriteChar
1997                     	xdef	_ST7789_SetWindow
1998                     	xdef	_ST7789_DrawPixel
1999                     	xdef	_ST7789_setScrollArea
2000                     	xdef	_ST7789_swPartArea
2001                     	xdef	_ST7789_setPartArea
2002                     	xdef	_ST7789_setScroll
2003                     	xdef	_ST7789_SetRotation
2004                     	xdef	_ST7789_Clear
2005                     	xdef	_delay_ms
2006                     	xdef	_ST7789_Init
2007                     	xref.b	c_lreg
2008                     	xref.b	c_x
2027                     	xref	c_lcmp
2028                     	xref	c_lgadc
2029                     	xref	c_llsh
2030                     	xref	c_ltor
2031                     	xref	c_rtol
2032                     	xref	c_uitolx
2033                     	xref	c_bmulx
2034                     	end
