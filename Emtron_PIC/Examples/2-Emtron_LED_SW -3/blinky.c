 /***************************************************************************************************/
/* This program interfaces 4 switches and 2 LED's */
/* The LED's glow based on the switch inputs      */ 
/**************************************************************************************************/


#include <p18f4550.h>

/*The following lines of code perform interrupt vector relocation to work with the USB bootloader. These must be
used with every application program to run as a USB application.*/

extern void _startup (void);
#pragma code _RESET_INTERRUPT_VECTOR = 0x1000

void _reset (void)
{
        _asm goto _startup _endasm
}

#pragma code

#pragma code _LOW_INTERRUPT_VECTOR = 0x1018
void low_ISR (void)
{
}
#pragma code


#pragma code _HIGH_INTERRUPT_VECTOR = 0x1008
void high_ISR (void)
{
       
}
#pragma code

// Delay function 
void myMsDelay (unsigned int time)
{
        unsigned int i, j;
        for (i = 0; i < time; i++)
                for (j = 0; j < 710; j++);
}



void main(void)
{
       TRISA=0x00;			// PORTA = O/P
       TRISC=0xFF;          // Configures RC0, RC1, RC2, RC4 as inputs to which the switches are connected and RA4, RA5 as ouputs to which LEDS are connected
      
        while(1)
        {
 		/*	 PORTA = 0xFF;	
               	myMsDelay(1000);
         	 PORTA = ~(PORTC << 4);  // Left shifting the status of the keys to display on the LED's
				myMsDelay(1000);
         */
			 PORTA = 0xFF;
			 myMsDelay(500);
		     PORTAbits.RA4 = PORTCbits.RC0; 
             PORTAbits.RA5 = PORTCbits.RC1; 
   		      myMsDelay(500);
    	}

}



