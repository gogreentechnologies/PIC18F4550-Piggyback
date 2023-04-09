Title "PIC18F452 EX11-4 Delay Program"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>		;This is a header file 

REG1	EQU	0x01			;Define Register1		

TIMER1:	MOVLW	0x5				;Count in REG1 to get multiples of 
		MOVWF	REG1			;  100 ms delay
		MOVLW	B'101100001'	;Bit pattern for Timer1: Prescaler 1:8,
		MOVWF	T1CON 			;16-bit mode, Enable Timer1
		CALL	DELAY100
		NOP

DELAY100
		MOVLW	0x85			;High count of 85EDH
		MOVWF	TMR1H			;Load high count in Timer1 High Register	
		MOVLW	0xED			;Low count of 85EDH
		MOVWF	TMR1L			;Load low count in Timer1 Low Register
		BCF 	PIR1, TMR1IF	;Clear TIMR0 overflow flag
LOOP:	BTFSS 	PIR1, TMR1IF 		;Test bit TMR0 flag – if set skip
		BRA 	LOOP		   	;Keep in loop until TMR0 flag is set 
		DECF  REG1,1,0			;Decrement count		
		BNZ   DELAY100			;Is count = 0, if no repeat
		RETURN					;Go back to the calling program
		END
