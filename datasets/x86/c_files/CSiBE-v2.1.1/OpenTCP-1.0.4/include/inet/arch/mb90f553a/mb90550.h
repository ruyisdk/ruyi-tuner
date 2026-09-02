/*  FFMC-16 IO-MAP HEADER FILE      */
/*  ==========================      */
/* SOFTUNE WORKBENCH FORMAT         */
/* C-DEFINITIONS FOR IO-SYMBOLS     */
/* CREATED BY IO-WIZARD V2.2   */
/* DATE: 20/09/99 TIME: 11:28:04 */
/* *********************************************************** */
/*               FUJITSU MIKROELEKTRONIK GMBH                  */
/*               Am Siebenstein 6-10, 63303 Dreieich           */
/*               Tel.:++49/6103/690-0,Fax - 122                */
/*                                                             */
/* The following software is for demonstration purposes only.  */
/* It is not fully tested, nor validated in order to fullfill  */
/* its task under all circumstances. Therefore, this software  */
/* or any part of it must only be used in an evaluation        */
/* laboratory environment.                                     */
/* This software is subject to the rules of our standard       */
/* DISCLAIMER, that is delivered with our SW-tools (on the CD  */
/* "Micros Documentation & Software V3.0" see "\START.HTM" or  */
/* see our Internet Page -                                     */
/* http://www.fujitsu-ede.com/products/micro/disclaimer.html   */
/* *********************************************************** */
/* History:                                                      */
/* Date      Version     Author      Description                 */
/* 09.10.98  1.0     	T.Kaprolat  created                          */
/*                                                               */
/* 15.05.99  1.1 		J. Rohn */
/*  - converted for Suftune Workbench */
/*  - disclaimer added                                           */
/* 22.06.99  1.2		V.Satanovskiy */
/*  - 21h SCR bit 0 PIN renamed to PEN (error in HM !) */
/*                                                               */
/* 10.08.99  1.3			V.Satanovskiy */
/*  - AEh FMCS is added */
/* 20.09.99  1.4        M.Steeg */
/*  - 45hex PPGC1 bit13 PE10 renamed to POE1  */
/*  - 55hex PPGC5 bit13 PE50 renamed to POE5 */


#ifndef   __MB90XXX_H
#  define __MB90XXX_H
/*
- Please define __IO_NEAR in LARGE and COMPACT memory model, if the default
  data bank (DTB) is 00. This will result in better performance in these
  models.
- Please define __IO_FAR in SMALL and MEDIUM memory model, if the default
  data bank (DTB) is other than 00. This might be the case in systems with
  external RAM, which are not using internal RAM as default data area.
- Please define neither __IO_NEAR nor __IO_FAR in all other cases. This
  will work with almost all configurations.
*/

#  ifdef  __IO_NEAR
#    ifdef  __IO_FAR
#      error __IO_NEAR and __IO_FAR must not be defined at the same time
#    else
#      define ___IOWIDTH __near
#    endif
#  else
#    ifdef __IO_FAR
#      define ___IOWIDTH __far
#    else                               /* specified by memory model */
#      define ___IOWIDTH
#    endif
#  endif
#  ifdef  __IO_DEFINE
#    define __IO_EXTERN
#    define __IO_EXTENDED volatile ___IOWIDTH
#  else
#    define __IO_EXTERN   extern      /* for data, which can have __io */
#    define __IO_EXTENDED extern volatile ___IOWIDTH
#  endif

typedef unsigned char		IO_BYTE;
typedef unsigned short		IO_WORD;
typedef unsigned long		IO_LWORD;
typedef const unsigned short	IO_WORD_READ;

/* REGISTER BIT STRUCTURES */

typedef union{   /*  PORT DATA */
    IO_BYTE	byte;
    struct{
    IO_BYTE P00 :1;
    IO_BYTE P01 :1;
    IO_BYTE P02 :1;
    IO_BYTE P03 :1;
    IO_BYTE P04 :1;
    IO_BYTE P05 :1;
    IO_BYTE P06 :1;
    IO_BYTE P07 :1;
  }bit;
 }PDR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P10 :1;
    IO_BYTE P11 :1;
    IO_BYTE P12 :1;
    IO_BYTE P13 :1;
    IO_BYTE P14 :1;
    IO_BYTE P15 :1;
    IO_BYTE P16 :1;
    IO_BYTE P17 :1;
  }bit;
 }PDR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P20 :1;
    IO_BYTE P21 :1;
    IO_BYTE P22 :1;
    IO_BYTE P23 :1;
    IO_BYTE P24 :1;
    IO_BYTE P25 :1;
    IO_BYTE P26 :1;
    IO_BYTE P27 :1;
  }bit;
 }PDR2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P30 :1;
    IO_BYTE P31 :1;
    IO_BYTE P32 :1;
    IO_BYTE P33 :1;
    IO_BYTE P34 :1;
    IO_BYTE P35 :1;
    IO_BYTE P36 :1;
    IO_BYTE P37 :1;
  }bit;
 }PDR3STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P40 :1;
    IO_BYTE P41 :1;
    IO_BYTE P42 :1;
    IO_BYTE P43 :1;
    IO_BYTE P44 :1;
    IO_BYTE P45 :1;
    IO_BYTE P46 :1;
    IO_BYTE P47 :1;
  }bit;
 }PDR4STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P50 :1;
    IO_BYTE P51 :1;
    IO_BYTE P52 :1;
    IO_BYTE P53 :1;
    IO_BYTE P54 :1;
    IO_BYTE P55 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }PDR5STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P60 :1;
    IO_BYTE P61 :1;
    IO_BYTE P62 :1;
    IO_BYTE P63 :1;
    IO_BYTE P64 :1;
    IO_BYTE P65 :1;
    IO_BYTE P66 :1;
    IO_BYTE P67 :1;
  }bit;
 }PDR6STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P70 :1;
    IO_BYTE P71 :1;
    IO_BYTE P72 :1;
    IO_BYTE P73 :1;
    IO_BYTE P74 :1;
    IO_BYTE P75 :1;
    IO_BYTE P76 :1;
    IO_BYTE P77 :1;
  }bit;
 }PDR7STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P80 :1;
    IO_BYTE P81 :1;
    IO_BYTE P82 :1;
    IO_BYTE P83 :1;
    IO_BYTE P84 :1;
    IO_BYTE P85 :1;
    IO_BYTE P86 :1;
    IO_BYTE P87 :1;
  }bit;
 }PDR8STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE P90 :1;
    IO_BYTE P91 :1;
    IO_BYTE P92 :1;
    IO_BYTE P93 :1;
    IO_BYTE P94 :1;
    IO_BYTE P95 :1;
    IO_BYTE P96 :1;
    IO_BYTE P97 :1;
  }bit;
 }PDR9STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE PA0 :1;
    IO_BYTE PA1 :1;
    IO_BYTE PA2 :1;
    IO_BYTE PA3 :1;
    IO_BYTE PA4 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }PDRASTR;
typedef union{   /* PORT DIR */
    IO_BYTE	byte;
    struct{
    IO_BYTE D00 :1;
    IO_BYTE D01 :1;
    IO_BYTE D02 :1;
    IO_BYTE D03 :1;
    IO_BYTE D04 :1;
    IO_BYTE D05 :1;
    IO_BYTE D06 :1;
    IO_BYTE D07 :1;
  }bit;
 }DDR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D10 :1;
    IO_BYTE D11 :1;
    IO_BYTE D12 :1;
    IO_BYTE D13 :1;
    IO_BYTE D14 :1;
    IO_BYTE D15 :1;
    IO_BYTE D16 :1;
    IO_BYTE D17 :1;
  }bit;
 }DDR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D20 :1;
    IO_BYTE D21 :1;
    IO_BYTE D22 :1;
    IO_BYTE D23 :1;
    IO_BYTE D24 :1;
    IO_BYTE D25 :1;
    IO_BYTE D26 :1;
    IO_BYTE D27 :1;
  }bit;
 }DDR2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D30 :1;
    IO_BYTE D31 :1;
    IO_BYTE D32 :1;
    IO_BYTE D33 :1;
    IO_BYTE D34 :1;
    IO_BYTE D35 :1;
    IO_BYTE D36 :1;
    IO_BYTE D37 :1;
  }bit;
 }DDR3STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D40 :1;
    IO_BYTE D41 :1;
    IO_BYTE D42 :1;
    IO_BYTE D43 :1;
    IO_BYTE D44 :1;
    IO_BYTE D45 :1;
    IO_BYTE D46 :1;
    IO_BYTE D47 :1;
  }bit;
 }DDR4STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D60 :1;
    IO_BYTE D61 :1;
    IO_BYTE D62 :1;
    IO_BYTE D63 :1;
    IO_BYTE D64 :1;
    IO_BYTE D65 :1;
    IO_BYTE D66 :1;
    IO_BYTE D67 :1;
  }bit;
 }DDR6STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D70 :1;
    IO_BYTE D71 :1;
    IO_BYTE D72 :1;
    IO_BYTE D73 :1;
    IO_BYTE D74 :1;
    IO_BYTE D75 :1;
    IO_BYTE D76 :1;
    IO_BYTE D77 :1;
  }bit;
 }DDR7STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D80 :1;
    IO_BYTE D81 :1;
    IO_BYTE D82 :1;
    IO_BYTE D83 :1;
    IO_BYTE D84 :1;
    IO_BYTE D85 :1;
    IO_BYTE D86 :1;
    IO_BYTE D87 :1;
  }bit;
 }DDR8STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE D90 :1;
    IO_BYTE D91 :1;
    IO_BYTE D92 :1;
    IO_BYTE D93 :1;
    IO_BYTE D94 :1;
    IO_BYTE D95 :1;
    IO_BYTE D96 :1;
    IO_BYTE D97 :1;
  }bit;
 }DDR9STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE DA0 :1;
    IO_BYTE DA1 :1;
    IO_BYTE DA2 :1;
    IO_BYTE DA3 :1;
    IO_BYTE DA4 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }DDRASTR;
typedef union{   /* Output Pin Register */
    IO_BYTE	byte;
    struct{
    IO_BYTE OD40 :1;
    IO_BYTE OD41 :1;
    IO_BYTE OD42 :1;
    IO_BYTE OD43 :1;
    IO_BYTE OD44 :1;
    IO_BYTE OD45 :1;
    IO_BYTE OD46 :1;
    IO_BYTE OD47 :1;
  }bit;
 }ODR4STR;
typedef union{   /* Input Resistance Register */
    IO_BYTE	byte;
    struct{
    IO_BYTE RD00 :1;
    IO_BYTE RD01 :1;
    IO_BYTE RD02 :1;
    IO_BYTE RD03 :1;
    IO_BYTE RD04 :1;
    IO_BYTE RD05 :1;
    IO_BYTE RD06 :1;
    IO_BYTE RD07 :1;
  }bit;
 }RDR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE RD10 :1;
    IO_BYTE RD11 :1;
    IO_BYTE RD12 :1;
    IO_BYTE RD13 :1;
    IO_BYTE RD14 :1;
    IO_BYTE RD15 :1;
    IO_BYTE RD16 :1;
    IO_BYTE RD17 :1;
  }bit;
 }RDR1STR;
