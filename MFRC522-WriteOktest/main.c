#include <mega32.h>
#include <alcd.h>
#include <spi.h>
#include <stdio.h>
#include <delay.h>
#include <stdint.h>

/* --- Pins --- */
#define RC522_CS_PORT PORTB
#define RC522_CS_DDR  DDRB
#define RC522_CS_PIN  PORTB4

/* --- RC522 regs --- */
#define CommandReg       0x01
#define ComIEnReg        0x02
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
#define CRCResultRegH    0x21
#define CRCResultRegL    0x22
#define CollReg          0x0E

/* --- RC522 cmds --- */
#define PCD_Idle         0x00
#define PCD_CalcCRC      0x03
#define PCD_Transceive   0x0C
#define PCD_SoftReset    0x0F
#define PCD_MFAuthent    0x0E

/* --- ISO14443A/PICC --- */
#define PICC_REQIDL        0x26
#define PICC_ANTICOLL_CL1  0x93
#define PICC_ANTICOLL_CL2  0x95
#define PICC_SELECT_CL1    0x93
#define PICC_SELECT_CL2    0x95

/* --- Classic/Type2 cmds we use here (Classic only in this sketch) --- */
#define MF_AUTH_KEY_A    0x60
#define MF_READ          0x30
#define MF_WRITE         0xA0

/* --- Strings in flash --- */
static flash char S_C1K[]="MIFARE Classic 1K";
static flash char S_C4K[]="MIFARE Classic 4K";
static flash char S_UL []="Ultralight/NTAG";
static flash char S_UNK[]="Unknown/other";

/* --- Default Key A --- */
static uint8_t keyA[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

/* ===== SPI chip-select ===== */
static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_PIN); }
static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_PIN); }

/* ===== RC522 R/W ===== */
static void rc522_write(uint8_t reg, uint8_t val){
    cs_low(); spi((reg<<1)&0x7E); spi(val); cs_high();
}
static uint8_t rc522_read(uint8_t reg){
    uint8_t v;
    cs_low(); spi(((reg<<1)&0x7E)|0x80); v=spi(0x00); cs_high();
    return v;
}
static void set_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)|mask); }
static void clr_bit_mask(uint8_t reg, uint8_t mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }

/* ===== Init ===== */
static void rc522_soft_reset(void){ rc522_write(CommandReg,PCD_SoftReset); delay_ms(50); }
static void rc522_antenna_on(void){ if(!(rc522_read(TxControlReg)&0x03)) set_bit_mask(TxControlReg,0x03); }
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

/* ===== CRC_A ===== */
static void rc522_calc_crc(uint8_t *data, uint8_t len, uint8_t *crc2){
    uint8_t i;
    rc522_write(CommandReg, PCD_Idle);
    set_bit_mask(FIFOLevelReg, 0x80);
    for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
    rc522_write(CommandReg, PCD_CalcCRC);
    for(i=0;i<255;i++){ if(rc522_read(DivIrqReg) & 0x04) break; }
    crc2[0]=rc522_read(CRCResultRegL);
    crc2[1]=rc522_read(CRCResultRegH);
}

/* ===== Transceive ===== */
static uint8_t rc522_transceive(uint8_t *send, uint8_t sendLen, uint8_t *back, uint8_t *backBits){
    uint8_t i, n, lastBits;
    rc522_write(ComIEnReg, 0x77 | 0x80);
    clr_bit_mask(ComIrqReg, 0x80);
    set_bit_mask(FIFOLevelReg, 0x80);
    rc522_write(CommandReg, PCD_Idle);
    for(i=0;i<sendLen;i++) rc522_write(FIFODataReg, send[i]);
    rc522_write(CommandReg, PCD_Transceive);
    set_bit_mask(BitFramingReg, 0x80);
    i=200;
    do{ n=rc522_read(ComIrqReg); }while(--i && !(n&0x30));
    clr_bit_mask(BitFramingReg,0x80);
    if(!i) return 0;
    if(rc522_read(ErrorReg)&0x1B) return 0;
    n = rc522_read(FIFOLevelReg);
    lastBits = rc522_read(ControlReg) & 0x07;
    if(backBits){
        if(lastBits) *backBits = (n-1)*8 + lastBits;
        else         *backBits = n*8;
    }
    for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
    return 1;
}

