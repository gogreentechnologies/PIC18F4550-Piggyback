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
unsigned int count =0000;

 
_asm

/* User assembly code */
CLRF  LATA, ACCESS
CLRF  TRISA, ACCESS 

again:

MOVLW 0xFF
MOVWF LATA, ACCESS

CALL delay, BANKED  
 
MOVLW 0x00
MOVWF LATA, ACCESS

CALL delay, BANKED 

_endasm

 
_asm
delay:
MOVWF count, 0
loop1:
 
 DECFSZ count, 1, 0
 GOTO loop1
 RETURN BANKED   

_endasm
	while(1)
	{}	


}

