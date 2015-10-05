
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _read=R5
	.DEF _kluch=R4
	.DEF _k=R7
	.DEF _dat=R6
	.DEF _addr0=R9
	.DEF _addr1=R8
	.DEF _n=R11
	.DEF _j=R10
	.DEF _i=R13
	.DEF _KeyVal=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_KeyU:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x7E,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x51,0x21,0x0
	.DB  0x0,0x0,0x5A,0x53,0x41,0x57,0x40,0x0
	.DB  0x0,0x43,0x58,0x44,0x45,0x24,0x23,0x0
	.DB  0x0,0x20,0x56,0x46,0x54,0x52,0x25,0x0
	.DB  0x0,0x4E,0x42,0x48,0x47,0x59,0x5E,0x0
	.DB  0x0,0x0,0x4D,0x4A,0x55,0x26,0x2A,0x0
	.DB  0x0,0x3C,0x4B,0x49,0x4F,0x29,0x28,0x0
	.DB  0x0,0x3E,0x3F,0x4C,0x3A,0x50,0x5F,0x0
	.DB  0x0,0x0,0x22,0x0,0x7B,0x2B,0x0,0x0
	.DB  0x0,0x0,0xA,0x7D,0x7C,0x0
_KeyD:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x60,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x71,0x31,0x0
	.DB  0x0,0x0,0x7A,0x73,0x61,0x77,0x32,0x0
	.DB  0x0,0x63,0x78,0x64,0x65,0x34,0x33,0x0
	.DB  0x0,0x20,0x76,0x66,0x74,0x72,0x35,0x0
	.DB  0x0,0x6E,0x62,0x68,0x67,0x79,0x36,0x0
	.DB  0x0,0x0,0x6D,0x6A,0x75,0x37,0x38,0x0
	.DB  0x0,0x2C,0x6B,0x69,0x6F,0x30,0x39,0x0
	.DB  0x0,0x2E,0x2F,0x6C,0x3B,0x70,0x2D,0x0
	.DB  0x0,0x0,0x27,0x0,0x5B,0x3D,0x0,0x0
	.DB  0x0,0x0,0xA,0x5D,0x5C,0x0
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x45,0x52
	.DB  0x52,0x4F,0x52,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x55,0x20,0x70,0x69,0x74,0x2E
	.DB  0x20,0x3D,0x20,0x20,0x0,0x2E,0x0,0x76
	.DB  0x0,0x20,0x4C,0x4F,0x57,0x20,0x42,0x41
	.DB  0x54,0x54,0x45,0x52,0x59,0x21,0x21,0x21
	.DB  0x20,0x0,0x42,0x63,0x65,0x72,0x6F,0x20
	.DB  0x3D,0x20,0x0,0x50,0x4F,0x56,0x54,0x4F
	.DB  0x52,0x21,0x20,0x6A,0x20,0x3D,0x20,0x0
	.DB  0x45,0x52,0x52,0x21,0x20,0x6A,0x20,0x3D
	.DB  0x20,0x0,0x20,0x42,0x63,0x65,0x72,0x6F
	.DB  0x20,0x0,0x33,0x48,0x41,0x4B,0x4F,0x42
	.DB  0x20,0x3D,0x20,0x0,0x20,0x57,0x61,0x69
	.DB  0x74,0x2E,0x2E,0x2E,0x20,0x0,0x20,0x33
	.DB  0x41,0x48,0x4F,0x42,0x4F,0x3F,0x20,0x20
	.DB  0x59,0x20,0x2F,0x20,0x4E,0x20,0x0,0x70
	.DB  0x65,0x72,0x65,0x64,0x61,0x63,0x68,0x61
	.DB  0x20,0x0,0x6B,0x6F,0x6E,0x65,0x63,0x20
	.DB  0x70,0x65,0x72,0x65,0x64,0x61,0x63,0x68
	.DB  0x69,0x21,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 18.07.2014
;Author  : NeVaDa
;Company : Укртелеком
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=2
   .equ __scl_bit=3
; 0000 001F #endasm
;#include <i2c.h>
;#include <delay.h>
;#include <stdlib.h>
;
;#define kn1 PINC.5
;#define kn2 PINC.1
;#define kn3 PINC.3
;#define zvuk PORTD.7
;#define PS2_CLK   PIND.4
;#define PS2_DATA  PIND.5
;
;
;
;// Declare your global variables here
;#define EEPROM_BUS_ADDRESS 0xA0
; unsigned char KeyV[100], read, kluch, k, dat, addr0=0, addr1=0, n, j, i, KeyVal, zna;
; bit  flag=0, ravno=0, enter=0;
; unsigned int address, addr, paus, add;
; char conv[5];
; flash unsigned char KeyU[] = {'','','','','','','','','','','','','','','~','','','','','','','Q','!','','','','Z','S', ...
; flash unsigned char KeyD[] = {'','','','','','','','','','','','','','','`','','','','','','','q','1','','','','z','s', ...
;
;#define ADC_VREF_TYPE 0xC0
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 003A {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 003B ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 003C // Delay needed for the stabilization of the ADC input voltage
; 0000 003D delay_us(10);
	__DELAY_USB 27
; 0000 003E // Start the AD conversion
; 0000 003F ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0040 // Wait for the AD conversion to complete
; 0000 0041 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0042 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0043 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0001
; 0000 0044 }
; .FEND
;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 004A #endasm
;#include <lcd.h>
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 48
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 006A {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x0
; 0000 006B char status,data;
; 0000 006C status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 006D data=UDR;
	IN   R16,12
; 0000 006E if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6
; 0000 006F    {
; 0000 0070    rx_buffer[rx_wr_index]=data;
	LDS  R30,_rx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0071    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x30)
	BRNE _0x7
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0072    if (++rx_counter == RX_BUFFER_SIZE)
_0x7:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x30)
	BRNE _0x8
; 0000 0073       {
; 0000 0074       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 0075       rx_buffer_overflow=1;
	SET
	BLD  R2,3
; 0000 0076       };
_0x8:
; 0000 0077    };
_0x6:
; 0000 0078 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xC7
; .FEND
;
;
;
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0083 {
_getchar:
; .FSTART _getchar
; 0000 0084 char data;
; 0000 0085 while (rx_counter==0) if (!kn2) return 0xFF;
	ST   -Y,R17
;	data -> R17
_0x9:
	LDS  R30,_rx_counter
	CPI  R30,0
	BRNE _0xB
	SBIC 0x13,1
	RJMP _0xC
	LDI  R30,LOW(255)
	RJMP _0x20C0005
; 0000 0086 data=rx_buffer[rx_rd_index];
_0xC:
	RJMP _0x9
_0xB:
	LDS  R30,_rx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0087 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	SUBI R26,-LOW(1)
	STS  _rx_rd_index,R26
	CPI  R26,LOW(0x30)
	BRNE _0xD
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0000 0088 #asm("cli")
_0xD:
	cli
; 0000 0089 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0000 008A #asm("sei")
	sei
; 0000 008B return data;
	MOV  R30,R17
_0x20C0005:
	LD   R17,Y+
	RET
; 0000 008C }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 009C {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x0
; 0000 009D if (tx_counter)
	RCALL SUBOPT_0x1
	CPI  R30,0
	BREQ _0xE
; 0000 009E    {
; 0000 009F    --tx_counter;
	RCALL SUBOPT_0x1
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 00A0    UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00A1    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x8)
	BRNE _0xF
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 00A2    };
_0xF:
_0xE:
; 0000 00A3 }
_0xC7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00AA {
_putchar:
; .FSTART _putchar
; 0000 00AB while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x10:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x10
; 0000 00AC #asm("cli")
	cli
; 0000 00AD if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x1
	CPI  R30,0
	BRNE _0x14
	SBIC 0xB,5
	RJMP _0x13
_0x14:
; 0000 00AE    {
; 0000 00AF    tx_buffer[tx_wr_index]=c;
	LDS  R30,_tx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B0    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x8)
	BRNE _0x16
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 00B1    ++tx_counter;
_0x16:
	RCALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00B2    }