/* ===== REQA / Anticoll / Select ===== */
static uint8_t rc522_request(uint8_t reqMode, uint8_t *ATQA){
    uint8_t cmd, back[4], bits;
    cmd=reqMode; bits=0;
    rc522_write(BitFramingReg,0x07);
    if(!rc522_transceive(&cmd,1,back,&bits)) return 0;
    rc522_write(BitFramingReg,0x00);
    if(bits!=16) return 0;
    ATQA[0]=back[0]; ATQA[1]=back[1];
    return 1;
}
static uint8_t rc522_anticoll_level(uint8_t level_cmd, uint8_t *out5){
    uint8_t cmd[2], back[10], bits, i;
    bits=0;
    cmd[0]=level_cmd; cmd[1]=0x20;
    rc522_write(BitFramingReg,0x00);
    rc522_write(CollReg,0x80);
    if(!rc522_transceive(cmd,2,back,&bits)) return 0;
    if(bits!=40) return 0;
    for(i=0;i<5;i++) out5[i]=back[i];
    return 1;
}
static uint8_t rc522_get_uid(uint8_t *uid){
    uint8_t b[5], bcc, i, len;
    len=0;
    if(!rc522_anticoll_level(PICC_ANTICOLL_CL1,b)) return 0;
    if(b[0]==0x88){
        uid[0]=b[1]; uid[1]=b[2]; uid[2]=b[3];
        if(!rc522_anticoll_level(PICC_ANTICOLL_CL2,b)) return 0;
        bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
        uid[3]=b[0]; uid[4]=b[1]; uid[5]=b[2]; uid[6]=b[3];
        len=7;
    }else{
        bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
        for(i=0;i<4;i++) uid[i]=b[i];
        len=4;
    }
    return len;
}
static uint8_t uid_bcc4(uint8_t *u4){ return (uint8_t)(u4[0]^u4[1]^u4[2]^u4[3]); }
static uint8_t rc522_select_level(uint8_t level_cmd, uint8_t *uid4, uint8_t *sak_out){
    uint8_t f[9], crc[2], back[4], bits, bcc;
    bits=0;
    rc522_write(BitFramingReg,0x00);
    bcc=uid_bcc4(uid4);
    f[0]=level_cmd; f[1]=0x70;
    f[2]=uid4[0];   f[3]=uid4[1]; f[4]=uid4[2]; f[5]=uid4[3];
    f[6]=bcc; rc522_calc_crc(f,7,crc); f[7]=crc[0]; f[8]=crc[1];
    if(!rc522_transceive(f,9,back,&bits)) return 0;
    if(bits!=24) return 0;
    *sak_out=back[0]; return 1;
}
static uint8_t rc522_select(uint8_t *uid, uint8_t uid_len, uint8_t *sak){
    uint8_t uid4[4], tmp;
    if(uid_len==4){
        uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
        return rc522_select_level(PICC_SELECT_CL1, uid4, sak);
    }else if(uid_len==7){
        uid4[0]=0x88; uid4[1]=uid[0]; uid4[2]=uid[1]; uid4[3]=uid[2];
        if(!rc522_select_level(PICC_SELECT_CL1, uid4, &tmp)) return 0;
        uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6];
        return rc522_select_level(PICC_SELECT_CL2, uid4, sak);
    }
    return 0;
}

/* ===== Type detection ===== */
static void lcd_puts_flash(flash char* s){ char c; while((c=*s++)) lcd_putchar(c); }
static flash char* type_from_sak(uint8_t sak){
    uint8_t s; s = sak & 0xFC;
    if(s==0x08) return S_C1K;
    if(s==0x18) return S_C4K;
    if(s==0x00) return S_UL;
    return S_UNK;
}