typedef union{   /* Analog Input Enable Register */
    IO_BYTE	byte;
    struct{
    IO_BYTE ADE0 :1;
    IO_BYTE ADE1 :1;
    IO_BYTE ADE2 :1;
    IO_BYTE ADE3 :1;
    IO_BYTE ADE4 :1;
    IO_BYTE ADE5 :1;
    IO_BYTE ADE6 :1;
    IO_BYTE ADE7 :1;
  }bit;
 }ADERSTR;
typedef union{   /* UART0,1 */
    IO_BYTE	byte;
    struct{
    IO_BYTE SOE :1;
    IO_BYTE SCKE :1;
    IO_BYTE  :1;
    IO_BYTE CS0 :1;
    IO_BYTE CS1 :1;
    IO_BYTE CS2 :1;
    IO_BYTE MD0 :1;
    IO_BYTE MD1 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE CS :3;
    IO_BYTE MD :2;
  }bitc;
 }SMRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE TXE :1;
    IO_BYTE RXE :1;
    IO_BYTE REC :1;
    IO_BYTE AD :1;
    IO_BYTE CL :1;
    IO_BYTE SBL :1;
    IO_BYTE P :1;
    IO_BYTE PEN :1;
  }bit;
 }SCRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE TIE :1;
    IO_BYTE RIE :1;
    IO_BYTE  :1;
    IO_BYTE TDRE :1;
    IO_BYTE RDRF :1;
    IO_BYTE FRE :1;
    IO_BYTE ORE :1;
    IO_BYTE PE :1;
  }bit;
 }SSRSTR;
typedef union{   /* SIO channels 0,1 */
    IO_WORD	word;
    struct{
    IO_WORD SCOE :1;
    IO_WORD SOE :1;
    IO_WORD BDS :1;
    IO_WORD MODE :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD STRT :1;
    IO_WORD STOP :1;
    IO_WORD BUSY :1;
    IO_WORD SIR :1;
    IO_WORD SIE :1;
    IO_WORD SMD0 :1;
    IO_WORD SMD1 :1;
    IO_WORD SMD2 :1;
  }bit;
  struct{
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD SMD :3;
  }bitc;
 }SMCS0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE DIV0 :1;
    IO_BYTE DIV1 :1;
    IO_BYTE DIV2 :1;
    IO_BYTE DIV3 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE MD :1;
  }bit;
  struct{
    IO_BYTE DIV :4;
  }bitc;
 }CDCRSTR;
typedef union{  
    IO_WORD	word;
    struct{
    IO_WORD SCOE :1;
    IO_WORD SOE :1;
    IO_WORD BDS :1;
    IO_WORD MODE :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD STRT :1;
    IO_WORD STOP :1;
    IO_WORD BUSY :1;
    IO_WORD SIR :1;
    IO_WORD SIE :1;
    IO_WORD SMD0 :1;
    IO_WORD SMD1 :1;
    IO_WORD SMD2 :1;
  }bit;
  struct{
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD SMD :3;
  }bitc;
 }SMCS1STR;
typedef union{   /* Iih Quadrat C */
    IO_BYTE	byte;
    struct{
    IO_BYTE FBT :1;
    IO_BYTE GCA :1;
    IO_BYTE AAS :1;
    IO_BYTE TRX :1;
    IO_BYTE LRB :1;
    IO_BYTE AL :1;
    IO_BYTE RSC :1;
    IO_BYTE BB :1;
  }bit;
 }IBSR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE INT :1;
    IO_BYTE INTE :1;
    IO_BYTE GCAA :1;
    IO_BYTE ACK :1;
    IO_BYTE MSS :1;
    IO_BYTE SCC :1;
    IO_BYTE BEIE :1;
    IO_BYTE BER :1;
  }bit;
 }IBCR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CS0 :1;
    IO_BYTE CS1 :1;
    IO_BYTE CS2 :1;
    IO_BYTE CS3 :1;
    IO_BYTE CS4 :1;
    IO_BYTE EN :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE CS :5;
  }bitc;
 }ICCR0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE FBT :1;
    IO_BYTE GCA :1;
    IO_BYTE AAS :1;
    IO_BYTE TRX :1;
    IO_BYTE LRB :1;
    IO_BYTE AL :1;
    IO_BYTE RSC :1;
    IO_BYTE BB :1;
  }bit;
 }IBSR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE INT :1;
    IO_BYTE INTE :1;
    IO_BYTE GCAA :1;
    IO_BYTE ACK :1;
    IO_BYTE MSS :1;
    IO_BYTE SCC :1;
    IO_BYTE BEIE :1;
    IO_BYTE BER :1;
  }bit;
 }IBCR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CS0 :1;
    IO_BYTE CS1 :1;
    IO_BYTE CS2 :1;
    IO_BYTE CS3 :1;
    IO_BYTE CS4 :1;
    IO_BYTE EN :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE CS :5;
  }bitc;
 }ICCR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE PSEL :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }ISELSTR;
typedef union{   /* DTP, External Interrupts */
    IO_BYTE	byte;
    struct{
    IO_BYTE EN0 :1;
    IO_BYTE EN1 :1;
    IO_BYTE EN2 :1;
    IO_BYTE EN3 :1;
    IO_BYTE EN4 :1;
    IO_BYTE EN5 :1;
    IO_BYTE EN6 :1;
    IO_BYTE EN7 :1;
  }bit;
 }ENIRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE ER0 :1;
    IO_BYTE ER1 :1;
    IO_BYTE ER2 :1;
    IO_BYTE ER3 :1;
    IO_BYTE ER4 :1;
    IO_BYTE ER5 :1;
    IO_BYTE ER6 :1;
    IO_BYTE ER7 :1;
  }bit;
 }EIRRSTR;
typedef union{   /* AD Converter */
    IO_BYTE	byte;
    struct{
    IO_BYTE ANE0 :1;
    IO_BYTE ANE1 :1;
    IO_BYTE ANE2 :1;
    IO_BYTE ANS0 :1;
    IO_BYTE ANS1 :1;
    IO_BYTE ANS2 :1;
    IO_BYTE MD0 :1;
    IO_BYTE MD1 :1;
  }bit;
  struct{
    IO_BYTE ANE :3;
    IO_BYTE ANS :3;
    IO_BYTE MD :2;
  }bitc;
 }ADCS1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE DA :1;
    IO_BYTE STRT :1;
    IO_BYTE STS0 :1;
    IO_BYTE STS1 :1;
    IO_BYTE PAUS :1;
    IO_BYTE INTE :1;
    IO_BYTE INT :1;
    IO_BYTE BUSY :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE STS :2;
  }bitc;
 }ADCS2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE CT0 :1;
    IO_BYTE CT1 :1;
    IO_BYTE ST0 :1;
    IO_BYTE ST1 :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE CT :2;
    IO_BYTE ST :2;
  }bitc;
 }ADCR2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PUF0 :1;
    IO_BYTE PIE0 :1;
    IO_BYTE POE0 :1;
    IO_BYTE  :1;
    IO_BYTE PEN0 :1;
  }bit;
 }PPGC0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE MD0 :1;
    IO_BYTE MD1 :1;
    IO_BYTE PUF1 :1;
    IO_BYTE PIE1 :1;
    IO_BYTE POE1 :1;
    IO_BYTE  :1;
    IO_BYTE PEN1 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE MD :2;
  }bitc;
 }PPGC1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PUF2 :1;
    IO_BYTE PIE2 :1;
    IO_BYTE POE2 :1;
    IO_BYTE  :1;
    IO_BYTE PEN2 :1;
  }bit;
 }PPGC2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE MD0 :1;
    IO_BYTE MD1 :1;
    IO_BYTE PUF3 :1;
    IO_BYTE PIE3 :1;
    IO_BYTE POE3 :1;
    IO_BYTE  :1;
    IO_BYTE PEN3 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE MD :2;
  }bitc;
 }PPGC3STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE3STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PUF4 :1;
    IO_BYTE PIE4 :1;
    IO_BYTE POE4 :1;
    IO_BYTE  :1;
    IO_BYTE PEN4 :1;
  }bit;
 }PPGC4STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE MD0 :1;
    IO_BYTE MD1 :1;
    IO_BYTE PUF5 :1;
    IO_BYTE PIE5 :1;
    IO_BYTE POE5 :1;
    IO_BYTE  :1;
    IO_BYTE PEN5 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE MD :2;
  }bitc;
 }PPGC5STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE4STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE PCM0 :1;
    IO_BYTE PCM1 :1;
    IO_BYTE PCM2 :1;
    IO_BYTE PCS0 :1;
    IO_BYTE PCS1 :1;
    IO_BYTE PCS2 :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE PCM :3;
    IO_BYTE PCS :3;
  }bitc;
 }PPGOE5STR;
typedef union{   /* Clock Monitor Function */
    IO_BYTE	byte;
    struct{
    IO_BYTE FRQ0 :1;
    IO_BYTE FRQ1 :1;
    IO_BYTE FRQ2 :1;
    IO_BYTE CKEN :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE FRQ :3;
  }bitc;
 }CLKRSTR;
typedef union{   /* Reload Timer */
    IO_WORD	word;
    struct{
    IO_WORD TRG :1;
    IO_WORD CNTE :1;
    IO_WORD UF :1;
    IO_WORD INTE :1;
    IO_WORD RELD :1;
    IO_WORD OUTL :1;
    IO_WORD OUTE :1;
    IO_WORD MOD0 :1;
    IO_WORD MOD1 :1;
    IO_WORD MOD2 :1;
    IO_WORD CSL0 :1;
    IO_WORD CSL1 :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
  }bit;
  struct{
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD MOD :3;
    IO_WORD CSL :2;
  }bitc;
 }TMCSR0STR;
typedef union{  
    IO_WORD	word;
    struct{
    IO_WORD TRG :1;
    IO_WORD CNTE :1;
    IO_WORD UF :1;
    IO_WORD INTE :1;
    IO_WORD RELD :1;
    IO_WORD OUTL :1;
    IO_WORD OUTE :1;
    IO_WORD MOD0 :1;
    IO_WORD MOD1 :1;
    IO_WORD MOD2 :1;
    IO_WORD CSL0 :1;
    IO_WORD CSL1 :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
    IO_WORD  :1;
  }bit;
  struct{
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD :1;
    IO_WORD MOD :3;
    IO_WORD CSL :2;
  }bitc;
 }TMCSR1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE EG00 :1;
    IO_BYTE EG01 :1;
    IO_BYTE EG10 :1;
    IO_BYTE EG11 :1;
    IO_BYTE ICE0 :1;
    IO_BYTE ICE1 :1;
    IO_BYTE ICP0 :1;
    IO_BYTE ICP1 :1;
  }bit;
  struct{
    IO_BYTE EG0 :2;
    IO_BYTE EG1 :2;
  }bitc;
 }ICS01STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE EG02 :1;
    IO_BYTE EG03 :1;
    IO_BYTE EG12 :1;
    IO_BYTE EG13 :1;
    IO_BYTE ICE2 :1;
    IO_BYTE ICE3 :1;
    IO_BYTE ICP2 :1;
    IO_BYTE ICP3 :1;
  }bit;
  struct{
    IO_BYTE EG0 :2;
    IO_BYTE EG1 :2;
  }bitc;
 }ICS23STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CLK0 :1;
    IO_BYTE CLK1 :1;
    IO_BYTE CLR :1;
    IO_BYTE MODE :1;
    IO_BYTE STOP :1;
    IO_BYTE IVFE :1;
    IO_BYTE IVF :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE CLK :2;
  }bitc;
 }TCCSSTR;
