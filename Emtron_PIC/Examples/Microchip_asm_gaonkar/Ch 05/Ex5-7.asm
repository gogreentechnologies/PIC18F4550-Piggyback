	Title "PIC18F452 Addition Program"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file 

REG20	EQU	0x20			;Define data register addresses
REG21	EQU	0x21

		ORG	0x20			;Begin assembly at program memory 20H

		MOVLW	0x7F		;Load number 7FH in W register
		MOVWF	REG20		;Copy 7FH from W into Register 20H
		COMF 	REG20,1,0	;Take oneÿ’s complement of 7FH and save in REG20
		INCF	REG20,1		;Increment oneÿ’s complement to obtain 2's 
							;complement 
		MOVWF	REG21		;Save 7FH in REG21
		NEGF	REG21,0		;Take 2's complement 
		END


