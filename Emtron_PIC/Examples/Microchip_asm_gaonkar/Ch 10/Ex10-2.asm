	Title "PIC18F452 Addition Program"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file and must be included in the Source Program

STATUS_TEMP	EQU	0x00
WREG_TEMP	EQU	0x01
BSR_TEMP	EQU	0x02
ISRCODE		EQU	0x100

		ORG	ISRCODE

	MOVFF	STATUS, STATUS_TEMP		;
	MOVWF	WREG_TEMP
	MOVFF	BSR, BSR_TEMP
	;
	;ISR Code	
	;
	MOVFF	BSR_TEMP, BSR	
	MOVF	WREG_TEMP, W			;
	MOVFF	STATUS_TEMP,STATUS
	RETFIE
	
	END