typedef union{   /* ROM mirror function */
    IO_BYTE	byte;
    struct{
    IO_BYTE MI :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }ROMMSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CST0 :1;
    IO_BYTE CST1 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE ICE0 :1;
    IO_BYTE ICE1 :1;
    IO_BYTE ICP0 :1;
    IO_BYTE ICP1 :1;
  }bit;
 }OCS0STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE OTD0 :1;
    IO_BYTE OTD1 :1;
    IO_BYTE OTE0 :1;
    IO_BYTE OTE1 :1;
    IO_BYTE CMOD :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }OCS1STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CST0 :1;
    IO_BYTE CST1 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE ICE0 :1;
    IO_BYTE ICE1 :1;
    IO_BYTE ICP0 :1;
    IO_BYTE ICP1 :1;
  }bit;
 }OCS2STR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE OTD0 :1;
    IO_BYTE OTD1 :1;
    IO_BYTE OTE0 :1;
    IO_BYTE OTE1 :1;
    IO_BYTE CMOD :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }OCS3STR;
typedef union{   /* Delayed Interrupt */
    IO_BYTE	byte;
    struct{
    IO_BYTE R0 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
 }DIRRSTR;
typedef union{   /* Low Power Control Registers */
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE CG0 :1;
    IO_BYTE CG1 :1;
    IO_BYTE  :1;
    IO_BYTE RST :1;
    IO_BYTE SPL :1;
    IO_BYTE SLP :1;
    IO_BYTE STP :1;
  }bit;
  struct{
    IO_BYTE :1;
    IO_BYTE CG :2;
  }bitc;
 }LPMCRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE CS0 :1;
    IO_BYTE CS1 :1;
    IO_BYTE MCS :1;
    IO_BYTE  :1;
    IO_BYTE WS0 :1;
    IO_BYTE WS1 :1;
    IO_BYTE MCM :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE CS :2;
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE WS :2;
  }bitc;
 }CKSCRSTR;
typedef union{   /* External Bus I/F */
    IO_BYTE	byte;
    struct{
    IO_BYTE LMR0 :1;
    IO_BYTE LMR1 :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE HMR0 :1;
    IO_BYTE HMR1 :1;
    IO_BYTE IOR0 :1;
    IO_BYTE IOR1 :1;
  }bit;
  struct{
    IO_BYTE LMR :2;
    IO_BYTE :1;
    IO_BYTE :1;
    IO_BYTE HMR :2;
    IO_BYTE IOR :2;
  }bitc;
 }ARSRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE E16 :1;
    IO_BYTE E17 :1;
    IO_BYTE E18 :1;
    IO_BYTE E19 :1;
    IO_BYTE E20 :1;
    IO_BYTE E21 :1;
    IO_BYTE E22 :1;
    IO_BYTE E23 :1;
  }bit;
 }HACRSTR;
typedef union{  
    IO_BYTE	byte;
    struct{
    IO_BYTE  :1;
    IO_BYTE LMBS :1;
    IO_BYTE WRE :1;
    IO_BYTE HMBS :1;
    IO_BYTE IOBS :1;
    IO_BYTE HDE :1;
    IO_BYTE RYE :1;
    IO_BYTE CKE :1;
  }bit;
 }ECSRSTR;
typedef union{   /* Watch Dog */
    IO_BYTE	byte;
    struct{
    IO_BYTE WT0 :1;
    IO_BYTE WT1 :1;
    IO_BYTE WTE :1;
    IO_BYTE SRST :1;
    IO_BYTE ERST :1;
    IO_BYTE WRST :1;
    IO_BYTE STBR :1;
    IO_BYTE PONR :1;
  }bit;
  struct{
    IO_BYTE WT :2;
  }bitc;
 }WDTCSTR;
typedef union{   /* Time Base Timer */
    IO_BYTE	byte;
    struct{
    IO_BYTE TBC0 :1;
    IO_BYTE TBC1 :1;
    IO_BYTE TBR :1;
    IO_BYTE TBOF :1;
    IO_BYTE TBIE :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
  }bit;
  struct{
    IO_BYTE TBC :2;
  }bitc;
 }TBTCSTR;
typedef union{   /* Flash Control Register */
    IO_BYTE	byte;
    struct{
    IO_BYTE LPM :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE  :1;
    IO_BYTE RDY :1;
    IO_BYTE WE :1;
    IO_BYTE RDYINT :1;
    IO_BYTE INTE :1;
  }bit;
 }FMCSSTR;

/* C-DECLARATIONS */

