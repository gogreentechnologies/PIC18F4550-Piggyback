	Title "Ex11-6 Measuring Period of Incoming Pulse"
		List p=18F452, f =inhx32

		#include <p18F452.inc>

REG0	EQU		0x00
REG1	EQU		0x01
REG2	EQU		0x02
REG3	EQU		0x03

		ORG	0x00
		GOTO		MAIN

MAIN:	BSF 	TRISC,CCP1		;Set up CCP1 (RC2) pin as input
		MOVLW	B'10000001'		;Select Timer1 as clock for CCP1-Bits<6-3> 00
		MOVWF 	T3CON,0			;Timer3 on in 16-bit mode
		MOVLW	B'10000001'		;Enable Timer1 in 16-bit mode, set prescaler =1,
		MOVWF	T1CON,0			;  use instruction cycle clock 
		MOVLW 	B'00000101'		;Set CCP1 to capture on every rising edge
		MOVWF  	CCP1CON,0	
		BCF		PIE1,CCP1IE,0	;Disable CCP1 capture interrupt as a precaution
		
		CALL	PULSE
		MOVFF 	CCPR1L,REG0		;Save Timer1 at arrival of first rising edge
		MOVFF	CCPR1H,REG1		

		CALL	PULSE
		CLRF	CCP1CON			;Disable further captures
		MOVFF 	CCPR1L,REG2		;Save Timer1 at arrival of second rising edge
		MOVFF	CCPR1H,REG3		

		CALL	RESULT			;Get period in clock cycles
HERE	GOTO	HERE


PULSE:	BCF		PIR1,CCP1IF,0	;Clear the CCP1IF flag
CHECK	BTFSS 	PIR1,CCP1IF,0	;Is there a rising edge?
		GOTO	CHECK			;If not, wait in loop		
		RETURN

RESULT:	MOVF	REG0,W,0		;Get first low reading in W
		SUBWF 	REG2,1		;Subtract W from second low reading - Save in REG2
		MOVF	REG1,W		;Get first high reading in W	
		SUBWFB	REG3,1,0		;Subtract W from second high reading - Save in REG3  
		RETURN
		END
