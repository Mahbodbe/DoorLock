
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
	JMP  0x00
	JMP  0x00

_S_C1K_G000:
	.DB  0x4D,0x49,0x46,0x41,0x52,0x45,0x20,0x43
	.DB  0x6C,0x61,0x73,0x73,0x69,0x63,0x20,0x31
	.DB  0x4B,0x0
_S_C4K_G000:
	.DB  0x4D,0x49,0x46,0x41,0x52,0x45,0x20,0x43
	.DB  0x6C,0x61,0x73,0x73,0x69,0x63,0x20,0x34
	.DB  0x4B,0x0
_S_UL_G000:
	.DB  0x55,0x6C,0x74,0x72,0x61,0x6C,0x69,0x67
	.DB  0x68,0x74,0x2F,0x4E,0x54,0x41,0x47,0x0
_S_UNK_G000:
	.DB  0x55,0x6E,0x6B,0x6E,0x6F,0x77,0x6E,0x2F
	.DB  0x6F,0x74,0x68,0x65,0x72,0x0
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x4:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x0:
	.DB  0x52,0x43,0x35,0x32,0x32,0x20,0x52,0x65
	.DB  0x61,0x64,0x79,0x0,0x53,0x63,0x61,0x6E
	.DB  0x20,0x61,0x20,0x63,0x61,0x72,0x64,0x2E
	.DB  0x2E,0x2E,0x0,0x53,0x65,0x6C,0x65,0x63
	.DB  0x74,0x20,0x66,0x61,0x69,0x6C,0x65,0x64
	.DB  0x0,0x53,0x41,0x4B,0x3A,0x25,0x30,0x32
	.DB  0x58,0x0,0x55,0x49,0x44,0x3A,0x25,0x30
	.DB  0x32,0x58,0x25,0x30,0x32,0x58,0x25,0x30
	.DB  0x32,0x58,0x25,0x30,0x32,0x58,0x0,0x41
	.DB  0x75,0x74,0x68,0x2D,0x52,0x65,0x61,0x64
	.DB  0x20,0x46,0x41,0x49,0x4C,0x0,0x52,0x65
	.DB  0x61,0x64,0x20,0x45,0x72,0x72,0x6F,0x72
	.DB  0x0,0x42,0x34,0x3A,0x0,0x52,0x65,0x2D
	.DB  0x73,0x65,0x6C,0x65,0x63,0x74,0x20,0x46
	.DB  0x61,0x69,0x6C,0x0,0x41,0x75,0x74,0x68
	.DB  0x20,0x54,0x72,0x61,0x69,0x6C,0x65,0x72
	.DB  0x20,0x46,0x61,0x69,0x6C,0x0,0x54,0x72
	.DB  0x61,0x69,0x6C,0x65,0x72,0x20,0x52,0x65
	.DB  0x61,0x64,0x45,0x72,0x72,0x0,0x52,0x4F
	.DB  0x3A,0x0,0x59,0x45,0x53,0x20,0x0,0x4E
	.DB  0x4F,0x20,0x20,0x0,0x43,0x3A,0x25,0x64
	.DB  0x25,0x64,0x25,0x64,0x0,0x41,0x43,0x43
	.DB  0x3A,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x0,0x52,0x4F
	.DB  0x3A,0x4E,0x2F,0x41,0x20,0x28,0x54,0x79
	.DB  0x70,0x65,0x32,0x29,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _DEF_KEY_A_G000
	.DW  _0x3*2

	.DW  0x06
	.DW  _DEF_KEY_B_G000
	.DW  _0x4*2

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
;#include <spi.h>
;#include <stdio.h>
;#include <delay.h>
;#include <stdint.h>
;
;/* --- Pins --- */
;#define RC522_CS_PORT PORTB
;#define RC522_CS_DDR  DDRB
;#define RC522_CS_PIN  PORTB4
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
;#define ModeReg          0x11
;#define TxControlReg     0x14
;#define TxASKReg         0x15
;#define CollReg          0x0E
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
;#define PICC_HALT          0x50
;
;/* --- MIFARE Classic --- */
;#define MF_AUTH_KEY_A    0x60
;#define MF_AUTH_KEY_B    0x61
;#define MF_READ          0x30
;
;/* --- Strings in flash --- */
;static flash char S_C1K[]="MIFARE Classic 1K";
;static flash char S_C4K[]="MIFARE Classic 4K";
;static flash char S_UL []="Ultralight/NTAG";
;static flash char S_UNK[]="Unknown/other";
;
;/* --- Default Keys --- */
;static uint8_t DEF_KEY_A[6] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

	.DSEG
;static uint8_t DEF_KEY_B[6] = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
;
;/* --- CS helpers --- */
;static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_PIN); }
; 0000 0043 static void cs_low(void){  PORTB &= ~(1<<4       ); }

	.CSEG
_cs_low_G000:
; .FSTART _cs_low_G000
	CBI  0x18,4
	RET
; .FEND
;static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_PIN); }
; 0000 0044 static void cs_high(void){ PORTB |=  (1<<4       ); }
_cs_high_G000:
; .FSTART _cs_high_G000
	SBI  0x18,4
	RET
