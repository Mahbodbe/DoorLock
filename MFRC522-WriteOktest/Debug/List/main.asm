
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
_0x5F:
	.DB  0x57,0x52,0x49,0x54,0x45,0x5F,0x54,0x45
	.DB  0x53,0x54,0x5F,0x31,0x32,0x33,0x34,0x21
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x4
_0x0:
	.DB  0x25,0x30,0x32,0x58,0x0,0x52,0x43,0x35
	.DB  0x32,0x32,0x20,0x52,0x65,0x61,0x64,0x79
	.DB  0x0,0x53,0x63,0x61,0x6E,0x20,0x61,0x20
	.DB  0x63,0x61,0x72,0x64,0x2E,0x2E,0x2E,0x0
	.DB  0x53,0x65,0x6C,0x65,0x63,0x74,0x20,0x66
	.DB  0x61,0x69,0x6C,0x65,0x64,0x0,0x53,0x41
	.DB  0x4B,0x3A,0x25,0x30,0x32,0x58,0x0,0x55
	.DB  0x49,0x44,0x3A,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x32,0x58,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x32,0x58,0x0,0x4F,0x6E,0x6C,0x79
	.DB  0x20,0x43,0x6C,0x61,0x73,0x73,0x69,0x63
	.DB  0x20,0x52,0x57,0x0,0x41,0x75,0x74,0x68
	.DB  0x20,0x42,0x34,0x2E,0x2E,0x2E,0x0,0x41
	.DB  0x75,0x74,0x68,0x20,0x46,0x41,0x49,0x4C
	.DB  0x0,0x52,0x65,0x61,0x64,0x20,0x45,0x72
	.DB  0x72,0x0,0x57,0x72,0x69,0x74,0x65,0x2B
	.DB  0x52,0x65,0x61,0x64,0x2E,0x2E,0x2E,0x0
	.DB  0x57,0x72,0x69,0x74,0x65,0x20,0x46,0x41
	.DB  0x49,0x4C,0x0,0x52,0x65,0x2D,0x72,0x65
	.DB  0x61,0x64,0x20,0x46,0x41,0x49,0x4C,0x0
	.DB  0x4D,0x41,0x54,0x43,0x48,0x20,0x48,0x45
	.DB  0x58,0x3A,0x0,0x4D,0x49,0x53,0x4D,0x41
	.DB  0x54,0x43,0x48,0x20,0x48,0x45,0x58,0x3A
	.DB  0x0,0x41,0x53,0x43,0x49,0x49,0x3A,0x0
	.DB  0x48,0x45,0x58,0x5B,0x38,0x2E,0x2E,0x31
	.DB  0x35,0x5D,0x3A,0x0,0x41,0x53,0x43,0x49
	.DB  0x49,0x5B,0x38,0x2E,0x2E,0x5D,0x3A,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _keyA_G000
	.DW  _0x3*2

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
;#define TModeReg         0x2A
;#define TPrescalerReg    0x2B
;#define TReloadRegH      0x2C
;#define TReloadRegL      0x2D
;#define CRCResultRegH    0x21
;#define CRCResultRegL    0x22
;#define CollReg          0x0E
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
;/* --- Classic/Type2 cmds we use here (Classic only in this sketch) --- */
;#define MF_AUTH_KEY_A    0x60
;#define MF_READ          0x30
;#define MF_WRITE         0xA0
;
;/* --- Strings in flash --- */
;static flash char S_C1K[]="MIFARE Classic 1K";
;static flash char S_C4K[]="MIFARE Classic 4K";
;static flash char S_UL []="Ultralight/NTAG";
;static flash char S_UNK[]="Unknown/other";
;
;/* --- Default Key A --- */
;static uint8_t keyA[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

	.DSEG
;
;/* ===== SPI chip-select ===== */
;static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_PIN); }
; 0000 0041 static void cs_low(void){  PORTB &= ~(1<<4       ); }

	.CSEG
_cs_low_G000:
; .FSTART _cs_low_G000
	CBI  0x18,4
	RET
; .FEND
;static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_PIN); }
; 0000 0042 static void cs_high(void){ PORTB |=  (1<<4       ); }
_cs_high_G000:
; .FSTART _cs_high_G000
	SBI  0x18,4
	RET
; .FEND
;
;/* ===== RC522 R/W ===== */
;static void rc522_write(uint8_t reg, uint8_t val){
; 0000 0045 static void rc522_write(uint8_t reg, uint8_t val){
_rc522_write_G000:
; .FSTART _rc522_write_G000
; 0000 0046     cs_low(); spi((reg<<1)&0x7E); spi(val); cs_high();
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
; 0000 0047 }
	JMP  _0x20A0005
; .FEND
;static uint8_t rc522_read(uint8_t reg){
; 0000 0048 static uint8_t rc522_read(uint8_t reg){
_rc522_read_G000:
; .FSTART _rc522_read_G000
; 0000 0049     uint8_t v;
; 0000 004A     cs_low(); spi(((reg<<1)&0x7E)|0x80); v=spi(0x00); cs_high();
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
; 0000 004B     return v;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 004C }
; .FEND
;static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
; 0000 004D static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
_set_bit_mask_G000:
; .FSTART _set_bit_mask_G000
	CALL SUBOPT_0x0
;	reg -> Y+1
;	mask -> Y+0
	LDD  R26,Y+1
	OR   R30,R26
	MOV  R26,R30
	RCALL _rc522_write_G000
	JMP  _0x20A0005
; .FEND
;static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
; 0000 004E static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }
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
	JMP  _0x20A0005
; .FEND
;
;/* ===== Init ===== */
;static void rc522_soft_reset(void){ rc522_write(CommandReg,PCD_SoftReset); delay_ms(50); }
; 0000 0051 static void rc522_soft_reset(void){ rc522_write(0x01,0x0F); delay_ms(50); }
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
; 0000 0052 static void rc522_antenna_on(void){ if(!(rc522_read(0x14)&0x03)) set_bit_mask(0x14,0x03); }
_rc522_antenna_on_G000:
; .FSTART _rc522_antenna_on_G000
	LDI  R26,LOW(20)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x3)
	BRNE _0x4
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _set_bit_mask_G000
_0x4:
	RET
