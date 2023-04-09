	Title "PIC18F452 Addition Program"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;This is a header file and must be included in the Source Program

REG10	EQU	0x10	;Define data register addresses
REG11	EQU	0x11
REG12	EQU	0x12
REG13	EQU	0x13
REG20	EQU	0x20
REG21	EQU	0x21


	ORG 00
	GOTO 0x20	

	ORG	0x20

	MOVLW	0xF2		;Load 16-bit numbers in REG10, 11, 12, & 13
	MOVWF	REG10
	MOVLW	0x29
	MOVWF	REG11
	MOVLW	0x87
	MOVWF	REG12
	MOVLW	0x35
	MOVWF	REG13

	MOVF	REG10,W		;Copy low-order byte F2H in WREG
 	ADDWF	REG12,W,A	;Add low-order byte 87H and save sum in WREG
 	MOVWF	REG20		;Save sum of low-order bytes in REG20
 	MOVF	REG11,0		;Copy high-order byte 29H in WREG
 	ADDWFC	REG13,0,0	;Add high-order byte 35H and save sum in WREG
 	MOVWF	REG21		;Save sum of high-order bytes in REG21
	END
