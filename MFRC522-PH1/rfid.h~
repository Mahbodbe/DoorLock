#ifndef _RFID_H_
#define _RFID_H_

#include <stdint.h>

/* --- Chip Select wiring (match your board) --- */
#define RC522_CS_PORT PORTB
#define RC522_CS_DDR  DDRB
#define RC522_CS_BIT  4   /* PB4 (SS/SDA) */

/* --- ISO14443A/PICC --- */
#define PICC_REQIDL        0x26
#define PICC_ANTICOLL_CL1  0x93
#define PICC_ANTICOLL_CL2  0x95
#define PICC_SELECT_CL1    0x93
#define PICC_SELECT_CL2    0x95

/* Status codes */
#define MI_OK           0
#define MI_NOTAGERR     1
#define MI_TIMEOUT      2
#define MI_COMM_ERR     3
#define MI_BUFFER_ERR   4
#define MI_UNKNOWN_ERR  5
#define MI_AUTH_ERR     6

typedef unsigned char uchar;

/* High-level API (same naming/style that worked for you) */
void  rc522_init(void);
uchar rc522_request(uchar reqMode, uchar* ATQA);          /* REQA/WUPA */
uchar rc522_get_uid(uchar* uid);                           /* 4B or 7B */
uchar rc522_select(uchar* uid, uchar uid_len, uchar* sak); /* SAK out */

uchar mifare_auth_keyA(uchar blockAddr, uchar* uid4);
void  mifare_stop_crypto(void);
uchar mifare_read_block(uchar blockAddr, uchar* out16);
uchar mifare_write_block(uchar blockAddr, uchar* data16);

/* Low-level (used inside driver; exposed if needed) */
void  rc522_write(uchar reg, uchar val);
uchar rc522_read(uchar reg);
void  set_bit_mask(uchar reg, uchar mask);
void  clr_bit_mask(uchar reg, uchar mask);

#endif
