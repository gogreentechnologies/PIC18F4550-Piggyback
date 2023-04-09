    Title "PIC18F452 IP8-4 Binary to ASCII"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

BUFFER1	EQU	0x10		;Define data register addresses
BUFFER2	EQU	0X11			
REG1	EQU	0x01
ASCII	EQU	0x02
	
	
UNPACK:	MOVWF	REG1		;Save packed byte in REG1
		ANDLW	0x0F		;Mask high-order nibble 
		MOVWF	BUFFER1		;Save low-order nibble in BUFFER1
		MOVF	REG1,WREG	;Get the byte again
		SWAPF	WREG,0
		ANDLW	0x0F		;Mask low-order nibble 
		MOVWF	BUFFER2		;Save high-order nibble
		RETURN

BINASC:	MOVWF	ASCII		;Save the binaty number
		MOVLW	D'10'
		CPFSGT	ASCII		;If number is >10, add 07
		BRA		ADD30
		MOVLW	0x07
		ADDWF	ASCII,1,0
ADD30:	MOVLW	0x30
		ADDWF	ASCII,0,0
		RETURN
		END