; .FEND
;
;/* --- Low-level R/W --- */
;static void rc522_write(uint8_t reg, uint8_t val){
; 0000 0047 static void rc522_write(uint8_t reg, uint8_t val){
_rc522_write_G000:
; .FSTART _rc522_write_G000
; 0000 0048     cs_low(); spi((reg<<1)&0x7E); spi(val); cs_high();
	ST   -Y,R26
;	reg -> Y+1
;	val -> Y+0
	RCALL _cs_low_G000
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	MOV  R26,R30
	CALL _spi
	LD   R26,Y
	CALL _spi
	RCALL _cs_high_G000
; 0000 0049 }
	JMP  _0x20A0004
; .FEND
;static uint8_t rc522_read(uint8_t reg){
; 0000 004A static uint8_t rc522_read(uint8_t reg){
_rc522_read_G000:
; .FSTART _rc522_read_G000
; 0000 004B     uint8_t v;
; 0000 004C     cs_low(); spi(((reg<<1)&0x7E)|0x80); v=spi(0x00); cs_high();
	ST   -Y,R26
	ST   -Y,R17
;	reg -> Y+1
;	v -> R17
	RCALL _cs_low_G000
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	ORI  R30,0x80
	MOV  R26,R30
	CALL _spi
	LDI  R26,LOW(0)
	CALL _spi
	MOV  R17,R30
	RCALL _cs_high_G000
; 0000 004D     return v;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0000 004E }
; .FEND
;static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
; 0000 004F static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
_set_bit_mask_G000:
; .FSTART _set_bit_mask_G000
	CALL SUBOPT_0x0
;	reg -> Y+1
;	mask -> Y+0
	LDD  R26,Y+1
	OR   R30,R26
	MOV  R26,R30
	RCALL _rc522_write_G000
	JMP  _0x20A0004
; .FEND
;static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
; 0000 0050 static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
_clr_bit_mask_G000:
; .FSTART _clr_bit_mask_G000
	CALL SUBOPT_0x0
;	reg -> Y+1
;	mask -> Y+0
	MOV  R26,R30
	LDD  R30,Y+1
	COM  R30
	AND  R30,R26
	MOV  R26,R30
	RCALL _rc522_write_G000
	JMP  _0x20A0004
; .FEND
;
;/* --- Init --- */
;static void rc522_soft_reset(void){ rc522_write(CommandReg,PCD_SoftReset); delay_ms(50); }
; 0000 0053 static void rc522_soft_reset(void){ rc522_write(0x01,0x0F); delay_ms(50); }
_rc522_soft_reset_G000:
; .FSTART _rc522_soft_reset_G000
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _rc522_write_G000
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	RET
; .FEND
;static void rc522_antenna_on(void){ if(!(rc522_read(TxControlReg)&0x03)) set_bit_mask(TxControlReg,0x03); }
; 0000 0054 static void rc522_antenna_on(void){ if(!(rc522_read(0x14)&0x03)) set_bit_mask(0x14,0x03); }
_rc522_antenna_on_G000:
; .FSTART _rc522_antenna_on_G000
	LDI  R26,LOW(20)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x3)
	BRNE _0x5
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _set_bit_mask_G000
_0x5:
	RET
; .FEND
;static void rc522_init(void){
; 0000 0055 static void rc522_init(void){
_rc522_init_G000:
; .FSTART _rc522_init_G000
; 0000 0056     rc522_soft_reset();
	RCALL _rc522_soft_reset_G000
; 0000 0057     rc522_write(TModeReg,      0x8D);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _rc522_write_G000
; 0000 0058     rc522_write(TPrescalerReg, 0x3E);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _rc522_write_G000
; 0000 0059     rc522_write(TReloadRegL,   30);
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _rc522_write_G000
; 0000 005A     rc522_write(TReloadRegH,   0);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1
; 0000 005B     rc522_write(TxASKReg,      0x40);
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _rc522_write_G000
; 0000 005C     rc522_write(ModeReg,       0x3D);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _rc522_write_G000
; 0000 005D     rc522_antenna_on();
	RCALL _rc522_antenna_on_G000
; 0000 005E }
	RET
; .FEND
;
;/* --- CRC_A --- */
;static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
; 0000 0061 static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
_rc522_calc_crc_G000:
; .FSTART _rc522_calc_crc_G000
; 0000 0062     uint8_t i;
; 0000 0063     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x2
;	*data -> Y+4
;	len -> Y+3
;	*crc2 -> Y+1
;	i -> R17
; 0000 0064     set_bit_mask(FIFOLevelReg, 0x80);
	CALL SUBOPT_0x3
; 0000 0065     for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
	LDI  R17,LOW(0)
_0x7:
	LDD  R30,Y+3
	CP   R17,R30
	BRSH _0x8
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0x7
_0x8:
; 0000 0066 rc522_write(0x01, 0x03);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _rc522_write_G000
; 0000 0067     for(i=0;i<255;i++){
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,255
	BRSH _0xB
; 0000 0068         if(rc522_read(DivIrqReg) & 0x04) break;
	LDI  R26,LOW(5)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x4)
	BRNE _0xB
; 0000 0069     }
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 006A     crc2[0]=rc522_read(CRCResultRegL);
	LDI  R26,LOW(34)
	RCALL _rc522_read_G000
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
; 0000 006B     crc2[1]=rc522_read(CRCResultRegH);
	LDI  R26,LOW(33)
	RCALL _rc522_read_G000
	__PUTB1SNS 1,1
; 0000 006C }
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
;
;/* --- Transceive --- */
;static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
; 0000 006F static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
_rc522_transceive_G000:
; .FSTART _rc522_transceive_G000
; 0000 0070     uint8_t i, n, lastBits;
; 0000 0071     rc522_write(ComIEnReg, 0x77 | 0x80);
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
	RCALL _rc522_write_G000
; 0000 0072     clr_bit_mask(ComIrqReg, 0x80);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask_G000
; 0000 0073     set_bit_mask(FIFOLevelReg, 0x80);
	CALL SUBOPT_0x3
; 0000 0074     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 0075     for(i=0;i<sendLen;i++) rc522_write(FIFODataReg, send[i]);
	LDI  R17,LOW(0)
_0xE:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0xF
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0xE
_0xF:
; 0000 0076 rc522_write(0x01, 0x0C);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(12)
	RCALL _rc522_write_G000
; 0000 0077     set_bit_mask(BitFramingReg, 0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _set_bit_mask_G000
; 0000 0078     i=200;
	LDI  R17,LOW(200)
; 0000 0079     do{ n=rc522_read(ComIrqReg); }while(--i && !(n&0x30));
_0x11:
	LDI  R26,LOW(4)
	RCALL _rc522_read_G000
	MOV  R16,R30
	SUBI R17,LOW(1)
	BREQ _0x13
	ANDI R30,LOW(0x30)
	BREQ _0x14
_0x13:
	RJMP _0x12
_0x14:
	RJMP _0x11
_0x12:
; 0000 007A     clr_bit_mask(BitFramingReg,0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask_G000
; 0000 007B     if(!i) return 0;
	CPI  R17,0
	BRNE _0x15
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 007C     if(rc522_read(ErrorReg)&0x1B) return 0;
_0x15:
	LDI  R26,LOW(6)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x1B)
	BREQ _0x16
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 007D     n = rc522_read(FIFOLevelReg);
_0x16:
	LDI  R26,LOW(10)
	RCALL _rc522_read_G000
	MOV  R16,R30
; 0000 007E     lastBits = rc522_read(ControlReg) & 0x07;
	LDI  R26,LOW(12)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x7)
	MOV  R19,R30
; 0000 007F     if(backBits){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x17
; 0000 0080         if(lastBits) *backBits = (n-1)*8 + lastBits;
	CPI  R19,0
	BREQ _0x18
	MOV  R30,R16
	SUBI R30,LOW(1)
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R30,R19
	RJMP _0x68
; 0000 0081         else         *backBits = n*8;
_0x18:
	MOV  R30,R16
	LSL  R30
	LSL  R30
	LSL  R30
_0x68:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 0082     }
; 0000 0083     for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
_0x17:
	LDI  R17,LOW(0)
