 /***************************************************************************************************/
/* This program interfaces Boot SW switch and 1 LED */
/* The LED's glow based on the switch input      */ 
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
       TRISB=0x10;          // Configure PORTB.4 as I/P
      
        while(1)
        {
 	
			 PORTAbits.RA4 = PORTBbits.RB4; 
             
    	}

}



