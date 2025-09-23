#include <mega32.h>
#include <alcd.h>
#include <spi.h>
#include <stdio.h>
#include <delay.h>
#include <stdint.h>

#define RC522_CS_PORT PORTB
#define RC522_CS_DDR DDRB
#define RC522_CS_PIN PORTB4

#define CommandReg       0x01
#define ComIEnReg        0x02
#define DivIEnReg        0x03
#define ComIrqReg        0x04
#define DivIrqReg        0x05
#define ErrorReg         0x06
#define Status1Reg       0x07
#define Status2Reg       0x08
#define FIFODataReg      0x09
#define FIFOLevelReg     0x0A
#define ControlReg       0x0C
#define BitFramingReg    0x0D
#define ModeReg          0x11
#define TxControlReg     0x14
#define TxASKReg         0x15
#define TModeReg         0x2A
#define TPrescalerReg    0x2B
#define TReloadRegH      0x2C
#define TReloadRegL      0x2D
#define AutoTestReg      0x36
#define VersionReg       0x37

#define PCD_Idle         0x00
#define PCD_Mem          0x01
#define PCD_CalcCRC      0x03
#define PCD_Transceive   0x0C
#define PCD_SoftReset    0x0F

#define PICC_REQIDL        0x26
#define PICC_ANTICOLL_CL1  0x93
#define PICC_ANTICOLL_CL2  0x95
#define PICC_SELECT_CL1    0x93
#define PICC_SELECT_CL2    0x95
#define PICC_GET_VERSION   0x60 

#define CRCResultRegH    0x21
#define CRCResultRegL    0x22
#define CollReg          0x0E
  

/* ---- CS helpers ---- */
static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_PIN); }
static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_PIN); }

/* ---- Low-level R/W ---- */
static void rc522_write(uint8_t reg, uint8_t val){
    cs_low();
    spi( (reg<<1) & 0x7E );
    spi( val );
    cs_high();
}
static uint8_t rc522_read(uint8_t reg){
    uint8_t v;
    cs_low();
    spi( ((reg<<1)&0x7E) | 0x80 );
    v = spi(0x00);
    cs_high();
    return v;
}
static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }

static void rc522_soft_reset(void){ rc522_write(CommandReg,PCD_SoftReset); delay_ms(50); }

static void rc522_antenna_on(void){
    if(!(rc522_read(TxControlReg)&0x03)) set_bit_mask(TxControlReg,0x03);
}

static void rc522_init(void){
    rc522_soft_reset();
    rc522_write(TModeReg,      0x8D);
    rc522_write(TPrescalerReg, 0x3E);
    rc522_write(TReloadRegL,   30);
    rc522_write(TReloadRegH,   0);
    rc522_write(TxASKReg,      0x40);
    rc522_write(ModeReg,       0x3D);
    rc522_antenna_on();
}

static uint8_t rc522_selftest(uint8_t* ver_out){
    static const uint8_t expect_v10[64]={
        0x00,0xC6,0x37,0xD5,0x32,0xB7,0x57,0x5C,0xC2,0xD8,0x7C,0x4D,0xD9,0x70,0xC7,0x73,
        0x10,0xE6,0xD2,0xAA,0x5E,0xA1,0x3E,0x5A,0x14,0xAF,0x30,0x61,0xC9,0x70,0xDB,0x2E,
        0x64,0x22,0x72,0xB5,0xBD,0x65,0xF4,0xEC,0x22,0xBC,0xD3,0x72,0x35,0xCD,0xAA,0x41,
        0x1F,0xA7,0xF3,0x53,0x14,0xDE,0x7E,0x02,0xD9,0x0F,0xB5,0x5E,0x25,0x1D,0x29,0x79
    };
    static const uint8_t expect_v20[64]={
        0x00,0xEB,0x66,0xBA,0x57,0xBF,0x23,0x95,0xD0,0xE3,0x0D,0x3D,0x27,0x89,0x5C,0xDE,
        0x9D,0x3B,0xA7,0x00,0x21,0x5B,0x89,0x82,0x51,0x3A,0xEB,0x02,0x0C,0xA5,0x00,0x49,
        0x7C,0x84,0x4D,0xB3,0xCC,0xD2,0x1B,0x81,0x5D,0x48,0x76,0xD5,0x71,0x61,0x21,0xA9,
        0x86,0x96,0x83,0x38,0xCF,0x9D,0x5B,0x6D,0xDC,0x15,0xBA,0x3E,0x7D,0x95,0x3B,0x2F
    };
    uint8_t ver=rc522_read(VersionReg), i, fl, buf[64];
    rc522_soft_reset();
    rc522_write(FIFOLevelReg,0x80);
    for(i=0;i<25;i++) rc522_write(FIFODataReg,0x00);
    rc522_write(CommandReg,PCD_Mem);
    rc522_write(AutoTestReg,0x09);
    rc522_write(FIFODataReg,0x00);
    rc522_write(CommandReg,PCD_CalcCRC);
    for(i=0;i<200;i++){ fl=rc522_read(FIFOLevelReg); if(fl==64) break; delay_ms(1); }
    if(fl!=64){ *ver_out=ver; return 0; }
    for(i=0;i<64;i++) buf[i]=rc522_read(FIFODataReg);
    rc522_write(AutoTestReg,0x00);
    rc522_soft_reset();
    *ver_out=ver;
    if(ver==0x91){ for(i=0;i<64;i++) if(buf[i]!=expect_v10[i]) return 0; return 1; }
    if(ver==0x92){ for(i=0;i<64;i++) if(buf[i]!=expect_v20[i]) return 0; return 1; }
    return 0;
}

