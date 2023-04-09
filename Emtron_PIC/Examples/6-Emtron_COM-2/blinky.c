#include "p18f4550.h"
#include "stdio.h"
  
  // Oscillator Diagram Page-25
  // Configuration Bits Page 288
#pragma config FOSC = HSPLL_HS    // Primary Oscillator OSC1, OSC2 using 20 MHz crystal with PLL
#pragma config PLLDIV = 5         // 20 MHz crystal Divide by 5 to provide4 MHz input to generate 96 MHz/2 PLL clock O/P for USB 
#pragma config CPUDIV = OSC1_PLL2 // Divide 96 MHz PLL output by 2 to get 48 MHz system clock (primary Clock)
#pragma config USBDIV = 2         // USB clock comes from 96 MHz PLL output / 2


#pragma config FCMEN = OFF // Disable Fail-Safe Clock Monitor
#pragma config IESO = OFF  // Disable Oscillator Switchover mode
#pragma config PWRT = OFF  // Disable Power-up timer
#pragma config BOR = OFF   // Disable Brown-out reset
#pragma config VREGEN = ON // Use internal USB 3.3V voltage regulator
#pragma config WDT = OFF   // Disable Watchdog timer
#pragma config MCLRE = ON  // Enable MCLR Enable
#pragma config LVP = OFF   // Disable low voltage ICSP
#pragma config ICPRT = OFF // Disable dedicated programming port (44-pin devices)
#pragma config CP0 = OFF   // Disable code protection
 
/***************************
*    Function Prototypes   *
***************************/
void config(void);

void main (void)
{
   
  int i = 0xA12;
  char buf[20];
  
  config();
  
 

    while(1)
    {
        sprintf (buf, "%#010x", i);
    }    
}

void config (void)
{
    // TXSTA: TRANSMIT STATUS AND CONTROL REGISTER  Page 240 of Data Sheet  
    TXSTAbits.TX9  = 0;    // 8-bit transmission
    TXSTAbits.TXEN = 1;    // transmit enabled
    TXSTAbits.SYNC = 0;    // asynchronous mode
    TXSTAbits.BRGH = 0;    // low speed  formula for baud rate FOSC/[64 (n + 1)]  Page 243 Table 20-1 1st row
    
    // RCSTA: RECEIVE STATUS AND CONTROL REGISTER  Page 241 of Data Sheet  
    RCSTAbits.SPEN = 1;    // enable serial port (configures RX/DT and TX/CK pins as serial port pins)
    RCSTAbits.RX9  = 0;    // 8-bit reception
    RCSTAbits.CREN = 1;    // enable receiver
    
    // BAUDCON: BAUD RATE CONTROL REGISTER Page 242 of Data Sheet  
    BAUDCONbits.BRG16 = 0; // 8-bit baud rate generator
    SPBRG = 77;            // "77" calculated using formula from table 20-3 Page 245 FOSC=48 Mhz  9600 baud rate SPBRG=77 in the PIC18F4550 datasheet
    
    TRISCbits.RC6 = 0; // make the TX pin a digital output  Page 120
    TRISCbits.RC7 = 1; // make the RX pin a digital input
    
    // interrupts / USART interrupts configuration
    RCONbits.IPEN   = 0; // disable interrupt priority
    INTCONbits.GIE  = 0; // enable interrupts
    INTCONbits.PEIE = 0; // enable peripheral interrupts.
    PIE1bits.RCIE   = 0; // enable USART receive interrupt
}