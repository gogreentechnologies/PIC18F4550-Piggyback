	Title "PIC18F452 Ex5-1"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file and must be included in the Source Program

REG1	EQU	0x01			;Define data registers 01H, 02H, 10H, and 11H
REG2	EQU	0x02
REG10	EQU	0x10
REG11	EQU	0x11
 
 	MOVLW	0x7F			;Load first number 7FH in W register
 	MOVWF	REG1			;Copy 7FH from W into Register 01H
 	MOVLW	0x82			;Load second number 82H in W register
 	MOVWF	REG2			;Copy 82H from W into Register 02H
 	MOVFF	REG1, REG10		;Copy first number in Register 10H
 	MOVFF	REG2, REG11		;Copy the second number in Register 11H
 	SLEEP
	END