/* ===== Classic auth/read/write ===== */
static uint8_t mifare_auth_keyA(uint8_t blockAddr, uint8_t *uid4){
    uint8_t i;
    rc522_write(CommandReg, PCD_Idle);
    set_bit_mask(FIFOLevelReg,0x80);
    rc522_write(FIFODataReg, MF_AUTH_KEY_A);
    rc522_write(FIFODataReg, blockAddr);
    for(i=0;i<6;i++) rc522_write(FIFODataReg, keyA[i]);
    for(i=0;i<4;i++) rc522_write(FIFODataReg, uid4[i]);
    rc522_write(CommandReg, PCD_MFAuthent);
    for(i=0;i<200;i++){ if(rc522_read(Status2Reg) & 0x08) return 1; delay_ms(1); }
    return 0;
}
static void mifare_stop_crypto(void){
    clr_bit_mask(Status2Reg,0x08);
    rc522_write(CommandReg, PCD_Idle);
}
static uint8_t mifare_read_block(uint8_t blockAddr, uint8_t *out16){
    uint8_t cmd[4], crc[2], back[32], bits, i;
    bits=0;
    cmd[0]=MF_READ; cmd[1]=blockAddr;
    rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
    if(!rc522_transceive(cmd,4,back,&bits)) return 0;
    if(bits<16*8) return 0;
    for(i=0;i<16;i++) out16[i]=back[i];
    return 1;
}
static uint8_t mifare_write_block(uint8_t blockAddr, uint8_t *data16){
    uint8_t cmd[4], crc[2], ack[8], bits, frame[18], i;
    bits=0;
    cmd[0]=MF_WRITE; cmd[1]=blockAddr;
    rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
    if(!rc522_transceive(cmd,4,ack,&bits)) return 0;
    if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return 0;
    for(i=0;i<16;i++) frame[i]=data16[i];
    rc522_calc_crc(data16,16,crc); frame[16]=crc[0]; frame[17]=crc[1];
    if(!rc522_transceive(frame,18,ack,&bits)) return 0;
    if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return 0;
    return 1;
}

/* ===== Helpers for LCD formatting ===== */
static void print_hex8_line(uint8_t *buf){
    char line[21];
    uint8_t i;
    line[0]=0; /* clear */
    for(i=0;i<8;i++){
        sprintf(line+2*i,"%02X", buf[i]);
    }
    lcd_puts(line);
}
static void print_ascii8_line(uint8_t *buf){
    char line[17];
    uint8_t i;
    for(i=0;i<8;i++){
        uint8_t c = buf[i];
        if(c<0x20 || c>0x7E) line[i]='.';
        else line[i]=(char)c;
    }
    line[8]=0;
    lcd_puts(line);
}

