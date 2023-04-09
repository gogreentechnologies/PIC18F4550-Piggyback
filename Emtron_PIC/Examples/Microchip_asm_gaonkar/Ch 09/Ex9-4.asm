	Title "Ex9-4 BCD Digit Display"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	    ;This is a header file for PIC18F452

REG0 	EQU	0x00				;Define address of REG0

		ORG		00				;Begin assembly
		GOTO	0x20			;Program begins at location 0020H

		ORG		0x20           	;Begin assembly at memory location 000020H
START:	CLRF	PORTB           ;Intial reading at PORTB = 00
		CLRF	TRISB           ;Set up PORTB as an output port
		MOVLW	5               ;BCD digit to be displayed
		MOVWF	REG0, 0
		MOVLW	UPPER CODEADDR	;Copy upper 5 bits in Table Pointer of the 
		MOVWF	TBLPTRU			;21-bit address where code begins (CODEADDR)
		MOVLW	HIGH CODEADDR	;Copy high 8 bit in Table Pointer
		MOVWF	TBLPTRH
		MOVLW	LOW CODEADDR	;Copy low 8 bits in Table Pointer
		MOVWF	TBLPTRL
		MOVF	REG0, 0, 0		;Get BCD number to be displayed
		ADDWF	TBLPTRL 		;Add BCD number to Table Pointer
		TBLRD*					;Read LED code from memory
		MOVFF	TABLAT, PORTB	;Turn on LED

        ORG     0x40			;Store LED code starting at location 0040H

CODEADDR: DB	0xc0, 0xF9, 0xA4, 0xB0, 0x99 ;LED code for digits 0 to 4
		  DB	0x92, 0x82, 0xF8, 0x80, 0x98 ;LED code for digits 5 to 9
		END

 