__IO_EXTERN __io PDR0STR _pdr0;   /*  PORT DATA */
#define PDR0 _pdr0.byte
#define PDR0_P00 _pdr0.bit.P00
#define PDR0_P01 _pdr0.bit.P01
#define PDR0_P02 _pdr0.bit.P02
#define PDR0_P03 _pdr0.bit.P03
#define PDR0_P04 _pdr0.bit.P04
#define PDR0_P05 _pdr0.bit.P05
#define PDR0_P06 _pdr0.bit.P06
#define PDR0_P07 _pdr0.bit.P07
__IO_EXTERN __io PDR1STR _pdr1;  
#define PDR1 _pdr1.byte
#define PDR1_P10 _pdr1.bit.P10
#define PDR1_P11 _pdr1.bit.P11
#define PDR1_P12 _pdr1.bit.P12
#define PDR1_P13 _pdr1.bit.P13
#define PDR1_P14 _pdr1.bit.P14
#define PDR1_P15 _pdr1.bit.P15
#define PDR1_P16 _pdr1.bit.P16
#define PDR1_P17 _pdr1.bit.P17
__IO_EXTERN __io PDR2STR _pdr2;  
#define PDR2 _pdr2.byte
#define PDR2_P20 _pdr2.bit.P20
#define PDR2_P21 _pdr2.bit.P21
#define PDR2_P22 _pdr2.bit.P22
#define PDR2_P23 _pdr2.bit.P23
#define PDR2_P24 _pdr2.bit.P24
#define PDR2_P25 _pdr2.bit.P25
#define PDR2_P26 _pdr2.bit.P26
#define PDR2_P27 _pdr2.bit.P27
__IO_EXTERN __io PDR3STR _pdr3;  
#define PDR3 _pdr3.byte
#define PDR3_P30 _pdr3.bit.P30
#define PDR3_P31 _pdr3.bit.P31
#define PDR3_P32 _pdr3.bit.P32
#define PDR3_P33 _pdr3.bit.P33
#define PDR3_P34 _pdr3.bit.P34
#define PDR3_P35 _pdr3.bit.P35
#define PDR3_P36 _pdr3.bit.P36
#define PDR3_P37 _pdr3.bit.P37
__IO_EXTERN __io PDR4STR _pdr4;  
#define PDR4 _pdr4.byte
#define PDR4_P40 _pdr4.bit.P40
#define PDR4_P41 _pdr4.bit.P41
#define PDR4_P42 _pdr4.bit.P42
#define PDR4_P43 _pdr4.bit.P43
#define PDR4_P44 _pdr4.bit.P44
#define PDR4_P45 _pdr4.bit.P45
#define PDR4_P46 _pdr4.bit.P46
#define PDR4_P47 _pdr4.bit.P47
__IO_EXTERN __io PDR5STR _pdr5;  
#define PDR5 _pdr5.byte
#define PDR5_P50 _pdr5.bit.P50
#define PDR5_P51 _pdr5.bit.P51
#define PDR5_P52 _pdr5.bit.P52
#define PDR5_P53 _pdr5.bit.P53
#define PDR5_P54 _pdr5.bit.P54
#define PDR5_P55 _pdr5.bit.P55
__IO_EXTERN __io PDR6STR _pdr6;  
#define PDR6 _pdr6.byte
#define PDR6_P60 _pdr6.bit.P60
#define PDR6_P61 _pdr6.bit.P61
#define PDR6_P62 _pdr6.bit.P62
#define PDR6_P63 _pdr6.bit.P63
#define PDR6_P64 _pdr6.bit.P64
#define PDR6_P65 _pdr6.bit.P65
#define PDR6_P66 _pdr6.bit.P66
#define PDR6_P67 _pdr6.bit.P67
__IO_EXTERN __io PDR7STR _pdr7;  
#define PDR7 _pdr7.byte
#define PDR7_P70 _pdr7.bit.P70
#define PDR7_P71 _pdr7.bit.P71
#define PDR7_P72 _pdr7.bit.P72
#define PDR7_P73 _pdr7.bit.P73
#define PDR7_P74 _pdr7.bit.P74
#define PDR7_P75 _pdr7.bit.P75
#define PDR7_P76 _pdr7.bit.P76
#define PDR7_P77 _pdr7.bit.P77
__IO_EXTERN __io PDR8STR _pdr8;  
#define PDR8 _pdr8.byte
#define PDR8_P80 _pdr8.bit.P80
#define PDR8_P81 _pdr8.bit.P81
#define PDR8_P82 _pdr8.bit.P82
#define PDR8_P83 _pdr8.bit.P83
#define PDR8_P84 _pdr8.bit.P84
#define PDR8_P85 _pdr8.bit.P85
#define PDR8_P86 _pdr8.bit.P86
#define PDR8_P87 _pdr8.bit.P87
__IO_EXTERN __io PDR9STR _pdr9;  
#define PDR9 _pdr9.byte
#define PDR9_P90 _pdr9.bit.P90
#define PDR9_P91 _pdr9.bit.P91
#define PDR9_P92 _pdr9.bit.P92
#define PDR9_P93 _pdr9.bit.P93
#define PDR9_P94 _pdr9.bit.P94
#define PDR9_P95 _pdr9.bit.P95
#define PDR9_P96 _pdr9.bit.P96
#define PDR9_P97 _pdr9.bit.P97
__IO_EXTERN __io PDRASTR _pdra;  
#define PDRA _pdra.byte
#define PDRA_PA0 _pdra.bit.PA0
#define PDRA_PA1 _pdra.bit.PA1
#define PDRA_PA2 _pdra.bit.PA2
#define PDRA_PA3 _pdra.bit.PA3
#define PDRA_PA4 _pdra.bit.PA4
__IO_EXTERN __io DDR0STR _ddr0;   /* PORT DIR */
#define DDR0 _ddr0.byte
#define DDR0_D00 _ddr0.bit.D00
#define DDR0_D01 _ddr0.bit.D01
#define DDR0_D02 _ddr0.bit.D02
#define DDR0_D03 _ddr0.bit.D03
#define DDR0_D04 _ddr0.bit.D04
#define DDR0_D05 _ddr0.bit.D05
#define DDR0_D06 _ddr0.bit.D06
#define DDR0_D07 _ddr0.bit.D07
__IO_EXTERN __io DDR1STR _ddr1;  
#define DDR1 _ddr1.byte
#define DDR1_D10 _ddr1.bit.D10
#define DDR1_D11 _ddr1.bit.D11
#define DDR1_D12 _ddr1.bit.D12
#define DDR1_D13 _ddr1.bit.D13
#define DDR1_D14 _ddr1.bit.D14
#define DDR1_D15 _ddr1.bit.D15
#define DDR1_D16 _ddr1.bit.D16
#define DDR1_D17 _ddr1.bit.D17
__IO_EXTERN __io DDR2STR _ddr2;  
#define DDR2 _ddr2.byte
#define DDR2_D20 _ddr2.bit.D20
#define DDR2_D21 _ddr2.bit.D21
#define DDR2_D22 _ddr2.bit.D22
#define DDR2_D23 _ddr2.bit.D23
#define DDR2_D24 _ddr2.bit.D24
#define DDR2_D25 _ddr2.bit.D25
#define DDR2_D26 _ddr2.bit.D26
#define DDR2_D27 _ddr2.bit.D27
__IO_EXTERN __io DDR3STR _ddr3;  
#define DDR3 _ddr3.byte
#define DDR3_D30 _ddr3.bit.D30
#define DDR3_D31 _ddr3.bit.D31
#define DDR3_D32 _ddr3.bit.D32
#define DDR3_D33 _ddr3.bit.D33
#define DDR3_D34 _ddr3.bit.D34
#define DDR3_D35 _ddr3.bit.D35
#define DDR3_D36 _ddr3.bit.D36
#define DDR3_D37 _ddr3.bit.D37
__IO_EXTERN __io DDR4STR _ddr4;  
#define DDR4 _ddr4.byte
#define DDR4_D40 _ddr4.bit.D40
#define DDR4_D41 _ddr4.bit.D41
#define DDR4_D42 _ddr4.bit.D42
#define DDR4_D43 _ddr4.bit.D43
#define DDR4_D44 _ddr4.bit.D44
#define DDR4_D45 _ddr4.bit.D45
#define DDR4_D46 _ddr4.bit.D46
#define DDR4_D47 _ddr4.bit.D47
__IO_EXTERN __io DDR6STR _ddr6;  
#define DDR6 _ddr6.byte
#define DDR6_D60 _ddr6.bit.D60
#define DDR6_D61 _ddr6.bit.D61
#define DDR6_D62 _ddr6.bit.D62
#define DDR6_D63 _ddr6.bit.D63
#define DDR6_D64 _ddr6.bit.D64
#define DDR6_D65 _ddr6.bit.D65
#define DDR6_D66 _ddr6.bit.D66
#define DDR6_D67 _ddr6.bit.D67
__IO_EXTERN __io DDR7STR _ddr7;  
#define DDR7 _ddr7.byte
#define DDR7_D70 _ddr7.bit.D70
#define DDR7_D71 _ddr7.bit.D71
#define DDR7_D72 _ddr7.bit.D72
#define DDR7_D73 _ddr7.bit.D73
#define DDR7_D74 _ddr7.bit.D74
#define DDR7_D75 _ddr7.bit.D75
#define DDR7_D76 _ddr7.bit.D76
#define DDR7_D77 _ddr7.bit.D77
__IO_EXTERN __io DDR8STR _ddr8;  
#define DDR8 _ddr8.byte
#define DDR8_D80 _ddr8.bit.D80
#define DDR8_D81 _ddr8.bit.D81
#define DDR8_D82 _ddr8.bit.D82
#define DDR8_D83 _ddr8.bit.D83
#define DDR8_D84 _ddr8.bit.D84
#define DDR8_D85 _ddr8.bit.D85
#define DDR8_D86 _ddr8.bit.D86
#define DDR8_D87 _ddr8.bit.D87
__IO_EXTERN __io DDR9STR _ddr9;  
#define DDR9 _ddr9.byte
#define DDR9_D90 _ddr9.bit.D90
#define DDR9_D91 _ddr9.bit.D91
#define DDR9_D92 _ddr9.bit.D92
#define DDR9_D93 _ddr9.bit.D93
#define DDR9_D94 _ddr9.bit.D94
#define DDR9_D95 _ddr9.bit.D95
#define DDR9_D96 _ddr9.bit.D96
#define DDR9_D97 _ddr9.bit.D97
__IO_EXTERN __io DDRASTR _ddra;  
#define DDRA _ddra.byte
#define DDRA_DA0 _ddra.bit.DA0
#define DDRA_DA1 _ddra.bit.DA1
#define DDRA_DA2 _ddra.bit.DA2
#define DDRA_DA3 _ddra.bit.DA3
#define DDRA_DA4 _ddra.bit.DA4
__IO_EXTERN __io ODR4STR _odr4;   /* Output Pin Register */
#define ODR4 _odr4.byte
#define ODR4_OD40 _odr4.bit.OD40
#define ODR4_OD41 _odr4.bit.OD41
#define ODR4_OD42 _odr4.bit.OD42
#define ODR4_OD43 _odr4.bit.OD43
#define ODR4_OD44 _odr4.bit.OD44
#define ODR4_OD45 _odr4.bit.OD45
#define ODR4_OD46 _odr4.bit.OD46
#define ODR4_OD47 _odr4.bit.OD47
__IO_EXTERN __io RDR0STR _rdr0;   /* Input Resistance Register */
#define RDR0 _rdr0.byte
#define RDR0_RD00 _rdr0.bit.RD00
#define RDR0_RD01 _rdr0.bit.RD01
#define RDR0_RD02 _rdr0.bit.RD02
#define RDR0_RD03 _rdr0.bit.RD03
#define RDR0_RD04 _rdr0.bit.RD04
#define RDR0_RD05 _rdr0.bit.RD05
#define RDR0_RD06 _rdr0.bit.RD06
#define RDR0_RD07 _rdr0.bit.RD07
__IO_EXTERN __io RDR1STR _rdr1;  
#define RDR1 _rdr1.byte
#define RDR1_RD10 _rdr1.bit.RD10
#define RDR1_RD11 _rdr1.bit.RD11
#define RDR1_RD12 _rdr1.bit.RD12
#define RDR1_RD13 _rdr1.bit.RD13
#define RDR1_RD14 _rdr1.bit.RD14
#define RDR1_RD15 _rdr1.bit.RD15
#define RDR1_RD16 _rdr1.bit.RD16
#define RDR1_RD17 _rdr1.bit.RD17
__IO_EXTERN __io ADERSTR _ader;   /* Analog Input Enable Register */
#define ADER _ader.byte
#define ADER_ADE0 _ader.bit.ADE0
#define ADER_ADE1 _ader.bit.ADE1
#define ADER_ADE2 _ader.bit.ADE2
#define ADER_ADE3 _ader.bit.ADE3
#define ADER_ADE4 _ader.bit.ADE4
#define ADER_ADE5 _ader.bit.ADE5
#define ADER_ADE6 _ader.bit.ADE6
#define ADER_ADE7 _ader.bit.ADE7
__IO_EXTERN __io SMRSTR _smr;   /* UART0,1 */
#define SMR _smr.byte
#define SMR_SOE _smr.bit.SOE
#define SMR_SCKE _smr.bit.SCKE
#define SMR_CS0 _smr.bit.CS0
#define SMR_CS1 _smr.bit.CS1
#define SMR_CS2 _smr.bit.CS2
#define SMR_MD0 _smr.bit.MD0
#define SMR_MD1 _smr.bit.MD1
#define SMR_CS _smr.bitc.CS
#define SMR_MD _smr.bitc.MD
__IO_EXTERN __io SCRSTR _scr;  
#define SCR _scr.byte
#define SCR_TXE _scr.bit.TXE
#define SCR_RXE _scr.bit.RXE
#define SCR_REC _scr.bit.REC
#define SCR_AD _scr.bit.AD
#define SCR_CL _scr.bit.CL
#define SCR_SBL _scr.bit.SBL
#define SCR_P _scr.bit.P
#define SCR_PEN _scr.bit.PEN
__IO_EXTERN __io IO_BYTE _sidr;
#define SIDR _sidr   
__IO_EXTERN __io IO_BYTE _sodr;
#define SODR _sodr   
__IO_EXTERN __io SSRSTR _ssr;  
#define SSR _ssr.byte
#define SSR_TIE _ssr.bit.TIE
#define SSR_RIE _ssr.bit.RIE
#define SSR_TDRE _ssr.bit.TDRE
#define SSR_RDRF _ssr.bit.RDRF
#define SSR_FRE _ssr.bit.FRE
#define SSR_ORE _ssr.bit.ORE
#define SSR_PE _ssr.bit.PE
__IO_EXTERN __io SMCS0STR _smcs0;   /* SIO channels 0,1 */
#define SMCS0 _smcs0.word
#define SMCS0_SCOE _smcs0.bit.SCOE
#define SMCS0_SOE _smcs0.bit.SOE
#define SMCS0_BDS _smcs0.bit.BDS
#define SMCS0_MODE _smcs0.bit.MODE
#define SMCS0_STRT _smcs0.bit.STRT
#define SMCS0_STOP _smcs0.bit.STOP
#define SMCS0_BUSY _smcs0.bit.BUSY
#define SMCS0_SIR _smcs0.bit.SIR
#define SMCS0_SIE _smcs0.bit.SIE
#define SMCS0_SMD0 _smcs0.bit.SMD0
#define SMCS0_SMD1 _smcs0.bit.SMD1
#define SMCS0_SMD2 _smcs0.bit.SMD2
#define SMCS0_SMD _smcs0.bitc.SMD
__IO_EXTERN __io IO_BYTE _sdr0;
#define SDR0 _sdr0   
__IO_EXTERN __io CDCRSTR _cdcr;  
#define CDCR _cdcr.byte
#define CDCR_DIV0 _cdcr.bit.DIV0
#define CDCR_DIV1 _cdcr.bit.DIV1
#define CDCR_DIV2 _cdcr.bit.DIV2
#define CDCR_DIV3 _cdcr.bit.DIV3
#define CDCR_MD _cdcr.bit.MD
#define CDCR_DIV _cdcr.bitc.DIV
__IO_EXTERN __io SMCS1STR _smcs1;  
#define SMCS1 _smcs1.word
#define SMCS1_SCOE _smcs1.bit.SCOE
#define SMCS1_SOE _smcs1.bit.SOE
#define SMCS1_BDS _smcs1.bit.BDS
#define SMCS1_MODE _smcs1.bit.MODE
#define SMCS1_STRT _smcs1.bit.STRT
#define SMCS1_STOP _smcs1.bit.STOP
#define SMCS1_BUSY _smcs1.bit.BUSY
#define SMCS1_SIR _smcs1.bit.SIR
#define SMCS1_SIE _smcs1.bit.SIE
#define SMCS1_SMD0 _smcs1.bit.SMD0
#define SMCS1_SMD1 _smcs1.bit.SMD1
#define SMCS1_SMD2 _smcs1.bit.SMD2
#define SMCS1_SMD _smcs1.bitc.SMD
__IO_EXTERN __io IO_BYTE _sdr1;
#define SDR1 _sdr1   
__IO_EXTERN __io IBSR0STR _ibsr0;   /* Iih Quadrat C */
#define IBSR0 _ibsr0.byte
#define IBSR0_FBT _ibsr0.bit.FBT
#define IBSR0_GCA _ibsr0.bit.GCA
#define IBSR0_AAS _ibsr0.bit.AAS
#define IBSR0_TRX _ibsr0.bit.TRX
#define IBSR0_LRB _ibsr0.bit.LRB
#define IBSR0_AL _ibsr0.bit.AL
#define IBSR0_RSC _ibsr0.bit.RSC
#define IBSR0_BB _ibsr0.bit.BB
__IO_EXTERN __io IBCR0STR _ibcr0;  
#define IBCR0 _ibcr0.byte
#define IBCR0_INT _ibcr0.bit.INT
#define IBCR0_INTE _ibcr0.bit.INTE
#define IBCR0_GCAA _ibcr0.bit.GCAA
#define IBCR0_ACK _ibcr0.bit.ACK
#define IBCR0_MSS _ibcr0.bit.MSS
#define IBCR0_SCC _ibcr0.bit.SCC
#define IBCR0_BEIE _ibcr0.bit.BEIE
#define IBCR0_BER _ibcr0.bit.BER
__IO_EXTERN __io ICCR0STR _iccr0;  
#define ICCR0 _iccr0.byte
#define ICCR0_CS0 _iccr0.bit.CS0
#define ICCR0_CS1 _iccr0.bit.CS1
#define ICCR0_CS2 _iccr0.bit.CS2
#define ICCR0_CS3 _iccr0.bit.CS3
#define ICCR0_CS4 _iccr0.bit.CS4
#define ICCR0_EN _iccr0.bit.EN
#define ICCR0_CS _iccr0.bitc.CS
__IO_EXTERN __io IO_BYTE _iadr0;
#define IADR0 _iadr0   
__IO_EXTERN __io IO_BYTE _idar0;
#define IDAR0 _idar0   
__IO_EXTERN __io IBSR1STR _ibsr1;  
#define IBSR1 _ibsr1.byte
#define IBSR1_FBT _ibsr1.bit.FBT
#define IBSR1_GCA _ibsr1.bit.GCA
#define IBSR1_AAS _ibsr1.bit.AAS
#define IBSR1_TRX _ibsr1.bit.TRX
#define IBSR1_LRB _ibsr1.bit.LRB
#define IBSR1_AL _ibsr1.bit.AL
#define IBSR1_RSC _ibsr1.bit.RSC
#define IBSR1_BB _ibsr1.bit.BB
__IO_EXTERN __io IBCR1STR _ibcr1;  
#define IBCR1 _ibcr1.byte
#define IBCR1_INT _ibcr1.bit.INT
#define IBCR1_INTE _ibcr1.bit.INTE
#define IBCR1_GCAA _ibcr1.bit.GCAA
#define IBCR1_ACK _ibcr1.bit.ACK
#define IBCR1_MSS _ibcr1.bit.MSS
#define IBCR1_SCC _ibcr1.bit.SCC
#define IBCR1_BEIE _ibcr1.bit.BEIE
#define IBCR1_BER _ibcr1.bit.BER
__IO_EXTERN __io ICCR1STR _iccr1;  
#define ICCR1 _iccr1.byte
#define ICCR1_CS0 _iccr1.bit.CS0
#define ICCR1_CS1 _iccr1.bit.CS1
#define ICCR1_CS2 _iccr1.bit.CS2
#define ICCR1_CS3 _iccr1.bit.CS3
#define ICCR1_CS4 _iccr1.bit.CS4
#define ICCR1_EN _iccr1.bit.EN
#define ICCR1_CS _iccr1.bitc.CS
__IO_EXTERN __io IO_BYTE _iadr1;
#define IADR1 _iadr1   
__IO_EXTERN __io IO_BYTE _idar1;
#define IDAR1 _idar1   
__IO_EXTERN __io ISELSTR _isel;  
#define ISEL _isel.byte
#define ISEL_PSEL _isel.bit.PSEL
__IO_EXTERN __io ENIRSTR _enir;   /* DTP, External Interrupts */
#define ENIR _enir.byte
#define ENIR_EN0 _enir.bit.EN0
#define ENIR_EN1 _enir.bit.EN1
#define ENIR_EN2 _enir.bit.EN2
#define ENIR_EN3 _enir.bit.EN3
#define ENIR_EN4 _enir.bit.EN4
#define ENIR_EN5 _enir.bit.EN5
#define ENIR_EN6 _enir.bit.EN6
#define ENIR_EN7 _enir.bit.EN7
__IO_EXTERN __io EIRRSTR _eirr;  
#define EIRR _eirr.byte
#define EIRR_ER0 _eirr.bit.ER0
#define EIRR_ER1 _eirr.bit.ER1
#define EIRR_ER2 _eirr.bit.ER2
#define EIRR_ER3 _eirr.bit.ER3
#define EIRR_ER4 _eirr.bit.ER4
#define EIRR_ER5 _eirr.bit.ER5
#define EIRR_ER6 _eirr.bit.ER6
#define EIRR_ER7 _eirr.bit.ER7
/*-------------------------------------------------------------------**
**  External Interrupt Input Level register                          **
**                                                                   **
**  This declaration is intended to be included in IO-Wizard source  **
**  files.                                                           **
**  V0.1 still missing prefix '_'                                    **
**  V1.0 symbol prefix '_' added                                     **
**  V1.2 "extern" changed to pre-defined macro of IO-Wizrad, re-     **
**       quires IO-Wizard 1.7 or later                               **
**-------------------------------------------------------------------*/

