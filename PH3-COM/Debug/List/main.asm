
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
	JMP  _ext_int2_isr
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

_0x0:
	.DB  0x3E,0x44,0x69,0x73,0x41,0x72,0x6D,0x0
	.DB  0x3E,0x41,0x72,0x6D,0x0,0x3E,0x4C,0x61
	.DB  0x73,0x65,0x72,0x20,0x73,0x65,0x6E,0x73
	.DB  0x65,0x0,0x4D,0x6F,0x76,0x65,0x6D,0x65
	.DB  0x6E,0x74,0x20,0x73,0x65,0x6E,0x73,0x65
	.DB  0x0,0x3E,0x4D,0x6F,0x76,0x65,0x6D,0x65
	.DB  0x6E,0x74,0x20,0x73,0x65,0x6E,0x73,0x65
	.DB  0x0,0x3E,0x42,0x6F,0x74,0x68,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
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
;#include <delay.h>
;#include <alcd.h>
;#include <stdint.h>
;
;volatile uint8_t control = 0;
;volatile uint8_t controlL = 0;
;volatile uint8_t counter = 0;
;volatile uint8_t isBuzz1 = 0;
;volatile uint8_t isBuzz2 = 0;
;volatile uint8_t selectorT = 0;
;volatile uint8_t selectorL = 0;
;volatile uint8_t controlMenu = 0;
;volatile uint8_t check = 0;
;volatile uint8_t temp = 0;
;volatile uint8_t t_temp = 0;
;
;
;int ChooseMenu(void){
; 0000 0013 int ChooseMenu(void){

	.CSEG
_ChooseMenu:
; .FSTART _ChooseMenu
; 0000 0014     if (controlMenu == 0){
	LDS  R30,_controlMenu
	CPI  R30,0
	BRNE _0x3
; 0000 0015         if (selectorT == 0){
	LDS  R30,_selectorT
	CPI  R30,0
	BRNE _0x4
; 0000 0016             lcd_gotoxy(0,0); lcd_putsf(">DisArm");
	CALL SUBOPT_0x0
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x1
; 0000 0017             lcd_gotoxy(0,1); lcd_putsf("Arm");
	__POINTW2FN _0x0,4
	CALL _lcd_putsf
; 0000 0018             return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 0019         }
; 0000 001A         else if(selectorT == 1){
_0x4:
	LDS  R26,_selectorT
	CPI  R26,LOW(0x1)
	BRNE _0x6
; 0000 001B             lcd_gotoxy(0,0); lcd_putsf("DisArm");
	CALL SUBOPT_0x0
	__POINTW2FN _0x0,1
	CALL SUBOPT_0x1
; 0000 001C             lcd_gotoxy(0,1); lcd_putsf(">Arm");
	__POINTW2FN _0x0,8
	CALL _lcd_putsf
; 0000 001D             return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 001E         }
; 0000 001F     }
_0x6:
; 0000 0020     else if(controlMenu == 1){
	RJMP _0x7
_0x3:
	LDS  R26,_controlMenu
	CPI  R26,LOW(0x1)
	BRNE _0x8
; 0000 0021         if(selectorL == 0){
	LDS  R30,_selectorL
	CPI  R30,0
	BRNE _0x9
; 0000 0022             lcd_gotoxy(0,0); lcd_putsf(">Laser sense");
	CALL SUBOPT_0x0
	__POINTW2FN _0x0,13
	CALL SUBOPT_0x1
; 0000 0023             lcd_gotoxy(0,1); lcd_putsf("Movement sense");
	__POINTW2FN _0x0,26
	CALL _lcd_putsf
; 0000 0024             return 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 0025         }
; 0000 0026         else if(selectorL == 1){
_0x9:
	LDS  R26,_selectorL
	CPI  R26,LOW(0x1)
	BRNE _0xB
; 0000 0027             lcd_gotoxy(0,0); lcd_putsf("Laser sense");
	CALL SUBOPT_0x0
	__POINTW2FN _0x0,14
	CALL SUBOPT_0x1
; 0000 0028             lcd_gotoxy(0,1); lcd_putsf(">Movement sense");
	__POINTW2FN _0x0,41
	CALL _lcd_putsf
; 0000 0029             return 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 002A         }
; 0000 002B         else if(selectorL == 2){
_0xB:
	LDS  R26,_selectorL
	CPI  R26,LOW(0x2)
	BRNE _0xD
; 0000 002C             lcd_gotoxy(0,0); lcd_putsf("Movement sense");
	CALL SUBOPT_0x0
	__POINTW2FN _0x0,26
	CALL SUBOPT_0x1
; 0000 002D             lcd_gotoxy(0,1); lcd_putsf(">Both");
	__POINTW2FN _0x0,57
	CALL _lcd_putsf
; 0000 002E             return 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 002F         }
; 0000 0030     }
_0xD:
; 0000 0031 
; 0000 0032     return -1;
_0x8:
_0x7:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET
; 0000 0033 
; 0000 0034 }
; .FEND
;
;void LDR(int v){
; 0000 0036 void LDR(int v){
_LDR:
; .FSTART _LDR
; 0000 0037 
; 0000 0038     if(v > 500){
	ST   -Y,R27
	ST   -Y,R26
;	v -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLT _0xE
; 0000 0039 
; 0000 003A         PORTB |= (PORTB1 << 1);
	SBI  0x18,1
; 0000 003B         delay_ms(115);
	CALL SUBOPT_0x2
; 0000 003C         PORTD |= (1 << PORTD5);
; 0000 003D         isBuzz1 = 1;
	RJMP _0x32
; 0000 003E         }
; 0000 003F     else{
_0xE:
; 0000 0040         PORTB &= ~(PORTB1 << 1);
	CBI  0x18,1
; 0000 0041         if(isBuzz2 == 0)
	LDS  R30,_isBuzz2
	CPI  R30,0
	BRNE _0x10
; 0000 0042             PORTD &= ~(1 << PORTD5);
	CBI  0x12,5
; 0000 0043         isBuzz1 = 0;
_0x10:
	LDI  R30,LOW(0)
_0x32:
	STS  _isBuzz1,R30
; 0000 0044         }
; 0000 0045 
; 0000 0046 }
	RJMP _0x2020002
; .FEND
;
;void PIR(void) {
; 0000 0048 void PIR(void) {
_PIR:
; .FSTART _PIR
; 0000 0049 
; 0000 004A     if (PIND & (1 << PORTD7)){
	SBIS 0x10,7
	RJMP _0x11
; 0000 004B         PORTD |= (1 << PORTD6);
	SBI  0x12,6
; 0000 004C         delay_ms(115);
	CALL SUBOPT_0x2
; 0000 004D         PORTD |= (1 << PORTD5);
; 0000 004E         isBuzz2 = 1;
	RJMP _0x33
; 0000 004F         }
; 0000 0050     else
_0x11:
; 0000 0051     {
; 0000 0052         PORTD &= ~(1 << PORTD6);
	CBI  0x12,6
; 0000 0053         if (isBuzz1 == 0)
	LDS  R30,_isBuzz1
	CPI  R30,0
	BRNE _0x13
; 0000 0054             PORTD &= ~(1 << PORTD5 );
	CBI  0x12,5
; 0000 0055         isBuzz2 = 0;
_0x13:
	LDI  R30,LOW(0)
_0x33:
	STS  _isBuzz2,R30
; 0000 0056     }
; 0000 0057 
; 0000 0058 }
	RET
; .FEND
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 005B {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x3
; 0000 005C     if (control == 0 ){
	CPI  R30,0
	BRNE _0x14
; 0000 005D         selectorT += 1;
	LDS  R30,_selectorT
	SUBI R30,-LOW(1)
	STS  _selectorT,R30
; 0000 005E         if(selectorT == 2)
	LDS  R26,_selectorT
	CPI  R26,LOW(0x2)
	BRNE _0x15
; 0000 005F             selectorT = 0;
	LDI  R30,LOW(0)
	STS  _selectorT,R30
; 0000 0060     }
_0x15:
; 0000 0061     else if (control == 1){
	RJMP _0x16
_0x14:
	LDS  R26,_control
	CPI  R26,LOW(0x1)
	BRNE _0x17
; 0000 0062         selectorL += 1;
	LDS  R30,_selectorL
	SUBI R30,-LOW(1)
	STS  _selectorL,R30
; 0000 0063         if(selectorL == 3)
	LDS  R26,_selectorL
	CPI  R26,LOW(0x3)
	BRNE _0x18
; 0000 0064             selectorL = 0;
	LDI  R30,LOW(0)
	STS  _selectorL,R30
; 0000 0065     }
_0x18:
; 0000 0066 }
_0x17:
_0x16:
	RJMP _0x34
; .FEND
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0069 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R30
; 0000 006A 
; 0000 006B check = 1;
	LDI  R30,LOW(1)
	STS  _check,R30
; 0000 006C 
; 0000 006D }
	LD   R30,Y+
	RETI
; .FEND
;
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0070 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	CALL SUBOPT_0x3
; 0000 0071 
; 0000 0072 control += 1;
	SUBI R30,-LOW(1)
	STS  _control,R30
; 0000 0073 if (control == 2)
	LDS  R26,_control
	CPI  R26,LOW(0x2)
	BRNE _0x19
; 0000 0074     control = 0;
	LDI  R30,LOW(0)
	STS  _control,R30
; 0000 0075 
; 0000 0076 
; 0000 0077 }
_0x19:
_0x34:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 007D {
_read_adc:
; .FSTART _read_adc
; 0000 007E ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 007F delay_us(10);
	__DELAY_USB 27
; 0000 0080 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0081 while ((ADCSRA & (1<<ADIF))==0);
_0x1A:
	SBIS 0x6,4
	RJMP _0x1A
; 0000 0082 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0083 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 0084 }
; .FEND
;
;void main(void)
; 0000 0087 {
_main:
; .FSTART _main
; 0000 0088 // Port A initialization
; 0000 0089 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008A DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 008B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008C PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 008D 
; 0000 008E // Port B initialization
; 0000 008F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 0090 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0091 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 0092 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0093 
; 0000 0094 // Port C initialization
; 0000 0095 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0096 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0097 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0098 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0099 
; 0000 009A // Port D initialization
; 0000 009B // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 009C DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(112)
	OUT  0x11,R30
; 0000 009D // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 009E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 009F 
; 0000 00A0 // Timer/Counter 0 initialization
; 0000 00A1 // Clock source: System Clock
; 0000 00A2 // Clock value: Timer 0 Stopped
; 0000 00A3 // Mode: Normal top=0xFF
; 0000 00A4 // OC0 output: Disconnected
; 0000 00A5 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00A6 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A7 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00A8 
; 0000 00A9 // Timer/Counter 1 initialization
; 0000 00AA // Clock source: System Clock
; 0000 00AB // Clock value: Timer1 Stopped
; 0000 00AC // Mode: Normal top=0xFFFF
; 0000 00AD // OC1A output: Disconnected
; 0000 00AE // OC1B output: Disconnected
; 0000 00AF // Noise Canceler: Off
; 0000 00B0 // Input Capture on Falling Edge
; 0000 00B1 // Timer1 Overflow Interrupt: Off
; 0000 00B2 // Input Capture Interrupt: Off
; 0000 00B3 // Compare A Match Interrupt: Off
; 0000 00B4 // Compare B Match Interrupt: Off
; 0000 00B5 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00B6 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00B7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00BA ICR1L=0x00;
	OUT  0x26,R30
; 0000 00BB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00BC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00BE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BF 
; 0000 00C0 // Timer/Counter 2 initialization
; 0000 00C1 // Clock source: System Clock
; 0000 00C2 // Clock value: Timer2 Stopped
; 0000 00C3 // Mode: Normal top=0xFF
; 0000 00C4 // OC2 output: Disconnected
; 0000 00C5 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00C6 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00C7 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00C8 OCR2=0x00;
	OUT  0x23,R30
; 0000 00C9 
; 0000 00CA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00CB TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00CC 
; 0000 00CD // External Interrupt(s) initialization
; 0000 00CE // INT0: On
; 0000 00CF // INT0 Mode: Falling Edge
; 0000 00D0 // INT1: On
; 0000 00D1 // INT1 Mode: Falling Edge
; 0000 00D2 // INT2: On
; 0000 00D3 // INT2 Mode: Falling Edge
; 0000 00D4 GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 00D5 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 00D6 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00D7 GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 00D8 
; 0000 00D9 // USART initialization
; 0000 00DA // USART disabled
; 0000 00DB UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00DC 
; 0000 00DD // Analog Comparator initialization
; 0000 00DE // Analog Comparator: Off
; 0000 00DF // The Analog Comparator's positive input is
; 0000 00E0 // connected to the AIN0 pin
; 0000 00E1 // The Analog Comparator's negative input is
; 0000 00E2 // connected to the AIN1 pin
; 0000 00E3 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E4 
; 0000 00E5 // ADC initialization
; 0000 00E6 // ADC Clock frequency: 125.000 kHz
; 0000 00E7 // ADC Voltage Reference: AVCC pin
; 0000 00E8 // ADC Auto Trigger Source: ADC Stopped
; 0000 00E9 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00EA ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 00EB SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EC 
; 0000 00ED // SPI initialization
; 0000 00EE // SPI disabled
; 0000 00EF SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00F0 
; 0000 00F1 // TWI initialization
; 0000 00F2 // TWI disabled
; 0000 00F3 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00F4 
; 0000 00F5 // Alphanumeric LCD initialization
; 0000 00F6 // Connections are specified in the
; 0000 00F7 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00F8 // RS - PORTC Bit 0
; 0000 00F9 // RD - PORTC Bit 1
; 0000 00FA // EN - PORTC Bit 2
; 0000 00FB // D4 - PORTC Bit 4
; 0000 00FC // D5 - PORTC Bit 5
; 0000 00FD // D6 - PORTC Bit 6
; 0000 00FE // D7 - PORTC Bit 7
; 0000 00FF // Characters/line: 16
; 0000 0100 MCUCSR |= (1<<JTD);
	IN   R30,0x34
	ORI  R30,0x80
	OUT  0x34,R30
; 0000 0101 MCUCSR |= (1<<JTD);
	IN   R30,0x34
	ORI  R30,0x80
	OUT  0x34,R30
; 0000 0102 
; 0000 0103 delay_ms(30);
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
; 0000 0104 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0105 
; 0000 0106 
; 0000 0107 // Global enable interrupts
; 0000 0108 #asm("sei")
	sei
; 0000 0109 
; 0000 010A 
; 0000 010B while (1)
_0x1D:
; 0000 010C       {
; 0000 010D       temp = ChooseMenu();
	RCALL _ChooseMenu
	STS  _temp,R30
; 0000 010E       if(temp != t_temp)
	LDS  R30,_t_temp
	LDS  R26,_temp
	CP   R30,R26
	BREQ _0x20
; 0000 010F         lcd_clear();
	RCALL _lcd_clear
; 0000 0110 
; 0000 0111       switch(temp){
_0x20:
	LDS  R30,_temp
	LDI  R31,0
; 0000 0112         case 0:
	SBIW R30,0
	BRNE _0x24
; 0000 0113             if(check == 1){
	LDS  R26,_check
	CPI  R26,LOW(0x1)
	BRNE _0x25
; 0000 0114                 PORTD |= (1 << PORTD5);
	RCALL SUBOPT_0x4
; 0000 0115                 delay_ms(10);
; 0000 0116                 PORTD &= ~(1 << PORTD5 );
; 0000 0117                 check = 0;
; 0000 0118             }
; 0000 0119             break;
_0x25:
	RJMP _0x23
; 0000 011A         case 1:
_0x24:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26
; 0000 011B             if(check == 1){
	LDS  R26,_check
	CPI  R26,LOW(0x1)
	BRNE _0x27
; 0000 011C                 controlMenu = 1;
	LDI  R30,LOW(1)
	STS  _controlMenu,R30
; 0000 011D                 PORTD |= (1 << PORTD5);
	RCALL SUBOPT_0x4
; 0000 011E                 delay_ms(10);
; 0000 011F                 PORTD &= ~(1 << PORTD5);
; 0000 0120                 check = 0;
; 0000 0121             }
; 0000 0122             break;
_0x27:
	RJMP _0x23
; 0000 0123         case 2:
_0x26:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
; 0000 0124           if(control == 1){
	LDS  R26,_control
	CPI  R26,LOW(0x1)
	BRNE _0x29
; 0000 0125             unsigned int v = read_adc(0);
; 0000 0126             PORTD &= ~(1 << PORTD6);
	RCALL SUBOPT_0x5
;	v -> Y+0
	CBI  0x12,6
; 0000 0127             PORTB |= (1 << PORTB0);
	SBI  0x18,0
; 0000 0128             LDR(v);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _LDR
; 0000 0129             delay_ms(100);
	RCALL SUBOPT_0x6
; 0000 012A             }
	ADIW R28,2
; 0000 012B           else{
	RJMP _0x2A
_0x29:
; 0000 012C             PORTB &= ~(PORTB1 << 1);
	RCALL SUBOPT_0x7
; 0000 012D             PORTB &= ~(1 << PORTB0);
; 0000 012E             PORTD &= ~(1 << PORTD5);
; 0000 012F             PORTD &= ~(1 << PORTD6);
; 0000 0130             controlMenu = 0;
; 0000 0131           }
_0x2A:
; 0000 0132           break;
	RJMP _0x23
; 0000 0133         case 3:
_0x28:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2B
; 0000 0134           if(control == 1){
	LDS  R26,_control
	CPI  R26,LOW(0x1)
	BRNE _0x2C
; 0000 0135             PORTB &= ~(PORTB1 << 1);
	CBI  0x18,1
; 0000 0136             PORTB &= ~(1 << PORTB0);
	CBI  0x18,0
; 0000 0137             PORTD |= (1 << PORTD4);
	SBI  0x12,4
; 0000 0138             PIR();
	RCALL _PIR
; 0000 0139             delay_ms(100);
	RCALL SUBOPT_0x6
; 0000 013A             }
; 0000 013B           else{
	RJMP _0x2D
_0x2C:
; 0000 013C             PORTB &= ~(PORTB1 << 1);
	RCALL SUBOPT_0x7
; 0000 013D             PORTB &= ~(1 << PORTB0);
; 0000 013E             PORTD &= ~(1 << PORTD5);
; 0000 013F             PORTD &= ~(1 << PORTD6);
; 0000 0140             controlMenu = 0;
; 0000 0141           }
_0x2D:
; 0000 0142           break;
	RJMP _0x23
; 0000 0143         case 4:
_0x2B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x23
; 0000 0144 
; 0000 0145           if(control == 1){
	LDS  R26,_control
	CPI  R26,LOW(0x1)
	BRNE _0x2F
; 0000 0146             unsigned int v = read_adc(0);
; 0000 0147             PORTB |= (1 << PORTB0);
	RCALL SUBOPT_0x5
;	v -> Y+0
	SBI  0x18,0
; 0000 0148             LDR(v);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _LDR
; 0000 0149             PORTD |= (1 << PORTD4);
	SBI  0x12,4
; 0000 014A             PIR();
	RCALL _PIR
; 0000 014B             delay_ms(100);
	RCALL SUBOPT_0x6
; 0000 014C             }
	ADIW R28,2
; 0000 014D           else{
	RJMP _0x30
_0x2F:
; 0000 014E             PORTB &= ~(PORTB1 << 1);
	CBI  0x18,1
; 0000 014F             PORTB &= ~(1 << PORTB0);
	CBI  0x18,0
; 0000 0150             PORTD &= ~(1 << PORTD5);
	CBI  0x12,5
; 0000 0151             PORTD &= ~(1 << PORTD4);
	CBI  0x12,4
; 0000 0152             PORTD &= ~(1 << PORTD6);
	CBI  0x12,6
; 0000 0153             controlMenu = 0;
	LDI  R30,LOW(0)
	STS  _controlMenu,R30
; 0000 0154           }
_0x30:
; 0000 0155           break;
; 0000 0156       }
_0x23:
; 0000 0157 
; 0000 0158 
; 0000 0159       delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 015A       t_temp = temp;
	LDS  R30,_temp
	STS  _t_temp,R30
; 0000 015B       }
	RJMP _0x1D
; 0000 015C }
_0x31:
	RJMP _0x31
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
	RJMP _0x2020001
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
	RJMP _0x2020001
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
_0x2020002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
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
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2020001
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
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
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
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_control:
	.BYTE 0x1
_isBuzz1:
	.BYTE 0x1
_isBuzz2:
	.BYTE 0x1
_selectorT:
	.BYTE 0x1
_selectorL:
	.BYTE 0x1
_controlMenu:
	.BYTE 0x1
_check:
	.BYTE 0x1
_temp:
	.BYTE 0x1
_t_temp:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	RCALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(115)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x12,5
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_control
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	SBI  0x12,5
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x12,5
	LDI  R30,LOW(0)
	STS  _check,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SBIW R28,2
	LDI  R26,LOW(0)
	CALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	CBI  0x18,1
	CBI  0x18,0
	CBI  0x12,5
	CBI  0x12,6
	LDI  R30,LOW(0)
	STS  _controlMenu,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
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

;END OF CODE MARKER
__END_OF_CODE:
