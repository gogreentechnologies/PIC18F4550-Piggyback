//MPLAB C18 Microchip Inline Assembly
// Page 18 (51288a.pdf)

#include <p18f4550.h>
/*The following lines of code perform interrupt vector relocation to work with the USB bootloader. These must be
used with every application program to run as a USB application.*/
extern void _startup (void);
extern void asm_delay (void);
#pragma code _RESET_INTERRUPT_VECTOR = 0x1000

void _reset (void)
{
	_asm goto _startup _endasm
}

#pragma code
#pragma code _HIGH_INTERRUPT_VECTOR = 0x1008
void high_ISR (void)
{
}

#pragma code
#pragma code _LOW_INTERRUPT_VECTOR = 0x1018
void low_ISR (void)
{
}
#pragma code
/*End of interrupt vector relocation*/
/*Start of main program*/

void main()
{
 
_asm

/* User assembly code */
CLRF  LATA, ACCESS			// Clear PORTA output latch
CLRF  TRISA, ACCESS 		//Make PORTA pins all outputs
MOVLW 0xFF
MOVWF TRISB, ACCESS			// Make PORTB pins all I/P

again:

BTFSC	PORTB,4, ACCESS		// Has PB4 =0
//BTFSS	PORTB,4, ACCESS		// Has PB4 =1
GOTO again

BSF LATA, 4, ACCESS			// LED ON (4 / 5)
//BCF LATB, 4, ACCESS			// LED OFF (4 / 5)
_endasm

 	while(1)
	{}	


}

 