#ifndef __ELVR_H
#define __ELVR_H

typedef union{  
    IO_WORD word;
    struct{
      IO_WORD LA0 :1;
      IO_WORD LB0 :1;
      IO_WORD LA1 :1;
      IO_WORD LB1 :1;
      IO_WORD LA2 :1;
      IO_WORD LB2 :1;
      IO_WORD LA3 :1;
      IO_WORD LB3 :1;
      IO_WORD LA4 :1;
      IO_WORD LB4 :1;
      IO_WORD LA5 :1;
      IO_WORD LB5 :1;
      IO_WORD LA6 :1;
      IO_WORD LB6 :1;
      IO_WORD LA7 :1;
      IO_WORD LB7 :1;
    }bit;
    struct{
      IO_WORD LALB0 :2;
      IO_WORD LALB1 :2;
      IO_WORD LALB2 :2;
      IO_WORD LALB3 :2;
      IO_WORD LALB4 :2;
      IO_WORD LALB5 :2;
      IO_WORD LALB6 :2;
      IO_WORD LALB7 :2;
    } bitc;
} ELVRSTR;

__IO_EXTERN __io ELVRSTR _elvr;  
#define ELVR        _elvr.word
#define ELVR_LA0    _elvr.bit.LA0
#define ELVR_LB0    _elvr.bit.LB0
#define ELVR_LA1    _elvr.bit.LA1
#define ELVR_LB1    _elvr.bit.LB1
#define ELVR_LA2    _elvr.bit.LA2
#define ELVR_LB2    _elvr.bit.LB2
#define ELVR_LA3    _elvr.bit.LA3
#define ELVR_LB3    _elvr.bit.LB3
#define ELVR_LA4    _elvr.bit.LA4
#define ELVR_LB4    _elvr.bit.LB4
#define ELVR_LA5    _elvr.bit.LA5
#define ELVR_LB5    _elvr.bit.LB5
#define ELVR_LA6    _elvr.bit.LA6
#define ELVR_LB6    _elvr.bit.LB6
#define ELVR_LA7    _elvr.bit.LA7
#define ELVR_LB7    _elvr.bit.LB7
#define ELVR_LALB0  _elvr.bitc.LALB0
#define ELVR_LALB1  _elvr.bitc.LALB1
#define ELVR_LALB2  _elvr.bitc.LALB2
#define ELVR_LALB3  _elvr.bitc.LALB3
#define ELVR_LALB4  _elvr.bitc.LALB4
#define ELVR_LALB5  _elvr.bitc.LALB5
#define ELVR_LALB6  _elvr.bitc.LALB6
#define ELVR_LALB7  _elvr.bitc.LALB7

