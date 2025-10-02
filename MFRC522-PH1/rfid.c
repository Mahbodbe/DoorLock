#include <mega32.h>
#include <spi.h>
#include <delay.h>
#include "rfid.h"

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
#define CollReg          0x0E
#define ModeReg          0x11
#define TxControlReg     0x14
#define TxASKReg         0x15
#define CRCResultRegH    0x21
#define CRCResultRegL    0x22
#define TModeReg         0x2A
#define TPrescalerReg    0x2B
#define TReloadRegH      0x2C
#define TReloadRegL      0x2D

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

/* --- MIFARE Classic --- */
#define MF_AUTH_KEY_A    0x60
#define MF_READ          0x30
#define MF_WRITE         0xA0

/* --- Default Key A --- */
static uchar keyA[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};

/* --- CS helpers --- */
static void cs_low(void){  RC522_CS_PORT &= ~(1<<RC522_CS_BIT); }
static void cs_high(void){ RC522_CS_PORT |=  (1<<RC522_CS_BIT); }

/* ===== Low-level R/W ===== */
void rc522_write(uchar reg, uchar val){
    cs_low(); spi((reg<<1)&0x7E); spi(val); cs_high();
}
uchar rc522_read(uchar reg){
    uchar v;
    cs_low(); spi(((reg<<1)&0x7E)|0x80); v=spi(0x00); cs_high();
    return v;
}
void set_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)|mask); }
void clr_bit_mask(uchar reg, uchar mask){ rc522_write(reg, rc522_read(reg)&(~mask)); }

/* ===== CRC_A ===== */
static void rc522_calc_crc(uchar *data, uchar len, uchar *crc2){
    uchar i;
    rc522_write(CommandReg, PCD_Idle);
    set_bit_mask(FIFOLevelReg, 0x80);
    for(i=0;i<len;i++) rc522_write(FIFODataReg, data[i]);
    rc522_write(CommandReg, PCD_CalcCRC);
    for(i=0;i<255;i++){ if(rc522_read(DivIrqReg) & 0x04) break; }
    crc2[0]=rc522_read(CRCResultRegL);
    crc2[1]=rc522_read(CRCResultRegH);
}

/* ===== Transceive ===== */
static uchar rc522_transceive(uchar *send, uchar sendLen, uchar *back, uchar *backBits){
    uchar i, n, lastBits;
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
    if(!i) return MI_TIMEOUT;
    if(rc522_read(ErrorReg)&0x1B) return MI_COMM_ERR;
    n = rc522_read(FIFOLevelReg);
    lastBits = rc522_read(ControlReg) & 0x07;
    if(backBits){
        if(lastBits) *backBits = (n-1)*8 + lastBits;
        else         *backBits = n*8;
    }
    for(i=0;i<n;i++) back[i]=rc522_read(FIFODataReg);
    return MI_OK;
}

/* ===== Init ===== */
void rc522_init(void){
    RC522_CS_DDR  |= (1<<RC522_CS_BIT);
    RC522_CS_PORT |= (1<<RC522_CS_BIT);
    rc522_write(CommandReg,PCD_SoftReset);
    delay_ms(50);
    rc522_write(TModeReg,      0x8D);
    rc522_write(TPrescalerReg, 0x3E);
    rc522_write(TReloadRegL,   30);
    rc522_write(TReloadRegH,   0);
    rc522_write(TxASKReg,      0x40);
    rc522_write(ModeReg,       0x3D);
    if(!(rc522_read(TxControlReg)&0x03)) set_bit_mask(TxControlReg,0x03);
}

