	Title "PIC18F452 Ex6-8 Unpacking a Byte"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

BUFFER1	EQU	0x10		;Define data register addresses
BUFFER2	EQU	0X11			
REG1	EQU	0x01

		ORG		0x00
		GOTO	START	

		ORG		0x20		;Begin assembly at 0020H
START:	MOVLW	0x37		;Load the packed byte
		MOVWF	REG1		;Save packed byte in REG1
		ANDLW	0x0F		;Mask high-order nibble 3
		MOVWF	BUFFER1		;Save 02H in BUFFER1
		MOVF	REG1,W,0	;Get the byte again
		ANDLW	0xF0		;Mask low-order nibble 2
		RRNCF	WREG,0,0	;Rotate high-order nibble four times		
		RRNCF	WREG
		RRNCF	WREG
		RRNCF	WREG		
		MOVWF	BUFFER2		;Save high-order nibble as 03H
		END

