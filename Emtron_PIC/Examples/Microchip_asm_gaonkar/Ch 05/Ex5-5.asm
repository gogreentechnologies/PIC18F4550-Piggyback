	Title "PIC18F452 Ex5-5"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file and must be included in the Source Program

REG30	EQU	0x30	;Define data register addresses

		ORG  00
		GOTO 0x20

		ORG	0x20

	MOVLW	0x00		;Initialize all pins of PORTC as outputs
	MOVWF	TRISC
	MOVLW	0x7F		;Load number 7FH in W register
	SUBLW	0x28		;Subtract WREG from 28H and save result in WREG
	MOVWF	PORTC		;Display result at PORTC
	MOVWF	REG30
	END