; .FEND
;static void rc522_init(void){
; 0000 0053 static void rc522_init(void){
_rc522_init_G000:
; .FSTART _rc522_init_G000
; 0000 0054     rc522_soft_reset();
	RCALL _rc522_soft_reset_G000
; 0000 0055     rc522_write(TModeReg,      0x8D);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _rc522_write_G000
; 0000 0056     rc522_write(TPrescalerReg, 0x3E);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _rc522_write_G000
; 0000 0057     rc522_write(TReloadRegL,   30);
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _rc522_write_G000
; 0000 0058     rc522_write(TReloadRegH,   0);
	LDI  R30,LOW(44)
	CALL SUBOPT_0x1
; 0000 0059     rc522_write(TxASKReg,      0x40);
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _rc522_write_G000
; 0000 005A     rc522_write(ModeReg,       0x3D);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _rc522_write_G000
; 0000 005B     rc522_antenna_on();
	RCALL _rc522_antenna_on_G000
; 0000 005C }
	RET
; .FEND
;
;/* ===== CRC_A ===== */
;static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
; 0000 005F static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
_rc522_calc_crc_G000:
; .FSTART _rc522_calc_crc_G000
; 0000 0060     uint8_t i;
; 0000 0061     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x2
;	*data -> Y+4
;	len -> Y+3
;	*crc2 -> Y+1
;	i -> R17
; 0000 0062     set_bit_mask(FIFOLevelReg, 0x80);
	CALL SUBOPT_0x3
; 0000 0063     for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
	LDI  R17,LOW(0)
_0x6:
	LDD  R30,Y+3
	CP   R17,R30
	BRSH _0x7
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0x6
_0x7:
; 0000 0064 rc522_write(0x01, 0x03);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _rc522_write_G000
; 0000 0065     for(i=0;i<255;i++){ if(rc522_read(DivIrqReg) & 0x04) break; }
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,255
	BRSH _0xA
	LDI  R26,LOW(5)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x4)
	BRNE _0xA
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 0066     crc2[0]=rc522_read(CRCResultRegL);
	LDI  R26,LOW(34)
	RCALL _rc522_read_G000
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
; 0000 0067     crc2[1]=rc522_read(CRCResultRegH);
	LDI  R26,LOW(33)
	RCALL _rc522_read_G000
	__PUTB1SNS 1,1
; 0000 0068 }
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
;
;/* ===== Transceive ===== */
;static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
; 0000 006B static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
_rc522_transceive_G000:
; .FSTART _rc522_transceive_G000
; 0000 006C     uint8_t i, n, lastBits;
; 0000 006D     rc522_write(ComIEnReg, 0x77 | 0x80);
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
; 0000 006E     clr_bit_mask(ComIrqReg, 0x80);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask_G000
; 0000 006F     set_bit_mask(FIFOLevelReg, 0x80);
	CALL SUBOPT_0x3
; 0000 0070     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 0071     for(i=0;i<sendLen;i++) rc522_write(FIFODataReg, send[i]);
	LDI  R17,LOW(0)
_0xD:
	LDD  R30,Y+8
	CP   R17,R30
	BRSH _0xE
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0xD
_0xE:
; 0000 0072 rc522_write(0x01, 0x0C);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(12)
	RCALL _rc522_write_G000
; 0000 0073     set_bit_mask(BitFramingReg, 0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _set_bit_mask_G000
; 0000 0074     i=200;
	LDI  R17,LOW(200)
; 0000 0075     do{ n=rc522_read(ComIrqReg); }while(--i && !(n&0x30));
_0x10:
	LDI  R26,LOW(4)
	RCALL _rc522_read_G000
	MOV  R16,R30
	SUBI R17,LOW(1)
	BREQ _0x12
	ANDI R30,LOW(0x30)
	BREQ _0x13
_0x12:
	RJMP _0x11
_0x13:
	RJMP _0x10
_0x11:
; 0000 0076     clr_bit_mask(BitFramingReg,0x80);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _clr_bit_mask_G000
; 0000 0077     if(!i) return 0;
	CPI  R17,0
	BRNE _0x14
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 0078     if(rc522_read(ErrorReg)&0x1B) return 0;
_0x14:
	LDI  R26,LOW(6)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x1B)
	BREQ _0x15
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 0079     n = rc522_read(FIFOLevelReg);
_0x15:
	LDI  R26,LOW(10)
	RCALL _rc522_read_G000
	MOV  R16,R30
; 0000 007A     lastBits = rc522_read(ControlReg) & 0x07;
	LDI  R26,LOW(12)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x7)
	MOV  R19,R30
; 0000 007B     if(backBits){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x16
; 0000 007C         if(lastBits) *backBits = (n-1)*8 + lastBits;
	CPI  R19,0
	BREQ _0x17
	MOV  R30,R16
	SUBI R30,LOW(1)
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R30,R19
	RJMP _0x78
; 0000 007D         else         *backBits = n*8;
_0x17:
	MOV  R30,R16
	LSL  R30
	LSL  R30
	LSL  R30
_0x78:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 007E     }
; 0000 007F     for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
_0x16:
	LDI  R17,LOW(0)
_0x1A:
	CP   R17,R16
	BRSH _0x1B
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
	RJMP _0x1A
_0x1B:
; 0000 0080 return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000C
; 0000 0081 }
; .FEND
;
;/* ===== REQA / Anticoll / Select ===== */
;static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
; 0000 0084 static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
_rc522_request_G000:
; .FSTART _rc522_request_G000
; 0000 0085     uint8_t cmd, back[4], bits;
; 0000 0086     cmd=reqMode; bits=0;
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
; 0000 0087     rc522_write(BitFramingReg,0x07);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _rc522_write_G000
; 0000 0088     if(!rc522_transceive(&cmd,1,back,&bits)) return 0;
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
	BRNE _0x1C
	LDI  R30,LOW(0)
	RJMP _0x20A000E
; 0000 0089     rc522_write(BitFramingReg,0x00);
_0x1C:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 008A     if(bits!=16) return 0;
	CPI  R16,16
	BREQ _0x1D
	LDI  R30,LOW(0)
	RJMP _0x20A000E
; 0000 008B     ATQA[0]=back[0]; ATQA[1]=back[1];
_0x1D:
	LDD  R30,Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	LDD  R30,Y+3
	__PUTB1SNS 6,1
; 0000 008C     return 1;
	LDI  R30,LOW(1)
_0x20A000E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
; 0000 008D }
; .FEND
;static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
; 0000 008E static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
_rc522_anticoll_level_G000:
; .FSTART _rc522_anticoll_level_G000
; 0000 008F     uint8_t cmd[2], back[10], bits, i;
; 0000 0090     bits=0;
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
; 0000 0091     cmd[0]=level_cmd; cmd[1]=0x20;
	LDD  R30,Y+16
	STD  Y+12,R30
	LDI  R30,LOW(32)
	STD  Y+13,R30
; 0000 0092     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 0093     rc522_write(CollReg,0x80);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _rc522_write_G000
; 0000 0094     if(!rc522_transceive(cmd,2,back,&bits)) return 0;
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
	BRNE _0x1E
	LDI  R30,LOW(0)
	RJMP _0x20A000D
; 0000 0095     if(bits!=40) return 0;
_0x1E:
	CPI  R17,40
	BREQ _0x1F
	LDI  R30,LOW(0)
	RJMP _0x20A000D
; 0000 0096     for(i=0;i<5;i++) out5[i]=back[i];
_0x1F:
	LDI  R16,LOW(0)
_0x21:
	CPI  R16,5
	BRSH _0x22
	MOV  R30,R16
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	SUBI R16,-1
	RJMP _0x21
_0x22:
; 0000 0097 return 1;
	LDI  R30,LOW(1)
_0x20A000D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,17
	RET
; 0000 0098 }
; .FEND
;static uint8_t rc522_get_uid(uint8_t *uid){
; 0000 0099 static uint8_t rc522_get_uid(uint8_t *uid){
_rc522_get_uid_G000:
; .FSTART _rc522_get_uid_G000
; 0000 009A     uint8_t b[5], bcc, i, len;
; 0000 009B     len=0;
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
; 0000 009C     if(!rc522_anticoll_level(PICC_ANTICOLL_CL1,b)) return 0;
	LDI  R30,LOW(147)
	CALL SUBOPT_0x8
	BRNE _0x23
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 009D     if(b[0]==0x88){
_0x23:
	LDD  R26,Y+4
	CPI  R26,LOW(0x88)
	BRNE _0x24
; 0000 009E         uid[0]=b[1]; uid[1]=b[2]; uid[2]=b[3];
	LDD  R30,Y+5
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R30,Y+6
	__PUTB1SNS 9,1
	LDD  R30,Y+7
	__PUTB1SNS 9,2
; 0000 009F         if(!rc522_anticoll_level(PICC_ANTICOLL_CL2,b)) return 0;
	LDI  R30,LOW(149)
	CALL SUBOPT_0x8
	BRNE _0x25
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 00A0         bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
_0x25:
	CALL SUBOPT_0x9
	BREQ _0x26
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 00A1         uid[3]=b[0]; uid[4]=b[1]; uid[5]=b[2]; uid[6]=b[3];
_0x26:
	LDD  R30,Y+4
	__PUTB1SNS 9,3
	LDD  R30,Y+5
	__PUTB1SNS 9,4
	LDD  R30,Y+6
	__PUTB1SNS 9,5
	LDD  R30,Y+7
	__PUTB1SNS 9,6
; 0000 00A2         len=7;
	LDI  R19,LOW(7)
; 0000 00A3     }else{
	RJMP _0x27
_0x24:
; 0000 00A4         bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
	CALL SUBOPT_0x9
	BREQ _0x28
	LDI  R30,LOW(0)
	RJMP _0x20A000C
; 0000 00A5         for(i=0;i<4;i++) uid[i]=b[i];
_0x28:
	LDI  R16,LOW(0)
_0x2A:
	CPI  R16,4
	BRSH _0x2B
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
	RJMP _0x2A
_0x2B:
; 0000 00A6 len=4;
	LDI  R19,LOW(4)
; 0000 00A7     }
_0x27:
; 0000 00A8     return len;
	MOV  R30,R19
_0x20A000C:
	CALL __LOADLOCR4
	ADIW R28,11
	RET
; 0000 00A9 }
; .FEND
;static uint8_t uid_bcc4(uint8_t *u4){ return (uint8_t)(u4[0]^u4[1]^u4[2]^u4[3]); }
; 0000 00AA static uint8_t uid_bcc4(uint8_t *u4){ return (uint8_t)(u4[0]^u4[1]^u4[2]^u4[3]); }
_uid_bcc4_G000:
; .FSTART _uid_bcc4_G000
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
	JMP  _0x20A0005
; .FEND
;static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t *sak_out){
; 0000 00AB static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t *sak_out){
_rc522_select_level_G000:
; .FSTART _rc522_select_level_G000
; 0000 00AC     uint8_t f[9], crc[2], back[4], bits, bcc;
; 0000 00AD     bits=0;
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
; 0000 00AE     rc522_write(BitFramingReg,0x00);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1
; 0000 00AF     bcc=uid_bcc4(uid4);
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _uid_bcc4_G000
	MOV  R16,R30
; 0000 00B0     f[0]=level_cmd; f[1]=0x70;
	LDD  R30,Y+21
	STD  Y+8,R30
	LDI  R30,LOW(112)
	STD  Y+9,R30
; 0000 00B1     f[2]=uid4[0];   f[3]=uid4[1]; f[4]=uid4[2]; f[5]=uid4[3];
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
; 0000 00B2     f[6]=bcc; rc522_calc_crc(f,7,crc); f[7]=crc[0]; f[8]=crc[1];
	MOVW R30,R28
	ADIW R30,14
	ST   Z,R16
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,9
	RCALL _rc522_calc_crc_G000
	LDD  R30,Y+6
	STD  Y+15,R30
	LDD  R30,Y+7
	STD  Y+16,R30
; 0000 00B3     if(!rc522_transceive(f,9,back,&bits)) return 0;
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	CALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0000 00B4     if(bits!=24) return 0;
_0x2C:
	CPI  R17,24
	BREQ _0x2D
	LDI  R30,LOW(0)
	RJMP _0x20A000B
; 0000 00B5     *sak_out=back[0]; return 1;
_0x2D:
	LDD  R30,Y+2
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ST   X,R30
	LDI  R30,LOW(1)
_0x20A000B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; 0000 00B6 }
; .FEND
;static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
; 0000 00B7 static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
_rc522_select_G000:
; .FSTART _rc522_select_G000
; 0000 00B8     uint8_t uid4[4], tmp;
; 0000 00B9     if(uid_len==4){
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
	BRNE _0x2E
; 0000 00BA         uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
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
	CALL SUBOPT_0xA
; 0000 00BB         return rc522_select_level(PICC_SELECT_CL1, uid4, sak);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _rc522_select_level_G000
	RJMP _0x20A0009
; 0000 00BC     }else if(uid_len==7){
_0x2E:
	LDD  R26,Y+7
	CPI  R26,LOW(0x7)
	BRNE _0x30
; 0000 00BD         uid4[0]=0x88; uid4[1]=uid[0]; uid4[2]=uid[1]; uid4[3]=uid[2];
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
	CALL SUBOPT_0xA
; 0000 00BE         if(!rc522_select_level(PICC_SELECT_CL1, uid4, &tmp)) return 0;
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_select_level_G000
	POP  R17
	CPI  R30,0
	BREQ _0x20A000A
; 0000 00BF         uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6];
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
; 0000 00C0         return rc522_select_level(PICC_SELECT_CL2, uid4, sak);
	LDI  R30,LOW(149)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _rc522_select_level_G000
	RJMP _0x20A0009
