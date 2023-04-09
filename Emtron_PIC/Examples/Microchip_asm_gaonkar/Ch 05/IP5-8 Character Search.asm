	Title "IP5-8 - Searching for Character"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file  

BUFFER0	EQU	0x10				;Define data registers address
BUFFER1	EQU 0X11 	
BUFFER2 EQU 0x12 
BUFFER3	EQU	0x13 
BUFFER4	EQU	0x14 

		ORG	0x20				;Begin assembly at 0020H
START:	MOVLW	0x00			;Byte to initialize port as an output
		MOVWF	TRISB 			;Initialize PORTB & PORTC as output ports
		MOVWF	TRISC				
		LFSR	FSR0,BUFFER0	;Initialize FSR0 as a pointer 
NEXT:	MOVLW	0x00			;Test byte for end of string
		CPFSGT  INDF0			;Is this end of string?
		BRA	  	STOP			;Go to display FFH 
		MOVLW	0x20			;Test byte to check
		CPFSEQ	POSTINC0,W		;Check if this 20H and increment pointer
		BRA		NEXT			;If this is not 20H, go back and check next byte
		DECF	FSR0L			;Decrement pointer
		MOVFF	FSR0L, PORTC	;Display register address at PORTB and PORTC
		MOVFF	FSR0H, PORTB
		SLEEP
STOP:	MOVLW	0xFF			;No test byte in string, display all 1ÿ’s 
		MOVWF	PORTC
		SLEEP
		END						;End of assembly


