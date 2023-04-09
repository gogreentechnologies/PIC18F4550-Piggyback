;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;Function: BCDBIN subroutine converts a two-digit BCD number into it binary equivalent           
; Input:   Two-digit BCD number in WREG                                                                                    :
; Output:   Binary equivalent of the BCD number in WREG                                                                         
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
	Title "IP8-1 Unpacking a Byte"

	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

BUFFER1	EQU	0x10		;Define data register addresses
BUFFER2	EQU	0X11			
REG1	EQU	0x01

		ORG		0x00
		GOTO	START	

		ORG	0x20			;Begin assembly at 0020H
START:	MOVWF	REG1		;Save packed byte in REG1
		ANDLW	0x0F		;Mask high-order nibble 
		MOVWF	BUFFER1		;Save low-order nibble in BUFFER1
		MOVF	REG1,WREG,0	;Get the byte again
		SWAPF	WREG,0
		ANDLW	0x0F		;Mask low-order nibble 
		MOVWF	BUFFER2		;Save high-order nibble 
		MULLW	D'10'
		MOVFF	PRODL,WREG
		ADDWF	BUFFER1,0
		RETURN
		END