; 0000 00C1     }
; 0000 00C2     return 0;
_0x30:
_0x20A000A:
	LDI  R30,LOW(0)
_0x20A0009:
	LDD  R17,Y+0
	ADIW R28,10
	RET
; 0000 00C3 }
; .FEND
;
;/* ===== Type detection ===== */
;static void lcd_puts_flash(flash char* s){ char c; while((c=*s++)) lcd_putchar(c); }
; 0000 00C6 static void lcd_puts_flash(flash char* s){ char c; while((c=*s++)) lcd_putchar(c); }
_lcd_puts_flash_G000:
; .FSTART _lcd_puts_flash_G000
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*s -> Y+1
;	c -> R17
_0x32:
	CALL SUBOPT_0xB
	BREQ _0x34
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x32
_0x34:
	JMP  _0x20A0004
; .FEND
;static flash char* type_from_sak(uint8_t sak){
; 0000 00C7 static flash char* type_from_sak(uint8_t sak){
_type_from_sak_G000:
; .FSTART _type_from_sak_G000
; 0000 00C8     uint8_t s; s = sak & 0xFC;
	ST   -Y,R26
	ST   -Y,R17
;	sak -> Y+1
;	s -> R17
	LDD  R30,Y+1
	ANDI R30,LOW(0xFC)
	MOV  R17,R30
; 0000 00C9     if(s==0x08) return S_C1K;
	CPI  R17,8
	BRNE _0x35
	LDI  R30,LOW(_S_C1K_G000*2)
	LDI  R31,HIGH(_S_C1K_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 00CA     if(s==0x18) return S_C4K;
_0x35:
	CPI  R17,24
	BRNE _0x36
	LDI  R30,LOW(_S_C4K_G000*2)
	LDI  R31,HIGH(_S_C4K_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 00CB     if(s==0x00) return S_UL;
_0x36:
	CPI  R17,0
	BRNE _0x37
	LDI  R30,LOW(_S_UL_G000*2)
	LDI  R31,HIGH(_S_UL_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 00CC     return S_UNK;
_0x37:
	LDI  R30,LOW(_S_UNK_G000*2)
	LDI  R31,HIGH(_S_UNK_G000*2)
	LDD  R17,Y+0
	JMP  _0x20A0005
; 0000 00CD }
; .FEND
;
;/* ===== Classic auth/read/write ===== */
;static uint8_t mifare_auth_keyA(uint8_t blockAddr, uint8_t *uid4){
; 0000 00D0 static uint8_t mifare_auth_keyA(uint8_t blockAddr, uint8_t *uid4){
_mifare_auth_keyA_G000:
; .FSTART _mifare_auth_keyA_G000
; 0000 00D1     uint8_t i;
; 0000 00D2     rc522_write(CommandReg, PCD_Idle);
	CALL SUBOPT_0x2
;	blockAddr -> Y+3
;	*uid4 -> Y+1
;	i -> R17
; 0000 00D3     set_bit_mask(FIFOLevelReg,0x80);
	CALL SUBOPT_0x3
; 0000 00D4     rc522_write(FIFODataReg, MF_AUTH_KEY_A);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(96)
	RCALL _rc522_write_G000
; 0000 00D5     rc522_write(FIFODataReg, blockAddr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _rc522_write_G000
; 0000 00D6     for(i=0;i<6;i++) rc522_write(FIFODataReg, keyA[i]);
	LDI  R17,LOW(0)
_0x39:
	CPI  R17,6
	BRSH _0x3A
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_keyA_G000)
	SBCI R31,HIGH(-_keyA_G000)
	LD   R26,Z
	RCALL _rc522_write_G000
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 00D7 for(i=0;i<4;i++) rc522_write(0x09, uid4[i]);
	LDI  R17,LOW(0)
_0x3C:
	CPI  R17,4
	BRSH _0x3D
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x4
	SUBI R17,-1
	RJMP _0x3C
_0x3D:
; 0000 00D8 rc522_write(0x01, 0x0E);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(14)
	RCALL _rc522_write_G000
; 0000 00D9     for(i=0;i<200;i++){ if(rc522_read(Status2Reg) & 0x08) return 1; delay_ms(1); }
	LDI  R17,LOW(0)
_0x3F:
	CPI  R17,200
	BRSH _0x40
	LDI  R26,LOW(8)
	RCALL _rc522_read_G000
	ANDI R30,LOW(0x8)
	BREQ _0x41
	LDI  R30,LOW(1)
	RJMP _0x20A0008
_0x41:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	SUBI R17,-1
	RJMP _0x3F
_0x40:
; 0000 00DA     return 0;
	LDI  R30,LOW(0)
_0x20A0008:
	LDD  R17,Y+0
	ADIW R28,4
	RET
; 0000 00DB }
; .FEND
;static void mifare_stop_crypto(void){
; 0000 00DC static void mifare_stop_crypto(void){
_mifare_stop_crypto_G000:
; .FSTART _mifare_stop_crypto_G000
; 0000 00DD     clr_bit_mask(Status2Reg,0x08);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _clr_bit_mask_G000
; 0000 00DE     rc522_write(CommandReg, PCD_Idle);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1
; 0000 00DF }
	RET
; .FEND
;static uint8_t mifare_read_block(uint8_t blockAddr, uint8_t *out16){
; 0000 00E0 static uint8_t mifare_read_block(uint8_t blockAddr, uint8_t *out16){
_mifare_read_block_G000:
; .FSTART _mifare_read_block_G000
; 0000 00E1     uint8_t cmd[4], crc[2], back[32], bits, i;
; 0000 00E2     bits=0;
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
; 0000 00E3     cmd[0]=MF_READ; cmd[1]=blockAddr;
	LDI  R30,LOW(48)
	STD  Y+36,R30
	LDD  R30,Y+42
	STD  Y+37,R30
; 0000 00E4     rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,37
	RCALL _rc522_calc_crc_G000
	LDD  R30,Y+34
	STD  Y+38,R30
	LDD  R30,Y+35
	STD  Y+39,R30
; 0000 00E5     if(!rc522_transceive(cmd,4,back,&bits)) return 0;
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
	BRNE _0x42
	LDI  R30,LOW(0)
	RJMP _0x20A0007
; 0000 00E6     if(bits<16*8) return 0;
_0x42:
	CPI  R17,128
	BRSH _0x43
	LDI  R30,LOW(0)
	RJMP _0x20A0007
; 0000 00E7     for(i=0;i<16;i++) out16[i]=back[i];
_0x43:
	LDI  R16,LOW(0)
_0x45:
	CPI  R16,16
	BRSH _0x46
	MOV  R30,R16
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	SUBI R16,-1
	RJMP _0x45
_0x46:
; 0000 00E8 return 1;
	LDI  R30,LOW(1)
_0x20A0007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,43
	RET
; 0000 00E9 }
; .FEND
;static uint8_t mifare_write_block(uint8_t blockAddr, uint8_t *data16){
; 0000 00EA static uint8_t mifare_write_block(uint8_t blockAddr, uint8_t *data16){
_mifare_write_block_G000:
; .FSTART _mifare_write_block_G000
; 0000 00EB     uint8_t cmd[4], crc[2], ack[8], bits, frame[18], i;
; 0000 00EC     bits=0;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,32
	ST   -Y,R17
	ST   -Y,R16
;	blockAddr -> Y+36
;	*data16 -> Y+34
;	cmd -> Y+30
;	crc -> Y+28
;	ack -> Y+20
;	bits -> R17
;	frame -> Y+2
;	i -> R16
	LDI  R17,LOW(0)
; 0000 00ED     cmd[0]=MF_WRITE; cmd[1]=blockAddr;
	LDI  R30,LOW(160)
	STD  Y+30,R30
	LDD  R30,Y+36
	STD  Y+31,R30
; 0000 00EE     rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
	MOVW R30,R28
	ADIW R30,30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	CALL SUBOPT_0xC
	STD  Y+32,R30
	LDD  R30,Y+29
	STD  Y+33,R30
; 0000 00EF     if(!rc522_transceive(cmd,4,ack,&bits)) return 0;
	MOVW R30,R28
	ADIW R30,30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,23
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x47
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00F0     if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return 0;
_0x47:
	CPI  R17,4
	BRNE _0x49
	LDD  R30,Y+20
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x48
_0x49:
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00F1     for(i=0;i<16;i++) frame[i]=data16[i];
_0x48:
	LDI  R16,LOW(0)
_0x4C:
	CPI  R16,16
	BRSH _0x4D
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x4C
_0x4D:
; 0000 00F2 rc522_calc_crc(data16,16,crc); frame[16]=crc[0]; frame[17]=crc[1];
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	CALL SUBOPT_0xC
	STD  Y+18,R30
	LDD  R30,Y+29
	STD  Y+19,R30
; 0000 00F3     if(!rc522_transceive(frame,18,ack,&bits)) return 0;
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,23
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	PUSH R17
	RCALL _rc522_transceive_G000
	POP  R17
	CPI  R30,0
	BRNE _0x4E
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00F4     if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return 0;
_0x4E:
	CPI  R17,4
	BRNE _0x50
	LDD  R30,Y+20
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x4F
_0x50:
	LDI  R30,LOW(0)
	RJMP _0x20A0006
; 0000 00F5     return 1;
_0x4F:
	LDI  R30,LOW(1)
_0x20A0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,37
	RET
; 0000 00F6 }
; .FEND
;
;/* ===== Helpers for LCD formatting ===== */
;static void print_hex8_line(uint8_t *buf){
; 0000 00F9 static void print_hex8_line(uint8_t *buf){
_print_hex8_line_G000:
; .FSTART _print_hex8_line_G000
; 0000 00FA     char line[21];
; 0000 00FB     uint8_t i;
; 0000 00FC     line[0]=0; /* clear */
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,21
	ST   -Y,R17
;	*buf -> Y+22
;	line -> Y+1
;	i -> R17
	LDI  R30,LOW(0)
	STD  Y+1,R30
; 0000 00FD     for(i=0;i<8;i++){
	LDI  R17,LOW(0)
_0x53:
	CPI  R17,8
	BRSH _0x54
; 0000 00FE         sprintf(line+2*i,"%02X", buf[i]);
	LDI  R26,LOW(2)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CALL SUBOPT_0xD
; 0000 00FF     }
	SUBI R17,-1
	RJMP _0x53
_0x54:
; 0000 0100     lcd_puts(line);
	MOVW R26,R28
	ADIW R26,1
	CALL _lcd_puts
; 0000 0101 }
	LDD  R17,Y+0
	ADIW R28,24
	RET
; .FEND
;static void print_ascii8_line(uint8_t *buf){
; 0000 0102 static void print_ascii8_line(uint8_t *buf){
_print_ascii8_line_G000:
; .FSTART _print_ascii8_line_G000
; 0000 0103     char line[17];
; 0000 0104     uint8_t i;
; 0000 0105     for(i=0;i<8;i++){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,17
	ST   -Y,R17
;	*buf -> Y+18
;	line -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x56:
	CPI  R17,8
	BRSH _0x57
; 0000 0106         uint8_t c = buf[i];
; 0000 0107         if(c<0x20 || c>0x7E) line[i]='.';
	SBIW R28,1
;	*buf -> Y+19
;	line -> Y+2
;	c -> Y+0
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x59
	CPI  R26,LOW(0x7F)
	BRLO _0x58
_0x59:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(46)
	ST   X,R30
; 0000 0108         else line[i]=(char)c;
	RJMP _0x5B
_0x58:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0000 0109     }
_0x5B:
	ADIW R28,1
	SUBI R17,-1
	RJMP _0x56
_0x57:
; 0000 010A     line[8]=0;
	LDI  R30,LOW(0)
	STD  Y+9,R30
; 0000 010B     lcd_puts(line);
	MOVW R26,R28
	ADIW R26,1
	RCALL _lcd_puts
; 0000 010C }
	LDD  R17,Y+0
	JMP  _0x20A0002
; .FEND
;
;/* ===== main ===== */
;void main(void){
; 0000 010F void main(void){
_main:
; .FSTART _main
; 0000 0110     char line[21];
; 0000 0111     uint8_t atqa[2];
; 0000 0112     uint8_t uid[10], uid_len, sak;
; 0000 0113     uint8_t i;
; 0000 0114     flash char* type_str;
; 0000 0115 
; 0000 0116     /* MCU & SPI basic init (CodeVision style) */
; 0000 0117     DDRA=0x00; PORTA=0x00;
	SBIW R28,33
;	line -> Y+12
;	atqa -> Y+10
;	uid -> Y+0
;	uid_len -> R17
;	sak -> R16
;	i -> R19
;	*type_str -> R20,R21
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
; 0000 0118     DDRB=(1<<DDB7)|(1<<DDB5)|(1<<DDB4); PORTB=0x00;
	LDI  R30,LOW(176)
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0119     DDRC=0x00; PORTC=0x00;
	OUT  0x14,R30
	OUT  0x15,R30
; 0000 011A     DDRD=0x00; PORTD=0x00;
	OUT  0x11,R30
	OUT  0x12,R30
; 0000 011B     TCCR0=0; TCCR1A=0; TCCR1B=0; TCCR2=0; TIMSK=0;
	OUT  0x33,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x25,R30
	OUT  0x39,R30
; 0000 011C     MCUCR=0; MCUCSR=0;
	OUT  0x35,R30
	OUT  0x34,R30
; 0000 011D     UCSRB=0;
	OUT  0xA,R30
; 0000 011E     ACSR=(1<<ACD); SFIOR=0;
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 011F     ADCSRA=0;
	OUT  0x6,R30
; 0000 0120     SPCR=(1<<SPE)|(1<<MSTR)|(1<<SPR1); SPSR=0;
	LDI  R30,LOW(82)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0121 
; 0000 0122     RC522_CS_DDR |= (1<<RC522_CS_PIN);
	SBI  0x17,4
; 0000 0123     RC522_CS_PORT |= (1<<RC522_CS_PIN);
	SBI  0x18,4
; 0000 0124 
; 0000 0125     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0126     lcd_clear(); lcd_putsf("RC522 Ready");
	RCALL _lcd_clear
	__POINTW2FN _0x0,5
	RCALL _lcd_putsf
; 0000 0127     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0128 
; 0000 0129     rc522_init();
	RCALL _rc522_init_G000
; 0000 012A 
; 0000 012B     while(1){
_0x5C:
; 0000 012C         uint8_t ok;
; 0000 012D         uint8_t uid4[4];
; 0000 012E         uint8_t blk = 4;
; 0000 012F         uint8_t old16[16];
; 0000 0130         uint8_t write16[16] = {'W','R','I','T','E','_','T','E','S','T','_','1','2','3','4','!'};
; 0000 0131         uint8_t read16[16];
; 0000 0132         uint8_t match;
; 0000 0133 
; 0000 0134         lcd_clear(); lcd_putsf("Scan a card...");
	SBIW R28,55
	LDI  R24,33
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	LDI  R30,LOW(_0x5F*2)
	LDI  R31,HIGH(_0x5F*2)
	CALL __INITLOCB
;	line -> Y+67
;	atqa -> Y+65
;	uid -> Y+55
;	ok -> Y+54
;	uid4 -> Y+50
;	blk -> Y+49
;	old16 -> Y+33
;	write16 -> Y+17
;	read16 -> Y+1
;	match -> Y+0
	RCALL _lcd_clear
	__POINTW2FN _0x0,17
	RCALL _lcd_putsf
; 0000 0135         delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0136         if(!rc522_request(PICC_REQIDL, atqa)) { delay_ms(200); continue; }
	LDI  R30,LOW(38)
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(66))
	SBCI R27,HIGH(-(66))
	RCALL _rc522_request_G000
	CPI  R30,0
	BRNE _0x60
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	ADIW R28,55
	RJMP _0x5C
; 0000 0137 
; 0000 0138         uid_len = rc522_get_uid(uid);
_0x60:
	MOVW R26,R28
	ADIW R26,55
	RCALL _rc522_get_uid_G000
	MOV  R17,R30
; 0000 0139         ok = rc522_select(uid, uid_len, &sak);
	MOVW R30,R28
	ADIW R30,55
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	IN   R26,SPL
	IN   R27,SPH
	PUSH R16
	RCALL _rc522_select_G000
	POP  R16
	STD  Y+54,R30
; 0000 013A         if(!uid_len || !ok){
	CPI  R17,0
	BREQ _0x62
	CPI  R30,0
	BRNE _0x61
_0x62:
; 0000 013B             lcd_clear(); lcd_putsf("Select failed");
	RCALL _lcd_clear
	__POINTW2FN _0x0,32
	RCALL _lcd_putsf
; 0000 013C             delay_ms(600);
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	CALL _delay_ms
; 0000 013D             continue;
	ADIW R28,55
	RJMP _0x5C
; 0000 013E         }
; 0000 013F 
; 0000 0140         type_str = type_from_sak(sak);
_0x61:
	MOV  R26,R16
	RCALL _type_from_sak_G000
	MOVW R20,R30
; 0000 0141         lcd_clear(); lcd_puts_flash(type_str);
	RCALL _lcd_clear
	MOVW R26,R20
	RCALL _lcd_puts_flash_G000
; 0000 0142         sprintf(line,"SAK:%02X", sak);
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,46
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CALL SUBOPT_0xD
; 0000 0143         lcd_gotoxy(0,1); lcd_puts(line);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0144         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL SUBOPT_0x11
; 0000 0145 
; 0000 0146         lcd_clear();
; 0000 0147         if(uid_len==4){
	CPI  R17,4
	BRNE _0x64
; 0000 0148             sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
; 0000 0149             lcd_gotoxy(0,0); lcd_puts(line);
	RJMP _0x79
; 0000 014A         }else{
_0x64:
; 0000 014B             sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
; 0000 014C             lcd_gotoxy(0,0); lcd_puts(line);
	RCALL _lcd_gotoxy
	CALL SUBOPT_0x10
; 0000 014D             sprintf(line,"%02X%02X%02X", uid[4],uid[5],uid[6]);
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,63
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+63
	CALL SUBOPT_0x13
	__GETB1SX 68
	CALL SUBOPT_0x13
	__GETB1SX 73
	CALL SUBOPT_0x13
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 014E             lcd_gotoxy(0,1); lcd_puts(line);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x79:
	RCALL _lcd_gotoxy
	CALL SUBOPT_0x10
; 0000 014F         }
; 0000 0150         delay_ms(700);
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	CALL _delay_ms
; 0000 0151 
; 0000 0152         if((sak&0xFC)!=0x08 && (sak&0xFC)!=0x18){
	MOV  R30,R16
	ANDI R30,LOW(0xFC)
	CPI  R30,LOW(0x8)
	BREQ _0x67
	MOV  R30,R16
	ANDI R30,LOW(0xFC)
	CPI  R30,LOW(0x18)
	BRNE _0x68
_0x67:
	RJMP _0x66
_0x68:
; 0000 0153             lcd_clear(); lcd_putsf("Only Classic RW");
	RCALL _lcd_clear
	__POINTW2FN _0x0,76
	RCALL _lcd_putsf
; 0000 0154             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0155             continue;
	ADIW R28,55
	RJMP _0x5C
; 0000 0156         }
; 0000 0157 
; 0000 0158         if(uid_len==7){ uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6]; }
_0x66:
	CPI  R17,7
	BRNE _0x69
	LDD  R30,Y+58
	STD  Y+50,R30
	LDD  R30,Y+59
	STD  Y+51,R30
	LDD  R30,Y+60
	STD  Y+52,R30
	LDD  R30,Y+61
	RJMP _0x7A
; 0000 0159         else          { uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3]; }
_0x69:
	LDD  R30,Y+55
	STD  Y+50,R30
	LDD  R30,Y+56
	STD  Y+51,R30
	LDD  R30,Y+57
	STD  Y+52,R30
	LDD  R30,Y+58
_0x7A:
	STD  Y+53,R30
; 0000 015A 
; 0000 015B         lcd_clear(); lcd_putsf("Auth B4...");
	RCALL _lcd_clear
	__POINTW2FN _0x0,92
	RCALL _lcd_putsf
; 0000 015C         if(!mifare_auth_keyA(blk,uid4)){
	CALL SUBOPT_0x14
	BRNE _0x6B
; 0000 015D             lcd_clear(); lcd_putsf("Auth FAIL");
	RCALL _lcd_clear
	__POINTW2FN _0x0,103
	RCALL _lcd_putsf
; 0000 015E             delay_ms(900);
	CALL SUBOPT_0x15
; 0000 015F             continue;
	RJMP _0x5C
; 0000 0160         }
; 0000 0161 
; 0000 0162         if(!mifare_read_block(blk,old16)){
_0x6B:
	LDD  R30,Y+49
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,34
	RCALL _mifare_read_block_G000
	CPI  R30,0
	BRNE _0x6C
; 0000 0163             lcd_clear(); lcd_putsf("Read Err");
	RCALL _lcd_clear
	__POINTW2FN _0x0,113
	CALL SUBOPT_0x16
; 0000 0164             mifare_stop_crypto(); delay_ms(900); continue;
	RJMP _0x5C
; 0000 0165         }
; 0000 0166 
; 0000 0167         lcd_clear(); lcd_putsf("Write+Read...");
_0x6C:
	RCALL _lcd_clear
	__POINTW2FN _0x0,122
	RCALL _lcd_putsf
; 0000 0168         if(!mifare_write_block(blk,write16)){
	LDD  R30,Y+49
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,18
	RCALL _mifare_write_block_G000
	CPI  R30,0
	BRNE _0x6D
; 0000 0169             lcd_clear(); lcd_putsf("Write FAIL");
	RCALL _lcd_clear
	__POINTW2FN _0x0,136
	CALL SUBOPT_0x16
; 0000 016A             mifare_stop_crypto(); delay_ms(900); continue;
	RJMP _0x5C
; 0000 016B         }
; 0000 016C         if(!mifare_read_block(blk,read16)){
_0x6D:
	LDD  R30,Y+49
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _mifare_read_block_G000
	CPI  R30,0
	BRNE _0x6E
; 0000 016D             lcd_clear(); lcd_putsf("Re-read FAIL");
	RCALL _lcd_clear
	__POINTW2FN _0x0,147
	CALL SUBOPT_0x16
; 0000 016E             mifare_stop_crypto(); delay_ms(900); continue;
	RJMP _0x5C
; 0000 016F         }
; 0000 0170         mifare_stop_crypto();
_0x6E:
	RCALL _mifare_stop_crypto_G000
; 0000 0171 
; 0000 0172         match=1;
	LDI  R30,LOW(1)
	ST   Y,R30
; 0000 0173         for(i=0;i<16;i++){ if(read16[i]!=write16[i]){ match=0; break; } }
	LDI  R19,LOW(0)
_0x70:
	CPI  R19,16
	BRSH _0x71
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,17
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R0
	BREQ _0x72
	LDI  R30,LOW(0)
	ST   Y,R30
	RJMP _0x71
_0x72:
	SUBI R19,-1
	RJMP _0x70
_0x71:
; 0000 0174 
; 0000 0175         /* Show HEX (first 8 bytes) */
; 0000 0176         lcd_clear();
	RCALL _lcd_clear
; 0000 0177         lcd_putsf(match? "MATCH HEX:" : "MISMATCH HEX:");
	LD   R30,Y
	LDI  R31,0
	SBIW R30,0
	BREQ _0x73
	__POINTW1FN _0x0,160
	RJMP _0x74
_0x73:
	__POINTW1FN _0x0,171
_0x74:
	MOVW R26,R30
	CALL SUBOPT_0x17
; 0000 0178         lcd_gotoxy(0,1);
; 0000 0179         print_hex8_line(read16);
	MOVW R26,R28
	ADIW R26,1
	CALL SUBOPT_0x18
; 0000 017A         delay_ms(1200);
; 0000 017B 
; 0000 017C         /* Show ASCII (first 8 bytes) */
; 0000 017D         lcd_clear();
; 0000 017E         lcd_putsf("ASCII:");
	__POINTW2FN _0x0,185
	CALL SUBOPT_0x17
; 0000 017F         lcd_gotoxy(0,1);
; 0000 0180         print_ascii8_line(read16);
	MOVW R26,R28
	ADIW R26,1
	RCALL _print_ascii8_line_G000
; 0000 0181         delay_ms(1200);
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	CALL SUBOPT_0x11
; 0000 0182 
; 0000 0183         /* Show next 8 bytes HEX */
; 0000 0184         lcd_clear();
; 0000 0185         lcd_putsf("HEX[8..15]:");
	__POINTW2FN _0x0,192
	CALL SUBOPT_0x17
; 0000 0186         lcd_gotoxy(0,1);
; 0000 0187         print_hex8_line(read16+8);
	MOVW R26,R28
	ADIW R26,9
	CALL SUBOPT_0x18
; 0000 0188         delay_ms(1200);
; 0000 0189 
; 0000 018A         /* Show next 8 bytes ASCII */
; 0000 018B         lcd_clear();
; 0000 018C         lcd_putsf("ASCII[8..]:");
	__POINTW2FN _0x0,204
	CALL SUBOPT_0x17
; 0000 018D         lcd_gotoxy(0,1);
; 0000 018E         print_ascii8_line(read16+8);
	MOVW R26,R28
	ADIW R26,9
	RCALL _print_ascii8_line_G000
; 0000 018F         delay_ms(1200);
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	CALL _delay_ms
; 0000 0190 
; 0000 0191         /* Optional restore original content */
; 0000 0192          if(mifare_auth_keyA(blk,uid4)){ mifare_write_block(blk,old16); mifare_stop_crypto(); }
	CALL SUBOPT_0x14
	BREQ _0x76
	LDD  R30,Y+49
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,34
	RCALL _mifare_write_block_G000
	RCALL _mifare_stop_crypto_G000
; 0000 0193     }
_0x76:
	ADIW R28,55
	RJMP _0x5C
; 0000 0194 }
_0x77:
	RJMP _0x77
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
	RJMP _0x20A0003
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
	RJMP _0x20A0003
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
_0x20A0005:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x19
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x19
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
	RJMP _0x20A0003
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0003
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
	RJMP _0x20A0004
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	CALL SUBOPT_0xB
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20A0004:
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
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
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
	RJMP _0x20A0003
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
_0x20A0003:
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
	CALL SUBOPT_0x1B
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x1C
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1D
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x1D
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x1D
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
_0x20A0002:
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x20
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
	CALL SUBOPT_0x20
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
_keyA_G000:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	JMP  _rc522_write_G000

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,5
	CALL _rc522_anticoll_level_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
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
SUBOPT_0xA:
	STD  Y+4,R30
	LDI  R30,LOW(147)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,31
	CALL _rc522_calc_crc_G000
	LDD  R30,Y+28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	MOVW R30,R28
	SUBI R30,LOW(-(67))
	SBCI R31,HIGH(-(67))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	SUBI R26,LOW(-(67))
	SBCI R27,HIGH(-(67))
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,55
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+59
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1SX 64
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1SX 69
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1SX 74
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R30,Y+49
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,51
	CALL _mifare_auth_keyA_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	CALL _delay_ms
	ADIW R28,55
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CALL _lcd_putsf
	CALL _mifare_stop_crypto_G000
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	CALL _lcd_putsf
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL _print_hex8_line_G000
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