static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
    uint8_t i, n, lastBits;
    rc522_write(ComIEnReg, 0x77 | 0x80);
    clr_bit_mask(ComIrqReg, 0x80);
    set_bit_mask(FIFOLevelReg, 0x80);
    rc522_write(CommandReg, PCD_Idle);
    for(i=0;i<sendLen;i++) rc522_write(FIFODataReg, send[i]);
    rc522_write(CommandReg, PCD_Transceive);
    set_bit_mask(BitFramingReg, 0x80); // StartSend

    i=200;
    do{
        n=rc522_read(ComIrqReg);
    }while(--i && !(n&0x30)); // RxIRq or IdleIRq

    clr_bit_mask(BitFramingReg,0x80);
    if(!i) return 0;
    if(rc522_read(ErrorReg)&0x1B) return 0;

    n = rc522_read(FIFOLevelReg);
    lastBits = rc522_read(ControlReg) & 0x07;
    if(lastBits) *backBits = (n-1)*8 + lastBits;
    else         *backBits = n*8;

    for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
    return 1;
}

/* ---- REQA ---- */
static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
    uint8_t cmd= reqMode, back[2], backBits=0;
    rc522_write(BitFramingReg,0x07);             // 7-bit for REQA
    if(!rc522_transceive(&cmd,1,back,&backBits)) return 0;
    rc522_write(BitFramingReg,0x00);             
    if(backBits!=16) return 0;
    ATQA[0]=back[0]; ATQA[1]=back[1];
    return 1;
}

/* ---- Anti-collision (CL1/CL2) ---- */
static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
    uint8_t cmd[2];uint8_t back[10]; uint8_t backBits=0, i;
    cmd[0]=level_cmd;
    cmd[1] = 0x20;
    rc522_write(BitFramingReg,0x00);
    if(!rc522_transceive(cmd,2,back,&backBits)) 
        return 0;
    if(backBits!=40) 
        return 0;
    for(i=0;i<5;i++) 
        out5[i]=back[i];
    return 1;
}

static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
    uint8_t i;
    rc522_write(CommandReg, PCD_Idle);
    set_bit_mask(FIFOLevelReg, 0x80);           // flush FIFO
    for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
    rc522_write(CommandReg, PCD_CalcCRC);
    // ãäÊÙÑ ÇíÇä CRC
    for(i=0;i<255;i++){
        if(rc522_read(DivIrqReg) & 0x04) break;  // CRCIRq
    }
    crc2[0] = rc522_read(CRCResultRegL);
    crc2[1] = rc522_read(CRCResultRegH);
}


static uint8_t rc522_get_uid(uint8_t *uid){
    uint8_t block[5], i, bcc, len=0;

    if(!rc522_anticoll_level(PICC_ANTICOLL_CL1, block)) return 0;

    if(block[0]==0x88){ // Cascade
        uid[0]=block[1]; uid[1]=block[2]; uid[2]=block[3];
        if(!rc522_anticoll_level(PICC_ANTICOLL_CL2, block)) return 0;
        bcc = block[0]^block[1]^block[2]^block[3];
        if(bcc!=block[4]) return 0;
        uid[3]=block[0]; uid[4]=block[1]; uid[5]=block[2]; uid[6]=block[3];
        len=7;
    }else{
        bcc = block[0]^block[1]^block[2]^block[3];
        if(bcc!=block[4]) return 0;
        for(i=0;i<4;i++) uid[i]=block[i];
        len=4;
    }
    return len;
}

static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t bcc, uint8_t *sak_out){
    // Frame: [SEL, 0x70, UID0..UID3, BCC, CRC_L, CRC_H]
    uint8_t buf[9], crc[2], back[3]; 
    uint8_t backBits=0;

    rc522_write(BitFramingReg,0x00); // 8-bit framing

    buf[0]=level_cmd; 
    buf[1]=0x70;
    buf[2]=uid4[0]; buf[3]=uid4[1]; buf[4]=uid4[2]; buf[5]=uid4[3];
    buf[6]=bcc;

    rc522_calc_crc(buf,7,crc);
    buf[7]=crc[0]; buf[8]=crc[1];

    if(!rc522_transceive(buf,9,back,&backBits)) return 0;
    if(backBits!=24) return 0;       // SAK(8) + CRC_A(16)

    *sak_out = back[0];
    return 1;
}

