	Title "Multiplex Seven Segment Display"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	     	;Header file 
 
COUNTR 		EQU		0x00			;Define registers that are used
DIGIT_ON	EQU		0x01
DIGIT_OFF	EQU		0x02
L1REG		EQU		0x10			;Registers for delay count
L2REG		EQU		0x11
CODEREG		EQU		0x20
                               
			ORG		00
			GOTO	START


			ORG		0x20      		;Assemble at memory location 000020H
START:		CLRF	PORTB       	;Initial reading at PORTB = 00
			CLRF	TRISB       	;Set up PORTB and PORTC as output ports
			CLRF	TRISC
REPEAT:		MOVLW	4           	;Byte for four digits
			MOVWF	COUNTR, 0		;Set up counter
			CLRF	DIGIT_OFF		;All 0s to turn off display
			MOVLW	B'00000001'		;Code to turn on first LED
			MOVWF	DIGIT_ON		;Load the code in DIGIT_ON
			LFSR	FSR0, CODEREG	;Pointer for code

ANODE_CODE:	MOVFF	POSTINC0,PORTB	;Output code and increment pointer
			MOVFF	DIGIT_ON,PORTC	;Turn on LED
			MOVLW	2				;Count for 1 ms delay
			MOVWF	L2REG
			CALL	DELAY_1MS		;Call delay
			MOVFF	DIGIT_OFF,PORTC	;Turn off LEDs
			RLNCF	DIGIT_ON,1		;Get ready to turn next LED
			DECF	COUNTR,1		;Next count
			BNZ		ANODE_CODE		;If counter =/ 0, send next code
			BRA		REPEAT			;Start again

DELAY_1MS:
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function: Provides 1 ms delay	                                 :
		;Input: A multiplier count in register L2REG	                 :
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		
LOOP2:	MOVLW		D'10'		;Load decimal count in W
		MOVWF		L1REG		;Set up Loop1_Register as a counter
LOOP1:	DECF		L1REG, 1	;Decrement count in L1REG 
		NOP
		NOP
		BNZ			LOOP1		;Go back to LOOP1 if L1REG  =/ 0
		DECF 		L2REG,1		;Decrement L2REG
		BNZ			LOOP2 		;Go back to load 250 in L1REG and start LOOP1
		RETURN
		END

;Common cathode seven-segment LED code for 2006:
			
;CODEREG:   REG20: 0x7D		;Digit 6
;			Reg21: 0x3F		;Digit 0
;			Reg22: 0x3F		;Digit 0
;			Reg23: 0x5B		;Digit 2

 
