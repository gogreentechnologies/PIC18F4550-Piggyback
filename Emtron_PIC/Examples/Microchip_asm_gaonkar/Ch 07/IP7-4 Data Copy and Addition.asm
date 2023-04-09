	Title "IP7-4 Copying and Adding Bytes"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file  

		

BUFFER 	EQU		0x10			;Define the beginning data register address
COUNTER	EQU		0X01			;Set up register 01 as a counter

		ORG		00
		GOTO 	MAIN

BYTES	MACRO	COUNT		;Macro to provide count for bytes
		MOVLW	COUNT
		MOVWF	COUNTER
		ENDM
		
		ORG		0x20			;Begin assembly at 0020H
MAIN:	MOVLW	0x00			;Byte to initialize port as an output port
		MOVWF	TRISB			;Initialize Ports B &C as an output ports
		MOVWF	TRISC	
		LFSR	FSR0, BUFFER	;Set up FSR0 as pointer for data registers
		BYTES	05
		CALL	DATACOPY
		LFSR	FSR0, BUFFER	;Set up FSR0 as pointer for data registers
		BYTES	05
		CALL	ADDITION	
		MOVWF	PORTC			;Display low-order byte of sum at PORTC
		MOVFF	CYREG, PORTB	;Display high-order byte of sum at PORTB
		SLEEP

DATACOPY:	
		MOVLW	UPPER SOURCE	;Set up TBLPTR pointing to Source
		MOVWF	TBLPTRU			;address at 000040H
		MOVLW	HIGH SOURCE 
		MOVWF	TBLPTRH 
		MOVLW	LOW SOURCE 
		MOVWF	TBLPTRL
   NEXT:TBLRD*+					;Copy byte in Table Latch and increment source pointer
		MOVF	TABLAT,0 		;Copy byte from Table Latch in W
		MOVWF	POSTINC0		;Copy byte from W into data register BUFFER and increment FSR0 
		DECF	COUNTER,1,0		;Decrement count and store it in Counter 
		BNZ		NEXT			;Is copying complete?  If not go back and ;copy next byte
		RETURN
		
SOURCE:	DB	0xF6,0x67,0x7F,0xA9,0x72


CYREG	EQU 	0x02	

ADDITION:	
		CLRF 	CYREG			;Clear carry register
		LFSR	FSR0,BUFFER		;Set up FSR0 as pointer for data registers	
		MOVLW	0x00			;Clear W register to save sum
NEXTADD:ADDWF	POSTINC0,W 		;Add byte and increment FSR0
		BNC		SKIP			;Check for carry-if no carry jump to SKIP	
		INCF	CYREG			;If there is carry, increment CYREG 
SKIP:	DECF	COUNTER,1,0		;Next count and save count in register
		BNZ		NEXTADD			;If COUNT =/ 0, go back to add next byte
		RETURN
		END
