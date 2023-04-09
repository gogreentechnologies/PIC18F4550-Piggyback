;The following program should be simulated using 
;PIC18 Simulator IDE

	Title "Illust2-6 Displaying Byte"
	List p=18F452, f=inhx32
	#include <p18F452.inc>	;This is a header file for 18F452  
							;It includes definitions of SFRs

	ORG 	0x20		;Begin assembly at 0000H
	MOVLW	00 			;Load 00 into WREG
     MOVWF	TRISC 		;Set up PORTC as output port
	MOVLW	0x55 		;Load byte 55H to turn on alternate LEDs
	MOVWF	PORTC 		;Display 55H at PORTC
	SLEEP				;End of program, power down
	END					;End of assembly


