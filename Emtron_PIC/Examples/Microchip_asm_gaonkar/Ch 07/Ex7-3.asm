	 Title "Ex7-3"
 	 List p=18F452, f =inhx32
 	 #include <p18F452.inc>	;This is a header file 
  

REG1		EQU	0x01			;Define addresses of Data registers		
REG10 		EQU	0x10			;Register for 50ÿµs delay count
REG11		EQU	0x11		      ;Register to specify multiple of delay

			ORG 	0x20		
START:		MOVLW	B'11111110'	;Byte to set up Bit0 as an output
			MOVWF	TRISC			;Initialize Bit0 as an output pin
 			MOVWF	REG1		 ;Save Bit pattern in REG1
			MOVLW	05		 ;Count to get multiple 50 ÿµs delay
			MOVWF	REG11		 ;Load count to get 250ÿµs delay 
 
ONOFF:		MOVFF	REG1,PORTC 	  	;Turn on/off Bit0
			CALL	DELAY
			COMF	REG1,1	      ;Complement Bit Pattern
 			BRA		ONOFF	      ;Go back to change LED

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;Function: 	This subroutine provides multiple of 50 ?s delay :
;Input: 	Count of delay multiples in REG11                :
;Output: 	None                                             :
;Registers modified: WREG and data register REG10 and REG11  :
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

		
DELAY:
DELAY50MC:	MOVLW	D'166'	;Load decimal count in W
 			MOVWF	REG10  	;Set up REG10 as a counter
 LOOP1:		DECF	REG10,1	      ;Decrement REG10 
 			BNZ	LOOP1   		;Go back to LOOP1 if REG10 ? 0
 			DECF	REG11,1	      ;Decrement multiple
 			BNZ	DELAY50MC	 
 			RETURN
			END

