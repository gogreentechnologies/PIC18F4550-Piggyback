 	Title "IP8-2 Binary to BCD"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

BUFF0		EQU		0x10
BUFF1		EQU		0x11
BUFF2		EQU		0x12
TEMPR		EQU		0x00
CFLAG		EQU		0

		CLRF		BUFF0
		CLRF		BUFF1
		CLRF		BUFF2

BINBCD:	MOVWF		TEMPR			;Get the saved sum again
		LFSR		FSR0,BUFF2
		MOVLW		D'100' 		
		RCALL		BCD			 
		LFSR		FSR0, BUFF1
		MOVLW		D'10'			;Place 16 10  in WREG as a divisor
		RCALL 		BCD
		LFSR		FSR0, BUFF0
		MOVFF		TEMPR,BUFF0
		RETURN

BCD:		
		INCF		INDF0			;Begin counting number of subtractions
		SUBWF		TEMPR			;Subtract 16 10  from LO_SUM
		BTFSC		STATUS, CFLAG	;If C flag =0, skip next instruction
		GOTO		BCD				;If  C flag  =1, go back to next subtraction 
		ADDWF		TEMPR,1
		DECF		INDF0			;Adjust the last subtraction
		RETURN
		
		END
