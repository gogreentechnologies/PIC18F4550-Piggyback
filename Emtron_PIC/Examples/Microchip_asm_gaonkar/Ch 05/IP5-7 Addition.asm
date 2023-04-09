	Title "IP5-7 Addition of Data Bytes"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file that must be included in
								;Source program
BUFFER 		EQU	0x10			;Define the beginning data register address
COUNTER		EQU	0X01			;Set up register 01 as a counter
CYREG		EQU 0X02

		ORG	0x20				;Begin assembly at 0020H
START:	MOVLW	0x00			;Byte to initialize port as an output port
		MOVWF	TRISB			;Initialize Ports B &C as an output ports
		MOVWF	TRISC
		MOVLW	0X05			;Count for five bytes
		MOVWF	COUNTER			;Set up counter
		CLRF 	CYREG			;Clear carry register
		LFSR	FSR0,BUFFER		;Set up FSR0 as pointer for data registers
		MOVLW	0x00			;Clear W register to save sum
NEXTADD:ADDWF	POSTINC0,W 		;Add byte and increment FSR0
		BNC		SKIP			;Check for carry-if no carry jump to SKIP
		INCF	CYREG			;If there is carry, increment CYREG
SKIP:	DECF	COUNTER,1,0		;Next count and save count in register
		BNZ		NEXTADD			;If COUNT =/ 0, go back to add next byte
		MOVWF	PORTC			;Display low-order byte of sum at PORTC
		MOVFF	CYREG, PORTB	;Display high-order byte of sum at PORTB
		SLEEP
		END
