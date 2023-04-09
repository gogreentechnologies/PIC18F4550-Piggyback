	Title "PIC18F452 Ex5-4"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file 

REG20	EQU	0x20	  		;Register 20H is labeled as REG20
REG21	EQU	0x21			;Register 21H is labeled as REG21
REG30	EQU	0x30			;Register 30H is labeled as REG30

		MOVLW	0x48		;Load the first Hex number 48H in WREG
		MOVWF	REG20 		;Store 48H in File Register 20H in data memory
		MOVLW	0x4F		;Load the second number 4FH in WREG 
		MOVWF	REG21 		;Store 4FH in File Register 21H in data memory
		ADDWF	REG20, 0, 0 ;Add 4FH which is still in WREG to 48H 
			           		;and save the sum in WREG
		MOVWF	REG30		;Save the sum in File Register 30H
		END
