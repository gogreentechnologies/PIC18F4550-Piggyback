;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;The following program reads an analog temperature from LM34, a temperature transducer,  by using the A/D   : 
;converter module of PIC184520.  The temperature range is from 0 to 99.9F: The program converts the binary : 
;reading in BCD digits and stores them in the ASCII format.                                                                                   :
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	Title "Illust12-3 Interfacing Temperature Sensor"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>				;This is a header file 
			
WORD1		SET		0x10			;Define registers for multiplication
WORD2		SET		0x12			
RESULT		SET		0x14
		
DIVIDENDLO	EQU		0x20			;Define registers for division 
DIVIDENDHI 	EQU		0x21
QUOTIENT	EQU		0x22
INTEGER 	EQU		0x23
REMAINDR	EQU		0x24
DECIMAL		EQU		0x25
READING		EQU		0x26			;Register to get temperature reading for BCD
CFLAG		EQU		0			;Define bit position of carry flag

BCD0		EQU		0x30			;Define registers to save BCD digits
BCD1		EQU		0x31
		
DEGREES		SET		0x40			;Define registers to save ASCII characters for display
			

		ORG			00
		GOTO		MAIN

		ORG			0x20
MAIN:

ATOD_SETUP	MOVLW	B'00000001'		;Select channel AN0 and turn on A/D module
		MOVWF		ADCON0
		MOVLW		B'00001110'		;Select VDD and V SS as reference voltages	
		MOVWF		ADCON1					;  and set up RA0/AN0 for analog input
		MOVLW		B'10101101'				;Conversion reading is right justified, TAD = 12
		MOVWF		ADCON1					;  and conversion frequency = F OSC/ 16
	
		CALL		CONVERT				;Initialize A/D module
		CALL		MULTIPLY10			;Multiply temperature reading by 10 and divide 
		CALL		DIVIDE100			;  by 100 to adjust decimal point
		MOVFF		QUOTIENT,INTEGER 	;Save integer and remainder 
		MOVFF		DIVIDENDLO,REMAINDR
		MOVFF		REMAINDR, WORD1		;Adjust remainder to get decimal point by 
		CLRF		WORD1+1				; multiplying by 10 and dividing by 100
		CALL		MULTIPLY10
		CALL		DIVIDE100
		MOVFF		QUOTIENT,DECIMAL	;Save decimal point
		MOVF		INTEGER,W			;Get integer and convert it in BCD
		CALL		BINBCD
		
		MOVFF		BCD1, DEGREES		;Save integer in registers for display
		MOVFF		BCD0, DEGREES+1
		MOVLW		0x2E					;Save ASCII character for decimal point
		MOVWF		DEGREES+2		
		MOVF		DECIMAL,W			;Get decimal digit and convert in BCD
		CALL		BINBCD	
		MOVFF		BCD0, DEGREES+3		;Save decimal digit in registers for display
		CLRF		DEGREES+4			;Indicate end of display by null character
HERE	BRA			HERE

		
CONVERT:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	;Function:  This subroutine starts the A/D conversion and waits in a loop until the conversion flag :
	;	(DONE) is cleared.  The A/D module places the 10-bit converted  reading in registers :  ;	ADRESH (High-byte) and ADRESL (Low-byte).                                                           :
		;Output:	 10-bit digital reading equivalent of the analog temperature in registers WORD             :
		;	and WORD+1                                                                                                                    :
		;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		BSF		ADCON0,GO		;Starts conversion
  WAIT:	BTFSC		ADCON0, DONE	;Is conversion complete?  If not go to WAIT
		BRA		WAIT			; If yes, skip this Branch instruction
		MOVFF		ADRESL, WORD1	; Save low-order reading for BCD conversion
		MOVFF		ADRESH, WORD1+1	;Save high-order reading  for BCD conversion 		RETURN
		RETURN

MULTIPLY10:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function:    This subroutine multiplies 16-bit reading by decimal 10                                             :
	;Input:	The 16-bit reading in registers WORD1 and WORD1+1                                            :
	;Output:	The 16-bit product in registers RESULT and RESULT+1                                          :
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        

 		MOVLW	0x0A			;8-bit Multiplier ÿÿÿ– decimal  10
		MOVWF	WORD2						
		MOVF	WORD1,W		;Multiply low-order temperature reading by 10 
		MULWF	WORD2
		MOVFF	PRODL, RESULT	;Save result in RESULT and RESULT +1
		MOVFF	PRODH, RESULT+1

		MOVF	WORD1+1,W		; Multiply high-order temperature reading by 10
		MULWF	WORD2
		MOVF	PRODL,W
		ADDWF	RESULT+1,1		;Add previous product and save in RESULT+1
		MOVF	PRODH,W		
		ADDWFC 	RESULT+2,1		;Add previous product and save in RESULT+2
		RETURN

DIVIDE100:  	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function:     This subroutine divides 16-bit reading by decimal 102                                             :
	;Input:	The 16-bit number in registers RESULT and RESULT+1                                         :
	;Output:	The 8-bit quotient in register QUOTIENT and the remainder in DIVIDENDLO      :              
         		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		MOVFF		RESULT, DIVIDENDLO	;Get result after multiplication by 10
		MOVFF		RESULT+1, DIVIDENDHI
		CLRF		QUOTIENT		;Register to save integer reading      
AGAIN:	MOVLW		D'102'			;Divisor
		INCF		QUOTIENT
		SUBWF		DIVIDENDLO,1		;Begin division by subtraction low-order number
		BTFSC		STATUS, CFLAG	;Is the remainder negative
		GOTO		AGAIN			;If not, go back and subtract again
		DECF		DIVIDENDHI		;Now remainder in negative, adjust 
		BTFSC		STATUS, CFLAG
		GOTO		AGAIN	
		DECF		QUOTIENT
		ADDWF		DIVIDENDLO,1	
		RETURN
				

BINBCD:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function:     This subroutine converts 8-bit reading into two decimal BCD digits (0 to 9)            :
	;Input:	 An 8-bit number in W register                                                                                    :
	;Output:	Two unpacked BCD digits in registers BCD0 (low) and BCD1 (high)                      :              
	;Calls another subroutine DIVIDE
         		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		CLRF		BCD0			;Clear registers to save BCD digits
		CLRF		BCD1 
	
		MOVWF		READING		;Get temperature reading
		LFSR		FSR0, BCD1 		;Pointer to BCD1
		MOVLW		D'10'			;Divisor 10
		RCALL		DIVIDE			;Find BCD1
		LFSR		FSR0, BCD0		;Pointer to BUFF0 to save BCD0
		MOVFF		READING, BCD0	;Remainder = BCD0
		MOVLW		0x30			;ASCII conversion
		ADDWF		BCD1,1			;Save ASCII readings in BCD1 
		ADDWF		BCD0,1			;  and BCD0
		RETURN
			
DIVIDE:	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		;Function:     This subroutine divides an 8-bit number by 10                                                           :
	;Input:	 An 8-bit number in register READING and a pointer to BCD1                                :     
	;Output:	Two unpacked BCD digits in registers BCD0 (low) and BCD1 (high)                      :             
         		;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		INCF		INDF0			;Begin counting number of subtractions
		SUBWF		READING, 1		;Subtract power of ten from binary reading
		BTFSC		STATUS, CFLAG	;If C flag =0, skip next instruction
		GOTO		DIVIDE			;If  C flag  =1, go back to next subtraction 
		ADDWF		READING,1		;Adjust the temperature by adding divisor 
		DECF		INDF0			;Adjust the number of subtraction
		RETURN
		END	
