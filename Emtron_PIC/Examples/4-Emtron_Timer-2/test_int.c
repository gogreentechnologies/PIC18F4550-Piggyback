/********************************************************************/
//This program demonstrates the use of timer interrupts  		   //								                                                     */
/******************************************************************/


#include <p18f4550.h>
void myMsDelay (unsigned int time);

/*The following lines of code perform interrupt vector relocation to work with the USB bootloader. These must be
used with every application program to run as a USB application.*/
extern void _startup (void);
void timer_isr(void);


#pragma code _RESET_INTERRUPT_VECTOR = 0x1000
void _reset (void)
{
	_asm goto _startup _endasm

}
#pragma code
//The program execution comes to this point when a timer interrupt is generated
#pragma code _HIGH_INTERRUPT_VECTOR = 0x1008
void high_ISR (void)
{
	
	_asm goto timer_isr _endasm    //The program is relocated to execute the interrupt routine timer_iser

}
//
#pragma code
//
#pragma code _LOW_INTERRUPT_VECTOR = 0x1018
 void low_ISR (void)
{

}
#pragma code
// This function is executed as soon as the timer interrupt is generated due to timer overflow
#pragma interrupt timer_isr
void timer_isr(void)
{
unsigned int i, j;
	TMR0H = 0XFF;                         // Reloading the timer values after overflow
	TMR0L = 0XF0;
	
		LATA = 0x30;/*Toggling Port A pins*/
		myMsDelay(100);
		LATA = 0x00;
		myMsDelay(100);

	 
 	INTCONbits.TMR0IF = 0;	             //Resetting the timer overflow interrupt flag

}

void myMsDelay (unsigned int time)
{
	unsigned int i, j;
	for (i = 0; i < time; i++)
		for (j = 0; j < 710; j++);/*Calibrated for a 1 ms delay in MPLAB*/
}

void main()
{	
unsigned char config;

	TRISA = 0x00;                  //Configruing the LED port pins as outputs
	T0CON = 0x07;				//Set the timer to 16-bit mode,internal instruction cycle clock,1:256 prescaler

  	TMR0H = 0xFF;                // Reset Timer0 to 0x3500
  	TMR0L = 0xF0;
   	INTCONbits.TMR0IF = 0;      // Page - 101 Clear Timer0 overflow flag
	INTCONbits.TMR0IE = 1;		// TMR0 interrupt enabled
 	T0CONbits.TMR0ON = 1;		// Start timer0
	INTCONbits.GIE = 1;			// Global interrupt enabled

	myMsDelay(1);
while(1);                      //Program execution stays here untill the timer overflow interrupt is generated

}

