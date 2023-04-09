	Title "PIC18F452 DAC Ramp Waveform"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file 


REG10	EQU		0x10	;Delay register
COUNT 	EQU		D'100'	;Delay count

		ORG 	0x00
		GOTO	START

		ORG		0x20	
START	CLRF	TRISC	;Initialize PORTC as output 
		MOVLW	B'11111100'	;Set up RE0 and RE1 as output
		ANDWF 	TRISE	;  for control
		BCF		PORTE, RE0	;Access DAC 
		BCF		PORTE, RE1	;Write in DAC and place it in transparent mode
		CLRF	PORTC	;Start with outputting 0V to DAC
CONTINUE:INCF	PORTC	;Next output
		CALL 	DELAY 	;Wait for appropriate slope
		BRA		CONTINUE	;Continue 

;Function: This routine provides delay based on the count supplied to REG10

DELAY:	MOVLW	COUNT	;Load delay count in REG10
		MOVWF	REG10, 0
NEXT:	DECF	REG10,1	;Decrement count
		BNZ		NEXT	;If count is not zero, go back to decrement
		RETURN			;Go back to the caller
		END



