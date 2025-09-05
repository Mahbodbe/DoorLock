#include <mega32.h>
#include <delay.h>
#include <alcd.h>
#include <stdint.h>

// PB7 = SCK, PB5 = MOSI, PB4 = SS
#define PIN_SCK PORTB7
#define PIN_MOSI PORTB5
#define PIN_SS PORTB4

void test_pin(uint8_t pin, char *name){
    lcd_clear();
    lcd_puts("Test pin: ");
    lcd_puts(name);

    // High 
    PORTB |= (1<<pin);
    delay_ms(2000);

    //  Low 
    PORTB &= ~(1<<pin);
    delay_ms(2000);
}

void main(void){
    SPCR = 0x00;

    // LCD init
    lcd_init(16);
    lcd_clear();
    lcd_puts("Pin Voltage Test");
    delay_ms(2000);

    DDRB |= (1<<PIN_SCK) | (1<<PIN_MOSI) | (1<<PIN_SS);

    while(1){
        test_pin(PIN_SCK, "SCK (PB7)");
        test_pin(PIN_MOSI, "MOSI (PB5)");
        test_pin(PIN_SS, "SS (PB4)");
    }
}