#endif
__IO_EXTERN __io ADCS1STR _adcs1;   /* AD Converter */
#define ADCS1 _adcs1.byte
#define ADCS1_ANE0 _adcs1.bit.ANE0
#define ADCS1_ANE1 _adcs1.bit.ANE1
#define ADCS1_ANE2 _adcs1.bit.ANE2
#define ADCS1_ANS0 _adcs1.bit.ANS0
#define ADCS1_ANS1 _adcs1.bit.ANS1
#define ADCS1_ANS2 _adcs1.bit.ANS2
#define ADCS1_MD0 _adcs1.bit.MD0
#define ADCS1_MD1 _adcs1.bit.MD1
#define ADCS1_ANE _adcs1.bitc.ANE
#define ADCS1_ANS _adcs1.bitc.ANS
#define ADCS1_MD _adcs1.bitc.MD
__IO_EXTERN __io ADCS2STR _adcs2;  
#define ADCS2 _adcs2.byte
#define ADCS2_DA _adcs2.bit.DA
#define ADCS2_STRT _adcs2.bit.STRT
#define ADCS2_STS0 _adcs2.bit.STS0
#define ADCS2_STS1 _adcs2.bit.STS1
#define ADCS2_PAUS _adcs2.bit.PAUS
#define ADCS2_INTE _adcs2.bit.INTE
#define ADCS2_INT _adcs2.bit.INT
#define ADCS2_BUSY _adcs2.bit.BUSY
#define ADCS2_STS _adcs2.bitc.STS
__IO_EXTERN __io IO_BYTE _adcr1;
#define ADCR1 _adcr1   
__IO_EXTERN __io ADCR2STR _adcr2;  
#define ADCR2 _adcr2.byte
#define ADCR2_CT0 _adcr2.bit.CT0
#define ADCR2_CT1 _adcr2.bit.CT1
#define ADCR2_ST0 _adcr2.bit.ST0
#define ADCR2_ST1 _adcr2.bit.ST1
#define ADCR2_CT _adcr2.bitc.CT
#define ADCR2_ST _adcr2.bitc.ST
__IO_EXTERN __io IO_BYTE _prll0;
#define PRLL0 _prll0    /* Puls Pattern Generator Channel 0,1 */
__IO_EXTERN __io IO_BYTE _prlh0;
#define PRLH0 _prlh0   
__IO_EXTERN __io IO_BYTE _prll1;
#define PRLL1 _prll1   
__IO_EXTERN __io IO_BYTE _prlh1;
#define PRLH1 _prlh1   
__IO_EXTERN __io PPGC0STR _ppgc0;  
#define PPGC0 _ppgc0.byte
#define PPGC0_PUF0 _ppgc0.bit.PUF0
#define PPGC0_PIE0 _ppgc0.bit.PIE0
#define PPGC0_POE0 _ppgc0.bit.POE0
#define PPGC0_PEN0 _ppgc0.bit.PEN0
__IO_EXTERN __io PPGC1STR _ppgc1;  
#define PPGC1 _ppgc1.byte
#define PPGC1_MD0 _ppgc1.bit.MD0
#define PPGC1_MD1 _ppgc1.bit.MD1
#define PPGC1_PUF1 _ppgc1.bit.PUF1
#define PPGC1_PIE1 _ppgc1.bit.PIE1
#define PPGC1_POE1 _ppgc1.bit.POE1
#define PPGC1_PEN1 _ppgc1.bit.PEN1
#define PPGC1_MD _ppgc1.bitc.MD
__IO_EXTERN __io PPGOE0STR _ppgoe0;  
#define PPGOE0 _ppgoe0.byte
#define PPGOE0_PCM0 _ppgoe0.bit.PCM0
#define PPGOE0_PCM1 _ppgoe0.bit.PCM1
#define PPGOE0_PCM2 _ppgoe0.bit.PCM2
#define PPGOE0_PCS0 _ppgoe0.bit.PCS0
#define PPGOE0_PCS1 _ppgoe0.bit.PCS1
#define PPGOE0_PCS2 _ppgoe0.bit.PCS2
#define PPGOE0_PCM _ppgoe0.bitc.PCM
#define PPGOE0_PCS _ppgoe0.bitc.PCS
__IO_EXTERN __io PPGOE1STR _ppgoe1;  
#define PPGOE1 _ppgoe1.byte
#define PPGOE1_PCM0 _ppgoe1.bit.PCM0
#define PPGOE1_PCM1 _ppgoe1.bit.PCM1
#define PPGOE1_PCM2 _ppgoe1.bit.PCM2
#define PPGOE1_PCS0 _ppgoe1.bit.PCS0
#define PPGOE1_PCS1 _ppgoe1.bit.PCS1
#define PPGOE1_PCS2 _ppgoe1.bit.PCS2
#define PPGOE1_PCM _ppgoe1.bitc.PCM
#define PPGOE1_PCS _ppgoe1.bitc.PCS
__IO_EXTERN __io IO_BYTE _prll2;
#define PRLL2 _prll2   
__IO_EXTERN __io IO_BYTE _prlh2;
#define PRLH2 _prlh2   
__IO_EXTERN __io IO_BYTE _prll3;
#define PRLL3 _prll3   
__IO_EXTERN __io IO_BYTE _prlh3;
#define PRLH3 _prlh3   
__IO_EXTERN __io PPGC2STR _ppgc2;  
#define PPGC2 _ppgc2.byte
#define PPGC2_PUF2 _ppgc2.bit.PUF2
#define PPGC2_PIE2 _ppgc2.bit.PIE2
#define PPGC2_POE2 _ppgc2.bit.POE2
#define PPGC2_PEN2 _ppgc2.bit.PEN2
__IO_EXTERN __io PPGC3STR _ppgc3;  
#define PPGC3 _ppgc3.byte
#define PPGC3_MD0 _ppgc3.bit.MD0
#define PPGC3_MD1 _ppgc3.bit.MD1
#define PPGC3_PUF3 _ppgc3.bit.PUF3
#define PPGC3_PIE3 _ppgc3.bit.PIE3
#define PPGC3_POE3 _ppgc3.bit.POE3
#define PPGC3_PEN3 _ppgc3.bit.PEN3
#define PPGC3_MD _ppgc3.bitc.MD
__IO_EXTERN __io PPGOE2STR _ppgoe2;  
#define PPGOE2 _ppgoe2.byte
#define PPGOE2_PCM0 _ppgoe2.bit.PCM0
#define PPGOE2_PCM1 _ppgoe2.bit.PCM1
#define PPGOE2_PCM2 _ppgoe2.bit.PCM2
#define PPGOE2_PCS0 _ppgoe2.bit.PCS0
#define PPGOE2_PCS1 _ppgoe2.bit.PCS1
#define PPGOE2_PCS2 _ppgoe2.bit.PCS2
#define PPGOE2_PCM _ppgoe2.bitc.PCM
#define PPGOE2_PCS _ppgoe2.bitc.PCS
__IO_EXTERN __io PPGOE3STR _ppgoe3;  
#define PPGOE3 _ppgoe3.byte
#define PPGOE3_PCM0 _ppgoe3.bit.PCM0
#define PPGOE3_PCM1 _ppgoe3.bit.PCM1
#define PPGOE3_PCM2 _ppgoe3.bit.PCM2
#define PPGOE3_PCS0 _ppgoe3.bit.PCS0
#define PPGOE3_PCS1 _ppgoe3.bit.PCS1
#define PPGOE3_PCS2 _ppgoe3.bit.PCS2
#define PPGOE3_PCM _ppgoe3.bitc.PCM
#define PPGOE3_PCS _ppgoe3.bitc.PCS
__IO_EXTERN __io IO_BYTE _prll4;
#define PRLL4 _prll4   
__IO_EXTERN __io IO_BYTE _prlh4;
#define PRLH4 _prlh4   
__IO_EXTERN __io IO_BYTE _prll5;
#define PRLL5 _prll5   
__IO_EXTERN __io IO_BYTE _prlh5;
#define PRLH5 _prlh5   
__IO_EXTERN __io PPGC4STR _ppgc4;  
#define PPGC4 _ppgc4.byte
#define PPGC4_PUF4 _ppgc4.bit.PUF4
#define PPGC4_PIE4 _ppgc4.bit.PIE4
#define PPGC4_POE4 _ppgc4.bit.POE4
#define PPGC4_PEN4 _ppgc4.bit.PEN4
__IO_EXTERN __io PPGC5STR _ppgc5;  
#define PPGC5 _ppgc5.byte
#define PPGC5_MD0 _ppgc5.bit.MD0
#define PPGC5_MD1 _ppgc5.bit.MD1
#define PPGC5_PUF5 _ppgc5.bit.PUF5
#define PPGC5_PIE5 _ppgc5.bit.PIE5
#define PPGC5_POE5 _ppgc5.bit.POE5
#define PPGC5_PEN5 _ppgc5.bit.PEN5
#define PPGC5_MD _ppgc5.bitc.MD
__IO_EXTERN __io PPGOE4STR _ppgoe4;  
#define PPGOE4 _ppgoe4.byte
#define PPGOE4_PCM0 _ppgoe4.bit.PCM0
#define PPGOE4_PCM1 _ppgoe4.bit.PCM1
#define PPGOE4_PCM2 _ppgoe4.bit.PCM2
#define PPGOE4_PCS0 _ppgoe4.bit.PCS0
#define PPGOE4_PCS1 _ppgoe4.bit.PCS1
#define PPGOE4_PCS2 _ppgoe4.bit.PCS2
#define PPGOE4_PCM _ppgoe4.bitc.PCM
#define PPGOE4_PCS _ppgoe4.bitc.PCS
__IO_EXTERN __io PPGOE5STR _ppgoe5;  
#define PPGOE5 _ppgoe5.byte
#define PPGOE5_PCM0 _ppgoe5.bit.PCM0
#define PPGOE5_PCM1 _ppgoe5.bit.PCM1
#define PPGOE5_PCM2 _ppgoe5.bit.PCM2
#define PPGOE5_PCS0 _ppgoe5.bit.PCS0
#define PPGOE5_PCS1 _ppgoe5.bit.PCS1
#define PPGOE5_PCS2 _ppgoe5.bit.PCS2
#define PPGOE5_PCM _ppgoe5.bitc.PCM
#define PPGOE5_PCS _ppgoe5.bitc.PCS
__IO_EXTERN __io CLKRSTR _clkr;   /* Clock Monitor Function */
#define CLKR _clkr.byte
#define CLKR_FRQ0 _clkr.bit.FRQ0
#define CLKR_FRQ1 _clkr.bit.FRQ1
#define CLKR_FRQ2 _clkr.bit.FRQ2
#define CLKR_CKEN _clkr.bit.CKEN
#define CLKR_FRQ _clkr.bitc.FRQ
__IO_EXTERN __io TMCSR0STR _tmcsr0;   /* Reload Timer */
#define TMCSR0 _tmcsr0.word
#define TMCSR0_TRG _tmcsr0.bit.TRG
#define TMCSR0_CNTE _tmcsr0.bit.CNTE
#define TMCSR0_UF _tmcsr0.bit.UF
#define TMCSR0_INTE _tmcsr0.bit.INTE
#define TMCSR0_RELD _tmcsr0.bit.RELD
#define TMCSR0_OUTL _tmcsr0.bit.OUTL
#define TMCSR0_OUTE _tmcsr0.bit.OUTE
#define TMCSR0_MOD0 _tmcsr0.bit.MOD0
#define TMCSR0_MOD1 _tmcsr0.bit.MOD1
#define TMCSR0_MOD2 _tmcsr0.bit.MOD2
#define TMCSR0_CSL0 _tmcsr0.bit.CSL0
#define TMCSR0_CSL1 _tmcsr0.bit.CSL1
#define TMCSR0_MOD _tmcsr0.bitc.MOD
#define TMCSR0_CSL _tmcsr0.bitc.CSL
__IO_EXTERN __io IO_WORD _tmr0;
#define TMR0 _tmr0   
__IO_EXTERN __io IO_WORD _tmrlr0;
#define TMRLR0 _tmrlr0   
__IO_EXTERN __io TMCSR1STR _tmcsr1;  
#define TMCSR1 _tmcsr1.word
#define TMCSR1_TRG _tmcsr1.bit.TRG
#define TMCSR1_CNTE _tmcsr1.bit.CNTE
#define TMCSR1_UF _tmcsr1.bit.UF
#define TMCSR1_INTE _tmcsr1.bit.INTE
#define TMCSR1_RELD _tmcsr1.bit.RELD
#define TMCSR1_OUTL _tmcsr1.bit.OUTL
#define TMCSR1_OUTE _tmcsr1.bit.OUTE
#define TMCSR1_MOD0 _tmcsr1.bit.MOD0
#define TMCSR1_MOD1 _tmcsr1.bit.MOD1
#define TMCSR1_MOD2 _tmcsr1.bit.MOD2
#define TMCSR1_CSL0 _tmcsr1.bit.CSL0
#define TMCSR1_CSL1 _tmcsr1.bit.CSL1
#define TMCSR1_MOD _tmcsr1.bitc.MOD
#define TMCSR1_CSL _tmcsr1.bitc.CSL
__IO_EXTERN __io IO_WORD _tmr1;
#define TMR1 _tmr1   
__IO_EXTERN __io IO_WORD _tmrlr1;
#define TMRLR1 _tmrlr1   
__IO_EXTERN __io IO_WORD _ipcp0;
#define IPCP0 _ipcp0    /* ICU OCU units */
__IO_EXTERN __io IO_WORD _ipcp1;
#define IPCP1 _ipcp1   
__IO_EXTERN __io IO_WORD _ipcp2;
#define IPCP2 _ipcp2   
__IO_EXTERN __io IO_WORD _ipcp3;
#define IPCP3 _ipcp3   
__IO_EXTERN __io ICS01STR _ics01;  
#define ICS01 _ics01.byte
#define ICS01_EG00 _ics01.bit.EG00
#define ICS01_EG01 _ics01.bit.EG01
#define ICS01_EG10 _ics01.bit.EG10
#define ICS01_EG11 _ics01.bit.EG11
#define ICS01_ICE0 _ics01.bit.ICE0
#define ICS01_ICE1 _ics01.bit.ICE1
#define ICS01_ICP0 _ics01.bit.ICP0
#define ICS01_ICP1 _ics01.bit.ICP1
#define ICS01_EG0 _ics01.bitc.EG0
#define ICS01_EG1 _ics01.bitc.EG1
__IO_EXTERN __io ICS23STR _ics23;  
#define ICS23 _ics23.byte
#define ICS23_EG02 _ics23.bit.EG02
#define ICS23_EG03 _ics23.bit.EG03
#define ICS23_EG12 _ics23.bit.EG12
#define ICS23_EG13 _ics23.bit.EG13
#define ICS23_ICE2 _ics23.bit.ICE2
#define ICS23_ICE3 _ics23.bit.ICE3
#define ICS23_ICP2 _ics23.bit.ICP2
#define ICS23_ICP3 _ics23.bit.ICP3
#define ICS23_EG0 _ics23.bitc.EG0
#define ICS23_EG1 _ics23.bitc.EG1
__IO_EXTERN __io IO_WORD _tcdt;
#define TCDT _tcdt   
__IO_EXTERN __io TCCSSTR _tccs;  
#define TCCS _tccs.byte
#define TCCS_CLK0 _tccs.bit.CLK0
#define TCCS_CLK1 _tccs.bit.CLK1
#define TCCS_CLR _tccs.bit.CLR
#define TCCS_MODE _tccs.bit.MODE
#define TCCS_STOP _tccs.bit.STOP
#define TCCS_IVFE _tccs.bit.IVFE
#define TCCS_IVF _tccs.bit.IVF
#define TCCS_CLK _tccs.bitc.CLK
__IO_EXTERN __io ROMMSTR _romm;   /* ROM mirror function */
#define ROMM _romm.byte
#define ROMM_MI _romm.bit.MI
__IO_EXTERN __io IO_WORD _occp0;
#define OCCP0 _occp0    /* ICU OCU units */
__IO_EXTERN __io IO_WORD _occp1;
#define OCCP1 _occp1   
__IO_EXTERN __io IO_WORD _occp2;
#define OCCP2 _occp2   
__IO_EXTERN __io IO_WORD _occp3;
#define OCCP3 _occp3   
__IO_EXTERN __io OCS0STR _ocs0;  
#define OCS0 _ocs0.byte
#define OCS0_CST0 _ocs0.bit.CST0
#define OCS0_CST1 _ocs0.bit.CST1
#define OCS0_ICE0 _ocs0.bit.ICE0
#define OCS0_ICE1 _ocs0.bit.ICE1
#define OCS0_ICP0 _ocs0.bit.ICP0
#define OCS0_ICP1 _ocs0.bit.ICP1
__IO_EXTERN __io OCS1STR _ocs1;  
#define OCS1 _ocs1.byte
#define OCS1_OTD0 _ocs1.bit.OTD0
#define OCS1_OTD1 _ocs1.bit.OTD1
#define OCS1_OTE0 _ocs1.bit.OTE0
#define OCS1_OTE1 _ocs1.bit.OTE1
#define OCS1_CMOD _ocs1.bit.CMOD
__IO_EXTERN __io OCS2STR _ocs2;  
#define OCS2 _ocs2.byte
#define OCS2_CST0 _ocs2.bit.CST0
#define OCS2_CST1 _ocs2.bit.CST1
#define OCS2_ICE0 _ocs2.bit.ICE0
#define OCS2_ICE1 _ocs2.bit.ICE1
#define OCS2_ICP0 _ocs2.bit.ICP0
#define OCS2_ICP1 _ocs2.bit.ICP1
__IO_EXTERN __io OCS3STR _ocs3;  
#define OCS3 _ocs3.byte
#define OCS3_OTD0 _ocs3.bit.OTD0
#define OCS3_OTD1 _ocs3.bit.OTD1
#define OCS3_OTE0 _ocs3.bit.OTE0
#define OCS3_OTE1 _ocs3.bit.OTE1
#define OCS3_CMOD _ocs3.bit.CMOD
__IO_EXTERN __io DIRRSTR _dirr;   /* Delayed Interrupt */
#define DIRR _dirr.byte
#define DIRR_R0 _dirr.bit.R0
__IO_EXTERN __io LPMCRSTR _lpmcr;   /* Low Power Control Registers */
#define LPMCR _lpmcr.byte
#define LPMCR_CG0 _lpmcr.bit.CG0
#define LPMCR_CG1 _lpmcr.bit.CG1
#define LPMCR_RST _lpmcr.bit.RST
#define LPMCR_SPL _lpmcr.bit.SPL
#define LPMCR_SLP _lpmcr.bit.SLP
#define LPMCR_STP _lpmcr.bit.STP
#define LPMCR_CG _lpmcr.bitc.CG
__IO_EXTERN __io CKSCRSTR _ckscr;  
#define CKSCR _ckscr.byte
#define CKSCR_CS0 _ckscr.bit.CS0
#define CKSCR_CS1 _ckscr.bit.CS1
#define CKSCR_MCS _ckscr.bit.MCS
#define CKSCR_WS0 _ckscr.bit.WS0
#define CKSCR_WS1 _ckscr.bit.WS1
#define CKSCR_MCM _ckscr.bit.MCM
#define CKSCR_CS _ckscr.bitc.CS
#define CKSCR_WS _ckscr.bitc.WS
__IO_EXTERN __io ARSRSTR _arsr;   /* External Bus I/F */
#define ARSR _arsr.byte
#define ARSR_LMR0 _arsr.bit.LMR0
#define ARSR_LMR1 _arsr.bit.LMR1
#define ARSR_HMR0 _arsr.bit.HMR0
#define ARSR_HMR1 _arsr.bit.HMR1
#define ARSR_IOR0 _arsr.bit.IOR0
#define ARSR_IOR1 _arsr.bit.IOR1
#define ARSR_LMR _arsr.bitc.LMR
#define ARSR_HMR _arsr.bitc.HMR
#define ARSR_IOR _arsr.bitc.IOR
__IO_EXTERN __io HACRSTR _hacr;  
#define HACR _hacr.byte
#define HACR_E16 _hacr.bit.E16
#define HACR_E17 _hacr.bit.E17
#define HACR_E18 _hacr.bit.E18
#define HACR_E19 _hacr.bit.E19
#define HACR_E20 _hacr.bit.E20
#define HACR_E21 _hacr.bit.E21
#define HACR_E22 _hacr.bit.E22
#define HACR_E23 _hacr.bit.E23
__IO_EXTERN __io ECSRSTR _ecsr;  
#define ECSR _ecsr.byte
#define ECSR_LMBS _ecsr.bit.LMBS
#define ECSR_WRE _ecsr.bit.WRE
#define ECSR_HMBS _ecsr.bit.HMBS
#define ECSR_IOBS _ecsr.bit.IOBS
#define ECSR_HDE _ecsr.bit.HDE
#define ECSR_RYE _ecsr.bit.RYE
#define ECSR_CKE _ecsr.bit.CKE
__IO_EXTERN __io WDTCSTR _wdtc;   /* Watch Dog */
#define WDTC _wdtc.byte
#define WDTC_WT0 _wdtc.bit.WT0
#define WDTC_WT1 _wdtc.bit.WT1
#define WDTC_WTE _wdtc.bit.WTE
#define WDTC_SRST _wdtc.bit.SRST
#define WDTC_ERST _wdtc.bit.ERST
#define WDTC_WRST _wdtc.bit.WRST
#define WDTC_STBR _wdtc.bit.STBR
#define WDTC_PONR _wdtc.bit.PONR
#define WDTC_WT _wdtc.bitc.WT
__IO_EXTERN __io TBTCSTR _tbtc;   /* Time Base Timer */
#define TBTC _tbtc.byte
#define TBTC_TBC0 _tbtc.bit.TBC0
#define TBTC_TBC1 _tbtc.bit.TBC1
#define TBTC_TBR _tbtc.bit.TBR
#define TBTC_TBOF _tbtc.bit.TBOF
#define TBTC_TBIE _tbtc.bit.TBIE
#define TBTC_TBC _tbtc.bitc.TBC
__IO_EXTERN __io FMCSSTR _fmcs;   /* Flash Control Register */
#define FMCS _fmcs.byte
#define FMCS_LPM _fmcs.bit.LPM
#define FMCS_RDY _fmcs.bit.RDY
#define FMCS_WE _fmcs.bit.WE
#define FMCS_RDYINT _fmcs.bit.RDYINT
#define FMCS_INTE _fmcs.bit.INTE
/*******************************************************************
 *
 *    DESCRIPTION:  Interrupt Control Register Declaration
 *
 *    AUTHOR:       Fujitsu Mikroelektronik GmbH
 *
 *    HISTORY:    
 * Version 1.0      26.01.99: 
 *      - original version
 * Version 1.2      11.02.99
 *      - "extern" changed to pre-defined macro of IO-Wizard 
 *        (__IO_EXTERN), requires IO-Wizard 1.7 or later
 *
 *******************************************************************/

