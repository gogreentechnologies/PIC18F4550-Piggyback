	Title "IP7-5 Calculating Average Temperature"
	List p=18F452, f =inhx32
	#include <p18F452.inc>		;The header file  

		

BUFFER 	EQU	0x10			;Define the beginning data register address
COUNTER	EQU	0X01			;Set up register 01 as a counter
		ORG	0x20			;Begin assembly at 0020H

BYTES	MACRO	COUNT		;Macro to provide count for bytes
		MOVLW	COUNT
		MOVWF	COUNTER
		ENDM

MAIN:	MOVLW	0x00			;Byte to initialize port as an output port
		MOVWF	TRISC	
		LFSR	FSR0, BUFFER	;Set up FSR0 as pointer for data registers
		BYTES	08
		CALL	DATACOPY
		LFSR	FSR0, BUFFER
		BYTES	08
		CALL	SUM
		MOVFF	TEMP,PORTC	
		SLEEP

SOURCE:	DB	0x41,0x45,0x40,0x42
		DB	0x40,0x41,0x4F,0x50

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
		



LO_SUM		EQU 0x03		;Define addresses of data registers 
HI_SUM		EQU	0x04
TEMP		EQU	0x05						;Data stored starting from register 10H
CFLAG		EQU	0				;Bit 0 in STATUS register

		
SUM:	CLRF		WREG,0
		CLRF		LO_SUM		;Registers to save sum
		CLRF		HI_SUM
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;The next segment adds 8-bit numbers resulting into 16-bit sum in registers HI_SUM     :
		;and LO_SUM.  The sum is also saved HI_BYTE and LO_BYTE registers to use it        :
		;again to demonstrate the second algorithm of repeated subtraction.                                  :
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   
ADD:	ADDWF 	POSTINC0,0,0 		;Add data byte and save sum in WREG
		BTFSC	STATUS,C		;Check C flag.  If C = 0, skip next instruction
		INCF	HI_SUM		;If C = 1, increment HI_SUM
		DECF	COUNTER,1,0		;One addition done - decrement count
		BNZ		ADD			;If count =/ 0, go back to add next byte
		MOVWF	LO_SUM
		MOVLW  	0x03			;Shifting right four times ÿ– set up counter for 4
		MOVWF  	COUNTER
		CALL	AVG
		RETURN
		
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;The following instructions divide the sum by using the instruction Rotate Right through :
		;Carry four times.  The average of 8-bit numbers is always 8-bit number; it is saved in     :
		;register AVERAGE1                                                                                                           :
		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

AVG:
CLEARCY:	BCF 		STATUS, CFLAG 	;Clear C flag
			RRCF		HI_SUM		;Divide byte in HI_SUM by 2 
			RRCF		LO_SUM		; Divide byte in LO_SUM by 2
			DECF		COUNTER,1,0		;Decrement rotation count 
			BNZ			CLEARCY		;If counter =/ 0, go back to next divide
			MOVFF		LO_SUM, TEMP	;Save result in register AVERAGE1
			RETURN
			END