/* ===== main ===== */
void main(void){
    char line[21];
    uint8_t atqa[2];
    uint8_t uid[10], uid_len, sak;
    uint8_t i;
    flash char* type_str;

    /* MCU & SPI basic init (CodeVision style) */
    DDRA=0x00; PORTA=0x00;
    DDRB=(1<<DDB7)|(1<<DDB5)|(1<<DDB4); PORTB=0x00;
    DDRC=0x00; PORTC=0x00;
    DDRD=0x00; PORTD=0x00;
    TCCR0=0; TCCR1A=0; TCCR1B=0; TCCR2=0; TIMSK=0;
    MCUCR=0; MCUCSR=0;
    UCSRB=0;
    ACSR=(1<<ACD); SFIOR=0;
    ADCSRA=0;
    SPCR=(1<<SPE)|(1<<MSTR)|(1<<SPR1); SPSR=0;

    RC522_CS_DDR |= (1<<RC522_CS_PIN);
    RC522_CS_PORT |= (1<<RC522_CS_PIN);

    lcd_init(16);
    lcd_clear(); lcd_putsf("RC522 Ready");
    delay_ms(300);

    rc522_init();

    while(1){
        uint8_t ok;
        uint8_t uid4[4];
        uint8_t blk = 4;
        uint8_t old16[16];
        uint8_t write16[16] = {'W','R','I','T','E','_','T','E','S','T','_','1','2','3','4','!'};
        uint8_t read16[16];
        uint8_t match;

        lcd_clear(); lcd_putsf("Scan a card...");
        delay_ms(150);
        if(!rc522_request(PICC_REQIDL, atqa)) { delay_ms(200); continue; }

        uid_len = rc522_get_uid(uid);
        ok = rc522_select(uid, uid_len, &sak);
        if(!uid_len || !ok){
            lcd_clear(); lcd_putsf("Select failed");
            delay_ms(600);
            continue;
        }

        type_str = type_from_sak(sak);
        lcd_clear(); lcd_puts_flash(type_str);
        sprintf(line,"SAK:%02X", sak);
        lcd_gotoxy(0,1); lcd_puts(line);
        delay_ms(500);

        lcd_clear();
        if(uid_len==4){
            sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
            lcd_gotoxy(0,0); lcd_puts(line);
        }else{
            sprintf(line,"UID:%02X%02X%02X%02X", uid[0],uid[1],uid[2],uid[3]);
            lcd_gotoxy(0,0); lcd_puts(line);
            sprintf(line,"%02X%02X%02X", uid[4],uid[5],uid[6]);
            lcd_gotoxy(0,1); lcd_puts(line);
        }
        delay_ms(700);

        if((sak&0xFC)!=0x08 && (sak&0xFC)!=0x18){
            lcd_clear(); lcd_putsf("Only Classic RW");
            delay_ms(1000);
            continue;
        }

        if(uid_len==7){ uid4[0]=uid[3]; uid4[1]=uid[4]; uid4[2]=uid[5]; uid4[3]=uid[6]; }
        else          { uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3]; }

        lcd_clear(); lcd_putsf("Auth B4...");
        if(!mifare_auth_keyA(blk,uid4)){
            lcd_clear(); lcd_putsf("Auth FAIL");
            delay_ms(900);
            continue;
        }

        if(!mifare_read_block(blk,old16)){
            lcd_clear(); lcd_putsf("Read Err");
            mifare_stop_crypto(); delay_ms(900); continue;
        }

        lcd_clear(); lcd_putsf("Write+Read...");
        if(!mifare_write_block(blk,write16)){
            lcd_clear(); lcd_putsf("Write FAIL");
            mifare_stop_crypto(); delay_ms(900); continue;
        }
        if(!mifare_read_block(blk,read16)){
            lcd_clear(); lcd_putsf("Re-read FAIL");
            mifare_stop_crypto(); delay_ms(900); continue;
        }
        mifare_stop_crypto();

        match=1;
        for(i=0;i<16;i++){ if(read16[i]!=write16[i]){ match=0; break; } }

        /* Show HEX (first 8 bytes) */
        lcd_clear();
        lcd_putsf(match? "MATCH HEX:" : "MISMATCH HEX:");
        lcd_gotoxy(0,1);
        print_hex8_line(read16);
        delay_ms(1200);

        /* Show ASCII (first 8 bytes) */
        lcd_clear();
        lcd_putsf("ASCII:");
        lcd_gotoxy(0,1);
        print_ascii8_line(read16);
        delay_ms(1200);

        /* Show next 8 bytes HEX */
        lcd_clear();
        lcd_putsf("HEX[8..15]:");
        lcd_gotoxy(0,1);
        print_hex8_line(read16+8);
        delay_ms(1200);

        /* Show next 8 bytes ASCII */
        lcd_clear();
        lcd_putsf("ASCII[8..]:");
        lcd_gotoxy(0,1);
        print_ascii8_line(read16+8);
        delay_ms(1200);

        /* Optional restore original content */
         if(mifare_auth_keyA(blk,uid4)){ mifare_write_block(blk,old16); mifare_stop_crypto(); }
    }
}