_0x1B:
	CP   R17,R16
	BRSH _0x1C
	MOV  R30,R17
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(9)
	RCALL _rc522_read_G000
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 0084 return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A0009
; 0000 0085 }
; .FEND
;
;/* --- REQA/Anticoll/Select/Halt --- */
;static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
; 0000 0088 static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
_rc522_request_G000:
; .FSTART _rc522_request_G000
; 0000 0089     uint8_t cmd, back[4], bits;
; 0000 008A     cmd=reqMode; bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	reqMode -> Y+8
;	*ATQA -> Y+6
;	cmd -> R17
;	back -> Y+2
;	bits -> R16
	LDD  R17,Y+8
	LDI  R16,LOW(0)
; 0000 008B     rc522_write(BitFramingReg,0x07);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _rc522_write_G000
; 0000 008C     if(!rc522_transceive(&cmd,1,back,&bits)) return 0;
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _rc522_transceive_G000
	POP  R16
	POP  R17
	CPI  R30,0
	BRNE _0x1D
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 008D     rc522_write(BitFramingReg,0x00);
_0x1D:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 008E     if(bits!=16) return 0;
	CPI  R16,16
	BREQ _0x1E
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 008F     ATQA[0]=back[0]; ATQA[1]=back[1];
_0x1E:
	LDD  R30,Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDD  R30,Y+3
	__PUTB1SNS 6,1
; 0000 0090     return 1;
	LDI  R30,LOW(1)
_0x20A000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
; 0000 0091 }
; .FEND
;static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
; 0000 0092 static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
_rc522_anticoll_level_G000:
; .FSTART _rc522_anticoll_level_G000
; 0000 0093     uint8_t cmd[2], back[10], bits, i;
; 0000 0094     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
;	level_cmd -> Y+16
;	*out5 -> Y+14
;	cmd -> Y+12
;	back -> Y+2
;	bits -> R17
;	i -> R16
	LDI  R17,LOW(0)
; 0000 0095     cmd[0]=level_cmd; cmd[1]=0x20;
	LDD  R30,Y+16
	STD  Y+12,R30
	LDI  R30,LOW(32)
	STD  Y+13,R30
; 0000 0096     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 0097     rc522_write(CollReg,0x80);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _rc522_write_G000
; 0000 0098     if(!rc522_transceive(cmd,2,back,&bits)) return 0;
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x1F
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0000 0099     if(bits!=40) return 0;
_0x1F:
	CPI  R17,40
	BREQ _0x20
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0000 009A     for(i=0;i<5;i++) out5[i]=back[i];
_0x20:
	LDI  R16,LOW(0)
_0x22:
	CPI  R16,5
	BRSH _0x23
	MOV  R30,R16
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	SUBI R16,-1
	RJMP _0x22
_0x23:
; 0000 009B return 1;
	LDI  R30,LOW(1)
_0x20A000B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,17
	RET