static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
    uint8_t uid4[4], bcc, sak_tmp;

    if(uid_len==4){
        uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
        bcc = uid4[0]^uid4[1]^uid4[2]^uid4[3];
        return rc522_select_level(PICC_SELECT_CL1, uid4, bcc, sak);
    }

    if(uid_len==7){
        uid4[0]=0x88; uid4[1]=uid[0]; uid4[2]=uid[1]; uid4[3]=uid[2];
        bcc = uid4[0]^uid4[1]^uid4[2]^uid4[3];
        if(!rc522_select_level(PICC_SELECT_CL1, uid4, bcc, &sak_tmp)) return 0;

        uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6];
        bcc = uid4[0]^uid4[1]^uid4[2]^uid4[3];
        return rc522_select_level(PICC_SELECT_CL2, uid4, bcc, sak);
    }
    return 0;
}


static uint8_t rc522_get_version(uint8_t *ver8){
    uint8_t cmd = PICC_GET_VERSION;
    uint8_t back[12]; uint8_t bits=0, i;
    if(!rc522_transceive(&cmd,1,back,&bits)) return 0;
    if(bits < 8*8) return 0;    
    for(i=0;i<8;i++) ver8[i]=back[i];
    return 1;
}

static flash char S_C1K[]  = "MIFARE Classic 1K";
static flash char S_C4K[]  = "MIFARE Classic 4K";
static flash char S_UL[]   = "Ultralight/NTAG";
static flash char S_UNK[]  = "Unknown/other";

static flash char N_213[]  = "NTAG213";
static flash char N_215[]  = "NTAG215";
static flash char N_216[]  = "NTAG216";

static flash char* type_from_sak(uint8_t sak){
    if(sak==0x08 || sak==0x88) return S_C1K;
    if(sak==0x18 || sak==0x98) return S_C4K;
    if(sak==0x00)             return S_UL;
    return S_UNK;
}
static flash char* ntag_from_size(uint8_t size_code){
    if(size_code==0x0F) return N_213;
    if(size_code==0x11) return N_215;
    if(size_code==0x13) return N_216;
    return S_UL;
}

void main(void)
{
// Declare your local variables here
 
char line[21];
uint8_t ver=0, ok=0;
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 125.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (1<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16

RC522_CS_DDR |= (1<<RC522_CS_PIN);
RC522_CS_PORT |= (1<<RC522_CS_PIN);

lcd_init(16);
lcd_clear();
lcd_gotoxy(0,0);lcd_putsf("RC522 SelfTest");
lcd_gotoxy(0,1);lcd_putsf("Please wait...");
delay_ms(400);

ok = rc522_selftest(&ver);
lcd_clear();
sprintf(line, "Ver:0x%02X", ver);
lcd_gotoxy(0,0);lcd_puts(line);
if(!ok){lcd_gotoxy(0,1); lcd_putsf("SelfTest: FAIL"); while(1);}
lcd_gotoxy(0,1);lcd_puts("SelfTest: PASS");
delay_ms(600);

rc522_init();

while(1){
    uint8_t atqa[2], uid[10], uid_len=0, sak=0, ver8[8];
    flash char* type_str;

    if(rc522_request(PICC_REQIDL, atqa)){
        uid_len = rc522_get_uid(uid);
        if(uid_len){
            if(rc522_select(uid, uid_len, &sak)){
                type_str = type_from_sak(sak);

                if(sak==0x00 && rc522_get_version(ver8)){
                    flash char* ntag = ntag_from_size(ver8[6]);
                    type_str = ntag; 
                }

                lcd_clear();
                lcd_gotoxy(0,0); lcd_putsf(type_str);

                if(uid_len==4){
                    sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
                    lcd_gotoxy(0,1); lcd_puts(line);
                }else{ // 7-byte
                    sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
                    lcd_gotoxy(0,1); lcd_puts(line);
                    delay_ms(900);
                    lcd_clear();
                    lcd_gotoxy(0,0); lcd_putsf("UID cont.:");
                    sprintf(line,"%02X%02X%02X", uid[4],uid[5],uid[6]);
                    lcd_gotoxy(0,1); lcd_puts(line);
                }
                delay_ms(1200);
            }else{
                lcd_clear(); lcd_putsf("Select failed");
                delay_ms(600);
            }
        }
    }else{
        static uint8_t ui_init = 0;
        static uint8_t spin = 0;
        static const char spch[4] = {'|','/','-','\\'};
        static uint16_t ms_acc = 0;

        if(!ui_init){
            lcd_clear();
            lcd_gotoxy(0,0); lcd_putsf("Searching card");
            ui_init = 1;
        }
        lcd_gotoxy(15,0);
        lcd_putchar(spch[spin++ & 3]);

        if(rc522_request(PICC_REQIDL, atqa)){
            ui_init = 0;
            continue;
        }
        delay_ms(150);
        ms_acc += 150;
        if(ms_acc >= 1500){
            lcd_gotoxy(0,1);
            lcd_putsf("NO CARD       ");
            ms_acc = 0;
        }
    }
    delay_ms(150);
}
}