/* ===== REQA / Anticoll / Select ===== */
uchar rc522_request(uchar reqMode, uchar *ATQA){
    uchar cmd, back[4], bits, st;
    cmd=reqMode; bits=0;
    rc522_write(BitFramingReg,0x07);
    st = rc522_transceive(&cmd,1,back,&bits);
    rc522_write(BitFramingReg,0x00);
    if(st!=MI_OK) return MI_NOTAGERR;
    if(bits!=16)  return MI_NOTAGERR;
    ATQA[0]=back[0]; ATQA[1]=back[1];
    return MI_OK;
}
static uchar rc522_anticoll_level(uchar level_cmd, uchar *out5){
    uchar cmd[2], back[10], bits, i, st;
    bits=0;
    cmd[0]=level_cmd; cmd[1]=0x20;
    rc522_write(BitFramingReg,0x00);
    rc522_write(CollReg,0x80);
    st = rc522_transceive(cmd,2,back,&bits);
    if(st!=MI_OK) return st;
    if(bits!=40)  return MI_COMM_ERR;
    for(i=0;i<5;i++) out5[i]=back[i];
    return MI_OK;
}
uchar rc522_get_uid(uchar *uid){
    uchar b[5], bcc, i;
    if(rc522_anticoll_level(PICC_ANTICOLL_CL1,b)!=MI_OK) return 0;
    if(b[0]==0x88){
        for(i=0;i<4;i++) uid[i]=b[i+1];
        return 4;
    }else{
        bcc=b[0]^b[1]^b[2]^b[3]; if(bcc!=b[4]) return 0;
        for(i=0;i<4;i++) uid[i]=b[i];
        return 4;
    }
}
static uchar uid_bcc4(uchar *u4){ return (uchar)(u4[0]^u4[1]^u4[2]^u4[3]); }
static uchar rc522_select_level(uchar level_cmd, uchar *uid4, uchar *sak_out){
    uchar f[9], crc[2], back[4], bits, bcc, st;
    bits=0;
    rc522_write(BitFramingReg,0x00);
    bcc = uid_bcc4(uid4);
    f[0]=level_cmd; f[1]=0x70;
    f[2]=uid4[0];   f[3]=uid4[1]; f[4]=uid4[2]; f[5]=uid4[3];
    f[6]=bcc;
    rc522_calc_crc(f,7,crc); f[7]=crc[0]; f[8]=crc[1];
    st = rc522_transceive(f,9,back,&bits);
    if(st!=MI_OK) return st;
    if(bits!=24)  return MI_COMM_ERR;
    *sak_out = back[0];
    return MI_OK;
}
uchar rc522_select(uchar *uid, uchar uid_len, uchar *sak){
    uchar uid4[4];
    if(uid_len==4){
        uid4[0]=uid[0]; uid4[1]=uid[1]; uid4[2]=uid[2]; uid4[3]=uid[3];
        return rc522_select_level(PICC_SELECT_CL1, uid4, sak);
    }
    return MI_COMM_ERR;
}

/* ===== Classic auth/read/write ===== */
uchar mifare_auth_keyA(uchar blockAddr, uchar *uid4){
    uchar i;
    rc522_write(CommandReg, PCD_Idle);
    set_bit_mask(FIFOLevelReg,0x80);
    rc522_write(FIFODataReg, MF_AUTH_KEY_A);
    rc522_write(FIFODataReg, blockAddr);
    for(i=0;i<6;i++) rc522_write(FIFODataReg, keyA[i]);
    for(i=0;i<4;i++) rc522_write(FIFODataReg, uid4[i]);
    rc522_write(CommandReg, PCD_MFAuthent);
    for(i=0;i<200;i++){ if(rc522_read(Status2Reg) & 0x08) return MI_OK; delay_ms(1); }
    return MI_AUTH_ERR;
}
void mifare_stop_crypto(void){
    clr_bit_mask(Status2Reg,0x08);
    rc522_write(CommandReg, PCD_Idle);
}
uchar mifare_read_block(uchar blockAddr, uchar *out16){
    uchar cmd[4], crc[2], back[32], bits, i, st;
    bits=0;
    cmd[0]=MF_READ; cmd[1]=blockAddr;
    rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
    st = rc522_transceive(cmd,4,back,&bits);
    if(st!=MI_OK) return st;
    if(bits<16*8)  return MI_COMM_ERR;
    for(i=0;i<16;i++) out16[i]=back[i];
    return MI_OK;
}
uchar mifare_write_block(uchar blockAddr, uchar *data16){
    uchar cmd[4], crc[2], ack[8], bits, frame[18], i, st;
    bits=0;
    cmd[0]=MF_WRITE; cmd[1]=blockAddr;
    rc522_calc_crc(cmd,2,crc); cmd[2]=crc[0]; cmd[3]=crc[1];
    st = rc522_transceive(cmd,4,ack,&bits);
    if(st!=MI_OK) return st;
    if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return MI_COMM_ERR;
    for(i=0;i<16;i++) frame[i]=data16[i];
    rc522_calc_crc(data16,16,crc); frame[16]=crc[0]; frame[17]=crc[1];
    st = rc522_transceive(frame,18,ack,&bits);
    if(st!=MI_OK) return st;
    if((bits!=4) || ((ack[0]&0x0F)!=0x0A)) return MI_COMM_ERR;
    return MI_OK;
}
