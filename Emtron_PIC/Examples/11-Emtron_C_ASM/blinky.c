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
void myMsDelay (unsigned int time)
{
	unsigned int i, j;
	for (i = 0; i < time; i++)
		for (j = 0; j < 710; j++);/*Calibrated for a 1 ms delay in MPLAB*/
}

void main()
{
unsigned int count;
unsigned int milliseconds;
unsigned near char W_TEMP;
 
 
_asm
 
 /* User assembly code */
 MOVLW 10 // Move decimal 10 to count
 MOVWF count, 0
 /* Loop until count is 0 */
 start:
 
 DECFSZ count, 1, 0
 GOTO done
 BRA start
 
 done:

_endasm
 
_asm
   
	MOVLW 0xff
	MOVWF milliseconds, BANKED
	MOVWF TABLAT, ACCESS 
	MOVWF  W_TEMP, BANKED

    RLNCF   PORTA, 1, 0
    RRNCF   PORTA, 1, 0 
	
	MOVWF  0x50, ACCESS 
	SLEEP				
	NOP
_endasm	
	
	while(1)
	{
	}
}

