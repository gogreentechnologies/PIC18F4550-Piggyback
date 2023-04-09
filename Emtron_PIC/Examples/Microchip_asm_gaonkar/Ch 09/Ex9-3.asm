	Title "Ex9-3 LED Display"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	    ;This is a header file for PIC18F452

	CLRF	PORTC	; Clear PORTC
	CLRF	TRISC	; Load all 0's in TRISC to set up PORTC as an output port
	MOVLW 	0xAA	; Load appropriate bit pattern in W register
	MOVWF   PORTC	; Turn on corresponding LEDs
	END
