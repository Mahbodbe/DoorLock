#include <mega32.h>
#include <delay.h>
#include <alcd.h>
#include <stdint.h>

volatile uint8_t control = 0;
volatile uint8_t controlL = 0;
volatile uint8_t counter = 0;
volatile uint8_t isBuzz1 = 0;
volatile uint8_t isBuzz2 = 0;
volatile uint8_t selectorT = 0;
volatile uint8_t selectorL = 0;
volatile uint8_t controlMenu = 0;
volatile uint8_t check = 0;
volatile uint8_t temp = 0;
volatile uint8_t t_temp = 0;


int ChooseMenu(void){
    if (controlMenu == 0){
        if (selectorT == 0){  
            lcd_gotoxy(0,0); lcd_putsf(">DisArm");
            lcd_gotoxy(0,1); lcd_putsf("Arm");
            return 0;
        }
        else if(selectorT == 1){ 
            lcd_gotoxy(0,0); lcd_putsf("DisArm");
            lcd_gotoxy(0,1); lcd_putsf(">Arm");
            return 1;
        }
    }
    else if(controlMenu == 1){
        if(selectorL == 0){  
            lcd_gotoxy(0,0); lcd_putsf(">Laser sense");
            lcd_gotoxy(0,1); lcd_putsf("Movement sense"); 
            return 2;
        }
        else if(selectorL == 1){
            lcd_gotoxy(0,0); lcd_putsf("Laser sense");
            lcd_gotoxy(0,1); lcd_putsf(">Movement sense");
            return 3;
        }
        else if(selectorL == 2){
            lcd_gotoxy(0,0); lcd_putsf("Movement sense");
            lcd_gotoxy(0,1); lcd_putsf(">Both");    
            return 4;
        }
    }
    
    return -1;
    
}

void LDR(int v){

    if(v > 500){ 
        
        PORTB |= (PORTB1 << 1); 
        delay_ms(115);
        PORTD |= (1 << PORTD5); 
        isBuzz1 = 1;
        }
    else{
        PORTB &= ~(PORTB1 << 1);
        if(isBuzz2 == 0)
            PORTD &= ~(1 << PORTD5);  
        isBuzz1 = 0;
        } 

}

void PIR(void) {

    if (PIND & (1 << PORTD7)){
        PORTD |= (1 << PORTD6); 
        delay_ms(115);
        PORTD |= (1 << PORTD5); 
        isBuzz2 = 1;
        }
    else     
    {
        PORTD &= ~(1 << PORTD6);
        if (isBuzz1 == 0)
            PORTD &= ~(1 << PORTD5 );
        isBuzz2 = 0;
    }   

}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    if (control == 0 ){
        selectorT += 1;
        if(selectorT == 2)
            selectorT = 0; 
    }
    else if (control == 1){
        selectorL += 1;
        if(selectorL == 3)
            selectorL = 0;
    }      
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{

check = 1;

}

interrupt [EXT_INT2] void ext_int2_isr(void)
{

control += 1;
if (control == 2)
    control = 0;   


}

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
delay_us(10);
ADCSRA|=(1<<ADSC);
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void main(void)
{
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
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
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

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

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

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
MCUCSR |= (1<<JTD);
MCUCSR |= (1<<JTD);

delay_ms(30);
lcd_init(16);


// Global enable interrupts
#asm("sei")


while (1)
      {        
      temp = ChooseMenu(); 
      if(temp != t_temp)
        lcd_clear(); 
      
      switch(temp){
        case 0: 
            if(check == 1){
                PORTD |= (1 << PORTD5);
                delay_ms(10);
                PORTD &= ~(1 << PORTD5 ); 
                check = 0;
            }
            break;            
        case 1:   
            if(check == 1){
                controlMenu = 1;
                PORTD |= (1 << PORTD5);
                delay_ms(10);
                PORTD &= ~(1 << PORTD5);
                check = 0; 
            }
            break;            
        case 2: 
          if(control == 1){  
            unsigned int v = read_adc(0);
            PORTD &= ~(1 << PORTD6); 
            PORTB |= (1 << PORTB0); 
            LDR(v);
            delay_ms(100);    
            }
          else{
            PORTB &= ~(PORTB1 << 1);
            PORTB &= ~(1 << PORTB0);
            PORTD &= ~(1 << PORTD5);
            PORTD &= ~(1 << PORTD6); 
            controlMenu = 0; 
          } 
          break;                                                             
        case 3:
          if(control == 1){
            PORTB &= ~(PORTB1 << 1);
            PORTB &= ~(1 << PORTB0); 
            PORTD |= (1 << PORTD4); 
            PIR();
            delay_ms(100);    
            }
          else{
            PORTB &= ~(PORTB1 << 1);
            PORTB &= ~(1 << PORTB0);
            PORTD &= ~(1 << PORTD5);
            PORTD &= ~(1 << PORTD6);
            controlMenu = 0;  
          }     
          break; 
        case 4: 
        
          if(control == 1){  
            unsigned int v = read_adc(0);
            PORTB |= (1 << PORTB0); 
            LDR(v);
            PORTD |= (1 << PORTD4); 
            PIR();
            delay_ms(100);    
            }
          else{
            PORTB &= ~(PORTB1 << 1);
            PORTB &= ~(1 << PORTB0);
            PORTD &= ~(1 << PORTD5);
            PORTD &= ~(1 << PORTD4);
            PORTD &= ~(1 << PORTD6); 
            controlMenu = 0; 
          }  
          break;
      }
      

      delay_ms(10);
      t_temp = temp;
      }
}