#ifndef __ICR_H
#define __ICR_H

typedef union{  
    unsigned char    byte;
    struct{
      unsigned char IL0      :1;
      unsigned char IL1      :1;
      unsigned char IL2      :1;
      unsigned char ISE      :1;
      unsigned char ICS0     :1;
      unsigned char ICS1     :1;
      unsigned char ICS2     :1;
      unsigned char ICS3     :1;
    }bit;
    struct{
            unsigned char    :4;
      const unsigned char S0 :1;
      const unsigned char S1 :1;
    }bitrd;
    struct{
      unsigned char IL       :3;
      unsigned char :1;
      unsigned char ICS      :4;
    }bitc;
    struct{
            unsigned char    :4;
      const unsigned char S  :2;
    }bitcrd;
 }ICRSTR;

__IO_EXTERN __io ICRSTR _icr[16];

#define ICR(i)        _icr[i].byte
#define ICR_IL0(i)    _icr[i].bit.IL0
#define ICR_IL1(i)    _icr[i].bit.IL1
#define ICR_IL2(i)    _icr[i].bit.IL2
#define ICR_ISE(i)    _icr[i].bit.ISE
#define ICR_ICS0(i)   _icr[i].bit.ICS0
#define ICR_ICS1(i)   _icr[i].bit.ICS1
#define ICR_ICS2(i)   _icr[i].bit.ICS2
#define ICR_ICS3(i)   _icr[i].bit.ICS3
#define ICR_IL(i)     _icr[i].bitc.IL
#define ICR_ICS(i)    _icr[i].bitc.ICS
#define ICR_S0(i)     _icr[i].bitrd.S0
#define ICR_S1(i)     _icr[i].bitrd.S1
#define ICR_S(i)      _icr[i].bitcrd.S

#define ICR00       _icr[0].byte
#define ICR00_IL0   _icr[0].bit.IL0
#define ICR00_IL1   _icr[0].bit.IL1
#define ICR00_IL2   _icr[0].bit.IL2
#define ICR00_ISE   _icr[0].bit.ISE
#define ICR00_ICS0  _icr[0].bit.ICS0
#define ICR00_ICS1  _icr[0].bit.ICS1
#define ICR00_ICS2  _icr[0].bit.ICS2
#define ICR00_ICS3  _icr[0].bit.ICS3
#define ICR00_IL    _icr[0].bitc.IL
#define ICR00_ICS   _icr[0].bitc.ICS
#define ICR00_S0    _icr[0].bitrd.S0
#define ICR00_S1    _icr[0].bitrd.S1
#define ICR00_S     _icr[0].bitcrd.S

#define ICR01       _icr[1].byte
#define ICR01_IL0   _icr[1].bit.IL0
#define ICR01_IL1   _icr[1].bit.IL1
#define ICR01_IL2   _icr[1].bit.IL2
#define ICR01_ISE   _icr[1].bit.ISE
#define ICR01_ICS0  _icr[1].bit.ICS0
#define ICR01_ICS1  _icr[1].bit.ICS1
#define ICR01_ICS2  _icr[1].bit.ICS2
#define ICR01_ICS3  _icr[1].bit.ICS3
#define ICR01_IL    _icr[1].bitc.IL
#define ICR01_ICS   _icr[1].bitc.ICS
#define ICR01_S0    _icr[1].bitrd.S0
#define ICR01_S1    _icr[1].bitrd.S1
#define ICR01_S     _icr[1].bitcrd.S