; 0000 00B3 else
	RJMP _0x17
_0x13:
; 0000 00B4    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B5 #asm("sei")
_0x17:
	sei
; 0000 00B6 }
	RJMP _0x20C0001
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;/***************************************************************************************
;+ Читаем ячейку из 24с02.
;+ В параметрах указывается адрес читаемой ячейки.
;+ Функция возвращает прочитаное из ячейки.
;****************************************************************************************/
;unsigned char eep_read(unsigned char address1, unsigned char address2) {
; 0000 00C2 unsigned char eep_read(unsigned char address1, unsigned char address2) {
_eep_read:
; .FSTART _eep_read
; 0000 00C3 unsigned char data;                    //переменная для прочитаных данных
; 0000 00C4 #asm("cli")
	ST   -Y,R26
	ST   -Y,R17
;	address1 -> Y+2
;	address2 -> Y+1
;	data -> R17
	cli
; 0000 00C5 i2c_start();                           //посылаем команду "старт" в шину i2c
	RCALL SUBOPT_0x2
; 0000 00C6 i2c_write(EEPROM_BUS_ADDRESS);         //посылаем в шину адрес устройства
; 0000 00C7 i2c_write(address1);
; 0000 00C8 i2c_write(address2);                    //посылаем в шину адрес читаемой ячейки
; 0000 00C9 i2c_start();                           //снова посылаем "старт" в шину
	RCALL _i2c_start
; 0000 00CA i2c_write(EEPROM_BUS_ADDRESS | 1);     //незнаю зачем но без этого не работает
	LDI  R26,LOW(161)
	RCALL _i2c_write
; 0000 00CB data=i2c_read(0);                      //принимаем данные с лини и сохраняем в переменную
	LDI  R26,LOW(0)
	RCALL _i2c_read
	MOV  R17,R30
; 0000 00CC i2c_stop();                            //посылаем команду "стоп"
	RCALL _i2c_stop
; 0000 00CD #asm("sei")
	sei
; 0000 00CE return data;                           //возврощаем значение прочитаного
	MOV  R30,R17
	RJMP _0x20C0002
; 0000 00CF }
; .FEND
;
;/***************************************************************************************
;+ Запись данных в ячейку 24с02.
;+ В параметрах указывается адрес записываемой ячейки (adress).
;+ Также указуем в параметрах данные которые надо записать в ячейку.
;****************************************************************************************/
;void eep_write(unsigned char address1, unsigned char address2, unsigned char data) {
; 0000 00D6 void eep_write(unsigned char address1, unsigned char address2, unsigned char data) {
_eep_write:
; .FSTART _eep_write
; 0000 00D7 #asm("cli")
	ST   -Y,R26
;	address1 -> Y+2
;	address2 -> Y+1
;	data -> Y+0
	cli
; 0000 00D8 i2c_start();                           //посылаем команду "старт" в шину i2c
	RCALL SUBOPT_0x2
; 0000 00D9 i2c_write(EEPROM_BUS_ADDRESS);         //посылаем в шину адрес устройства
; 0000 00DA i2c_write(address1);
; 0000 00DB i2c_write(address2);                    //посылаем в шину адрес записываемой ячейки
; 0000 00DC i2c_write(data);                       //посылаем данные для записи
	LD   R26,Y
	RCALL _i2c_write
; 0000 00DD i2c_stop();
	RCALL _i2c_stop
; 0000 00DE #asm("sei")
	sei
; 0000 00DF delay_ms(5);                           //посылаем команду "стоп"
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x3
; 0000 00E0 }
	RJMP _0x20C0003
; .FEND
;
;void err(void)
; 0000 00E3 {
_err:
; .FSTART _err
; 0000 00E4 kluch = 0;
	CLR  R4
; 0000 00E5 k = 0;
	CLR  R7
; 0000 00E6   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 00E7   delay_ms(50);
; 0000 00E8   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 00E9   delay_ms(50);
; 0000 00EA   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 00EB   delay_ms(50);
; 0000 00EC   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 00ED   delay_ms(50);
; 0000 00EE   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 00EF   delay_ms(50);
; 0000 00F0   zvuk = 1;
	SBI  0x12,7
; 0000 00F1   delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x3
; 0000 00F2   zvuk = 0;
	RCALL SUBOPT_0x6
; 0000 00F3   delay_ms(150);
; 0000 00F4   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 00F5   delay_ms(50);
; 0000 00F6   zvuk = 0;
	RCALL SUBOPT_0x6
; 0000 00F7   delay_ms(150);
; 0000 00F8   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 00F9   delay_ms(50);
; 0000 00FA   zvuk = 0;
	RCALL SUBOPT_0x6
; 0000 00FB   delay_ms(150);
; 0000 00FC   zvuk = 1;
	RCALL SUBOPT_0x7
; 0000 00FD   delay_ms(200);
; 0000 00FE   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 00FF   delay_ms(50);
; 0000 0100   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 0101   delay_ms(50);
; 0000 0102   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 0103   delay_ms(50);
; 0000 0104   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 0105   delay_ms(50);
; 0000 0106   zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 0107   delay_ms(50);
; 0000 0108   zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 0109   delay_ms(50);
; 0000 010A lcd_clear();
	RCALL _lcd_clear
; 0000 010B lcd_putsf("      ERROR     ");
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 010C lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 010D lcd_putsf("                ");
	__POINTW2FN _0x0,17
	RCALL _lcd_putsf
; 0000 010E kluch = 0;
	CLR  R4
; 0000 010F k = 0;
	CLR  R7
; 0000 0110 read = 0xFF;
	LDI  R30,LOW(255)
	MOV  R5,R30
; 0000 0111 while(rx_counter != 0) getchar() ;
_0x3C:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x3E
	RCALL _getchar
	RJMP _0x3C
_0x3E:
; 0000 0113 }
	RET
; .FEND
;
;unsigned char Scan_Data()     // Чтение из сканера
; 0000 0116 {
_Scan_Data:
; .FSTART _Scan_Data
; 0000 0117     unsigned char Data=0,temp;
; 0000 0118     while(PS2_CLK==0);
	RCALL __SAVELOCR2
;	Data -> R17
;	temp -> R16
	LDI  R17,0
_0x3F:
	SBIS 0x10,4
	RJMP _0x3F
; 0000 0119     for(i=0;i<10;i++)
	CLR  R13
_0x43:
	RCALL SUBOPT_0xA
	BRSH _0x44
; 0000 011A     {
; 0000 011B         paus = 0;
	RCALL SUBOPT_0xB
; 0000 011C         while(PS2_CLK==1) { if(paus++ > 65000) return(0);} ;
_0x45:
	SBIS 0x10,4
	RJMP _0x47
	RCALL SUBOPT_0xC
	CPI  R30,LOW(0xFDE9)
	LDI  R26,HIGH(0xFDE9)
	CPC  R31,R26
	BRLO _0x48
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x48:
	RJMP _0x45
_0x47:
; 0000 011D         temp=PS2_DATA;
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	MOV  R16,R30
; 0000 011E         temp<<=i;
	MOV  R30,R13
	MOV  R26,R16
	RCALL __LSLB12
	MOV  R16,R30
; 0000 011F         Data|=temp;
	OR   R17,R16
; 0000 0120         while(PS2_CLK==0);
_0x49:
	SBIS 0x10,4
	RJMP _0x49
; 0000 0121     }
	INC  R13
	RJMP _0x43
_0x44:
; 0000 0122 //    PORTD=0x00;
; 0000 0123 //    delay_ms(1);
; 0000 0124     return(Data);
	MOV  R30,R17
_0x20C0004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0125 }
; .FEND
;
;
;
;void main(void)
; 0000 012A {
_main:
; .FSTART _main
; 0000 012B // Declare your local variables here
; 0000 012C 
; 0000 012D // Input/Output Ports initialization
; 0000 012E // Port B initialization
; 0000 012F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0130 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0131 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0132 DDRB=0x00;
	OUT  0x17,R30
; 0000 0133 
; 0000 0134 // Port C initialization
; 0000 0135 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0136 // State6=P State5=P State4=P State3=P State2=T State1=P State0=T
; 0000 0137 PORTC=0x7A;
	LDI  R30,LOW(122)
	OUT  0x15,R30
; 0000 0138 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0139 
; 0000 013A // Port D initialization
; 0000 013B // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 013C // State7=1 State6=P State5=P State4=P State3=P State2=P State1=T State0=T
; 0000 013D PORTD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x12,R30
; 0000 013E DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 013F 
; 0000 0140 // Timer/Counter 0 initialization
; 0000 0141 // Clock source: System Clock
; 0000 0142 // Clock value: Timer 0 Stopped
; 0000 0143 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0144 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0145 
; 0000 0146 // Timer/Counter 1 initialization
; 0000 0147 // Clock source: System Clock
; 0000 0148 // Clock value: Timer 1 Stopped
; 0000 0149 // Mode: Normal top=FFFFh
; 0000 014A // OC1A output: Discon.
; 0000 014B // OC1B output: Discon.
; 0000 014C // Noise Canceler: Off
; 0000 014D // Input Capture on Falling Edge
; 0000 014E // Timer 1 Overflow Interrupt: Off
; 0000 014F // Input Capture Interrupt: Off
; 0000 0150 // Compare A Match Interrupt: Off
; 0000 0151 // Compare B Match Interrupt: Off
; 0000 0152 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0153 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0154 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0155 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0156 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0157 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0158 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0159 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 015A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 015B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 015C 
; 0000 015D // Timer/Counter 2 initialization
; 0000 015E // Clock source: System Clock
; 0000 015F // Clock value: Timer 2 Stopped
; 0000 0160 // Mode: Normal top=FFh
; 0000 0161 // OC2 output: Disconnected
; 0000 0162 ASSR=0x00;
	OUT  0x22,R30
; 0000 0163 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0164 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0165 OCR2=0x00;
	OUT  0x23,R30
; 0000 0166 
; 0000 0167 // External Interrupt(s) initialization
; 0000 0168 // INT0: Off
; 0000 0169 // INT1: Off
; 0000 016A MCUCR=0x00;
	OUT  0x35,R30
; 0000 016B 
; 0000 016C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 016D TIMSK=0x00;
	OUT  0x39,R30
; 0000 016E 
; 0000 016F // USART initialization
; 0000 0170 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0171 // USART Receiver: On
; 0000 0172 // USART Transmitter: On
; 0000 0173 // USART Mode: Asynchronous
; 0000 0174 // USART Baud Rate: 9600
; 0000 0175 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0176 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0177 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0178 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0179 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 017A 
; 0000 017B // Analog Comparator initialization
; 0000 017C // Analog Comparator: Off
; 0000 017D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 017E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0180 
; 0000 0181 // I2C Bus initialization
; 0000 0182 i2c_init();
	RCALL _i2c_init
; 0000 0183 
; 0000 0184 // LCD module initialization
; 0000 0185 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0186 
; 0000 0187 // Global enable interrupts
; 0000 0188 #asm("sei")
	sei
; 0000 0189 dat = 0x94;
	LDI  R30,LOW(148)
	MOV  R6,R30
; 0000 018A address = eep_read(0,0)*256;       // восстановление последнего записаного адреса
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _eep_read
	MOV  R31,R30
	LDI  R30,0
	RCALL SUBOPT_0xD
; 0000 018B address = address + eep_read(0,1);
	LDI  R26,LOW(1)
	RCALL _eep_read
	LDI  R31,0
	LDS  R26,_address
	LDS  R27,_address+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0xD
; 0000 018C zna = eep_read(0,2);
	LDI  R26,LOW(2)
	RCALL _eep_read
	STS  _zna,R30
; 0000 018D //address = address + 1;
; 0000 018E //k = 4;
; 0000 018F 
; 0000 0190 lcd_clear();
	RCALL _lcd_clear
; 0000 0191 
; 0000 0192 
; 0000 0193 // ADC initialization
; 0000 0194 // ADC Clock frequency: 62,500 kHz
; 0000 0195 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0196 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 0197 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0198 zvuk=0;
	CBI  0x12,7
; 0000 0199 delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 019A addr = read_adc(4)/10;
	LDI  R26,LOW(4)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RCALL SUBOPT_0xF
; 0000 019B addr = addr * 71;
	RCALL SUBOPT_0x10
	LDI  R30,LOW(71)
	RCALL __MULB1W2U
	RCALL SUBOPT_0xF
; 0000 019C zvuk=1;
	SBI  0x12,7
; 0000 019D itoa(addr,conv)  ;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 019E       lcd_gotoxy(0,0);
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 019F       lcd_putsf("U pit. =  ");
	__POINTW2FN _0x0,34
	RCALL _lcd_putsf
; 0000 01A0       lcd_putchar(conv[0]);
	LDS  R26,_conv
	RCALL _lcd_putchar
; 0000 01A1       lcd_putsf(".");
	__POINTW2FN _0x0,45
	RCALL _lcd_putsf
; 0000 01A2       lcd_putchar(conv[1]);
	__GETB2MN _conv,1
	RCALL _lcd_putchar
; 0000 01A3       lcd_putsf("v") ;
	__POINTW2FN _0x0,47
	RCALL _lcd_putsf
; 0000 01A4 ADMUX = 0 ;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 01A5 ADCSRA = 0 ;
	OUT  0x6,R30
; 0000 01A6 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 01A7     if (addr < 4800)
	RCALL SUBOPT_0x10
	CPI  R26,LOW(0x12C0)
	LDI  R30,HIGH(0x12C0)
	CPC  R27,R30
	BRSH _0x50
; 0000 01A8     {
; 0000 01A9     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 01AA     lcd_putsf(" LOW BATTERY!!! ");
	__POINTW2FN _0x0,49
	RCALL _lcd_putsf
; 0000 01AB     err() ;
	RCALL _err
; 0000 01AC     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 01AD     lcd_putsf(" LOW BATTERY!!! ");
	__POINTW2FN _0x0,49
	RCALL _lcd_putsf
; 0000 01AE     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 01AF     };
_0x50:
; 0000 01B0 
; 0000 01B1 k=0;
	CLR  R7
; 0000 01B2 lcd_clear();
	RCALL _lcd_clear
; 0000 01B3         addr = address;
	RCALL SUBOPT_0x13
; 0000 01B4         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 01B5         lcd_putsf("Bcero = ");
	RCALL SUBOPT_0x14
; 0000 01B6         add = zna+1;
; 0000 01B7         itoa(addr/add, conv);
; 0000 01B8         lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 01B9 while (1)
_0x51:
; 0000 01BA   {
; 0000 01BB //----------------------------------------------------------------------------------
; 0000 01BC     if (k==0)       // обработка клавиш
	TST  R7
	BRNE _0x54
; 0000 01BD     {
; 0000 01BE         if (PS2_CLK==0)
	SBIC 0x10,4
	RJMP _0x55
; 0000 01BF          {
; 0000 01C0             j++;
	RCALL SUBOPT_0x16
; 0000 01C1             KeyV[j]=Scan_Data(); // Читать байт
	PUSH R31
	PUSH R30
	RCALL _Scan_Data
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01C2             if (KeyV[j] == 90) k=1; // Если Enter выполнить следующий блок
	RCALL SUBOPT_0x17
	LD   R26,Z
	CPI  R26,LOW(0x5A)
	BRNE _0x56
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01C3             if (KeyV[j] == 0) j=0; // Если 0 пропуск и заново
_0x56:
	RCALL SUBOPT_0x17
	LD   R30,Z
	CPI  R30,0
	BRNE _0x57
	CLR  R10
; 0000 01C4             paus = 0;
_0x57:
	RCALL SUBOPT_0xB
; 0000 01C5          }
; 0000 01C6         if (rx_counter > 0) if(getchar() == 0x20) k=2; // если w с комп, то - передача на комп
_0x55:
	LDS  R26,_rx_counter
	CPI  R26,LOW(0x1)
	BRLO _0x58
	RCALL _getchar
	CPI  R30,LOW(0x20)
	BRNE _0x59
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 01C7         if (!kn1) k = 4;
_0x59:
_0x58:
	SBIC 0x13,5
	RJMP _0x5A
	LDI  R30,LOW(4)
	MOV  R7,R30
; 0000 01C8         if (!kn2) k = 5;
_0x5A:
	SBIC 0x13,1
	RJMP _0x5B
	LDI  R30,LOW(5)
	MOV  R7,R30
; 0000 01C9         if (!kn3) k = 3;
_0x5B:
	SBIC 0x13,3
	RJMP _0x5C
	LDI  R30,LOW(3)
	MOV  R7,R30
; 0000 01CA         if (j > 0) if (paus++ > 11111)
_0x5C:
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x5D
	RCALL SUBOPT_0xC
	CPI  R30,LOW(0x2B68)
	LDI  R26,HIGH(0x2B68)
	CPC  R31,R26
	BRLO _0x5E
; 0000 01CB         {
; 0000 01CC             KeyV[++j] = 90;
	RCALL SUBOPT_0x16
	LDI  R26,LOW(90)
	STD  Z+0,R26
; 0000 01CD             k = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01CE         }
; 0000 01CF     };
_0x5E:
_0x5D:
_0x54:
; 0000 01D0 
; 0000 01D1     if (k==1)   // Введен готовый номер
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ PC+2
	RJMP _0x5F
; 0000 01D2     {
; 0000 01D3 
; 0000 01D4         n=j;
	MOV  R11,R10
; 0000 01D5         i = 1;
	MOV  R13,R30
; 0000 01D6         j = 0;
	CLR  R10
; 0000 01D7         flag = 0;
	RCALL SUBOPT_0x18
; 0000 01D8         while(i <= n)
_0x60:
	CP   R11,R13
	BRLO _0x62
; 0000 01D9         {
; 0000 01DA             if (KeyV[i] == 0x12)
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x12)
	BRNE _0x63
; 0000 01DB             {
; 0000 01DC                 flag = 1;
	RCALL SUBOPT_0x1A
; 0000 01DD                 i++;
	INC  R13
; 0000 01DE             };
_0x63:
; 0000 01DF             if (KeyV[i] == 0xF0)
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0xF0)
	BRNE _0x64
; 0000 01E0             {
; 0000 01E1                if (KeyV[++i] == 0x12) flag = 0;
	INC  R13
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x12)
	BRNE _0x65
	RCALL SUBOPT_0x18
; 0000 01E2                i++;
_0x65:
	INC  R13
; 0000 01E3             };
_0x64:
; 0000 01E4             //*******************************************
; 0000 01E5             if(KeyV[i] != 0x12 && KeyV[i] != 0xF0)
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x12)
	BREQ _0x67
	LD   R26,Z
	CPI  R26,LOW(0xF0)
	BRNE _0x68
_0x67:
	RJMP _0x66
_0x68:
; 0000 01E6             {
; 0000 01E7                 if (flag) KeyV[++j] = KeyU[KeyV[i++]];
	SBRS R2,0
	RJMP _0x69
	RCALL SUBOPT_0x1B
	SUBI R30,LOW(-_KeyU*2)
	SBCI R31,HIGH(-_KeyU*2)
	RJMP _0xC5
; 0000 01E8                 else KeyV[++j] = KeyD[KeyV[i++]];
_0x69:
	RCALL SUBOPT_0x1B
	SUBI R30,LOW(-_KeyD*2)
	SBCI R31,HIGH(-_KeyD*2)
_0xC5:
	LPM  R30,Z
	ST   X,R30
; 0000 01E9             }
; 0000 01EA         }
_0x66:
	RJMP _0x60
_0x62:
; 0000 01EB //        KeyV[++j] = 0x0A;
; 0000 01EC         flag = 0;
	RCALL SUBOPT_0x18
; 0000 01ED         addr=address;
	RCALL SUBOPT_0x13
; 0000 01EE         add = zna+1;
	RCALL SUBOPT_0x1C
; 0000 01EF         for(i=0;i<10;i++)         // Поиск совпадающий номеров
	CLR  R13
_0x6C:
	RCALL SUBOPT_0xA
	BRSH _0x6D
; 0000 01F0         {
; 0000 01F1             n=j;
	MOV  R11,R10
; 0000 01F2             while (n > 0)
_0x6E:
	LDI  R30,LOW(0)
	CP   R30,R11
	BRSH _0x70
; 0000 01F3             {
; 0000 01F4                 addr1 = addr>>8;
	RCALL SUBOPT_0x1D
; 0000 01F5                 addr0 = addr -  (unsigned int) addr1*256 ;
; 0000 01F6                 KeyVal = eep_read(addr1,addr0);
	RCALL SUBOPT_0x1E
	MOV  R12,R30
; 0000 01F7                 if (KeyVal != KeyV[n])
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R30,Z
	CP   R30,R12
	BREQ _0x71
; 0000 01F8                 {
; 0000 01F9                     flag = 0;
	RCALL SUBOPT_0x18
; 0000 01FA                     addr = addr - n;
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x10
	SUB  R26,R30
	SBC  R27,R31
	STS  _addr,R26
	STS  _addr+1,R27
; 0000 01FB                     n = 0;
	CLR  R11
; 0000 01FC                 }
; 0000 01FD                 else
	RJMP _0x72
_0x71:
; 0000 01FE                 {
; 0000 01FF                     flag = 1;
	RCALL SUBOPT_0x1A
; 0000 0200                     addr = addr - 1;
	RCALL SUBOPT_0x11
	SBIW R30,1
	RCALL SUBOPT_0xF
; 0000 0201                     if(--n == 0) i = 21;
	DEC  R11
	BRNE _0x73
	LDI  R30,LOW(21)
	MOV  R13,R30
; 0000 0202                 }
_0x73:
_0x72:
; 0000 0203                 if (addr < 3)
	RCALL SUBOPT_0x10
	SBIW R26,3
	BRSH _0x74
; 0000 0204                 {
; 0000 0205                     if (i < 10) i = 10;
	RCALL SUBOPT_0xA
	BRSH _0x75
	LDI  R30,LOW(10)
	MOV  R13,R30
; 0000 0206                     break;
_0x75:
	RJMP _0x70
; 0000 0207                 }
; 0000 0208             }
_0x74:
	RJMP _0x6E
_0x70:
; 0000 0209             if(add != j) flag = 1;
	MOV  R30,R10
	LDS  R26,_add
	LDS  R27,_add+1
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x76
	RCALL SUBOPT_0x1A
; 0000 020A             if (flag && i < 10) i = 10;
_0x76:
	SBRS R2,0
	RJMP _0x78
	RCALL SUBOPT_0xA
	BRLO _0x79
_0x78:
	RJMP _0x77
_0x79:
	LDI  R30,LOW(10)
	MOV  R13,R30
; 0000 020B 
; 0000 020C         }
_0x77:
	INC  R13
	RJMP _0x6C
_0x6D:
; 0000 020D 
; 0000 020E         if (flag)
	SBRS R2,0
	RJMP _0x7A
; 0000 020F         {
; 0000 0210             zvuk = 0;
	CBI  0x12,7
; 0000 0211             lcd_clear();
	RCALL _lcd_clear
; 0000 0212             if (i > 20) lcd_putsf("POVTOR! j = ");
	LDI  R30,LOW(20)
	CP   R30,R13
	BRSH _0x7D
	__POINTW2FN _0x0,75
	RJMP _0xC6
; 0000 0213             else lcd_putsf("ERR! j = ");
_0x7D:
	__POINTW2FN _0x0,88
_0xC6:
	RCALL _lcd_putsf
; 0000 0214             itoa(j-1, conv);
	MOV  R30,R10
	LDI  R31,0
	SBIW R30,1
	RCALL SUBOPT_0x12
; 0000 0215             lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 0216             lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 0217             delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 0218             zvuk = 1;
	RCALL SUBOPT_0x5
; 0000 0219             delay_ms(50) ;
; 0000 021A 
; 0000 021B         }
; 0000 021C         else
	RJMP _0x81
_0x7A:
; 0000 021D         {
; 0000 021E             n = 0;
	CLR  R11
; 0000 021F             addr = address;
	RCALL SUBOPT_0x13
; 0000 0220             flag = 1;
	RCALL SUBOPT_0x1A
; 0000 0221             lcd_clear();
	RCALL _lcd_clear
; 0000 0222             while(++n <= j)
_0x82:
	INC  R11
	CP   R10,R11
	BRLO _0x84
; 0000 0223             {
; 0000 0224                 addr = addr + 1;
	RCALL SUBOPT_0x22
; 0000 0225                 addr1 = addr>>8;
; 0000 0226                 addr0 = addr -  (unsigned int) addr1*256 ;
; 0000 0227                 eep_write(addr1,addr0,KeyV[n]);
	ST   -Y,R9
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x23
	RCALL _eep_write
; 0000 0228                 if  (eep_read(addr1,addr0) != KeyV[n])
	ST   -Y,R8
	RCALL SUBOPT_0x1E
	MOV  R26,R30
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LD   R30,Z
	CP   R30,R26
	BREQ _0x85
; 0000 0229                 {
; 0000 022A                     flag = 0;
	RCALL SUBOPT_0x18
; 0000 022B                     err();  // проверка записи
	RCALL _err
; 0000 022C                     break;
	RJMP _0x84
; 0000 022D                 }
; 0000 022E                 if (zna > 15) { if (KeyV[n] != 0x0A) lcd_putchar(KeyV[n]); } else lcd_putchar(KeyV[n]);
_0x85:
	LDS  R26,_zna
	CPI  R26,LOW(0x10)
	BRLO _0x86
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x23
	CPI  R26,LOW(0xA)
	BREQ _0x87
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x23
	RCALL _lcd_putchar
_0x87:
	RJMP _0x88
_0x86:
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x23
	RCALL _lcd_putchar
; 0000 022F             }
_0x88:
	RJMP _0x82
_0x84:
; 0000 0230             if (flag)
	SBRS R2,0
	RJMP _0x89
; 0000 0231             {
; 0000 0232                 eep_write(0,0,addr1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	MOV  R26,R8
	RCALL _eep_write
; 0000 0233                 eep_write(0,1,addr0);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R9
	RCALL _eep_write
; 0000 0234                 if  (eep_read(0,0) != addr1)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _eep_read
	CP   R8,R30
	BREQ _0x8A
; 0000 0235                 {
; 0000 0236                     err();  // проверка записи
	RCALL _err
; 0000 0237                     break;
	RJMP _0x53
; 0000 0238                 }
; 0000 0239                 if  (eep_read(0,1) != addr0)
_0x8A:
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	RCALL _eep_read
	CP   R9,R30
	BREQ _0x8B
; 0000 023A                 {
; 0000 023B                     err();  // проверка записи
	RCALL _err
; 0000 023C                     break;
	RJMP _0x53
; 0000 023D                 }
; 0000 023E             }
_0x8B:
; 0000 023F             address = addr;
_0x89:
	RCALL SUBOPT_0x24
; 0000 0240         }
_0x81:
; 0000 0241         zvuk = 0;
	CBI  0x12,7
; 0000 0242         addr = address;
	RCALL SUBOPT_0x13
; 0000 0243         lcd_putsf(" Bcero ");
	__POINTW2FN _0x0,98
	RCALL _lcd_putsf
; 0000 0244         add = zna+1;
	RCALL SUBOPT_0x1C
; 0000 0245         itoa(addr/add, conv);
	LDS  R30,_add
	LDS  R31,_add+1
	RCALL SUBOPT_0x10
	RCALL __DIVW21U
	RCALL SUBOPT_0x12
; 0000 0246         k = 0;
	CLR  R7
; 0000 0247         j = 0;
	CLR  R10
; 0000 0248         ravno = 0;
	CLT
	BLD  R2,1
; 0000 0249         delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 024A         lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 024B         zvuk = 1;
	SBI  0x12,7
; 0000 024C     }
; 0000 024D 
; 0000 024E     if (k == 4)
_0x5F:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x90
; 0000 024F     {
; 0000 0250         zvuk = 0;
	CBI  0x12,7
; 0000 0251         addr = address;
	RCALL SUBOPT_0x13
; 0000 0252         delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 0253         zvuk = 1;
	SBI  0x12,7
; 0000 0254         lcd_clear();
	RCALL _lcd_clear
; 0000 0255         lcd_putsf("Bcero = ");
	RCALL SUBOPT_0x14
; 0000 0256         add = zna+1;
; 0000 0257         itoa(addr/add, conv);
; 0000 0258         delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 0259         lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 025A         itoa(zna, conv);
	RCALL SUBOPT_0x25
; 0000 025B         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 025C         lcd_putsf("3HAKOB = ");
	RCALL SUBOPT_0x26
; 0000 025D         lcd_puts(conv);
; 0000 025E         delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 025F 
; 0000 0260         k = 0;
	CLR  R7
; 0000 0261         j = 0;
	CLR  R10
; 0000 0262 
; 0000 0263     }
; 0000 0264 
; 0000 0265     if (k == 3)
_0x90:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x95
; 0000 0266     {
; 0000 0267         zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 0268         delay_ms(50);
; 0000 0269         lcd_clear();
	RCALL _lcd_clear
; 0000 026A         lcd_putsf(" Wait... ");
	__POINTW2FN _0x0,116
	RCALL _lcd_putsf
; 0000 026B         zvuk = 1;
	SBI  0x12,7
; 0000 026C         j = n;
	MOV  R10,R11
; 0000 026D         n=0;
	CLR  R11
; 0000 026E         while (addr > 3)
_0x9A:
	RCALL SUBOPT_0x10
	SBIW R26,4
	BRLO _0x9C
; 0000 026F         {
; 0000 0270             addr = addr - 1;
	RCALL SUBOPT_0x11
	SBIW R30,1
	RCALL SUBOPT_0xF
; 0000 0271             addr1 = addr>>8;
	RCALL SUBOPT_0x1D
; 0000 0272             addr0 = addr -  (unsigned int) addr1*256 ;
; 0000 0273             KeyVal = eep_read(addr1,addr0);
	RCALL SUBOPT_0x1E
	MOV  R12,R30
; 0000 0274             if (KeyVal ==  0x0A )
	LDI  R30,LOW(10)
	CP   R30,R12
	BRNE _0x9A
; 0000 0275             {
; 0000 0276                break;
; 0000 0277             }
; 0000 0278         }
_0x9C:
; 0000 0279         zvuk = 0;
	CBI  0x12,7
; 0000 027A         lcd_clear();
	RCALL _lcd_clear
; 0000 027B         lcd_putsf("Bcero = ");
	RCALL SUBOPT_0x14
; 0000 027C         add = zna+1;
; 0000 027D         itoa(addr/add, conv);
; 0000 027E         delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 027F         lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 0280         itoa(zna, conv);
	RCALL SUBOPT_0x25
; 0000 0281         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 0282         lcd_putsf("3HAKOB = ");
	RCALL SUBOPT_0x26
; 0000 0283         lcd_puts(conv);
; 0000 0284         zvuk = 1;
	SBI  0x12,7
; 0000 0285         delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 0286         address = addr;
	RCALL SUBOPT_0x24
; 0000 0287         k = 0;
	CLR  R7
; 0000 0288         j = 0;
	CLR  R10
; 0000 0289 
; 0000 028A     }
; 0000 028B 
; 0000 028C     if (k == 5)
_0x95:
	LDI  R30,LOW(5)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xA2
; 0000 028D     {
; 0000 028E         zvuk = 0;
	RCALL SUBOPT_0x4
; 0000 028F         delay_ms(50);
; 0000 0290         flag = 0;
	RCALL SUBOPT_0x18
; 0000 0291         lcd_clear();
	RCALL _lcd_clear
; 0000 0292         lcd_putsf(" 3AHOBO?  Y / N ");
	__POINTW2FN _0x0,126
	RCALL _lcd_putsf
; 0000 0293         zvuk = 1;
	SBI  0x12,7
; 0000 0294         while (kn1 && kn3);
_0xA7:
	SBIS 0x13,5
	RJMP _0xAA
	SBIC 0x13,3
	RJMP _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
	RJMP _0xA7
_0xA9:
; 0000 0295         while(!kn2)
_0xAC:
	SBIC 0x13,1
	RJMP _0xAE
; 0000 0296         {
; 0000 0297             if(!kn3)
	SBIC 0x13,3
	RJMP _0xAF
; 0000 0298             {
; 0000 0299                 zvuk = 1;
	RCALL SUBOPT_0x27
; 0000 029A                 lcd_clear();
; 0000 029B                 zna++;
	SUBI R30,-LOW(1)
	STS  _zna,R30
; 0000 029C                 itoa(zna, conv);
	RCALL SUBOPT_0x25
; 0000 029D                 delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x3
; 0000 029E                 lcd_putsf("3HAKOB = ");
	RCALL SUBOPT_0x26
; 0000 029F                 lcd_puts(conv);
; 0000 02A0                 zvuk = 1;
	RCALL SUBOPT_0x7
; 0000 02A1                 delay_ms(200);
; 0000 02A2             }
; 0000 02A3             if(!kn1)
_0xAF:
	SBIC 0x13,5
	RJMP _0xB4
; 0000 02A4             {
; 0000 02A5                 zvuk = 1;
	RCALL SUBOPT_0x27
; 0000 02A6                 lcd_clear();
; 0000 02A7                 zna--;
	SUBI R30,LOW(1)
	STS  _zna,R30
; 0000 02A8                 itoa(zna, conv);
	RCALL SUBOPT_0x25
; 0000 02A9                 delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x3
; 0000 02AA                 lcd_putsf("3HAKOB = ");
	RCALL SUBOPT_0x26
; 0000 02AB                 lcd_puts(conv);
; 0000 02AC                 zvuk = 1;
	RCALL SUBOPT_0x7
; 0000 02AD                 delay_ms(200);
; 0000 02AE             }
; 0000 02AF              flag = 1;
_0xB4:
	RCALL SUBOPT_0x1A
; 0000 02B0         }
	RJMP _0xAC
_0xAE:
; 0000 02B1         if (flag)
	SBRS R2,0
	RJMP _0xB9
; 0000 02B2         {
; 0000 02B3             eep_write(0,2,zna);
	RCALL SUBOPT_0x8
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_zna
	RCALL _eep_write
; 0000 02B4             if  (eep_read(0,2) != zna)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(2)
	RCALL _eep_read
	MOV  R26,R30
	LDS  R30,_zna
	CP   R30,R26
	BREQ _0xBA
; 0000 02B5             {
; 0000 02B6                 err();  // проверка записи
	RCALL _err
; 0000 02B7                 break;
	RJMP _0x53
; 0000 02B8             }
; 0000 02B9 
; 0000 02BA         }
_0xBA:
; 0000 02BB         delay_ms(500);
_0xB9:
	RCALL SUBOPT_0xE
; 0000 02BC         if (!kn3)    address = 2;
	SBIC 0x13,3
	RJMP _0xBB
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _address,R30
	STS  _address+1,R31
; 0000 02BD         addr = address;
_0xBB:
	RCALL SUBOPT_0x13
; 0000 02BE         zvuk = 0;
	CBI  0x12,7
; 0000 02BF         lcd_clear();
	RCALL _lcd_clear
; 0000 02C0         lcd_putsf("Bcero = ");
	RCALL SUBOPT_0x14
; 0000 02C1         add = zna+1;
; 0000 02C2         itoa(addr/add, conv);
; 0000 02C3         delay_ms(50);
	RCALL SUBOPT_0x21
; 0000 02C4         lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 02C5         itoa(zna, conv);
	RCALL SUBOPT_0x25
; 0000 02C6         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 02C7         lcd_putsf("3HAKOB = ");
	RCALL SUBOPT_0x26
; 0000 02C8         lcd_puts(conv);
; 0000 02C9         zvuk = 1;
	SBI  0x12,7
; 0000 02CA         j = 0;
	CLR  R10
; 0000 02CB         k = 0;
	CLR  R7
; 0000 02CC         delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 02CD     }
; 0000 02CE 
; 0000 02CF //----------------------------------------------------------------------------------
; 0000 02D0 
; 0000 02D1     if(k == 2)
_0xA2:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xC0
; 0000 02D2     {
; 0000 02D3           lcd_clear();
	RCALL _lcd_clear
; 0000 02D4           lcd_putsf("peredacha ");
	__POINTW2FN _0x0,143
	RCALL _lcd_putsf
; 0000 02D5           itoa(address, conv);
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x12
; 0000 02D6           lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 02D7           lcd_puts(conv);
	RCALL SUBOPT_0x15
; 0000 02D8                 addr = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xF
; 0000 02D9                 putchar(eep_read(0,0));
	RCALL SUBOPT_0x8
	LDI  R26,LOW(0)
	RCALL _eep_read
	MOV  R26,R30
	RCALL _putchar
; 0000 02DA                 putchar(eep_read(0,1));
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	RCALL _eep_read
	MOV  R26,R30
	RCALL _putchar
; 0000 02DB                 putchar(0x0A);
	LDI  R26,LOW(10)
	RCALL _putchar
; 0000 02DC                 while (addr < address)
_0xC1:
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x10
	CP   R26,R30
	CPC  R27,R31
	BRSH _0xC3
; 0000 02DD                 {
; 0000 02DE                 addr=addr+1;
	RCALL SUBOPT_0x22
; 0000 02DF                 addr1 = addr>>8;
; 0000 02E0                 addr0 = addr - (unsigned int) addr1*256 ;
; 0000 02E1                 read = eep_read(addr1,addr0);
	RCALL SUBOPT_0x1E
	MOV  R5,R30
; 0000 02E2                 putchar(read);
	MOV  R26,R5
	RCALL _putchar
; 0000 02E3                 } ;
	RJMP _0xC1
_0xC3:
; 0000 02E4       lcd_clear();
	RCALL _lcd_clear
; 0000 02E5       lcd_putsf("konec peredachi!");
	__POINTW2FN _0x0,154
	RCALL _lcd_putsf
; 0000 02E6       lcd_gotoxy(0,1);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 02E7       lcd_putsf("                ");
	__POINTW2FN _0x0,17
	RCALL _lcd_putsf
; 0000 02E8       k = 0;
	CLR  R7
; 0000 02E9 
; 0000 02EA     }
; 0000 02EB 
; 0000 02EC 
; 0000 02ED   };
_0xC0:
	RJMP _0x51
