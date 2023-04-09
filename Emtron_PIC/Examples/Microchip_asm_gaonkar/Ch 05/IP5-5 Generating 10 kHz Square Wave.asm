	Title "IP5-5 Generating 10 kHz Square Wave"
 	List p=18F452, f =inhx32
 	#include <p18F452.inc>	;This is a header file  
							;It defines SFRs 
 
REG1	EQU		0x01			;Address of Data Register1		
REG10 	EQU		0x10			;Address of Data Register10
  
 		ORG 	0x20		
START:	MOVLW	B'11111110'		;Load number to set up  BIT0 as an output
 		MOVWF	TRISC			;Initialize BIT0 as an output pin
  		MOVWF	REG1		 	;Save Bit pattern in REG1
   
ONOFF:	MOVFF	REG1,PORTC    	;(8 Clk)-Turn on/off BIT0
 		MOVLW	D'166'	        ;(4 Cy) -Load decimal count in W
  		MOVWF	REG10      		;(4 Cy)	;Set up REG10 as a counter
  
LOOP1:	DECF	REG10, 1        ;(4 Clk) - Decrement REG10 
  		BNZ		LOOP1  			;(8/4 Clk)-Go back to LOOP1 if REG 10 =/ 0
  
  		COMF	REG1,1          ;(4 Cy)-Complement Bit Pattern
  		BRA		ONOFF      	     ;(8 Cy)-Go back to change LED
		END
