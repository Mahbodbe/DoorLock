
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x50,0x61,0x73,0x73,0x57,0x6F,0x72,0x64
_0x0:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x0
	.DB  0x50,0x6C,0x61,0x63,0x65,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x63,0x61,0x72,0x64,0x0
	.DB  0x20,0x20,0x20,0x0,0x2E,0x20,0x20,0x0
	.DB  0x2E,0x2E,0x20,0x0,0x2E,0x2E,0x2E,0x0
	.DB  0x45,0x72,0x72,0x6F,0x72,0x3A,0x0,0x4E
	.DB  0x6F,0x20,0x43,0x61,0x72,0x64,0x0,0x54
	.DB  0x69,0x6D,0x65,0x6F,0x75,0x74,0x0,0x43
	.DB  0x6F,0x6D,0x6D,0x20,0x45,0x72,0x72,0x6F
	.DB  0x72,0x0,0x41,0x75,0x74,0x68,0x20,0x45
	.DB  0x72,0x72,0x6F,0x72,0x0,0x55,0x6E,0x6B
	.DB  0x6E,0x6F,0x77,0x6E,0x20,0x45,0x72,0x72
	.DB  0x0,0x44,0x61,0x74,0x61,0x20,0x66,0x6F
	.DB  0x75,0x6E,0x64,0x0,0x3E,0x52,0x65,0x61
	.DB  0x64,0x20,0x26,0x20,0x63,0x68,0x65,0x63
	.DB  0x6B,0x0,0x3E,0x57,0x72,0x69,0x74,0x65
	.DB  0x20,0x70,0x61,0x73,0x73,0x77,0x6F,0x72
	.DB  0x64,0x0,0x45,0x6D,0x70,0x74,0x79,0x20
	.DB  0x62,0x6C,0x6F,0x63,0x6B,0x0,0x3E,0x44
	.DB  0x6F,0x20,0x6E,0x6F,0x74,0x68,0x69,0x6E
	.DB  0x67,0x0,0x43,0x61,0x72,0x64,0x20,0x72
	.DB  0x65,0x6D,0x6F,0x76,0x65,0x64,0x0,0x57
	.DB  0x72,0x69,0x74,0x65,0x20,0x4F,0x4B,0x0
	.DB  0x4D,0x61,0x74,0x63,0x68,0x0,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x4F
	.DB  0x4B,0x0,0x41,0x63,0x63,0x65,0x73,0x73
	.DB  0x20,0x67,0x72,0x61,0x6E,0x74,0x65,0x64
	.DB  0x0,0x50,0x61,0x73,0x73,0x77,0x6F,0x72
	.DB  0x64,0x20,0x4E,0x47,0x0,0x54,0x72,0x79
	.DB  0x20,0x61,0x67,0x61,0x69,0x6E,0x0,0x57
	.DB  0x72,0x69,0x74,0x65,0x20,0x64,0x6F,0x6E
	.DB  0x65,0x0
_0x20003:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _password_G000
	.DW  _0x3*2

	.DW  0x06
	.DW  _keyA_G001
	.DW  _0x20003*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
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
;#include <alcd.h>
;#include <string.h>
;#include <stdio.h>
;#include <spi.h>
;#include <delay.h>
;#include "rfid.h"
;
;/* Buzzer / LEDs */
;#define BUZZER_PORT PORTD
;#define BUZZER_PIN  5
;#define GREEN_LED_PORT PORTD
;#define GREEN_LED_PIN 6
;#define RED_LED_PORT PORTB
;#define RED_LED_PIN 1
;
;/* UI state */
;static unsigned char password[] = "PassWord";

	.DSEG