_0x53:
; 0000 02EE }
_0xC4:
	RJMP _0xC4
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
; .FSTART __lcd_delay_G101
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
; .FEND
__lcd_read_nibble_G101:
; .FSTART __lcd_read_nibble_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G101:
; .FSTART _lcd_read_byte0_G101
	RCALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	RCALL SUBOPT_0x8
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x20C0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x20C0002:
	LDD  R17,Y+0
_0x20C0003:
	ADIW R28,3
	RET
; .FEND
__long_delay_G101:
; .FSTART __long_delay_G101
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G101:
; .FSTART __lcd_init_write_G101
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	RCALL __long_delay_G101
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G101
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x202000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_KeyV:
	.BYTE 0x64
_zna:
	.BYTE 0x1
_address:
	.BYTE 0x2
_addr:
	.BYTE 0x2
_paus:
	.BYTE 0x2
_add:
	.BYTE 0x2
_conv:
	.BYTE 0x5
_rx_buffer:
	.BYTE 0x30
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_tx_counter
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	RCALL _i2c_start
	LDI  R26,LOW(160)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _i2c_write
	LDD  R26,Y+1
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x3:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	CBI  0x12,7
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	SBI  0x12,7
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CBI  0x12,7
	LDI  R26,LOW(150)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	SBI  0x12,7
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	CP   R13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _paus,R30
	STS  _paus+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_paus)
	LDI  R27,HIGH(_paus)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	STS  _address,R30
	STS  _address+1,R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0xF:
	STS  _addr,R30
	STS  _addr+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x10:
	LDS  R26,_addr
	LDS  R27,_addr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x11:
	LDS  R30,_addr
	LDS  R31,_addr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_conv)
	LDI  R27,HIGH(_conv)
	RJMP _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x13:
	LDS  R30,_address
	LDS  R31,_address+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x14:
	__POINTW2FN _0x0,66
	RCALL _lcd_putsf
	LDS  R30,_zna
	LDI  R31,0
	ADIW R30,1
	STS  _add,R30
	STS  _add+1,R31
	RCALL SUBOPT_0x10
	RCALL __DIVW21U
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_conv)
	LDI  R27,HIGH(_conv)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	INC  R10
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_KeyV)
	SBCI R31,HIGH(-_KeyV)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_KeyV)
	SBCI R31,HIGH(-_KeyV)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x19:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_KeyV)
	SBCI R31,HIGH(-_KeyV)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	SET
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	INC  R10
	MOV  R26,R10
	LDI  R27,0
	SUBI R26,LOW(-_KeyV)
	SBCI R27,HIGH(-_KeyV)
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_KeyV)
	SBCI R31,HIGH(-_KeyV)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDS  R30,_zna
	LDI  R31,0
	ADIW R30,1
	STS  _add,R30
	STS  _add+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1D:
	LDS  R30,_addr+1
	MOV  R8,R30
	LDI  R26,LOW(0)
	LDS  R30,_addr
	SUB  R30,R26
	MOV  R9,R30
	ST   -Y,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOV  R26,R9
	RJMP _eep_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	MOV  R30,R11
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	SUBI R30,LOW(-_KeyV)
	SBCI R31,HIGH(-_KeyV)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x11
	ADIW R30,1
	RCALL SUBOPT_0xF
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x20
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x11
	STS  _address,R30
	STS  _address+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	LDS  R30,_zna
	LDI  R31,0
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x26:
	__POINTW2FN _0x0,106
	RCALL _lcd_putsf
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	SBI  0x12,7
	RCALL _lcd_clear
	LDS  R30,_zna
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDS  R30,_address
	LDS  R31,_address+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	RCALL __long_delay_G101
	LDI  R26,LOW(48)
	RJMP __lcd_init_write_G101


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