; 0000 009C }
; .FEND
;static uint8_t uid_bcc4(uint8_t *u4){
; 0000 009D static uint8_t uid_bcc4(uint8_t *u4){
_uid_bcc4_G000:
; .FSTART _uid_bcc4_G000
; 0000 009E     uint8_t b;
; 0000 009F     b = (uint8_t)(u4[0]^u4[1]^u4[2]^u4[3]);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*u4 -> Y+1
;	b -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+1
	EOR  R26,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+2
	EOR  R26,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+3
	EOR  R30,R26
	MOV  R17,R30
; 0000 00A0     return b;
	JMP  _0x20A0003
; 0000 00A1 }
; .FEND
;static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t *sak_out){
; 0000 00A2 static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t *sak_out){
_rc522_select_level_G000:
; .FSTART _rc522_select_level_G000
; 0000 00A3     uint8_t f[9], crc[2], back[4], bits, bcc;
; 0000 00A4     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,15
	ST   -Y,R17
	ST   -Y,R16
;	level_cmd -> Y+21
;	*uid4 -> Y+19
;	*sak_out -> Y+17
;	f -> Y+8
;	crc -> Y+6
;	back -> Y+2
;	bits -> R17
;	bcc -> R16
	LDI  R17,LOW(0)
; 0000 00A5     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 00A6     bcc = uid_bcc4(uid4);
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _uid_bcc4_G000
	MOV  R16,R30
; 0000 00A7     f[0]=level_cmd; f[1]=0x70;
	LDD  R30,Y+21
	STD  Y+8,R30
	LDI  R30,LOW(112)
	STD  Y+9,R30
; 0000 00A8     f[2]=uid4[0];   f[3]=uid4[1]; f[4]=uid4[2]; f[5]=uid4[3];
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LD   R30,X
	STD  Y+10,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R30,Z+1
	STD  Y+11,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R30,Z+2
	STD  Y+12,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R30,Z+3
	STD  Y+13,R30
; 0000 00A9     f[6]=bcc; rc522_calc_crc(f,7,crc); f[7]=crc[0]; f[8]=crc[1];
	MOVW R30,R28
	ADIW R30,14
	ST   Z,R16
	CALL SUBOPT_0x8
	LDI  R30,LOW(7)
	CALL SUBOPT_0x9
	STD  Y+15,R30
	LDD  R30,Y+7
	STD  Y+16,R30
; 0000 00AA     if(!rc522_transceive(f,9,back,&bits)) return 0;
	CALL SUBOPT_0x8
	LDI  R30,LOW(9)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x24
	LDI  R30,LOW(0)
	RJMP _0x20A000A
; 0000 00AB     if(bits!=24) return 0;
_0x24:
	CPI  R17,24
	BREQ _0x25
	LDI  R30,LOW(0)
	RJMP _0x20A000A
; 0000 00AC     *sak_out = back[0];
_0x25:
	LDD  R30,Y+2
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ST   X,R30
; 0000 00AD     return 1;
	LDI  R30,LOW(1)
_0x20A000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; 0000 00AE }
; .FEND
;static uint8_t rc522_get_uid(uint8_t *uid){
; 0000 00AF static uint8_t rc522_get_uid(uint8_t *uid){
_rc522_get_uid_G000:
; .FSTART _rc522_get_uid_G000
; 0000 00B0     uint8_t b[5], bcc, i, len;
; 0000 00B1     len=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	CALL __SAVELOCR4
;	*uid -> Y+9
;	b -> Y+4
;	bcc -> R17
;	i -> R16
;	len -> R19
	LDI  R19,LOW(0)
; 0000 00B2     if(!rc522_anticoll_level(PICC_ANTICOLL_CL1,b)) return 0;
	LDI  R30,LOW(147)
	CALL SUBOPT_0xA
	BRNE _0x26
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 00B3     if(b[0]==0x88){
_0x26:
	LDD  R26,Y+4
	CPI  R26,LOW(0x88)
	BRNE _0x27
; 0000 00B4         uid[0]=b[1]; uid[1]=b[2]; uid[2]=b[3];
	LDD  R30,Y+5
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R30,Y+6
	__PUTB1SNS 9,1
	LDD  R30,Y+7
	__PUTB1SNS 9,2
; 0000 00B5         if(!rc522_anticoll_level(PICC_ANTICOLL_CL2,b)) return 0;
	LDI  R30,LOW(149)
	CALL SUBOPT_0xA
	BRNE _0x28
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 00B6         bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
_0x28:
	CALL SUBOPT_0xB
	BREQ _0x29
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 00B7         uid[3]=b[0]; uid[4]=b[1]; uid[5]=b[2]; uid[6]=b[3];
_0x29:
	LDD  R30,Y+4
	__PUTB1SNS 9,3
	LDD  R30,Y+5
	__PUTB1SNS 9,4
	LDD  R30,Y+6
	__PUTB1SNS 9,5
	LDD  R30,Y+7
	__PUTB1SNS 9,6
; 0000 00B8         len=7;
	LDI  R19,LOW(7)
; 0000 00B9     }else{
	RJMP _0x2A
_0x27:
; 0000 00BA         bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
	CALL SUBOPT_0xB
	BREQ _0x2B
	LDI  R30,LOW(0)
	RJMP _0x20A0009
; 0000 00BB         for(i=0;i<4;i++) uid[i]=b[i];
_0x2B:
	LDI  R16,LOW(0)
_0x2D:
	CPI  R16,4
	BRSH _0x2E
	MOV  R30,R16
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x2D
_0x2E:
; 0000 00BC len=4;
	LDI  R19,LOW(4)
; 0000 00BD     }
_0x2A:
; 0000 00BE     return len;
	MOV  R30,R19
_0x20A0009:
	CALL __LOADLOCR4
	ADIW R28,11
	RET
; 0000 00BF }
; .FEND
;static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
; 0000 00C0 static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
_rc522_select_G000:
; .FSTART _rc522_select_G000
; 0000 00C1     uint8_t uid4[4], tmp;
; 0000 00C2     if(uid_len==4){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	*uid -> Y+8
;	uid_len -> Y+7
;	*sak -> Y+5
;	uid4 -> Y+1
;	tmp -> R17
	LDD  R26,Y+7
	CPI  R26,LOW(0x4)
	BRNE _0x2F
; 0000 00C3         uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	STD  Y+1,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+1
	STD  Y+2,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+2
	STD  Y+3,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+3
	CALL SUBOPT_0xC
; 0000 00C4         return rc522_select_level(PICC_SELECT_CL1, uid4, sak);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _rc522_select_level_G000
	RJMP _0x20A0007
; 0000 00C5     }else if(uid_len==7){
_0x2F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x7)
	BRNE _0x31
; 0000 00C6         uid4[0]=0x88; uid4[1]=uid[0]; uid4[2]=uid[1]; uid4[3]=uid[2];
	LDI  R30,LOW(136)
	STD  Y+1,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	STD  Y+2,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+1
	STD  Y+3,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+2
	CALL SUBOPT_0xC
; 0000 00C7         if(!rc522_select_level(PICC_SELECT_CL1, uid4, &tmp)) return 0;
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_select_level_G000
	POP  R17
	CPI  R30,0
	BREQ _0x20A0008
; 0000 00C8         uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+3
	STD  Y+1,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+4
	STD  Y+2,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+5
	STD  Y+3,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R30,Z+6
	STD  Y+4,R30
; 0000 00C9         return rc522_select_level(PICC_SELECT_CL2, uid4, sak);
	LDI  R30,LOW(149)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _rc522_select_level_G000
	RJMP _0x20A0007
; 0000 00CA     }
; 0000 00CB     return 0;
_0x31:
_0x20A0008:
	LDI  R30,LOW(0)
_0x20A0007:
	LDD  R17,Y+0
	ADIW R28,10
	RET
