   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  43                     ; 50 void SPI_DeInit(void)
  43                     ; 51 {
  45                     .text:	section	.text,new
  46  0000               _SPI_DeInit:
  50                     ; 52   SPI->CR1    = SPI_CR1_RESET_VALUE;
  52  0000 725f5200      	clr	20992
  53                     ; 53   SPI->CR2    = SPI_CR2_RESET_VALUE;
  55  0004 725f5201      	clr	20993
  56                     ; 54   SPI->ICR    = SPI_ICR_RESET_VALUE;
  58  0008 725f5202      	clr	20994
  59                     ; 55   SPI->SR     = SPI_SR_RESET_VALUE;
  61  000c 35025203      	mov	20995,#2
  62                     ; 56   SPI->CRCPR  = SPI_CRCPR_RESET_VALUE;
  64  0010 35075205      	mov	20997,#7
  65                     ; 57 }
  68  0014 81            	ret
 384                     ; 78 void SPI_Init(SPI_FirstBit_TypeDef FirstBit, SPI_BaudRatePrescaler_TypeDef BaudRatePrescaler, SPI_Mode_TypeDef Mode, SPI_ClockPolarity_TypeDef ClockPolarity, SPI_ClockPhase_TypeDef ClockPhase, SPI_DataDirection_TypeDef Data_Direction, SPI_NSS_TypeDef Slave_Management, uint8_t CRCPolynomial)
 384                     ; 79 {
 385                     .text:	section	.text,new
 386  0000               _SPI_Init:
 388  0000 89            	pushw	x
 389  0001 88            	push	a
 390       00000001      OFST:	set	1
 393                     ; 81   assert_param(IS_SPI_FIRSTBIT_OK(FirstBit));
 395                     ; 82   assert_param(IS_SPI_BAUDRATE_PRESCALER_OK(BaudRatePrescaler));
 397                     ; 83   assert_param(IS_SPI_MODE_OK(Mode));
 399                     ; 84   assert_param(IS_SPI_POLARITY_OK(ClockPolarity));
 401                     ; 85   assert_param(IS_SPI_PHASE_OK(ClockPhase));
 403                     ; 86   assert_param(IS_SPI_DATA_DIRECTION_OK(Data_Direction));
 405                     ; 87   assert_param(IS_SPI_SLAVEMANAGEMENT_OK(Slave_Management));
 407                     ; 88   assert_param(IS_SPI_CRC_POLYNOMIAL_OK(CRCPolynomial));
 409                     ; 91   SPI->CR1 = (uint8_t)((uint8_t)((uint8_t)FirstBit | BaudRatePrescaler) |
 409                     ; 92                        (uint8_t)((uint8_t)ClockPolarity | ClockPhase));
 411  0002 7b07          	ld	a,(OFST+6,sp)
 412  0004 1a08          	or	a,(OFST+7,sp)
 413  0006 6b01          	ld	(OFST+0,sp),a
 415  0008 9f            	ld	a,xl
 416  0009 1a02          	or	a,(OFST+1,sp)
 417  000b 1a01          	or	a,(OFST+0,sp)
 418  000d c75200        	ld	20992,a
 419                     ; 95   SPI->CR2 = (uint8_t)((uint8_t)(Data_Direction) | (uint8_t)(Slave_Management));
 421  0010 7b09          	ld	a,(OFST+8,sp)
 422  0012 1a0a          	or	a,(OFST+9,sp)
 423  0014 c75201        	ld	20993,a
 424                     ; 97   if (Mode == SPI_MODE_MASTER)
 426  0017 7b06          	ld	a,(OFST+5,sp)
 427  0019 a104          	cp	a,#4
 428  001b 2606          	jrne	L302
 429                     ; 99     SPI->CR2 |= (uint8_t)SPI_CR2_SSI;
 431  001d 72105201      	bset	20993,#0
 433  0021 2004          	jra	L502
 434  0023               L302:
 435                     ; 103     SPI->CR2 &= (uint8_t)~(SPI_CR2_SSI);
 437  0023 72115201      	bres	20993,#0
 438  0027               L502:
 439                     ; 107   SPI->CR1 |= (uint8_t)(Mode);
 441  0027 c65200        	ld	a,20992
 442  002a 1a06          	or	a,(OFST+5,sp)
 443  002c c75200        	ld	20992,a
 444                     ; 110   SPI->CRCPR = (uint8_t)CRCPolynomial;
 446  002f 7b0b          	ld	a,(OFST+10,sp)
 447  0031 c75205        	ld	20997,a
 448                     ; 111 }
 451  0034 5b03          	addw	sp,#3
 452  0036 81            	ret
 507                     ; 119 void SPI_Cmd(FunctionalState NewState)
 507                     ; 120 {
 508                     .text:	section	.text,new
 509  0000               _SPI_Cmd:
 513                     ; 122   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 515                     ; 124   if (NewState != DISABLE)
 517  0000 4d            	tnz	a
 518  0001 2706          	jreq	L532
 519                     ; 126     SPI->CR1 |= SPI_CR1_SPE; /* Enable the SPI peripheral*/
 521  0003 721c5200      	bset	20992,#6
 523  0007 2004          	jra	L732
 524  0009               L532:
 525                     ; 130     SPI->CR1 &= (uint8_t)(~SPI_CR1_SPE); /* Disable the SPI peripheral*/
 527  0009 721d5200      	bres	20992,#6
 528  000d               L732:
 529                     ; 132 }
 532  000d 81            	ret
 641                     ; 141 void SPI_ITConfig(SPI_IT_TypeDef SPI_IT, FunctionalState NewState)
 641                     ; 142 {
 642                     .text:	section	.text,new
 643  0000               _SPI_ITConfig:
 645  0000 89            	pushw	x
 646  0001 88            	push	a
 647       00000001      OFST:	set	1
 650                     ; 143   uint8_t itpos = 0;
 652                     ; 145   assert_param(IS_SPI_CONFIG_IT_OK(SPI_IT));
 654                     ; 146   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 656                     ; 149   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)SPI_IT & (uint8_t)0x0F));
 658  0002 9e            	ld	a,xh
 659  0003 a40f          	and	a,#15
 660  0005 5f            	clrw	x
 661  0006 97            	ld	xl,a
 662  0007 a601          	ld	a,#1
 663  0009 5d            	tnzw	x
 664  000a 2704          	jreq	L41
 665  000c               L61:
 666  000c 48            	sll	a
 667  000d 5a            	decw	x
 668  000e 26fc          	jrne	L61
 669  0010               L41:
 670  0010 6b01          	ld	(OFST+0,sp),a
 672                     ; 151   if (NewState != DISABLE)
 674  0012 0d03          	tnz	(OFST+2,sp)
 675  0014 270a          	jreq	L113
 676                     ; 153     SPI->ICR |= itpos; /* Enable interrupt*/
 678  0016 c65202        	ld	a,20994
 679  0019 1a01          	or	a,(OFST+0,sp)
 680  001b c75202        	ld	20994,a
 682  001e 2009          	jra	L313
 683  0020               L113:
 684                     ; 157     SPI->ICR &= (uint8_t)(~itpos); /* Disable interrupt*/
 686  0020 7b01          	ld	a,(OFST+0,sp)
 687  0022 43            	cpl	a
 688  0023 c45202        	and	a,20994
 689  0026 c75202        	ld	20994,a
 690  0029               L313:
 691                     ; 159 }
 694  0029 5b03          	addw	sp,#3
 695  002b 81            	ret
 729                     ; 166 void SPI_SendData(uint8_t Data)
 729                     ; 167 {
 730                     .text:	section	.text,new
 731  0000               _SPI_SendData:
 735                     ; 168   SPI->DR = Data; /* Write in the DR register the data to be sent*/
 737  0000 c75204        	ld	20996,a
 738                     ; 169 }
 741  0003 81            	ret
 764                     ; 176 uint8_t SPI_ReceiveData(void)
 764                     ; 177 {
 765                     .text:	section	.text,new
 766  0000               _SPI_ReceiveData:
 770                     ; 178   return ((uint8_t)SPI->DR); /* Return the data in the DR register*/
 772  0000 c65204        	ld	a,20996
 775  0003 81            	ret
 811                     ; 187 void SPI_NSSInternalSoftwareCmd(FunctionalState NewState)
 811                     ; 188 {
 812                     .text:	section	.text,new
 813  0000               _SPI_NSSInternalSoftwareCmd:
 817                     ; 190   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 819                     ; 192   if (NewState != DISABLE)
 821  0000 4d            	tnz	a
 822  0001 2706          	jreq	L163
 823                     ; 194     SPI->CR2 |= SPI_CR2_SSI; /* Set NSS pin internally by software*/
 825  0003 72105201      	bset	20993,#0
 827  0007 2004          	jra	L363
 828  0009               L163:
 829                     ; 198     SPI->CR2 &= (uint8_t)(~SPI_CR2_SSI); /* Reset NSS pin internally by software*/
 831  0009 72115201      	bres	20993,#0
 832  000d               L363:
 833                     ; 200 }
 836  000d 81            	ret
 859                     ; 207 void SPI_TransmitCRC(void)
 859                     ; 208 {
 860                     .text:	section	.text,new
 861  0000               _SPI_TransmitCRC:
 865                     ; 209   SPI->CR2 |= SPI_CR2_CRCNEXT; /* Enable the CRC transmission*/
 867  0000 72185201      	bset	20993,#4
 868                     ; 210 }
 871  0004 81            	ret
 907                     ; 218 void SPI_CalculateCRCCmd(FunctionalState NewState)
 907                     ; 219 {
 908                     .text:	section	.text,new
 909  0000               _SPI_CalculateCRCCmd:
 913                     ; 221   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 915                     ; 223   if (NewState != DISABLE)
 917  0000 4d            	tnz	a
 918  0001 2706          	jreq	L314
 919                     ; 225     SPI->CR2 |= SPI_CR2_CRCEN; /* Enable the CRC calculation*/
 921  0003 721a5201      	bset	20993,#5
 923  0007 2004          	jra	L514
 924  0009               L314:
 925                     ; 229     SPI->CR2 &= (uint8_t)(~SPI_CR2_CRCEN); /* Disable the CRC calculation*/
 927  0009 721b5201      	bres	20993,#5
 928  000d               L514:
 929                     ; 231 }
 932  000d 81            	ret
 996                     ; 238 uint8_t SPI_GetCRC(SPI_CRC_TypeDef SPI_CRC)
 996                     ; 239 {
 997                     .text:	section	.text,new
 998  0000               _SPI_GetCRC:
1000  0000 88            	push	a
1001       00000001      OFST:	set	1
1004                     ; 240   uint8_t crcreg = 0;
1006                     ; 243   assert_param(IS_SPI_CRC_OK(SPI_CRC));
1008                     ; 245   if (SPI_CRC != SPI_CRC_RX)
1010  0001 4d            	tnz	a
1011  0002 2707          	jreq	L154
1012                     ; 247     crcreg = SPI->TXCRCR;  /* Get the Tx CRC register*/
1014  0004 c65207        	ld	a,20999
1015  0007 6b01          	ld	(OFST+0,sp),a
1018  0009 2005          	jra	L354
1019  000b               L154:
1020                     ; 251     crcreg = SPI->RXCRCR; /* Get the Rx CRC register*/
1022  000b c65206        	ld	a,20998
1023  000e 6b01          	ld	(OFST+0,sp),a
1025  0010               L354:
1026                     ; 255   return crcreg;
1028  0010 7b01          	ld	a,(OFST+0,sp)
1031  0012 5b01          	addw	sp,#1
1032  0014 81            	ret
1057                     ; 263 void SPI_ResetCRC(void)
1057                     ; 264 {
1058                     .text:	section	.text,new
1059  0000               _SPI_ResetCRC:
1063                     ; 267   SPI_CalculateCRCCmd(ENABLE);
1065  0000 a601          	ld	a,#1
1066  0002 cd0000        	call	_SPI_CalculateCRCCmd
1068                     ; 270   SPI_Cmd(ENABLE);
1070  0005 a601          	ld	a,#1
1071  0007 cd0000        	call	_SPI_Cmd
1073                     ; 271 }
1076  000a 81            	ret
1100                     ; 278 uint8_t SPI_GetCRCPolynomial(void)
1100                     ; 279 {
1101                     .text:	section	.text,new
1102  0000               _SPI_GetCRCPolynomial:
1106                     ; 280   return SPI->CRCPR; /* Return the CRC polynomial register */
1108  0000 c65205        	ld	a,20997
1111  0003 81            	ret
1167                     ; 288 void SPI_BiDirectionalLineConfig(SPI_Direction_TypeDef SPI_Direction)
1167                     ; 289 {
1168                     .text:	section	.text,new
1169  0000               _SPI_BiDirectionalLineConfig:
1173                     ; 291   assert_param(IS_SPI_DIRECTION_OK(SPI_Direction));
1175                     ; 293   if (SPI_Direction != SPI_DIRECTION_RX)
1177  0000 4d            	tnz	a
1178  0001 2706          	jreq	L325
1179                     ; 295     SPI->CR2 |= SPI_CR2_BDOE; /* Set the Tx only mode*/
1181  0003 721c5201      	bset	20993,#6
1183  0007 2004          	jra	L525
1184  0009               L325:
1185                     ; 299     SPI->CR2 &= (uint8_t)(~SPI_CR2_BDOE); /* Set the Rx only mode*/
1187  0009 721d5201      	bres	20993,#6
1188  000d               L525:
1189                     ; 301 }
1192  000d 81            	ret
1313                     ; 311 FlagStatus SPI_GetFlagStatus(SPI_Flag_TypeDef SPI_FLAG)
1313                     ; 312 {
1314                     .text:	section	.text,new
1315  0000               _SPI_GetFlagStatus:
1317  0000 88            	push	a
1318       00000001      OFST:	set	1
1321                     ; 313   FlagStatus status = RESET;
1323                     ; 315   assert_param(IS_SPI_FLAGS_OK(SPI_FLAG));
1325                     ; 318   if ((SPI->SR & (uint8_t)SPI_FLAG) != (uint8_t)RESET)
1327  0001 c45203        	and	a,20995
1328  0004 2706          	jreq	L306
1329                     ; 320     status = SET; /* SPI_FLAG is set */
1331  0006 a601          	ld	a,#1
1332  0008 6b01          	ld	(OFST+0,sp),a
1335  000a 2002          	jra	L506
1336  000c               L306:
1337                     ; 324     status = RESET; /* SPI_FLAG is reset*/
1339  000c 0f01          	clr	(OFST+0,sp)
1341  000e               L506:
1342                     ; 328   return status;
1344  000e 7b01          	ld	a,(OFST+0,sp)
1347  0010 5b01          	addw	sp,#1
1348  0012 81            	ret
1383                     ; 346 void SPI_ClearFlag(SPI_Flag_TypeDef SPI_FLAG)
1383                     ; 347 {
1384                     .text:	section	.text,new
1385  0000               _SPI_ClearFlag:
1389                     ; 348   assert_param(IS_SPI_CLEAR_FLAGS_OK(SPI_FLAG));
1391                     ; 350   SPI->SR = (uint8_t)(~SPI_FLAG);
1393  0000 43            	cpl	a
1394  0001 c75203        	ld	20995,a
1395                     ; 351 }
1398  0004 81            	ret
1480                     ; 366 ITStatus SPI_GetITStatus(SPI_IT_TypeDef SPI_IT)
1480                     ; 367 {
1481                     .text:	section	.text,new
1482  0000               _SPI_GetITStatus:
1484  0000 88            	push	a
1485  0001 89            	pushw	x
1486       00000002      OFST:	set	2
1489                     ; 368   ITStatus pendingbitstatus = RESET;
1491                     ; 369   uint8_t itpos = 0;
1493                     ; 370   uint8_t itmask1 = 0;
1495                     ; 371   uint8_t itmask2 = 0;
1497                     ; 372   uint8_t enablestatus = 0;
1499                     ; 373   assert_param(IS_SPI_GET_IT_OK(SPI_IT));
1501                     ; 375   itpos = (uint8_t)((uint8_t)1 << ((uint8_t)SPI_IT & (uint8_t)0x0F));
1503  0002 a40f          	and	a,#15
1504  0004 5f            	clrw	x
1505  0005 97            	ld	xl,a
1506  0006 a601          	ld	a,#1
1507  0008 5d            	tnzw	x
1508  0009 2704          	jreq	L05
1509  000b               L25:
1510  000b 48            	sll	a
1511  000c 5a            	decw	x
1512  000d 26fc          	jrne	L25
1513  000f               L05:
1514  000f 6b01          	ld	(OFST-1,sp),a
1516                     ; 378   itmask1 = (uint8_t)((uint8_t)SPI_IT >> (uint8_t)4);
1518  0011 7b03          	ld	a,(OFST+1,sp)
1519  0013 4e            	swap	a
1520  0014 a40f          	and	a,#15
1521  0016 6b02          	ld	(OFST+0,sp),a
1523                     ; 380   itmask2 = (uint8_t)((uint8_t)1 << itmask1);
1525  0018 7b02          	ld	a,(OFST+0,sp)
1526  001a 5f            	clrw	x
1527  001b 97            	ld	xl,a
1528  001c a601          	ld	a,#1
1529  001e 5d            	tnzw	x
1530  001f 2704          	jreq	L45
1531  0021               L65:
1532  0021 48            	sll	a
1533  0022 5a            	decw	x
1534  0023 26fc          	jrne	L65
1535  0025               L45:
1536  0025 6b02          	ld	(OFST+0,sp),a
1538                     ; 382   enablestatus = (uint8_t)((uint8_t)SPI->SR & itmask2);
1540  0027 c65203        	ld	a,20995
1541  002a 1402          	and	a,(OFST+0,sp)
1542  002c 6b02          	ld	(OFST+0,sp),a
1544                     ; 384   if (((SPI->ICR & itpos) != RESET) && enablestatus)
1546  002e c65202        	ld	a,20994
1547  0031 1501          	bcp	a,(OFST-1,sp)
1548  0033 270a          	jreq	L766
1550  0035 0d02          	tnz	(OFST+0,sp)
1551  0037 2706          	jreq	L766
1552                     ; 387     pendingbitstatus = SET;
1554  0039 a601          	ld	a,#1
1555  003b 6b02          	ld	(OFST+0,sp),a
1558  003d 2002          	jra	L176
1559  003f               L766:
1560                     ; 392     pendingbitstatus = RESET;
1562  003f 0f02          	clr	(OFST+0,sp)
1564  0041               L176:
1565                     ; 395   return  pendingbitstatus;
1567  0041 7b02          	ld	a,(OFST+0,sp)
1570  0043 5b03          	addw	sp,#3
1571  0045 81            	ret
1616                     ; 412 void SPI_ClearITPendingBit(SPI_IT_TypeDef SPI_IT)
1616                     ; 413 {
1617                     .text:	section	.text,new
1618  0000               _SPI_ClearITPendingBit:
1620  0000 88            	push	a
1621       00000001      OFST:	set	1
1624                     ; 414   uint8_t itpos = 0;
1626                     ; 415   assert_param(IS_SPI_CLEAR_IT_OK(SPI_IT));
1628                     ; 420   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)(SPI_IT & (uint8_t)0xF0) >> 4));
1630  0001 a4f0          	and	a,#240
1631  0003 4e            	swap	a
1632  0004 a40f          	and	a,#15
1633  0006 5f            	clrw	x
1634  0007 97            	ld	xl,a
1635  0008 a601          	ld	a,#1
1636  000a 5d            	tnzw	x
1637  000b 2704          	jreq	L26
1638  000d               L46:
1639  000d 48            	sll	a
1640  000e 5a            	decw	x
1641  000f 26fc          	jrne	L46
1642  0011               L26:
1643  0011 6b01          	ld	(OFST+0,sp),a
1645                     ; 422   SPI->SR = (uint8_t)(~itpos);
1647  0013 7b01          	ld	a,(OFST+0,sp)
1648  0015 43            	cpl	a
1649  0016 c75203        	ld	20995,a
1650                     ; 424 }
1653  0019 84            	pop	a
1654  001a 81            	ret
1667                     	xdef	_SPI_ClearITPendingBit
1668                     	xdef	_SPI_GetITStatus
1669                     	xdef	_SPI_ClearFlag
1670                     	xdef	_SPI_GetFlagStatus
1671                     	xdef	_SPI_BiDirectionalLineConfig
1672                     	xdef	_SPI_GetCRCPolynomial
1673                     	xdef	_SPI_ResetCRC
1674                     	xdef	_SPI_GetCRC
1675                     	xdef	_SPI_CalculateCRCCmd
1676                     	xdef	_SPI_TransmitCRC
1677                     	xdef	_SPI_NSSInternalSoftwareCmd
1678                     	xdef	_SPI_ReceiveData
1679                     	xdef	_SPI_SendData
1680                     	xdef	_SPI_ITConfig
1681                     	xdef	_SPI_Cmd
1682                     	xdef	_SPI_Init
1683                     	xdef	_SPI_DeInit
1702                     	end
