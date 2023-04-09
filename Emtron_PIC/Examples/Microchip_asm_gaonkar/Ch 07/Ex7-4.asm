	 Title "Generating 10 kHz Square Wave Using Macro"
 	 List p=18F452, f =inhx32
 	 #include <p18F452.inc>		;This is a header file 



DELAY	MACRO	COUNT			;Macro begins here
		MOVLW	COUNT
		MOVWF	REG11 
LOOP 	MOVLW	D'166'		;50 micro-sec delay 
		MOVWF	REG10 		;  as in Example 7.2
LOOP1	DECF	REG10,F
		BNZ	LOOP1
		DECF	REG11
		BNZ	LOOP
		ENDM				;End of macro

REG1	EQU	0x01			;Address of Data Register1
REG10 	EQU	0x10			;Address of Data Register10
REG11	EQU	0x11			;Address of Data Register11

 		ORG 	0x20		
START:	MOVLW B'11111110'		;Number to set up BIT0 as an output
 		MOVWF	TRISC			;Initialize BIT0 as an output pin
  		MOVWF	REG1		 	;Save Bit pattern in REG1 
ONOFF:	MOVFF	REG1,PORTC 		;Turn on/off BIT0
		DELAY	D'05' 		 	;Macro DELAY
		COMF	REG1,F          	;Complement Bit Pattern
  		BRA	ONOFF      	    	;Go back to change LED
		END
