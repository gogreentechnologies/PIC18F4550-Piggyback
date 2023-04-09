
#include <p18f4550.h> // Always include the header file

  // Oscillator Diagram Page-25
  // Configuration Bits Page 288
  // HS means 20 MHz
#pragma config FOSC = HSPLL_HS    // Primary Oscillator OSC1, OSC2 using 20 MHz crystal with PLL
#pragma config PLLDIV = 5         // 20 MHz crystal Divide by 5 to provide4 MHz input to generate 96 MHz/2 PLL clock O/P for USB (Page 32 Table 2-3 1st row
#pragma config CPUDIV = OSC1_PLL2 // Divide 96 MHz PLL output by 2 to get 48 MHz system clock maximum (primary Clock)
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



 
void main(void)
{
	unsigned int timerValue = 0;
	unsigned char* timerValuePtr = 0;
	
	// T0CON: TIMER0 CONTROL REGISTER Page 127
    T0CONbits.TMR0ON = 0; // Stop the timer
    T0CONbits.T08BIT = 0; // Run in 16-bit mode
    T0CONbits.T0CS = 0;   // Use system clock to increment timer
    T0CONbits.PSA = 0;    // A prescaler is assigned for Timer0
    T0CONbits.T0PS2 = 1;  // Use a 1:256 prescaler
    T0CONbits.T0PS1 = 1;
    T0CONbits.T0PS0 = 1;
    
    INTCONbits.GIEH = 0;
    INTCONbits.TMR0IE = 0;
    INTCONbits.TMR0IF = 0;
    
    T0CONbits.TMR0ON = 1; // Start the timer
	
	
	TRISAbits.TRISA4 = 0; // Configure RA4, as an output   // LED configuration
	TRISBbits.TRISB0 = 0; // Configure RB0, as an output    
	
    while(1) // Program loop
    {
	    timerValuePtr = (unsigned char*)&timerValue;
		*timerValuePtr = TMR0L;
		timerValuePtr++;
		*timerValuePtr = TMR0H;
		
		if(timerValue >= 23441) // 	FOSC  = 48 Mhz; it lways divide by FOSC/4
								//  TCY = 4/FOSC = 4/48MHz ~= 83.33 ns. 
								//Timer increments every 83.33 ns * prescaler = 83.33 ns * 256 = 21.33 uS. 
		{				  		// So, for a half second delay, the timer value would be .5/(21.33 uS) ~= 23441.
			
			LATAbits.LATA4 ^= 1; // RA4, pin 2	
			LATBbits.LATB0 ^= 1; // B0
			
			
			timerValue = 0;
			TMR0H = 0;
			TMR0L = 0;
		}
    }
}