; 0000 00CC }
; .FEND
;static uint8_t picc_halt(void){
; 0000 00CD static uint8_t picc_halt(void){
_picc_halt_G000:
; .FSTART _picc_halt_G000
; 0000 00CE     uint8_t cmd[4], crc[2], back[4], bits, ok;
; 0000 00CF     bits=0; ok=0;
	SBIW R28,10
	ST   -Y,R17
	ST   -Y,R16
;	cmd -> Y+8
;	crc -> Y+6
;	back -> Y+2
;	bits -> R17
;	ok -> R16
	LDI  R17,LOW(0)
	LDI  R16,LOW(0)
; 0000 00D0     cmd[0]=PICC_HALT; cmd[1]=0x00;
	LDI  R30,LOW(80)
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
; 0000 00D1     rc522_calc_crc(cmd,2,crc);
	CALL SUBOPT_0x8
	LDI  R30,LOW(2)
	CALL SUBOPT_0x9
; 0000 00D2     cmd[2]=crc[0]; cmd[3]=crc[1];
	STD  Y+10,R30
	LDD  R30,Y+7
	STD  Y+11,R30
; 0000 00D3     ok = rc522_transceive(cmd,4,back,&bits);
	CALL SUBOPT_0x8
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	MOV  R16,R30
; 0000 00D4     /* HALT expects no reply; ignore ok/bits */
; 0000 00D5     return 1;
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET
; 0000 00D6 }
; .FEND
;
;/* --- Type detect --- */
;static void lcd_puts_flash(flash char* s){ char c; while((c=*s++)) lcd_putchar(c); }
; 0000 00D9 static void lcd_puts_flash(flash char* s){ char c; while((c=*s++)) lcd_putchar(c); }
_lcd_puts_flash_G000:
; .FSTART _lcd_puts_flash_G000
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*s -> Y+1
;	c -> R17
_0x33:
	CALL SUBOPT_0xD
	BREQ _0x35
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x33
_0x35:
	JMP  _0x20A0003
; .FEND
;static flash char* type_from_sak(uint8_t sak){
; 0000 00DA static flash char* type_from_sak(uint8_t sak){
_type_from_sak_G000:
; .FSTART _type_from_sak_G000
; 0000 00DB     uint8_t s;
; 0000 00DC     s = sak & 0xFC;
	ST   -Y,R26
	ST   -Y,R17
;	sak -> Y+1
;	s -> R17
	LDD  R30,Y+1
	ANDI R30,LOW(0xFC)
	MOV  R17,R30
; 0000 00DD     if(s==0x08) return S_C1K;
	CPI  R17,8
	BRNE _0x36
	LDI  R30,LOW(_S_C1K_G000*2)
	LDI  R31,HIGH(_S_C1K_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0000 00DE     if(s==0x18) return S_C4K;
_0x36:
	CPI  R17,24
	BRNE _0x37
	LDI  R30,LOW(_S_C4K_G000*2)
	LDI  R31,HIGH(_S_C4K_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0000 00DF     if(s==0x00) return S_UL;
_0x37:
	CPI  R17,0
	BRNE _0x38
	LDI  R30,LOW(_S_UL_G000*2)
	LDI  R31,HIGH(_S_UL_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0000 00E0     return S_UNK;
_0x38:
	LDI  R30,LOW(_S_UNK_G000*2)
	LDI  R31,HIGH(_S_UNK_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0004
; 0000 00E1 }
; .FEND
;
;/* --- MIFARE Classic auth/read --- */
;static uint8_t mifare_auth(uint8_t auth_cmd, uint8_t blockAddr, uint8_t *uid4, uint8_t *key6){
; 0000 00E4 static uint8_t mifare_auth(uint8_t auth_cmd, uint8_t blockAddr, uint8_t *uid4, uint8_t *key6){
_mifare_auth_G000:
; .FSTART _mifare_auth_G000
; 0000 00E5     uint8_t i;
; 0000 00E6     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x2
;	auth_cmd -> Y+6
;	blockAddr -> Y+5
;	*uid4 -> Y+3
;	*key6 -> Y+1
;	i -> R17
; 0000 00E7     set_bit_mask(FIFOLevelReg,0x80);
	CALL SUBOPT_0x3
; 0000 00E8     rc522_write(FIFODataReg, auth_cmd);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+7
	RCALL _rc522_write_G000
; 0000 00E9     rc522_write(FIFODataReg, blockAddr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+6
	RCALL _rc522_write_G000
; 0000 00EA     for(i=0;i<6;i++) rc522_write(FIFODataReg, key6[i]);
	LDI  R17,LOW(0)
_0x3A:
	CPI  R17,6
	BRSH _0x3B
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0x3A
_0x3B:
; 0000 00EB for(i=0;i<4;i++) rc522_write(0x09, uid4[i]);
	LDI  R17,LOW(0)
_0x3D:
	CPI  R17,4
	BRSH _0x3E
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 00EC rc522_write(0x01, 0x0E);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(14)
	RCALL _rc522_write_G000
; 0000 00ED     for(i=0;i<200;i++){
	LDI  R17,LOW(0)
_0x40:
	CPI  R17,200
	BRSH _0x41
; 0000 00EE         if(rc522_read(Status2Reg) & 0x08) return 1;
	LDI  R26,LOW(8)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x8)
	BREQ _0x42
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x20A0005
; 0000 00EF         delay_ms(1);
_0x42:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 00F0     }
	SUBI R17,-1
	RJMP _0x40
_0x41:
; 0000 00F1     return 0;
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x20A0005
; 0000 00F2 }
; .FEND
;static void mifare_stop_crypto(void){
; 0000 00F3 static void mifare_stop_crypto(void){
_mifare_stop_crypto_G000:
; .FSTART _mifare_stop_crypto_G000
; 0000 00F4     clr_bit_mask(Status2Reg,0x08);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _clr_bit_mask_G000
; 0000 00F5     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 00F6 }
	RET
; .FEND
;static uint8_t mifare_read_block(uint8_t blockAddr, uint8_t *out16){
; 0000 00F7 static uint8_t mifare_read_block(uint8_t blockAddr, uint8_t *out16){
_mifare_read_block_G000:
; .FSTART _mifare_read_block_G000
; 0000 00F8     uint8_t cmd[4], crc[2], back[32], bits, i;
; 0000 00F9     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,38
	ST   -Y,R17
	ST   -Y,R16
;	blockAddr -> Y+42
;	*out16 -> Y+40
;	cmd -> Y+36
;	crc -> Y+34
;	back -> Y+2
;	bits -> R17
;	i -> R16
	LDI  R17,LOW(0)
; 0000 00FA     cmd[0]=MF_READ; cmd[1]=blockAddr;
	LDI  R30,LOW(48)
	STD  Y+36,R30
	LDD  R30,Y+42
	STD  Y+37,R30
; 0000 00FB     rc522_calc_crc(cmd,2,crc);
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,37
	RCALL _rc522_calc_crc_G000
; 0000 00FC     cmd[2]=crc[0]; cmd[3]=crc[1];
	LDD  R30,Y+34
	STD  Y+38,R30
	LDD  R30,Y+35
	STD  Y+39,R30
; 0000 00FD     if(!rc522_transceive(cmd,4,back,&bits)) return 0;
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x43
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00FE     if(bits < 16*8) return 0;
_0x43:
	CPI  R17,128
	BRSH _0x44
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00FF     for(i=0;i<16;i++) out16[i]=back[i];
_0x44:
	LDI  R16,LOW(0)
_0x46:
	CPI  R16,16
	BRSH _0x47
	MOV  R30,R16
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	SUBI R16,-1
	RJMP _0x46
_0x47:
; 0000 0100 return 1;
	LDI  R30,LOW(1)
_0x20A0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,43
	RET
; 0000 0101 }
; .FEND
;
;static uint8_t get_c_bits_for_block(uint8_t *trailer, uint8_t blockOffset,
; 0000 0104                                     uint8_t *c1, uint8_t *c2, uint8_t *c3)
; 0000 0105 {
_get_c_bits_for_block_G000:
; .FSTART _get_c_bits_for_block_G000
; 0000 0106     uint8_t b7 = trailer[7];
; 0000 0107     uint8_t b8 = trailer[8];
; 0000 0108     uint8_t i  = (blockOffset & 0x03);
; 0000 0109 
; 0000 010A     /* Per NXP: C1 from B7[4+i], C2 from B8[4+i], C3 from B8[i] */
; 0000 010B     *c1 = (uint8_t)((b7 >> (4 + i)) & 0x01);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*trailer -> Y+11
;	blockOffset -> Y+10
;	*c1 -> Y+8
;	*c2 -> Y+6
;	*c3 -> Y+4
;	b7 -> R17
;	b8 -> R16
;	i -> R19
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R30,Z+7
	MOV  R17,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R30,Z+8
	MOV  R16,R30
	LDD  R30,Y+10
	ANDI R30,LOW(0x3)
	MOV  R19,R30
	SUBI R30,-LOW(4)
	MOV  R26,R17
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X,R30
; 0000 010C     *c2 = (uint8_t)((b8 >> (4 + i)) & 0x01);
	MOV  R30,R19
	SUBI R30,-LOW(4)
	MOV  R26,R16
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 010D     *c3 = (uint8_t)((b8 >> (0 + i)) & 0x01);
	MOV  R30,R19
	MOV  R26,R16
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 010E     return 1;
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	ADIW R28,13
	RET
; 0000 010F }
; .FEND
;
;/* replaces previous data_block_is_readonly (???? ?????? ???? ???) */
;static uint8_t data_block_is_readonly(uint8_t c1, uint8_t c2, uint8_t c3)
; 0000 0113 {
_data_block_is_readonly_G000:
; .FSTART _data_block_is_readonly_G000
; 0000 0114     uint8_t code = (uint8_t)((c1<<2)|(c2<<1)|c3);
; 0000 0115     /* 010, 001, 101, 111 => never write */
; 0000 0116     return (code==2 || code==1 || code==5 || code==7) ? 1 : 0;
	ST   -Y,R26
	ST   -Y,R17
;	c1 -> Y+3
;	c2 -> Y+2
;	c3 -> Y+1
;	code -> R17
	LDD  R30,Y+3
	LSL  R30
	LSL  R30
	MOV  R26,R30
	LDD  R30,Y+2
	LSL  R30
	OR   R30,R26
	LDD  R26,Y+1
	OR   R30,R26
	MOV  R17,R30
	CPI  R17,2
	BREQ _0x48
	CPI  R17,1
	BREQ _0x48
	CPI  R17,5
	BREQ _0x48
	CPI  R17,7
	BRNE _0x4A
_0x48:
	LDI  R30,LOW(1)
	RJMP _0x4B
_0x4A:
	LDI  R30,LOW(0)
_0x4B:
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 0117 }
; .FEND
;
;
;/* --- Re-select helper --- */
;static uint8_t rc522_reselect(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
; 0000 011B static uint8_t rc522_reselect(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
_rc522_reselect_G000:
; .FSTART _rc522_reselect_G000
; 0000 011C     uint8_t atqa[2];
; 0000 011D     picc_halt();
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
;	*uid -> Y+5
;	uid_len -> Y+4
;	*sak -> Y+2
;	atqa -> Y+0
	RCALL _picc_halt_G000
; 0000 011E     delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 011F     rc522_request(PICC_REQIDL, atqa);
	LDI  R30,LOW(38)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,1
	RCALL _rc522_request_G000
; 0000 0120     return rc522_select(uid, uid_len, sak);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RCALL _rc522_select_G000
_0x20A0005:
	ADIW R28,7
	RET
; 0000 0121 }
; .FEND
;
;void main(void){
; 0000 0123 void main(void){
_main:
; .FSTART _main
; 0000 0124     char line[21];
; 0000 0125     uint8_t atqa[2];
; 0000 0126     uint8_t uid[10];
; 0000 0127     uint8_t uid_len;
; 0000 0128     uint8_t sak;
; 0000 0129     uint8_t uid4[4];
; 0000 012A     uint8_t blk4[16];
; 0000 012B     uint8_t trailer[16];
; 0000 012C     uint8_t c1,c2,c3;
; 0000 012D     uint8_t is_ro;
; 0000 012E     uint8_t i;
; 0000 012F     flash char* type_str;
; 0000 0130 
; 0000 0131     /* Minimal MCU/SPI setup */
; 0000 0132     DDRA=0x00; PORTA=0x00;
	SBIW R28,63
	SBIW R28,9
;	line -> Y+51
;	atqa -> Y+49
;	uid -> Y+39
;	uid_len -> R17
;	sak -> R16
;	uid4 -> Y+35
;	blk4 -> Y+19
;	trailer -> Y+3
;	c1 -> R19
;	c2 -> R18
;	c3 -> R21
;	is_ro -> R20
;	i -> Y+2
;	*type_str -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
; 0000 0133     DDRB=(1<<DDB7)|(1<<DDB5)|(1<<DDB4); PORTB=0x00;
	LDI  R30,LOW(176)
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0134     DDRC=0x00; PORTC=0x00;
	OUT  0x14,R30
	OUT  0x15,R30
; 0000 0135     DDRD=0x00; PORTD=0x00;
	OUT  0x11,R30
	OUT  0x12,R30
; 0000 0136     TCCR0=0; TCCR1A=0; TCCR1B=0; TCCR2=0; TIMSK=0;
	OUT  0x33,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x25,R30
	OUT  0x39,R30
; 0000 0137     MCUCR=0; MCUCSR=0;
	OUT  0x35,R30
	OUT  0x34,R30
; 0000 0138     UCSRB=0;
	OUT  0xA,R30
; 0000 0139     ACSR=(1<<ACD); SFIOR=0;
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 013A     ADCSRA=0;
	OUT  0x6,R30
; 0000 013B     SPCR=(1<<SPE)|(1<<MSTR)|(1<<SPR1); SPSR=0;
	LDI  R30,LOW(82)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 013C 
; 0000 013D     RC522_CS_DDR |= (1<<RC522_CS_PIN);
	SBI  0x17,4
; 0000 013E     RC522_CS_PORT |= (1<<RC522_CS_PIN);
	SBI  0x18,4
; 0000 013F 
; 0000 0140     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0141     lcd_clear(); lcd_putsf("RC522 Ready");
	CALL _lcd_clear
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0142     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0143 
; 0000 0144     rc522_init();
	RCALL _rc522_init_G000
; 0000 0145 
; 0000 0146     while(1){
_0x4D:
; 0000 0147         lcd_clear(); lcd_putsf("Scan a card...");
	CALL _lcd_clear
	__POINTW2FN _0x0,12
	CALL _lcd_putsf
; 0000 0148         delay_ms(120);
	LDI  R26,LOW(120)
	LDI  R27,0
	CALL _delay_ms
; 0000 0149 
; 0000 014A         if(!rc522_request(PICC_REQIDL, atqa)) { delay_ms(120); continue; }
	LDI  R30,LOW(38)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,50
	RCALL _rc522_request_G000
	CPI  R30,0
	BRNE _0x50
	LDI  R26,LOW(120)
	LDI  R27,0
	CALL _delay_ms
	RJMP _0x4D
; 0000 014B 
; 0000 014C         uid_len = rc522_get_uid(uid);
_0x50:
	MOVW R26,R28
	ADIW R26,39
	RCALL _rc522_get_uid_G000
	MOV  R17,R30
; 0000 014D         if(!uid_len || !rc522_select(uid, uid_len, &sak)){
	CPI  R17,0
	BREQ _0x52
	MOVW R30,R28
	ADIW R30,39
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _rc522_select_G000
	POP  R16
	CPI  R30,0
	BRNE _0x51
_0x52:
; 0000 014E             lcd_clear(); lcd_putsf("Select failed");
	RCALL _lcd_clear
	__POINTW2FN _0x0,27
	CALL _lcd_putsf
; 0000 014F             delay_ms(600);
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	CALL _delay_ms
; 0000 0150             continue;
	RJMP _0x4D
; 0000 0151         }
; 0000 0152 
; 0000 0153         type_str = type_from_sak(sak);
_0x51:
	MOV  R26,R16
	RCALL _type_from_sak_G000
	ST   Y,R30
	STD  Y+1,R31
; 0000 0154 
; 0000 0155         lcd_clear();
	RCALL _lcd_clear
; 0000 0156         lcd_gotoxy(0,0); lcd_puts_flash(type_str);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _lcd_puts_flash_G000
; 0000 0157         sprintf(line,"SAK:%02X", sak);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CALL SUBOPT_0x10
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0158         lcd_gotoxy(0,1); lcd_puts(line);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0000 0159         delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 015A 
; 0000 015B         lcd_clear();
	RCALL _lcd_clear
; 0000 015C         if(uid_len==4){
	CPI  R17,4
	BRNE _0x54
; 0000 015D             sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x13
	LDD  R30,Y+48
	CALL SUBOPT_0x10
	LDD  R30,Y+53
	CALL SUBOPT_0x10
	LDD  R30,Y+58
	CALL SUBOPT_0x10
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 015E             lcd_gotoxy(0,0); lcd_puts(line);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x69
; 0000 015F         }else{
_0x54:
; 0000 0160             sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x13
	LDD  R30,Y+48
	CALL SUBOPT_0x10
	LDD  R30,Y+53
	CALL SUBOPT_0x10
	LDD  R30,Y+58
	CALL SUBOPT_0x10
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 0161             lcd_gotoxy(0,0); lcd_puts(line);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
; 0000 0162             sprintf(line,"%02X%02X%02X", uid[4],uid[5],uid[6]);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,58
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+47
	CALL SUBOPT_0x10
	LDD  R30,Y+52
	CALL SUBOPT_0x10
	LDD  R30,Y+57
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
; 0000 0163             lcd_gotoxy(0,1); lcd_puts(line);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x69:
	RCALL _lcd_gotoxy
	CALL SUBOPT_0x12
; 0000 0164         }
; 0000 0165         delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL _delay_ms
; 0000 0166 
; 0000 0167         /* Classic path: sector 1: block 4 (data) and block 7 (trailer) */
; 0000 0168         if((sak&0xFC)==0x08 || (sak&0xFC)==0x18){
	MOV  R30,R16
	ANDI R30,LOW(0xFC)
	CPI  R30,LOW(0x8)
	BREQ _0x57
	MOV  R30,R16
	ANDI R30,LOW(0xFC)
	CPI  R30,LOW(0x18)
	BREQ _0x57
	RJMP _0x56
_0x57:
; 0000 0169             if(uid_len==7){ uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6]; }
	CPI  R17,7
	BRNE _0x59
	LDD  R30,Y+42
	STD  Y+35,R30
	LDD  R30,Y+43
	STD  Y+36,R30
	LDD  R30,Y+44
	STD  Y+37,R30
	LDD  R30,Y+45
	RJMP _0x6A
; 0000 016A             else          { uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3]; }
_0x59:
	LDD  R30,Y+39
	STD  Y+35,R30
	LDD  R30,Y+40
	STD  Y+36,R30
	LDD  R30,Y+41
	STD  Y+37,R30
	LDD  R30,Y+42
_0x6A:
	STD  Y+38,R30
; 0000 016B 
; 0000 016C             /* Auth A for block 4 */
; 0000 016D             if(!mifare_auth(MF_AUTH_KEY_A,4,uid4,DEF_KEY_A)){
	LDI  R30,LOW(96)
	ST   -Y,R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x15
	BRNE _0x5B
; 0000 016E                 lcd_clear(); lcd_putsf("Auth-Read FAIL");
	RCALL _lcd_clear
	__POINTW2FN _0x0,71
	CALL SUBOPT_0x16
; 0000 016F                 delay_ms(800);
; 0000 0170                 mifare_stop_crypto();
; 0000 0171                 continue;
	RJMP _0x4D
; 0000 0172             }
; 0000 0173             if(!mifare_read_block(4, blk4)){
_0x5B:
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,20
	RCALL _mifare_read_block_G000
	CPI  R30,0
	BRNE _0x5C
; 0000 0174                 lcd_clear(); lcd_putsf("Read Error");
	RCALL _lcd_clear
	__POINTW2FN _0x0,86
	CALL SUBOPT_0x16
; 0000 0175                 delay_ms(800);
; 0000 0176                 mifare_stop_crypto();
; 0000 0177                 continue;
	RJMP _0x4D
; 0000 0178             }
; 0000 0179             mifare_stop_crypto();
_0x5C:
	RCALL _mifare_stop_crypto_G000
; 0000 017A 
; 0000 017B             lcd_clear(); lcd_putsf("B4:");
	RCALL _lcd_clear
	__POINTW2FN _0x0,97
	RCALL _lcd_putsf
; 0000 017C             lcd_gotoxy(0,1);
	CALL SUBOPT_0x11
; 0000 017D             for(i=0;i<8;i++){
	LDI  R30,LOW(0)
	STD  Y+2,R30
_0x5E:
	LDD  R26,Y+2
	CPI  R26,LOW(0x8)
	BRSH _0x5F
; 0000 017E                 sprintf(line,"%02X", blk4[i]);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,23
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CALL SUBOPT_0x10
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 017F                 lcd_puts(line);
	CALL SUBOPT_0x12
; 0000 0180             }
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	RJMP _0x5E
_0x5F:
; 0000 0181             delay_ms(1100);
	LDI  R26,LOW(1100)
	LDI  R27,HIGH(1100)
	CALL _delay_ms
; 0000 0182 
; 0000 0183             /* Re-select before trailer auth to avoid state issues */
; 0000 0184             if(!rc522_reselect(uid, uid_len, &sak)){
	MOVW R30,R28
	ADIW R30,39
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _rc522_reselect_G000
	POP  R16
	CPI  R30,0
	BRNE _0x60
; 0000 0185                 lcd_clear(); lcd_putsf("Re-select Fail");
	RCALL _lcd_clear
	__POINTW2FN _0x0,101
	RCALL _lcd_putsf
; 0000 0186                 delay_ms(700);
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	CALL _delay_ms
; 0000 0187                 continue;
	RJMP _0x4D
; 0000 0188             }
; 0000 0189 
; 0000 018A             /* Try Trailer auth: first Key A, then Key B */
; 0000 018B             if(!mifare_auth(MF_AUTH_KEY_A,7,uid4,DEF_KEY_A)){
_0x60:
	LDI  R30,LOW(96)
	ST   -Y,R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x15
	BRNE _0x61
; 0000 018C                 if(!mifare_auth(MF_AUTH_KEY_B,7,uid4,DEF_KEY_B)){
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,37
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_DEF_KEY_B_G000)
	LDI  R27,HIGH(_DEF_KEY_B_G000)
	RCALL _mifare_auth_G000
	CPI  R30,0
	BRNE _0x62
; 0000 018D                     lcd_clear(); lcd_putsf("Auth Trailer Fail");
	RCALL _lcd_clear
	__POINTW2FN _0x0,116
	RCALL _lcd_putsf
; 0000 018E                     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 018F                     mifare_stop_crypto();
	RCALL _mifare_stop_crypto_G000
; 0000 0190                     continue;
	RJMP _0x4D
; 0000 0191                 }
; 0000 0192             }
_0x62:
; 0000 0193 
; 0000 0194             if(!mifare_read_block(7, trailer)){
_0x61:
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL _mifare_read_block_G000
	CPI  R30,0
	BRNE _0x63
; 0000 0195                 lcd_clear(); lcd_putsf("Trailer ReadErr");
	RCALL _lcd_clear
	__POINTW2FN _0x0,134
	RCALL _lcd_putsf
; 0000 0196                 delay_ms(900);
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	CALL _delay_ms
; 0000 0197                 mifare_stop_crypto();
	RCALL _mifare_stop_crypto_G000
; 0000 0198                 continue;
	RJMP _0x4D
; 0000 0199             }
; 0000 019A             mifare_stop_crypto();
_0x63:
	RCALL _mifare_stop_crypto_G000
; 0000 019B 
; 0000 019C             get_c_bits_for_block(trailer, 0, &c1, &c2, &c3);
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R19
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R18
	IN   R26,SPL
	IN   R27,SPH
	PUSH R21
	RCALL _get_c_bits_for_block_G000
	POP  R21
	POP  R18
	POP  R19
; 0000 019D             is_ro = data_block_is_readonly(c1,c2,c3);
	ST   -Y,R19
	ST   -Y,R18
	MOV  R26,R21
	RCALL _data_block_is_readonly_G000
	MOV  R20,R30
; 0000 019E 
; 0000 019F             lcd_clear();
	RCALL _lcd_clear
; 0000 01A0             lcd_putsf("RO:");
	__POINTW2FN _0x0,150
	RCALL _lcd_putsf
; 0000 01A1             if(is_ro) lcd_putsf("YES ");
	CPI  R20,0
	BREQ _0x64
	__POINTW2FN _0x0,154
	RJMP _0x6B
; 0000 01A2             else      lcd_putsf("NO  ");
_0x64:
	__POINTW2FN _0x0,159
_0x6B:
	RCALL _lcd_putsf
; 0000 01A3             sprintf(line,"C:%d%d%d", c1,c2,c3);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,164
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	CALL SUBOPT_0x10
	MOV  R30,R18
	CALL SUBOPT_0x10
	MOV  R30,R21
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
; 0000 01A4             lcd_gotoxy(8,0); lcd_puts(line);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
; 0000 01A5             lcd_gotoxy(0,1);
	CALL SUBOPT_0x11
; 0000 01A6             sprintf(line,"ACC:%02X%02X%02X", trailer[6],trailer[7],trailer[8]);
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,173
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+13
	CALL SUBOPT_0x10
	LDD  R30,Y+18
	CALL SUBOPT_0x10
	LDD  R30,Y+23
	CALL SUBOPT_0x10
	CALL SUBOPT_0x14
; 0000 01A7             lcd_puts(line);
	CALL SUBOPT_0x12
; 0000 01A8             delay_ms(1400);
	LDI  R26,LOW(1400)
	LDI  R27,HIGH(1400)
	RJMP _0x6C
; 0000 01A9         } else {
_0x56:
; 0000 01AA             lcd_clear(); lcd_putsf("RO:N/A (Type2)");
	RCALL _lcd_clear
	__POINTW2FN _0x0,190
	RCALL _lcd_putsf
; 0000 01AB             delay_ms(800);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
_0x6C:
	CALL _delay_ms
; 0000 01AC         }
; 0000 01AD     }
	RJMP _0x4D
; 0000 01AE }
_0x67:
	RJMP _0x67
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
	RJMP _0x20A0002
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
	RJMP _0x20A0002
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
	CALL SUBOPT_0x17
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x17
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
	RJMP _0x20A0002
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x20A0003
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	CALL SUBOPT_0xD
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20A0003:
	LDD  R17,Y+0
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
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
	CALL SUBOPT_0x18
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
	RJMP _0x20A0002
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
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
_0x20A0002:
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
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x19
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x19
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x1A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1B
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x19
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1B
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_DEF_KEY_A_G000:
	.BYTE 0x6
_DEF_KEY_B_G000:
	.BYTE 0x6
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+2
	JMP  _rc522_read_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _rc522_write_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(128)
	JMP  _set_bit_mask_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	JMP  _rc522_write_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,9
	CALL _rc522_calc_crc_G000
	LDD  R30,Y+6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,5
	CALL _rc522_anticoll_level_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDD  R30,Y+5
	LDD  R26,Y+4
	EOR  R30,R26
	LDD  R26,Y+6
	EOR  R30,R26
	LDD  R26,Y+7
	EOR  R30,R26
	MOV  R17,R30
	LDD  R30,Y+8
	CP   R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	STD  Y+4,R30
	LDI  R30,LOW(147)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	MOVW R30,R28
	ADIW R30,51
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x10:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	MOVW R26,R28
	ADIW R26,51
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__POINTW1FN _0x0,50
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+43
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,37
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_DEF_KEY_A_G000)
	LDI  R27,HIGH(_DEF_KEY_A_G000)
	CALL _mifare_auth_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL _lcd_putsf
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	CALL _delay_ms
	JMP  _mifare_stop_crypto_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