;static volatile int menu_list = 0;
;static volatile int write_menu = 0;
;static volatile char read_selected = 0;
;static volatile char write_selected = 0;
;static volatile int screen = 0;         // 0=welcome,1=hasData,2=empty
;
;/* INT0: next */
;interrupt [EXT_INT0] void ext_int0_isr(void){
; 0000 001A interrupt [2] void ext_int0_isr(void){

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x0
; 0000 001B     if(screen==1){ menu_list = (menu_list+1)&1; }
	BRNE _0x4
	CALL SUBOPT_0x1
	ADIW R30,1
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	STS  _menu_list_G000,R30
	STS  _menu_list_G000+1,R31
; 0000 001C     else if(screen==2){ write_menu = (write_menu+1)&1; }
	RJMP _0x5
_0x4:
	CALL SUBOPT_0x2
	BRNE _0x6
	LDS  R30,_write_menu_G000
	LDS  R31,_write_menu_G000+1
	ADIW R30,1
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	STS  _write_menu_G000,R30
	STS  _write_menu_G000+1,R31
; 0000 001D }
_0x6:
_0x5:
	RJMP _0x65
; .FEND
;/* INT1: select */
;interrupt [EXT_INT1] void ext_int1_isr(void){
; 0000 001F interrupt [3] void ext_int1_isr(void){
_ext_int1_isr:
; .FSTART _ext_int1_isr
	CALL SUBOPT_0x0
; 0000 0020     if(screen==1){ /* has data */
	BRNE _0x7
; 0000 0021         if(menu_list==0) read_selected=1;
	CALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0x8
	LDI  R30,LOW(1)
	STS  _read_selected_G000,R30
; 0000 0022         else write_selected=1;
	RJMP _0x9
_0x8:
	LDI  R30,LOW(1)
	STS  _write_selected_G000,R30
; 0000 0023     }else if(screen==2){ /* empty */
_0x9:
	RJMP _0xA
_0x7:
	CALL SUBOPT_0x2
	BRNE _0xB
; 0000 0024         if(write_menu==1) write_selected=1; /* confirm write */
	LDS  R26,_write_menu_G000
	LDS  R27,_write_menu_G000+1
	SBIW R26,1
	BRNE _0xC
	LDI  R30,LOW(1)
	STS  _write_selected_G000,R30
; 0000 0025         else { /* do nothing */ screen=0; }
	RJMP _0xD
_0xC:
	LDI  R30,LOW(0)
	STS  _screen_G000,R30
	STS  _screen_G000+1,R30
_0xD:
; 0000 0026     }
; 0000 0027 }
_0xB:
_0xA:
_0x65:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;/* LCD (=16 chars) */
;static void lcd_welcome_init(void){
; 0000 002A static void lcd_welcome_init(void){
_lcd_welcome_init_G000:
; .FSTART _lcd_welcome_init_G000
; 0000 002B     lcd_clear();
	CALL SUBOPT_0x3
; 0000 002C     lcd_gotoxy(0,0); lcd_putsf("Welcome");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x4
; 0000 002D     lcd_gotoxy(0,1); lcd_putsf("Place your card");
	__POINTW2FN _0x0,8
	CALL _lcd_putsf
; 0000 002E }
	RET
; .FEND
;static void lcd_welcome_anim(unsigned char step){
; 0000 002F static void lcd_welcome_anim(unsigned char step){
_lcd_welcome_anim_G000:
; .FSTART _lcd_welcome_anim_G000
; 0000 0030     unsigned char d = step % 4;
; 0000 0031     lcd_gotoxy(13,1);
	ST   -Y,R26
	ST   -Y,R17
;	step -> Y+1
;	d -> R17
	LDD  R30,Y+1
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MANDW12
	MOV  R17,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0032     if(d==0)      lcd_putsf("   ");
	CPI  R17,0
	BRNE _0xE
	__POINTW2FN _0x0,24
	RJMP _0x60
; 0000 0033     else if(d==1) lcd_putsf(".  ");
_0xE:
	CPI  R17,1
	BRNE _0x10
	__POINTW2FN _0x0,28
	RJMP _0x60
; 0000 0034     else if(d==2) lcd_putsf(".. ");
_0x10:
	CPI  R17,2
	BRNE _0x12
	__POINTW2FN _0x0,32
	RJMP _0x60
; 0000 0035     else          lcd_putsf("...");
_0x12:
	__POINTW2FN _0x0,36
_0x60:
	CALL _lcd_putsf
; 0000 0036 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;static void show_error(char e){
; 0000 0037 static void show_error(char e){
_show_error_G000:
; .FSTART _show_error_G000
; 0000 0038     lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("Error:");
	ST   -Y,R26
;	e -> Y+0
	CALL SUBOPT_0x3
	__POINTW2FN _0x0,40
	CALL SUBOPT_0x4
; 0000 0039     lcd_gotoxy(0,1);
; 0000 003A     if(e==MI_NOTAGERR)      lcd_putsf("No Card");
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x14
	__POINTW2FN _0x0,47
	RJMP _0x61
; 0000 003B     else if(e==MI_TIMEOUT)  lcd_putsf("Timeout");
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x16
	__POINTW2FN _0x0,55
	RJMP _0x61
; 0000 003C     else if(e==MI_COMM_ERR) lcd_putsf("Comm Error");
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x18
	__POINTW2FN _0x0,63
	RJMP _0x61
; 0000 003D     else if(e==MI_AUTH_ERR) lcd_putsf("Auth Error");
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x1A
	__POINTW2FN _0x0,74
	RJMP _0x61
; 0000 003E     else                    lcd_putsf("Unknown Err");
_0x1A:
	__POINTW2FN _0x0,85
_0x61:
	CALL _lcd_putsf
; 0000 003F }
	ADIW R28,1
	RET
; .FEND
;
;/* helpers */
;static unsigned char is_all(const unsigned char *p, unsigned char v){
; 0000 0042 static unsigned char is_all(const unsigned char *p, unsigned char v){
_is_all_G000:
; .FSTART _is_all_G000
; 0000 0043     unsigned char i; for(i=0;i<16;i++) if(p[i]!=v) return 0; return 1;
	ST   -Y,R26
	ST   -Y,R17
;	*p -> Y+2
;	v -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x1D:
	CPI  R17,16
	BRSH _0x1E
	CALL SUBOPT_0x5
	LDD  R30,Y+1
	CP   R30,R26
	BREQ _0x1F
	LDI  R30,LOW(0)
	JMP  _0x20A0007
_0x1F:
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
	LDI  R30,LOW(1)
	JMP  _0x20A0007
; 0000 0044 }
; .FEND
;static unsigned char is_empty16(const unsigned char *p){
; 0000 0045 static unsigned char is_empty16(const unsigned char *p){
_is_empty16_G000:
; .FSTART _is_empty16_G000
; 0000 0046     return (is_all(p,0x00) || is_all(p,0xFF));
	ST   -Y,R27
	ST   -Y,R26
;	*p -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _is_all_G000
	CPI  R30,0
	BRNE _0x20
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(255)
	RCALL _is_all_G000
	CPI  R30,0
	BRNE _0x20
	LDI  R30,0
	RJMP _0x21
_0x20:
	LDI  R30,1
_0x21:
	JMP  _0x20A0004
; 0000 0047 }
; .FEND
;
;/* ---------- presence check + debounce ---------- */
;/* quick poll: REQA then WUPA */
;static unsigned char card_present_quick(void){
; 0000 004B static unsigned char card_present_quick(void){
_card_present_quick_G000:
; .FSTART _card_present_quick_G000
; 0000 004C     uchar atqa[2];
; 0000 004D     char st = rc522_request(PICC_REQIDL, atqa);
; 0000 004E     if(st==MI_OK) return 1;
	SBIW R28,2
	ST   -Y,R17
;	atqa -> Y+1
;	st -> R17
	LDI  R30,LOW(38)
	CALL SUBOPT_0x6
	CPI  R17,0
	BRNE _0x22
	LDI  R30,LOW(1)
	JMP  _0x20A0003
; 0000 004F     st = rc522_request(0x52, atqa); /* WUPA */
_0x22:
	LDI  R30,LOW(82)
	CALL SUBOPT_0x6
; 0000 0050     return (st==MI_OK);
	MOV  R26,R17
	LDI  R30,LOW(0)
	CALL __EQB12
	JMP  _0x20A0003
; 0000 0051 }
; .FEND
;/* debounced presence: majority of N samples */
;static unsigned char card_present_debounced(unsigned char samples){
; 0000 0053 static unsigned char card_present_debounced(unsigned char samples){
_card_present_debounced_G000:
; .FSTART _card_present_debounced_G000
; 0000 0054     unsigned char ok=0, i;
; 0000 0055     for(i=0;i<samples; i++){
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	samples -> Y+2
;	ok -> R17
;	i -> R16
	LDI  R17,0
	LDI  R16,LOW(0)
_0x24:
	LDD  R30,Y+2
	CP   R16,R30
	BRSH _0x25
; 0000 0056         if(card_present_quick()) ok++;
	RCALL _card_present_quick_G000
	CPI  R30,0
	BREQ _0x26
	SUBI R17,-1
; 0000 0057         delay_ms(5);
_0x26:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0058     }
	SUBI R16,-1
	RJMP _0x24
_0x25:
; 0000 0059     return (ok >= (samples/2 + 1));
	LDD  R26,Y+2
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ADIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CALL __GEW12
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0002
; 0000 005A }
; .FEND
;/* ----------------------------------------------- */
;
;/* Menus */
;static void draw_menu_hasdata(void){
; 0000 005E static void draw_menu_hasdata(void){
_draw_menu_hasdata_G000:
; .FSTART _draw_menu_hasdata_G000
; 0000 005F     lcd_clear();
	CALL _lcd_clear
; 0000 0060     if(menu_list==0){
	CALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0x27
; 0000 0061         lcd_gotoxy(0,0); lcd_putsf("Data found");
	CALL SUBOPT_0x7
	__POINTW2FN _0x0,97
	CALL SUBOPT_0x4
; 0000 0062         lcd_gotoxy(0,1); lcd_putsf(">Read & check");
	__POINTW2FN _0x0,108
	RJMP _0x62
; 0000 0063     }else{
_0x27:
; 0000 0064         lcd_gotoxy(0,0); lcd_putsf("Read & check");
	CALL SUBOPT_0x7
	__POINTW2FN _0x0,109
	CALL SUBOPT_0x4
; 0000 0065         lcd_gotoxy(0,1); lcd_putsf(">Write password");
	__POINTW2FN _0x0,122
_0x62:
	CALL _lcd_putsf
; 0000 0066     }
; 0000 0067 }
	RET
; .FEND
;
;static void draw_menu_empty(void){
; 0000 0069 static void draw_menu_empty(void){
_draw_menu_empty_G000:
; .FSTART _draw_menu_empty_G000
; 0000 006A     lcd_clear();
	CALL _lcd_clear
; 0000 006B     if(write_menu==0){
	LDS  R30,_write_menu_G000
	LDS  R31,_write_menu_G000+1
	SBIW R30,0
	BRNE _0x29
; 0000 006C         lcd_gotoxy(0,0); lcd_putsf("Empty block");
	CALL SUBOPT_0x7
	__POINTW2FN _0x0,138
	CALL SUBOPT_0x4
; 0000 006D         lcd_gotoxy(0,1); lcd_putsf(">Do nothing");
	__POINTW2FN _0x0,150
	RJMP _0x63
; 0000 006E     }else{
_0x29:
; 0000 006F         lcd_gotoxy(0,0); lcd_putsf("Do nothing");
	CALL SUBOPT_0x7
	__POINTW2FN _0x0,151
	CALL SUBOPT_0x4
; 0000 0070         lcd_gotoxy(0,1); lcd_putsf(">Write password");
	__POINTW2FN _0x0,122
_0x63:
	CALL _lcd_putsf
; 0000 0071     }
; 0000 0072 }
	RET
; .FEND
;
;void main(void){
; 0000 0074 void main(void){
_main:
; .FSTART _main
; 0000 0075     // Port A initialization
; 0000 0076     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0077     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0078     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0079     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 007A 
; 0000 007B     // Port B initialization
; 0000 007C     // Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=Out Bit0=In
; 0000 007D     DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(178)
	OUT  0x17,R30
; 0000 007E     // State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=0 Bit0=T
; 0000 007F     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0080 
; 0000 0081     // Port C initialization
; 0000 0082     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0083     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0084     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0085     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0086 
; 0000 0087     // Port D initialization
; 0000 0088     // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0089     DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(96)
	OUT  0x11,R30
; 0000 008A     // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008B     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 008C 
; 0000 008D     /* Timers off */
; 0000 008E     TCCR0=0; TCCR1A=0; TCCR1B=0; TCCR2=0;
	OUT  0x33,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x25,R30
; 0000 008F     /* External INTs: INT0/1 falling-edge */
; 0000 0090     GICR|=(1<<INT1)|(1<<INT0);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0091     MCUCR=(1<<ISC11)|(0<<ISC10)|(1<<ISC01)|(0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0092     GIFR=(1<<INTF1)|(1<<INTF0);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0093     /* USART/ADC/AC off */
; 0000 0094     UCSRB=0; ADCSRA=0; ACSR=(1<<ACD);
	LDI  R30,LOW(0)
	OUT  0xA,R30
	OUT  0x6,R30
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0095     /* SPI fosc/128 ~125kHz */
; 0000 0096     SPCR=(1<<SPE)|(1<<MSTR)|(1<<SPR1)|(1<<SPR0); SPSR=0;
	LDI  R30,LOW(83)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0097 
; 0000 0098     /* LCD + enable interrupts */
; 0000 0099     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 009A     #asm("sei")
	sei
; 0000 009B 
; 0000 009C     /* RC522 */
; 0000 009D     rc522_init();
	RCALL _rc522_init
; 0000 009E 
; 0000 009F     while(1){
_0x2B:
; 0000 00A0         uchar uid[10], uid_len, sak;
; 0000 00A1         uchar atqa[2];
; 0000 00A2         uchar buf[16], verify[16], write16[16];
; 0000 00A3         uchar i;
; 0000 00A4         char st;
; 0000 00A5 
; 0000 00A6         /* Welcome + quiet poll */
; 0000 00A7         screen=0; menu_list=0; write_menu=0; read_selected=0; write_selected=0;
	SBIW R28,63
	SBIW R28,1
;	uid -> Y+54
;	uid_len -> Y+53
;	sak -> Y+52
;	atqa -> Y+50
;	buf -> Y+34
;	verify -> Y+18
;	write16 -> Y+2
;	i -> Y+1
;	st -> Y+0
	LDI  R30,LOW(0)
	STS  _screen_G000,R30
	STS  _screen_G000+1,R30
	STS  _menu_list_G000,R30
	STS  _menu_list_G000+1,R30
	STS  _write_menu_G000,R30
	STS  _write_menu_G000+1,R30
	STS  _read_selected_G000,R30
	STS  _write_selected_G000,R30
; 0000 00A8         lcd_welcome_init();
	RCALL _lcd_welcome_init_G000
; 0000 00A9         {
; 0000 00AA             unsigned char step=0;
; 0000 00AB             while(1){
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	uid -> Y+55
;	uid_len -> Y+54
;	sak -> Y+53
;	atqa -> Y+51
;	buf -> Y+35
;	verify -> Y+19
;	write16 -> Y+3
;	i -> Y+2
;	st -> Y+1
;	step -> Y+0
_0x2E:
; 0000 00AC                 st = rc522_request(PICC_REQIDL, atqa);
	LDI  R30,LOW(38)
	CALL SUBOPT_0x8
; 0000 00AD                 if(st==MI_OK) break;
	BREQ _0x30
; 0000 00AE                 st = rc522_request(0x52, atqa);
	LDI  R30,LOW(82)
	CALL SUBOPT_0x8
; 0000 00AF                 if(st==MI_OK) break;
	BREQ _0x30
; 0000 00B0                 lcd_welcome_anim(step++);
	LD   R26,Y
	SUBI R26,-LOW(1)
	ST   Y,R26
	SUBI R26,LOW(1)
	RCALL _lcd_welcome_anim_G000
; 0000 00B1                 delay_ms(120);
	CALL SUBOPT_0x9
; 0000 00B2             }
	RJMP _0x2E
_0x30:
; 0000 00B3         }
	ADIW R28,1
; 0000 00B4 
; 0000 00B5         uid_len = rc522_get_uid(uid);
	MOVW R26,R28
	ADIW R26,54
	RCALL _rc522_get_uid
	STD  Y+53,R30
; 0000 00B6         if(!uid_len){ show_error(MI_COMM_ERR); delay_ms(500); continue; }
	CPI  R30,0
	BRNE _0x33
	LDI  R26,LOW(3)
	CALL SUBOPT_0xA
	RJMP _0x2B
; 0000 00B7         st = rc522_select(uid, uid_len, &sak);
_0x33:
	MOVW R30,R28
	ADIW R30,54
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+55
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,55
	RCALL _rc522_select
	ST   Y,R30
; 0000 00B8         if(st!=MI_OK){ show_error(st); delay_ms(500); continue; }
	CPI  R30,0
	BREQ _0x34
	LD   R26,Y
	CALL SUBOPT_0xA
	RJMP _0x2B
; 0000 00B9 
; 0000 00BA         /* Auth + read block 8 */
; 0000 00BB         if(mifare_auth_keyA(8, uid)!=MI_OK){ show_error(MI_AUTH_ERR); delay_ms(700); mifare_stop_crypto(); continue; }
_0x34:
	LDI  R30,LOW(8)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,55
	RCALL _mifare_auth_keyA
	CPI  R30,0
	BREQ _0x35
	LDI  R26,LOW(6)
	CALL SUBOPT_0xB
	RJMP _0x2B
; 0000 00BC         if(mifare_read_block(8, buf)!=MI_OK){ show_error(MI_COMM_ERR); delay_ms(700); mifare_stop_crypto(); continue; }
_0x35:
	LDI  R30,LOW(8)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,35
	CALL _mifare_read_block
	CPI  R30,0
	BREQ _0x36
	LDI  R26,LOW(3)
	CALL SUBOPT_0xB
	RJMP _0x2B
; 0000 00BD 
; 0000 00BE         if(is_empty16(buf)){
_0x36:
	MOVW R26,R28
	ADIW R26,34
	RCALL _is_empty16_G000
	CPI  R30,0
	BRNE PC+2
	RJMP _0x37
; 0000 00BF             unsigned int idle_ticks_e = 0; // ~ 120ms per tick
; 0000 00C0             unsigned char miss = 0;
; 0000 00C1             /* EMPTY: menu via INT0/INT1 */
; 0000 00C2             screen=2; draw_menu_empty();
	CALL SUBOPT_0xC
;	uid -> Y+57
;	uid_len -> Y+56
;	sak -> Y+55
;	atqa -> Y+53
;	buf -> Y+37
;	verify -> Y+21
;	write16 -> Y+5
;	i -> Y+4
;	st -> Y+3
;	idle_ticks_e -> Y+1
;	miss -> Y+0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _screen_G000,R30
	STS  _screen_G000+1,R31
	RCALL _draw_menu_empty_G000
; 0000 00C3 
; 0000 00C4             while(screen==2){
_0x38:
	CALL SUBOPT_0x2
	BREQ PC+2
	RJMP _0x3A
; 0000 00C5                 /* leave if card really removed (debounced) */
; 0000 00C6                 if(!card_present_debounced(4)){         /* 4 samples -> majority */
	LDI  R26,LOW(4)
	RCALL _card_present_debounced_G000
	CPI  R30,0
	BRNE _0x3B
; 0000 00C7                     if(++miss >= 3){                    /* 3 consecutive fails */
	LD   R26,Y
	SUBI R26,-LOW(1)
	ST   Y,R26
	CPI  R26,LOW(0x3)
	BRLO _0x3C
; 0000 00C8                         mifare_stop_crypto();
	CALL _mifare_stop_crypto
; 0000 00C9                         lcd_clear(); lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 00CA                         lcd_putsf("Card removed");
	CALL SUBOPT_0xD
; 0000 00CB                         delay_ms(400);
; 0000 00CC                         break;                          /* back to welcome */
	RJMP _0x3A
; 0000 00CD                     }
; 0000 00CE                 }else{
_0x3C:
	RJMP _0x3D
_0x3B:
; 0000 00CF                     miss = 0;                           /* reset on any hit */
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 00D0                 }
_0x3D:
; 0000 00D1 
; 0000 00D2                 if(write_selected){
	LDS  R30,_write_selected_G000
	CPI  R30,0
	BRNE PC+2
	RJMP _0x3E
; 0000 00D3                     for(i=0;i<16;i++) write16[i]=0x00;
	LDI  R30,LOW(0)
	STD  Y+4,R30
_0x40:
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRSH _0x41
	CALL SUBOPT_0xE
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RJMP _0x40
_0x41:
; 0000 00D4 for(i=0;i<8;i++)  write16[i]=password[i];
	LDI  R30,LOW(0)
	STD  Y+4,R30
_0x43:
	LDD  R26,Y+4
	CPI  R26,LOW(0x8)
	BRSH _0x44
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RJMP _0x43
_0x44:
; 0000 00D5 if(mifare_write_block(8, write16)==0 &&
; 0000 00D6                        mifare_read_block(8, verify)==MI_OK &&
; 0000 00D7                        memcmp(verify, write16, 16)==0){
	CALL SUBOPT_0x10
	BRNE _0x46
	LDI  R30,LOW(8)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,22
	RCALL _mifare_read_block
	CPI  R30,0
	BRNE _0x46
	MOVW R30,R28
	ADIW R30,21
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	LDI  R26,LOW(16)
	LDI  R27,0
	CALL _memcmp
	CPI  R30,0
	BREQ _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 00D8                         GREEN_LED_PORT |= (1<<GREEN_LED_PIN);
	CALL SUBOPT_0x12
; 0000 00D9                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(200);
; 0000 00DA                         lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("Write OK");
	__POINTW2FN _0x0,175
	CALL SUBOPT_0x4
; 0000 00DB                         lcd_gotoxy(0,1); lcd_putsf("Match");
	__POINTW2FN _0x0,184
	CALL SUBOPT_0x13
; 0000 00DC                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
; 0000 00DD                         GREEN_LED_PORT &= ~(1<<GREEN_LED_PIN);
; 0000 00DE                     }else{
	RJMP _0x48
_0x45:
; 0000 00DF                         RED_LED_PORT |= (1<<RED_LED_PIN);
	CALL SUBOPT_0x14
; 0000 00E0                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(120);
; 0000 00E1                         show_error(MI_COMM_ERR);
	LDI  R26,LOW(3)
	RCALL _show_error_G000
; 0000 00E2                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
	CBI  0x12,5
; 0000 00E3                         RED_LED_PORT &= ~(1<<RED_LED_PIN);
	CBI  0x18,1
; 0000 00E4                     }
_0x48:
; 0000 00E5                     write_selected=0;
	CALL SUBOPT_0x15
; 0000 00E6                     mifare_stop_crypto();
; 0000 00E7                     delay_ms(900);
; 0000 00E8                     break; /* back to welcome */
	RJMP _0x3A
; 0000 00E9                 }
; 0000 00EA 
; 0000 00EB                 delay_ms(120);
_0x3E:
	CALL SUBOPT_0x9
; 0000 00EC                 idle_ticks_e++;
	CALL SUBOPT_0x16
; 0000 00ED                 if(idle_ticks_e > 80){ /* ~9.6s */
	BRLO _0x49
; 0000 00EE                     mifare_stop_crypto();
	RCALL _mifare_stop_crypto
; 0000 00EF                     break;                              /* back to welcome */
	RJMP _0x3A
; 0000 00F0                 }
; 0000 00F1 
; 0000 00F2                 /* refresh menu if user pressed next */
; 0000 00F3                 draw_menu_empty();
_0x49:
	RCALL _draw_menu_empty_G000
; 0000 00F4             }
	RJMP _0x38
_0x3A:
; 0000 00F5         }else{
	RJMP _0x64
_0x37:
; 0000 00F6             /* HAS DATA: menu via INT0/INT1 */
; 0000 00F7             unsigned int idle_ticks_h = 0; // ~ 120ms per tick
; 0000 00F8             unsigned char miss = 0;
; 0000 00F9             screen=1; draw_menu_hasdata();
	CALL SUBOPT_0xC
;	uid -> Y+57
;	uid_len -> Y+56
;	sak -> Y+55
;	atqa -> Y+53
;	buf -> Y+37
;	verify -> Y+21
;	write16 -> Y+5
;	i -> Y+4
;	st -> Y+3
;	idle_ticks_h -> Y+1
;	miss -> Y+0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _screen_G000,R30
	STS  _screen_G000+1,R31
	RCALL _draw_menu_hasdata_G000
; 0000 00FA 
; 0000 00FB             while(screen==1){
_0x4B:
	LDS  R26,_screen_G000
	LDS  R27,_screen_G000+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0x4D
; 0000 00FC                 /* leave if card really removed (debounced) */
; 0000 00FD                 if(!card_present_debounced(4)){
	LDI  R26,LOW(4)
	RCALL _card_present_debounced_G000
	CPI  R30,0
	BRNE _0x4E
; 0000 00FE                     if(++miss >= 3){
	LD   R26,Y
	SUBI R26,-LOW(1)
	ST   Y,R26
	CPI  R26,LOW(0x3)
	BRLO _0x4F
; 0000 00FF                         mifare_stop_crypto();
	RCALL _mifare_stop_crypto
; 0000 0100                         lcd_clear(); lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0101                         lcd_putsf("Card removed");
	CALL SUBOPT_0xD
; 0000 0102                         delay_ms(400);
; 0000 0103                         break;                          /* back to welcome */
	RJMP _0x4D
; 0000 0104                     }
; 0000 0105                 }else{
_0x4F:
	RJMP _0x50
_0x4E:
; 0000 0106                     miss = 0;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0107                 }
_0x50:
; 0000 0108 
; 0000 0109                 if(read_selected){
	LDS  R30,_read_selected_G000
	CPI  R30,0
	BREQ _0x51
; 0000 010A                     if(strncmp((char*)buf,(char*)password,8)==0){
	MOVW R30,R28
	ADIW R30,37
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_password_G000)
	LDI  R31,HIGH(_password_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x52
; 0000 010B                         GREEN_LED_PORT |= (1<<GREEN_LED_PIN);
	CALL SUBOPT_0x12
; 0000 010C                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(200);
; 0000 010D                         lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("Password OK");
	__POINTW2FN _0x0,190
	CALL SUBOPT_0x4
; 0000 010E                         lcd_gotoxy(0,1); lcd_putsf("Access granted");
	__POINTW2FN _0x0,202
	CALL SUBOPT_0x13
; 0000 010F                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
; 0000 0110                         GREEN_LED_PORT &= ~(1<<GREEN_LED_PIN);
; 0000 0111                     }else{
	RJMP _0x53
_0x52:
; 0000 0112                         RED_LED_PORT |= (1<<RED_LED_PIN);
	CALL SUBOPT_0x14
; 0000 0113                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(120);
; 0000 0114                         lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("Password NG");
	CALL SUBOPT_0x3
	__POINTW2FN _0x0,217
	CALL SUBOPT_0x4
; 0000 0115                         lcd_gotoxy(0,1); lcd_putsf("Try again");
	__POINTW2FN _0x0,229
	CALL _lcd_putsf
; 0000 0116                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
	CBI  0x12,5
; 0000 0117                         RED_LED_PORT &= ~(1<<RED_LED_PIN);
	CBI  0x18,1
; 0000 0118                     }
_0x53:
; 0000 0119                     read_selected=0;
	LDI  R30,LOW(0)
	STS  _read_selected_G000,R30
; 0000 011A                     mifare_stop_crypto();
	RCALL _mifare_stop_crypto
; 0000 011B                     delay_ms(900);
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	CALL _delay_ms
; 0000 011C                     break;
	RJMP _0x4D
; 0000 011D                 }else if(write_selected){
_0x51:
	LDS  R30,_write_selected_G000
	CPI  R30,0
	BREQ _0x55
; 0000 011E                     for(i=0;i<16;i++) write16[i]=0x00;
	LDI  R30,LOW(0)
	STD  Y+4,R30
_0x57:
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRSH _0x58
	CALL SUBOPT_0xE
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RJMP _0x57
_0x58:
; 0000 011F for(i=0;i<8;i++)  write16[i]=password[i];
	LDI  R30,LOW(0)
	STD  Y+4,R30
_0x5A:
	LDD  R26,Y+4
	CPI  R26,LOW(0x8)
	BRSH _0x5B
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	LDD  R30,Y+4
	SUBI R30,-LOW(1)
	STD  Y+4,R30
	RJMP _0x5A
_0x5B:
; 0000 0120 if(mifare_write_block(8, write16)==0){
	CALL SUBOPT_0x10
	BRNE _0x5C
; 0000 0121                         GREEN_LED_PORT |= (1<<GREEN_LED_PIN);
	CALL SUBOPT_0x12
; 0000 0122                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(200);
; 0000 0123                         lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("Write done");
	__POINTW2FN _0x0,239
	CALL SUBOPT_0x13
; 0000 0124                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
; 0000 0125                         GREEN_LED_PORT &= ~(1<<GREEN_LED_PIN);
; 0000 0126                     }else{
	RJMP _0x5D
_0x5C:
; 0000 0127                         RED_LED_PORT |= (1<<RED_LED_PIN);
	CALL SUBOPT_0x14
; 0000 0128                         BUZZER_PORT |= (1<<BUZZER_PIN); delay_ms(120);
; 0000 0129                         show_error(MI_COMM_ERR);
	LDI  R26,LOW(3)
	RCALL _show_error_G000
; 0000 012A                         BUZZER_PORT &= ~(1<<BUZZER_PIN);
	CBI  0x12,5
; 0000 012B                         RED_LED_PORT &= ~(1<<RED_LED_PIN);
	CBI  0x18,1
; 0000 012C                     }
_0x5D:
; 0000 012D                     write_selected=0;
	CALL SUBOPT_0x15
; 0000 012E                     mifare_stop_crypto();
; 0000 012F                     delay_ms(900);
; 0000 0130                     break;
	RJMP _0x4D
; 0000 0131                 }
; 0000 0132 
; 0000 0133                 delay_ms(120);
_0x55:
	CALL SUBOPT_0x9
; 0000 0134                 idle_ticks_h++;
	CALL SUBOPT_0x16
; 0000 0135                 if(idle_ticks_h > 80){ /* ~9.6s */
	BRLO _0x5E
; 0000 0136                     mifare_stop_crypto();
	RCALL _mifare_stop_crypto
; 0000 0137                     break;                              /* back to welcome */
	RJMP _0x4D
; 0000 0138                 }
; 0000 0139 
; 0000 013A                 /* refresh menu if user pressed next */
; 0000 013B                 draw_menu_hasdata();
_0x5E:
	RCALL _draw_menu_hasdata_G000
; 0000 013C             }
	RJMP _0x4B
_0x4D:
; 0000 013D         }
_0x64:
	ADIW R28,3
; 0000 013E     }
	ADIW R28,63
	ADIW R28,1
	RJMP _0x2B
; 0000 013F }
_0x5F:
	RJMP _0x5F
; .FEND
;#include <mega32.h>
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
;#include <spi.h>
;#include <delay.h>
;#include "rfid.h"
;
;/* --- RC522 regs --- */
;#define CommandReg       0x01
;#define ComIEnReg        0x02
;#define ComIrqReg        0x04
;#define DivIrqReg        0x05
;#define ErrorReg         0x06
;#define Status1Reg       0x07
;#define Status2Reg       0x08
;#define FIFODataReg      0x09
;#define FIFOLevelReg     0x0A
;#define ControlReg       0x0C
;#define BitFramingReg    0x0D
;#define CollReg          0x0E
;#define ModeReg          0x11
;#define TxControlReg     0x14
;#define TxASKReg         0x15
;#define CRCResultRegH    0x21
;#define CRCResultRegL    0x22
;#define TModeReg         0x2A
;#define TPrescalerReg    0x2B
;#define TReloadRegH      0x2C
;#define TReloadRegL      0x2D
;
;/* --- RC522 cmds --- */
;#define PCD_Idle         0x00
;#define PCD_CalcCRC      0x03
;#define PCD_Transceive   0x0C
;#define PCD_SoftReset    0x0F
;#define PCD_MFAuthent    0x0E
;
;/* --- ISO14443A/PICC --- */
;#define PICC_REQIDL        0x26
;#define PICC_ANTICOLL_CL1  0x93
;#define PICC_ANTICOLL_CL2  0x95
;#define PICC_SELECT_CL1    0x93
;#define PICC_SELECT_CL2    0x95
;
;/* --- MIFARE Classic --- */
;#define MF_AUTH_KEY_A    0x60
;#define MF_READ          0x30
;#define MF_WRITE         0xA0
;
;/* --- Default Key A --- */
;static uchar keyA[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

	.DSEG
;
;/* --- CS helpers --- */
;static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_BIT); }
; 0001 0034 static void cs_low(void){  PORTB &= ~(1<<4   ); }

	.CSEG
_cs_low_G001:
; .FSTART _cs_low_G001
	CBI  0x18,4
	RET
; .FEND
;static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_BIT); }
; 0001 0035 static void cs_high(void){ PORTB |=  (1<<4   ); }
_cs_high_G001:
; .FSTART _cs_high_G001
	SBI  0x18,4
	RET
; .FEND
;
;/* ===== Low-level R/W ===== */
;void rc522_write(uchar reg, uchar val){
; 0001 0038 void rc522_write(uchar reg, uchar val){
_rc522_write:
; .FSTART _rc522_write
; 0001 0039     cs_low(); spi((reg<<1)&0x7E); spi(val); cs_high();
	ST   -Y,R26
;	reg -> Y+1
;	val -> Y+0
	RCALL _cs_low_G001
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	MOV  R26,R30
	CALL _spi
	LD   R26,Y
	CALL _spi
	RCALL _cs_high_G001
; 0001 003A }
	JMP  _0x20A0004
; .FEND
;uchar rc522_read(uchar reg){
; 0001 003B uchar rc522_read(uchar reg){
_rc522_read:
; .FSTART _rc522_read
; 0001 003C     uchar v;
; 0001 003D     cs_low(); spi(((reg<<1)&0x7E)|0x80); v=spi(0x00); cs_high();
	ST   -Y,R26
	ST   -Y,R17
;	reg -> Y+1
;	v -> R17
	RCALL _cs_low_G001
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	ORI  R30,0x80
	MOV  R26,R30
	CALL _spi
	LDI  R26,LOW(0)
	CALL _spi
	MOV  R17,R30
	RCALL _cs_high_G001
; 0001 003E     return v;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0001 003F }
; .FEND
;void set_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)|mask); }
; 0001 0040 void set_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)|mask); }
_set_bit_mask:
; .FSTART _set_bit_mask
	CALL SUBOPT_0x17
;	reg -> Y+1
;	mask -> Y+0
	LDD  R26,Y+1
	OR   R30,R26
	MOV  R26,R30
	RCALL _rc522_write
	JMP  _0x20A0004
; .FEND
;void clr_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
; 0001 0041 void clr_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
_clr_bit_mask:
; .FSTART _clr_bit_mask
	CALL SUBOPT_0x17
;	reg -> Y+1
;	mask -> Y+0
	MOV  R26,R30
	LDD  R30,Y+1
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	RCALL _rc522_write
	JMP  _0x20A0004
; .FEND
;
;/* ===== CRC_A ===== */
;static void rc522_calc_crc(uchar *data, uchar len, uchar *crc2){
; 0001 0044 static void rc522_calc_crc(uchar *data, uchar len, uchar *crc2){
_rc522_calc_crc_G001:
; .FSTART _rc522_calc_crc_G001
; 0001 0045     uchar i;
; 0001 0046     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x18
;	*data -> Y+4
;	len -> Y+3
;	*crc2 -> Y+1
;	i -> R17
; 0001 0047     set_bit_mask(FIFOLevelReg, 0x80);
; 0001 0048     for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
	LDI  R17,LOW(0)
_0x20005:
	LDD  R30,Y+3
	CP   R17,R30
	BRSH _0x20006
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x19
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0049 rc522_write(0x01, 0x03);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _rc522_write
; 0001 004A     for(i=0;i<255;i++){ if(rc522_read(DivIrqReg) & 0x04) break; }
	LDI  R17,LOW(0)
_0x20008:
	CPI  R17,255
	BRSH _0x20009
	LDI  R26,LOW(5)
	RCALL _rc522_read
	ANDI R30,LOW(0x4)
	BRNE _0x20009
	SUBI R17,-1
	RJMP _0x20008
_0x20009:
; 0001 004B     crc2[0]=rc522_read(CRCResultRegL);
	LDI  R26,LOW(34)
	RCALL _rc522_read
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
; 0001 004C     crc2[1]=rc522_read(CRCResultRegH);
	LDI  R26,LOW(33)
	RCALL _rc522_read
	__PUTB1SNS 1,1
; 0001 004D }
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
;
;/* ===== Transceive ===== */
;static uchar rc522_transceive(uchar *send, uchar sendLen, uchar *back, uchar *backBits){
; 0001 0050 static uchar rc522_transceive(uchar *send, uchar sendLen, uchar *back, uchar *backBits){
_rc522_transceive_G001:
; .FSTART _rc522_transceive_G001
; 0001 0051     uchar i, n, lastBits;
; 0001 0052     rc522_write(ComIEnReg, 0x77 | 0x80);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*send -> Y+9
;	sendLen -> Y+8
;	*back -> Y+6
;	*backBits -> Y+4
;	i -> R17
;	n -> R16
;	lastBits -> R19
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(247)
	RCALL _rc522_write
; 0001 0053     clr_bit_mask(ComIrqReg, 0x80);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask
; 0001 0054     set_bit_mask(FIFOLevelReg, 0x80);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _set_bit_mask
; 0001 0055     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0001 0056     for(i=0;i<sendLen;i++) rc522_write(FIFODataReg, send[i]);
	LDI  R17,LOW(0)
_0x2000C:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0x2000D
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x19
	SUBI R17,-1
	RJMP _0x2000C
_0x2000D:
; 0001 0057 rc522_write(0x01, 0x0C);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(12)
	RCALL _rc522_write
; 0001 0058     set_bit_mask(BitFramingReg, 0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _set_bit_mask
; 0001 0059     i=200;
	LDI  R17,LOW(200)
; 0001 005A     do{ n=rc522_read(ComIrqReg); }while(--i && !(n&0x30));
_0x2000F:
	LDI  R26,LOW(4)
	RCALL _rc522_read
	MOV  R16,R30
	SUBI R17,LOW(1)
	BREQ _0x20011
	ANDI R30,LOW(0x30)
	BREQ _0x20012
_0x20011:
	RJMP _0x20010
_0x20012:
	RJMP _0x2000F
_0x20010:
; 0001 005B     clr_bit_mask(BitFramingReg,0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask
; 0001 005C     if(!i) return MI_TIMEOUT;
	CPI  R17,0
	BRNE _0x20013
	LDI  R30,LOW(2)
	RJMP _0x20A000B
; 0001 005D     if(rc522_read(ErrorReg)&0x1B) return MI_COMM_ERR;
_0x20013:
	LDI  R26,LOW(6)
	RCALL _rc522_read
	ANDI R30,LOW(0x1B)
	BREQ _0x20014
	LDI  R30,LOW(3)
	RJMP _0x20A000B
; 0001 005E     n = rc522_read(FIFOLevelReg);
_0x20014:
	LDI  R26,LOW(10)
	RCALL _rc522_read
	MOV  R16,R30
; 0001 005F     lastBits = rc522_read(ControlReg) & 0x07;
	LDI  R26,LOW(12)
	RCALL _rc522_read
	ANDI R30,LOW(0x7)
	MOV  R19,R30
; 0001 0060     if(backBits){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x20015
; 0001 0061         if(lastBits) *backBits = (n-1)*8 + lastBits;
	CPI  R19,0
	BREQ _0x20016
	MOV  R30,R16
	SUBI R30,LOW(1)
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R30,R19
	RJMP _0x2004A
; 0001 0062         else         *backBits = n*8;
_0x20016:
	MOV  R30,R16
	LSL  R30
	LSL  R30
	LSL  R30
_0x2004A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0001 0063     }
; 0001 0064     for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
_0x20015:
	LDI  R17,LOW(0)
_0x20019:
	CP   R17,R16
	BRSH _0x2001A
	MOV  R30,R17
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(9)
	RCALL _rc522_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20019
_0x2001A:
; 0001 0065 return 0;
	RJMP _0x20A000C
; 0001 0066 }
; .FEND
;
;/* ===== Init ===== */
;void rc522_init(void){
; 0001 0069 void rc522_init(void){
_rc522_init:
; .FSTART _rc522_init
; 0001 006A     RC522_CS_DDR  |= (1<<RC522_CS_BIT);
	SBI  0x17,4
; 0001 006B     RC522_CS_PORT |= (1<<RC522_CS_BIT);
	SBI  0x18,4
; 0001 006C     rc522_write(CommandReg,PCD_SoftReset);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _rc522_write
; 0001 006D     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0001 006E     rc522_write(TModeReg,      0x8D);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _rc522_write
; 0001 006F     rc522_write(TPrescalerReg, 0x3E);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _rc522_write
; 0001 0070     rc522_write(TReloadRegL,   30);
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _rc522_write
; 0001 0071     rc522_write(TReloadRegH,   0);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1A
; 0001 0072     rc522_write(TxASKReg,      0x40);
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _rc522_write
; 0001 0073     rc522_write(ModeReg,       0x3D);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _rc522_write
; 0001 0074     if(!(rc522_read(TxControlReg)&0x03)) set_bit_mask(TxControlReg,0x03);
	LDI  R26,LOW(20)
	RCALL _rc522_read
	ANDI R30,LOW(0x3)
	BRNE _0x2001B
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _set_bit_mask
; 0001 0075 }
_0x2001B:
	RET
; .FEND
;
;/* ===== REQA / Anticoll / Select ===== */
;uchar rc522_request(uchar reqMode, uchar *ATQA){
; 0001 0078 uchar rc522_request(uchar reqMode, uchar *ATQA){
_rc522_request:
; .FSTART _rc522_request
; 0001 0079     uchar cmd, back[4], bits, st;
; 0001 007A     cmd=reqMode; bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	reqMode -> Y+10
;	*ATQA -> Y+8
;	cmd -> R17
;	back -> Y+4
;	bits -> R16
;	st -> R19
	LDD  R17,Y+10
	LDI  R16,LOW(0)
; 0001 007B     rc522_write(BitFramingReg,0x07);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _rc522_write
; 0001 007C     st = rc522_transceive(&cmd,1,back,&bits);
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x11
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _rc522_transceive_G001
	POP  R16
	POP  R17
	MOV  R19,R30
; 0001 007D     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1A
; 0001 007E     if(st!=MI_OK) return MI_NOTAGERR;
	CPI  R19,0
	BREQ _0x2001C
	LDI  R30,LOW(1)
	RJMP _0x20A000B
; 0001 007F     if(bits!=16)  return MI_NOTAGERR;
_0x2001C:
	CPI  R16,16
	BREQ _0x2001D
	LDI  R30,LOW(1)
	RJMP _0x20A000B
; 0001 0080     ATQA[0]=back[0]; ATQA[1]=back[1];
_0x2001D:
	LDD  R30,Y+4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X,R30
	LDD  R30,Y+5
	__PUTB1SNS 8,1
; 0001 0081     return MI_OK;
_0x20A000C:
	LDI  R30,LOW(0)
_0x20A000B:
	CALL __LOADLOCR4
	ADIW R28,11
	RET
; 0001 0082 }
; .FEND
;static uchar rc522_anticoll_level(uchar level_cmd, uchar *out5){
; 0001 0083 static uchar rc522_anticoll_level(uchar level_cmd, uchar *out5){
_rc522_anticoll_level_G001:
; .FSTART _rc522_anticoll_level_G001
; 0001 0084     uchar cmd[2], back[10], bits, i, st;
; 0001 0085     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR4
;	level_cmd -> Y+18
;	*out5 -> Y+16
;	cmd -> Y+14
;	back -> Y+4
;	bits -> R17
;	i -> R16
;	st -> R19
	LDI  R17,LOW(0)
; 0001 0086     cmd[0]=level_cmd; cmd[1]=0x20;
	LDD  R30,Y+18
	STD  Y+14,R30
	LDI  R30,LOW(32)
	STD  Y+15,R30
; 0001 0087     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1A
; 0001 0088     rc522_write(CollReg,0x80);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _rc522_write
; 0001 0089     st = rc522_transceive(cmd,2,back,&bits);
	MOVW R30,R28
	ADIW R30,14
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x11
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G001
	POP  R17
	MOV  R19,R30
; 0001 008A     if(st!=MI_OK) return st;
	CPI  R19,0
	BREQ _0x2001E
	RJMP _0x20A000A
; 0001 008B     if(bits!=40)  return MI_COMM_ERR;
_0x2001E:
	CPI  R17,40
	BREQ _0x2001F
	LDI  R30,LOW(3)
	RJMP _0x20A000A
; 0001 008C     for(i=0;i<5;i++) out5[i]=back[i];
_0x2001F:
	LDI  R16,LOW(0)
_0x20021:
	CPI  R16,5
	BRSH _0x20022
	MOV  R30,R16
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	SUBI R16,-1
	RJMP _0x20021
_0x20022:
; 0001 008D return 0;
	LDI  R30,LOW(0)
_0x20A000A:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
; 0001 008E }
; .FEND
;uchar rc522_get_uid(uchar *uid){
; 0001 008F uchar rc522_get_uid(uchar *uid){
_rc522_get_uid:
; .FSTART _rc522_get_uid
; 0001 0090     uchar b[5], bcc, i;
; 0001 0091     if(rc522_anticoll_level(PICC_ANTICOLL_CL1,b)!=MI_OK) return 0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	ST   -Y,R17
	ST   -Y,R16
;	*uid -> Y+7
;	b -> Y+2
;	bcc -> R17
;	i -> R16
	LDI  R30,LOW(147)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	RCALL _rc522_anticoll_level_G001
	CPI  R30,0
	BREQ _0x20023
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0001 0092     if(b[0]==0x88){
_0x20023:
	LDD  R26,Y+2
	CPI  R26,LOW(0x88)
	BRNE _0x20024
; 0001 0093         for(i=0;i<4;i++) uid[i]=b[i+1];
	LDI  R16,LOW(0)
_0x20026:
	CPI  R16,4
	BRSH _0x20027
	MOV  R30,R16
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x1C
	ADIW R30,1
	CALL SUBOPT_0x1E
	SUBI R16,-1
	RJMP _0x20026
_0x20027:
; 0001 0094 return 4;
	LDI  R30,LOW(4)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0001 0095     }else{
_0x20024:
; 0001 0096         bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
	LDD  R30,Y+3
	LDD  R26,Y+2
	EOR  R30,R26
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+5
	EOR  R30,R26
	MOV  R17,R30
	LDD  R30,Y+6
	CP   R30,R17
	BREQ _0x20029
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0001 0097         for(i=0;i<4;i++) uid[i]=b[i];
_0x20029:
	LDI  R16,LOW(0)
_0x2002B:
	CPI  R16,4
	BRSH _0x2002C
	MOV  R30,R16
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	SUBI R16,-1
	RJMP _0x2002B
_0x2002C:
; 0001 0098 return 4;
	LDI  R30,LOW(4)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0008
; 0001 0099     }
; 0001 009A }
; .FEND
;static uchar uid_bcc4(uchar *u4){ return (uchar)(u4[0]^u4[1]^u4[2]^u4[3]); }
; 0001 009B static uchar uid_bcc4(uchar *u4){ return (uchar)(u4[0]^u4[1]^u4[2]^u4[3]); }
_uid_bcc4_G001:
; .FSTART _uid_bcc4_G001
	ST   -Y,R27
	ST   -Y,R26
;	*u4 -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+1
	EOR  R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+2
	EOR  R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R30,Z+3
	EOR  R30,R26
	RJMP _0x20A0004
; .FEND
;static uchar rc522_select_level(uchar level_cmd, uchar *uid4, uchar *sak_out){
; 0001 009C static uchar rc522_select_level(uchar level_cmd, uchar *uid4, uchar *sak_out){
_rc522_select_level_G001:
; .FSTART _rc522_select_level_G001
; 0001 009D     uchar f[9], crc[2], back[4], bits, bcc, st;
; 0001 009E     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,15
	CALL __SAVELOCR4
;	level_cmd -> Y+23
;	*uid4 -> Y+21
;	*sak_out -> Y+19
;	f -> Y+10
;	crc -> Y+8
;	back -> Y+4
;	bits -> R17
;	bcc -> R16
;	st -> R19
	LDI  R17,LOW(0)
; 0001 009F     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1A
; 0001 00A0     bcc = uid_bcc4(uid4);
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	RCALL _uid_bcc4_G001
	MOV  R16,R30
; 0001 00A1     f[0]=level_cmd; f[1]=0x70;
	LDD  R30,Y+23
	STD  Y+10,R30
	LDI  R30,LOW(112)
	STD  Y+11,R30
; 0001 00A2     f[2]=uid4[0];   f[3]=uid4[1]; f[4]=uid4[2]; f[5]=uid4[3];
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	STD  Y+12,R30
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R30,Z+1
	STD  Y+13,R30
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R30,Z+2
	STD  Y+14,R30
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R30,Z+3
	STD  Y+15,R30
; 0001 00A3     f[6]=bcc;
	MOVW R30,R28
	ADIW R30,16
	ST   Z,R16
; 0001 00A4     rc522_calc_crc(f,7,crc); f[7]=crc[0]; f[8]=crc[1];
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,11
	RCALL _rc522_calc_crc_G001
	LDD  R30,Y+8
	STD  Y+17,R30
	LDD  R30,Y+9
	STD  Y+18,R30
; 0001 00A5     st = rc522_transceive(f,9,back,&bits);
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL SUBOPT_0x11
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G001
	POP  R17
	MOV  R19,R30
; 0001 00A6     if(st!=MI_OK) return st;
	CPI  R19,0
	BREQ _0x2002D
	RJMP _0x20A0009
; 0001 00A7     if(bits!=24)  return MI_COMM_ERR;
_0x2002D:
	CPI  R17,24
	BREQ _0x2002E
	LDI  R30,LOW(3)
	RJMP _0x20A0009
; 0001 00A8     *sak_out = back[0];
_0x2002E:
	LDD  R30,Y+4
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	ST   X,R30
; 0001 00A9     return MI_OK;
	LDI  R30,LOW(0)
_0x20A0009:
	CALL __LOADLOCR4
	ADIW R28,24
	RET
; 0001 00AA }
; .FEND
;uchar rc522_select(uchar *uid, uchar uid_len, uchar *sak){
; 0001 00AB uchar rc522_select(uchar *uid, uchar uid_len, uchar *sak){
_rc522_select:
; .FSTART _rc522_select
; 0001 00AC     uchar uid4[4];
; 0001 00AD     if(uid_len==4){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	*uid -> Y+7
;	uid_len -> Y+6
;	*sak -> Y+4
;	uid4 -> Y+0
	LDD  R26,Y+6
	CPI  R26,LOW(0x4)
	BRNE _0x2002F
; 0001 00AE         uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LD   R30,X
	ST   Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R30,Z+1
	STD  Y+1,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R30,Z+2
	STD  Y+2,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R30,Z+3
	STD  Y+3,R30
; 0001 00AF         return rc522_select_level(PICC_SELECT_CL1, uid4, sak);
	LDI  R30,LOW(147)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RCALL _rc522_select_level_G001
	RJMP _0x20A0008
; 0001 00B0     }
; 0001 00B1     return MI_COMM_ERR;
_0x2002F:
	LDI  R30,LOW(3)
_0x20A0008:
	ADIW R28,9
	RET
; 0001 00B2 }
; .FEND
;
;/* ===== Classic auth/read/write ===== */
;uchar mifare_auth_keyA(uchar blockAddr, uchar *uid4){
; 0001 00B5 uchar mifare_auth_keyA(uchar blockAddr, uchar *uid4){
_mifare_auth_keyA:
; .FSTART _mifare_auth_keyA
; 0001 00B6     uchar i;
; 0001 00B7     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x18
;	blockAddr -> Y+3
;	*uid4 -> Y+1
;	i -> R17
; 0001 00B8     set_bit_mask(FIFOLevelReg,0x80);
; 0001 00B9     rc522_write(FIFODataReg, MF_AUTH_KEY_A);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(96)
	RCALL _rc522_write
; 0001 00BA     rc522_write(FIFODataReg, blockAddr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _rc522_write
; 0001 00BB     for(i=0;i<6;i++) rc522_write(FIFODataReg, keyA[i]);
	LDI  R17,LOW(0)
_0x20031:
	CPI  R17,6
	BRSH _0x20032
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_keyA_G001)
	SBCI R31,HIGH(-_keyA_G001)
	LD   R26,Z
	RCALL _rc522_write
	SUBI R17,-1
	RJMP _0x20031
_0x20032:
; 0001 00BC for(i=0;i<4;i++) rc522_write(0x09, uid4[i]);
	LDI  R17,LOW(0)
_0x20034:
	CPI  R17,4
	BRSH _0x20035
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL SUBOPT_0x5
	RCALL _rc522_write
	SUBI R17,-1
	RJMP _0x20034
_0x20035:
; 0001 00BD rc522_write(0x01, 0x0E);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(14)
	RCALL _rc522_write
; 0001 00BE     for(i=0;i<200;i++){ if(rc522_read(Status2Reg) & 0x08) return MI_OK; delay_ms(1); }
	LDI  R17,LOW(0)
_0x20037:
	CPI  R17,200
	BRSH _0x20038
	LDI  R26,LOW(8)
	RCALL _rc522_read
	ANDI R30,LOW(0x8)
	BREQ _0x20039
	LDI  R30,LOW(0)
	RJMP _0x20A0007
_0x20039:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	SUBI R17,-1
	RJMP _0x20037
_0x20038:
; 0001 00BF     return MI_AUTH_ERR;
	LDI  R30,LOW(6)
_0x20A0007:
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0001 00C0 }
; .FEND
;void mifare_stop_crypto(void){
; 0001 00C1 void mifare_stop_crypto(void){
_mifare_stop_crypto:
; .FSTART _mifare_stop_crypto
; 0001 00C2     clr_bit_mask(Status2Reg,0x08);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _clr_bit_mask
; 0001 00C3     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
; 0001 00C4 }
	RET
; .FEND
;uchar mifare_read_block(uchar blockAddr, uchar *out16){
; 0001 00C5 uchar mifare_read_block(uchar blockAddr, uchar *out16){
_mifare_read_block:
; .FSTART _mifare_read_block
; 0001 00C6     uchar cmd[4], crc[2], back[32], bits, i, st;
; 0001 00C7     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,38
	CALL __SAVELOCR4
;	blockAddr -> Y+44
;	*out16 -> Y+42
;	cmd -> Y+38
;	crc -> Y+36
;	back -> Y+4
;	bits -> R17
;	i -> R16
;	st -> R19
	LDI  R17,LOW(0)
; 0001 00C8     cmd[0]=MF_READ; cmd[1]=blockAddr;
	LDI  R30,LOW(48)
	STD  Y+38,R30
	LDD  R30,Y+44
	STD  Y+39,R30
; 0001 00C9     rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
	MOVW R30,R28
	ADIW R30,38
	CALL SUBOPT_0x1B
	MOVW R26,R28
	ADIW R26,39
	RCALL _rc522_calc_crc_G001
	LDD  R30,Y+36
	STD  Y+40,R30
	LDD  R30,Y+37
	STD  Y+41,R30
; 0001 00CA     st = rc522_transceive(cmd,4,back,&bits);
	MOVW R30,R28
	ADIW R30,38
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x11
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G001
	POP  R17
	MOV  R19,R30
; 0001 00CB     if(st!=MI_OK) return st;
	CPI  R19,0
	BREQ _0x2003A
	RJMP _0x20A0006
; 0001 00CC     if(bits<16*8)  return MI_COMM_ERR;
_0x2003A:
	CPI  R17,128
	BRSH _0x2003B
	LDI  R30,LOW(3)
	RJMP _0x20A0006
; 0001 00CD     for(i=0;i<16;i++) out16[i]=back[i];
_0x2003B:
	LDI  R16,LOW(0)
_0x2003D:
	CPI  R16,16
	BRSH _0x2003E
	MOV  R30,R16
	LDD  R26,Y+42
	LDD  R27,Y+42+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	SUBI R16,-1
	RJMP _0x2003D
_0x2003E:
; 0001 00CE return 0;
	LDI  R30,LOW(0)
_0x20A0006:
	CALL __LOADLOCR4
	ADIW R28,45
	RET
; 0001 00CF }
; .FEND
;uchar mifare_write_block(uchar blockAddr, uchar *data16){
; 0001 00D0 uchar mifare_write_block(uchar blockAddr, uchar *data16){
_mifare_write_block:
; .FSTART _mifare_write_block
; 0001 00D1     uchar cmd[4], crc[2], ack[8], bits, frame[18], i, st;
; 0001 00D2     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,32
	CALL __SAVELOCR4
;	blockAddr -> Y+38
;	*data16 -> Y+36
;	cmd -> Y+32
;	crc -> Y+30
;	ack -> Y+22
;	bits -> R17
;	frame -> Y+4
;	i -> R16
;	st -> R19
	LDI  R17,LOW(0)
; 0001 00D3     cmd[0]=MF_WRITE; cmd[1]=blockAddr;
	LDI  R30,LOW(160)
	STD  Y+32,R30
	LDD  R30,Y+38
	STD  Y+33,R30
; 0001 00D4     rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
	MOVW R30,R28
	ADIW R30,32
	CALL SUBOPT_0x1B
	MOVW R26,R28
	ADIW R26,33
	RCALL _rc522_calc_crc_G001
	LDD  R30,Y+30
	STD  Y+34,R30
	LDD  R30,Y+31
	STD  Y+35,R30
; 0001 00D5     st = rc522_transceive(cmd,4,ack,&bits);
	MOVW R30,R28
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,25
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G001
	POP  R17
	MOV  R19,R30
; 0001 00D6     if(st!=MI_OK) return st;
	CPI  R19,0
	BREQ _0x2003F
	RJMP _0x20A0005
; 0001 00D7     if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return MI_COMM_ERR;
_0x2003F:
	CPI  R17,4
	BRNE _0x20041
	LDD  R30,Y+22
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x20040
_0x20041:
	LDI  R30,LOW(3)
	RJMP _0x20A0005
; 0001 00D8     for(i=0;i<16;i++) frame[i]=data16[i];
_0x20040:
	LDI  R16,LOW(0)
_0x20044:
	CPI  R16,16
	BRSH _0x20045
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x20044
_0x20045:
; 0001 00D9 rc522_calc_crc(data16,16,crc); frame[16]=crc[0]; frame[17]=crc[1];
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,33
	RCALL _rc522_calc_crc_G001
	LDD  R30,Y+30
	STD  Y+20,R30
	LDD  R30,Y+31
	STD  Y+21,R30
; 0001 00DA     st = rc522_transceive(frame,18,ack,&bits);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,25
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G001
	POP  R17
	MOV  R19,R30
; 0001 00DB     if(st!=MI_OK) return st;
	CPI  R19,0
	BREQ _0x20046
	RJMP _0x20A0005
; 0001 00DC     if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return MI_COMM_ERR;
_0x20046:
	CPI  R17,4
	BRNE _0x20048
	LDD  R30,Y+22
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x20047
_0x20048:
	LDI  R30,LOW(3)
	RJMP _0x20A0005
; 0001 00DD     return MI_OK;
_0x20047:
	LDI  R30,LOW(0)
_0x20A0005:
	CALL __LOADLOCR4
	ADIW R28,39
	RET
; 0001 00DE }
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	JMP  _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	JMP  _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
_0x20A0004:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1F
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	JMP  _0x20A0001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	JMP  _0x20A0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20A0003:
	LDD  R17,Y+0
_0x20A0002:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x20A0001
; .FEND

	.CSEG
_memcmp:
; .FSTART _memcmp
	ST   -Y,R27
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r25,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
memcmp0:
    adiw r24,0
    breq memcmp1
    sbiw r24,1
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    breq memcmp0
memcmp1:
    sub  r22,r23
    brcc memcmp2
    ldi  r30,-1
    ret
memcmp2:
    ldi  r30,0
    breq memcmp3
    inc  r30
memcmp3:
    ret
; .FEND
_strncmp:
; .FSTART _strncmp
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strncmp0:
    tst  r24
    breq strncmp1
    dec  r24
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strncmp1
    tst  r22
    brne strncmp0
strncmp3:
    clr  r30
    ret
strncmp1:
    sub  r22,r23
    breq strncmp3
    ldi  r30,1
    brcc strncmp2
    subi r30,2
strncmp2:
    ret
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
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2060003:
	SBIS 0xE,7
	RJMP _0x2060003
	IN   R30,0xF
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_password_G000:
	.BYTE 0x9
_menu_list_G000:
	.BYTE 0x2
_write_menu_G000:
	.BYTE 0x2
_read_selected_G000:
	.BYTE 0x1
_write_selected_G000:
	.BYTE 0x1
_screen_G000:
	.BYTE 0x2
_keyA_G001:
	.BYTE 0x6
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R26,_screen_G000
	LDS  R27,_screen_G000+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_menu_list_G000
	LDS  R31,_menu_list_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_screen_G000
	LDS  R27,_screen_G000+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x3:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _rc522_request
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,52
	CALL _rc522_request
	STD  Y+1,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(120)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL _show_error_G000
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	ADIW R28,63
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	CALL _show_error_G000
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	CALL _delay_ms
	CALL _mifare_stop_crypto
	ADIW R28,63
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	SBIW R28,3
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	__POINTW2FN _0x0,162
	CALL _lcd_putsf
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDD  R30,Y+4
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDD  R30,Y+4
	LDI  R31,0
	SUBI R30,LOW(-_password_G000)
	SBCI R31,HIGH(-_password_G000)
	LD   R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(8)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	CALL _mifare_write_block
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	SBI  0x12,6
	SBI  0x12,5
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL _lcd_putsf
	CBI  0x12,5
	CBI  0x12,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	SBI  0x18,1
	SBI  0x12,5
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _write_selected_G000,R30
	CALL _mifare_stop_crypto
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CPI  R26,LOW(0x51)
	LDI  R30,HIGH(0x51)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+2
	JMP  _rc522_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rc522_write
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(128)
	JMP  _set_bit_mask

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	JMP  _rc522_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _rc522_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__GEW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRGE __GEW12T
	CLR  R30
__GEW12T:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
