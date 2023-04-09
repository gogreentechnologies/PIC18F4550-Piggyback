#include "p18f4550.h"
// Programming using PICKIT-3 
/***************************
*   Device configuration   *
***************************/
#pragma config FOSC = HSPLL_HS    // Using 20 MHz crystal with PLL
#pragma config PLLDIV = 5         // Divide by 5 to provide the 96 MHz PLL with 4 MHz input
#pragma config CPUDIV = OSC1_PLL2 // Divide 96 MHz PLL output by 2 to get 48 MHz system clock
#pragma config FCMEN = OFF // Disable Fail-Safe Clock Monitor
#pragma config IESO = OFF  // Disable Oscillator Switchover mode
#pragma config PWRT = OFF  // Disable Power-up timer
#pragma config BOR = OFF   // Disable Brown-out reset
#pragma config WDT = OFF   // Disable Watchdog timer
#pragma config MCLRE = ON  // Enable MCLR Enable
#pragma config LVP = OFF   // Disable low voltage ICSP
#pragma config ICPRT = OFF // Disable dedicated programming port (only on 44-pin devices)
#pragma config CP0 = OFF   // Disable code protection

/***************************
*    Function Prototypes   *
***************************/
void config(void);

void main (void)
{
    config();
    
    while(1)
    {
        // program loop
    }    
}

void config (void)
{
    // USART configuration
    TXSTAbits.TX9  = 0;    // PAGE-240 8-bit transmission
    TXSTAbits.TXEN = 1;    // transmit enabled
    TXSTAbits.SYNC = 0;    // asynchronous mode
    TXSTAbits.BRGH = 0;    // high speed
    RCSTAbits.SPEN = 1;    // enable serial port (configures RX/DT and TX/CK pins as serial port pins)
    RCSTAbits.RX9  = 0;    // 8-bit reception
    RCSTAbits.CREN = 1;    // enable receiver
    BAUDCONbits.BRG16 = 0; // 8-bit baud rate generator
    SPBRG = 77;            // 9600 Baud rate calculated using formula from table 20-1 in the PIC18F4550 datasheet
    
    TRISCbits.RC6 = 0; // make the TX pin a digital output
    TRISCbits.RC7 = 1; // make the RX pin a digital input
    
    // interrupts / USART interrupts configuration
    RCONbits.IPEN   = 0; // Page-110 disable interrupt priority
    INTCONbits.GIE  = 1; // Page-101 enable interrupts
    INTCONbits.PEIE = 1; // enable peripheral interrupts.
    PIE1bits.RCIE   = 1; // Page-106 enable USART receive interrupt
}

// start ISR code
#pragma code isr = 0x08 // store the below code at address 0x08
#pragma interrupt isr   // let the compiler know that the function isr() is an interrupt handler

void isr(void)
{
    if(PIR1bits.RCIF == 1) // if the USART receive interrupt flag has been set
    {
        if(PIR1bits.TXIF == 1) // check if the TXREG is empty
        {
            TXREG = RCREG; // echo received data back to sender
        }
    }    
}

#pragma code // return to the default code section
	