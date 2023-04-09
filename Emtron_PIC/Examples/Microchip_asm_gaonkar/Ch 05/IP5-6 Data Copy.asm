	Title "PIC18F452 IP5-6 Data Copy"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file that must be included in Source ;program 

BUFFER 	EQU	0x10			;Define the beginning data register address
COUNTER	EQU	0X01			;Set up register 01 as a counter
		ORG	0x20			;Begin assembly at 0020H

START:	MOVLW	0x00			;Byte to initialize port as an output port
		MOVWF	TRISC			;Initialize PORTC as an output port
		MOVLW	0X05			;Count for five bytes
		MOVWF	COUNTER			;Set up counter
		LFSR	FSR0, BUFFER	;Set up FSR0 as pointer for data registers
		MOVLW	UPPER SOURCE	;Set up TBLPTR pointing to Source
		MOVWF	TBLPTRU			;address at 000040H
		MOVLW	HIGH SOURCE 
		MOVWF	TBLPTRH 
		MOVLW	LOW SOURCE 
		MOVWF	TBLPTRL
NEXT:	TBLRD*+					;Copy byte in Table Latch and increment source pointer
		MOVF	TABLAT,0 		;Copy byte from Table Latch in W
		MOVWF	POSTINC0		;Copy byte from W into data register BUFFER and increment FSR0 
		DECF	COUNTER,1,0		;Decrement count and store it in Counter 
		BNZ		NEXT			;Is copying complete?  If not go back and ;copy next byte
		MOVLW	0xFF			;Load completion indicator
		MOVWF	PORTC			;Turn on all LEDs at PORTC
		SLEEP
		ORG		0X50
SOURCE:	DB	0xF6,0x67,0x7F,0xA9,0x72
		END
