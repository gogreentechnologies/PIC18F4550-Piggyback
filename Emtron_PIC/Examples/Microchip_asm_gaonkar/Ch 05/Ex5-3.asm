	Title "Example 5-3"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;This is a header file 
 
REG10 	EQU	0x10				;Define data register address

		MOVLW	UPPER BUFFER	;Load the upper bits of BUFFER in TBLPTRU 
		MOVWF	TBLPTRU		
		MOVLW	HIGH BUFFER 	;Load high-byte in TBLPTRH
		MOVWF	TBLPTRH 
		MOVLW	LOW BUFFER		;Load low-byte in TBLPTRL
		MOVWF	TBLPTRL
		TBLRD*					;Copy byte F6H in Table Latch
		MOVF	TABLAT,W 		;Copy byte F6H from Table Latch into W 
		MOVWF	REG10			;Copy byte F6H from W into REG10

		ORG	0X40
BUFFER	DB	0xF6				;Store the byte F6H in 000040H
		END