#define ICR02       _icr[2].byte
#define ICR02_IL0   _icr[2].bit.IL0
#define ICR02_IL1   _icr[2].bit.IL1
#define ICR02_IL2   _icr[2].bit.IL2
#define ICR02_ISE   _icr[2].bit.ISE
#define ICR02_ICS0  _icr[2].bit.ICS0
#define ICR02_ICS1  _icr[2].bit.ICS1
#define ICR02_ICS2  _icr[2].bit.ICS2
#define ICR02_ICS3  _icr[2].bit.ICS3
#define ICR02_IL    _icr[2].bitc.IL
#define ICR02_ICS   _icr[2].bitc.ICS
#define ICR02_S0    _icr[2].bitrd.S0
#define ICR02_S1    _icr[2].bitrd.S1
#define ICR02_S     _icr[2].bitcrd.S

#define ICR03       _icr[3].byte
#define ICR03_IL0   _icr[3].bit.IL0
#define ICR03_IL1   _icr[3].bit.IL1
#define ICR03_IL2   _icr[3].bit.IL2
#define ICR03_ISE   _icr[3].bit.ISE
#define ICR03_ICS0  _icr[3].bit.ICS0
#define ICR03_ICS1  _icr[3].bit.ICS1
#define ICR03_ICS2  _icr[3].bit.ICS2
#define ICR03_ICS3  _icr[3].bit.ICS3
#define ICR03_IL    _icr[3].bitc.IL
#define ICR03_ICS   _icr[3].bitc.ICS
#define ICR03_S0    _icr[3].bitrd.S0
#define ICR03_S1    _icr[3].bitrd.S1
#define ICR03_S     _icr[3].bitcrd.S

#define ICR04       _icr[4].byte
#define ICR04_IL4   _icr[4].bit.IL0
#define ICR04_IL1   _icr[4].bit.IL1
#define ICR04_IL2   _icr[4].bit.IL2
#define ICR04_ISE   _icr[4].bit.ISE
#define ICR04_ICS4  _icr[4].bit.ICS0
#define ICR04_ICS1  _icr[4].bit.ICS1
#define ICR04_ICS2  _icr[4].bit.ICS2
#define ICR04_ICS3  _icr[4].bit.ICS3
#define ICR04_IL    _icr[4].bitc.IL
#define ICR04_ICS   _icr[4].bitc.ICS
#define ICR04_S4    _icr[4].bitrd.S0
#define ICR04_S1    _icr[4].bitrd.S1
#define ICR04_S     _icr[4].bitcrd.S

#define ICR05       _icr[5].byte
#define ICR05_IL0   _icr[5].bit.IL0
#define ICR05_IL1   _icr[5].bit.IL1
#define ICR05_IL2   _icr[5].bit.IL2
#define ICR05_ISE   _icr[5].bit.ISE
#define ICR05_ICS0  _icr[5].bit.ICS0
#define ICR05_ICS1  _icr[5].bit.ICS1
#define ICR05_ICS2  _icr[5].bit.ICS2
#define ICR05_ICS3  _icr[5].bit.ICS3
#define ICR05_IL    _icr[5].bitc.IL
#define ICR05_ICS   _icr[5].bitc.ICS
#define ICR05_S0    _icr[5].bitrd.S0
#define ICR05_S1    _icr[5].bitrd.S1
#define ICR05_S     _icr[5].bitcrd.S

#define ICR06       _icr[6].byte
#define ICR06_IL0   _icr[6].bit.IL0
#define ICR06_IL1   _icr[6].bit.IL1
#define ICR06_IL2   _icr[6].bit.IL2
#define ICR06_ISE   _icr[6].bit.ISE
#define ICR06_ICS0  _icr[6].bit.ICS0
#define ICR06_ICS1  _icr[6].bit.ICS1
#define ICR06_ICS2  _icr[6].bit.ICS2
#define ICR06_ICS3  _icr[6].bit.ICS3
#define ICR06_IL    _icr[6].bitc.IL
#define ICR06_ICS   _icr[6].bitc.ICS
#define ICR06_S0    _icr[6].bitrd.S0
#define ICR06_S1    _icr[6].bitrd.S1
#define ICR06_S     _icr[6].bitcrd.S

#define ICR07       _icr[7].byte
#define ICR07_IL0   _icr[7].bit.IL0
#define ICR07_IL1   _icr[7].bit.IL1
#define ICR07_IL2   _icr[7].bit.IL2
#define ICR07_ISE   _icr[7].bit.ISE
#define ICR07_ICS0  _icr[7].bit.ICS0
#define ICR07_ICS1  _icr[7].bit.ICS1
#define ICR07_ICS2  _icr[7].bit.ICS2
#define ICR07_ICS3  _icr[7].bit.ICS3
#define ICR07_IL    _icr[7].bitc.IL
#define ICR07_ICS   _icr[7].bitc.ICS
#define ICR07_S0    _icr[7].bitrd.S0
#define ICR07_S1    _icr[7].bitrd.S1
#define ICR07_S     _icr[7].bitcrd.S

#define ICR08       _icr[8].byte
#define ICR08_IL0   _icr[8].bit.IL0
#define ICR08_IL1   _icr[8].bit.IL1
#define ICR08_IL2   _icr[8].bit.IL2
#define ICR08_ISE   _icr[8].bit.ISE
#define ICR08_ICS0  _icr[8].bit.ICS0
#define ICR08_ICS1  _icr[8].bit.ICS1
#define ICR08_ICS2  _icr[8].bit.ICS2
#define ICR08_ICS3  _icr[8].bit.ICS3
#define ICR08_IL    _icr[8].bitc.IL
#define ICR08_ICS   _icr[8].bitc.ICS
#define ICR08_S0    _icr[8].bitrd.S0
#define ICR08_S1    _icr[8].bitrd.S1
#define ICR08_S     _icr[8].bitcrd.S

#define ICR09       _icr[9].byte
#define ICR09_IL0   _icr[9].bit.IL0
#define ICR09_IL1   _icr[9].bit.IL1
#define ICR09_IL2   _icr[9].bit.IL2
#define ICR09_ISE   _icr[9].bit.ISE
#define ICR09_ICS0  _icr[9].bit.ICS0
#define ICR09_ICS1  _icr[9].bit.ICS1
#define ICR09_ICS2  _icr[9].bit.ICS2
#define ICR09_ICS3  _icr[9].bit.ICS3
#define ICR09_IL    _icr[9].bitc.IL
#define ICR09_ICS   _icr[9].bitc.ICS
#define ICR09_S0    _icr[9].bitrd.S0
#define ICR09_S1    _icr[9].bitrd.S1
#define ICR09_S     _icr[9].bitcrd.S

#define ICR10       _icr[10].byte
#define ICR10_IL0   _icr[10].bit.IL0
#define ICR10_IL1   _icr[10].bit.IL1
#define ICR10_IL2   _icr[10].bit.IL2
#define ICR10_ISE   _icr[10].bit.ISE
#define ICR10_ICS0  _icr[10].bit.ICS0
#define ICR10_ICS1  _icr[10].bit.ICS1
#define ICR10_ICS2  _icr[10].bit.ICS2
#define ICR10_ICS3  _icr[10].bit.ICS3
#define ICR10_IL    _icr[10].bitc.IL
#define ICR10_ICS   _icr[10].bitc.ICS
#define ICR10_S0    _icr[10].bitrd.S0
#define ICR10_S1    _icr[10].bitrd.S1
#define ICR10_S     _icr[10].bitcrd.S

#define ICR11       _icr[11].byte
#define ICR11_IL0   _icr[11].bit.IL0
#define ICR11_IL1   _icr[11].bit.IL1
#define ICR11_IL2   _icr[11].bit.IL2
#define ICR11_ISE   _icr[11].bit.ISE
#define ICR11_ICS0  _icr[11].bit.ICS0
#define ICR11_ICS1  _icr[11].bit.ICS1
#define ICR11_ICS2  _icr[11].bit.ICS2
#define ICR11_ICS3  _icr[11].bit.ICS3
#define ICR11_IL    _icr[11].bitc.IL
#define ICR11_ICS   _icr[11].bitc.ICS
#define ICR11_S0    _icr[11].bitrd.S0
#define ICR11_S1    _icr[11].bitrd.S1
#define ICR11_S     _icr[11].bitcrd.S

#define ICR12       _icr[12].byte
#define ICR12_IL0   _icr[12].bit.IL0
#define ICR12_IL1   _icr[12].bit.IL1
#define ICR12_IL2   _icr[12].bit.IL2
#define ICR12_ISE   _icr[12].bit.ISE
#define ICR12_ICS0  _icr[12].bit.ICS0
#define ICR12_ICS1  _icr[12].bit.ICS1
#define ICR12_ICS2  _icr[12].bit.ICS2
#define ICR12_ICS3  _icr[12].bit.ICS3
#define ICR12_IL    _icr[12].bitc.IL
#define ICR12_ICS   _icr[12].bitc.ICS
#define ICR12_S0    _icr[12].bitrd.S0
#define ICR12_S1    _icr[12].bitrd.S1
#define ICR12_S     _icr[12].bitcrd.S

#define ICR13       _icr[13].byte
#define ICR13_IL0   _icr[13].bit.IL0
#define ICR13_IL1   _icr[13].bit.IL1
#define ICR13_IL2   _icr[13].bit.IL2
#define ICR13_ISE   _icr[13].bit.ISE
#define ICR13_ICS0  _icr[13].bit.ICS0
#define ICR13_ICS1  _icr[13].bit.ICS1
#define ICR13_ICS2  _icr[13].bit.ICS2
#define ICR13_ICS3  _icr[13].bit.ICS3
#define ICR13_IL    _icr[13].bitc.IL
#define ICR13_ICS   _icr[13].bitc.ICS
#define ICR13_S0    _icr[13].bitrd.S0
#define ICR13_S1    _icr[13].bitrd.S1
#define ICR13_S     _icr[13].bitcrd.S

#define ICR14       _icr[14].byte
#define ICR14_IL0   _icr[14].bit.IL0
#define ICR14_IL1   _icr[14].bit.IL1
#define ICR14_IL2   _icr[14].bit.IL2
#define ICR14_ISE   _icr[14].bit.ISE
#define ICR14_ICS0  _icr[14].bit.ICS0
#define ICR14_ICS1  _icr[14].bit.ICS1
#define ICR14_ICS2  _icr[14].bit.ICS2
#define ICR14_ICS3  _icr[14].bit.ICS3
#define ICR14_IL    _icr[14].bitc.IL
#define ICR14_ICS   _icr[14].bitc.ICS
#define ICR14_S0    _icr[14].bitrd.S0
#define ICR14_S1    _icr[14].bitrd.S1
#define ICR14_S     _icr[14].bitcrd.S

#define ICR15       _icr[15].byte
#define ICR15_IL0   _icr[15].bit.IL0
#define ICR15_IL1   _icr[15].bit.IL1
#define ICR15_IL2   _icr[15].bit.IL2
#define ICR15_ISE   _icr[15].bit.ISE
#define ICR15_ICS0  _icr[15].bit.ICS0
#define ICR15_ICS1  _icr[15].bit.ICS1
#define ICR15_ICS2  _icr[15].bit.ICS2
#define ICR15_ICS3  _icr[15].bit.ICS3
#define ICR15_IL    _icr[15].bitc.IL
#define ICR15_ICS   _icr[15].bitc.ICS
#define ICR15_S0    _icr[15].bitrd.S0
#define ICR15_S1    _icr[15].bitrd.S1
#define ICR15_S     _icr[15].bitcrd.S


#endif /*  __ICR_H */
#  undef ___IOWIDTH
#endif                   /* __MB90XXX_H */
