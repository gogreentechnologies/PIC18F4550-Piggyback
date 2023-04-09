;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;The following instructions generate an interrupt every one    :
;millisecond using Timer 2 and its internal register PR2       :
;MCU clock frequency = 10 MHz                                  :
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	Title "Generating 1 ms interrupt"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>			;This is a header file 

		ORG		0x00
		GOTO		TIMER2

		ORG		0x08
		GOTO		ISR_1ms

		ORG		0x20
TIMER2:	MOVLW	D'38'			;Count for PR2 to generate 1 ms interrupt
		MOVWF	PR2			;Load count in PR2		
		BSF	RCON,	 IPEN		;Enable priority - RCON <7>
		BSF	INTCON,GIEH		;Enable global high-priority - INTCON <7>
		BSF	INTCON,PEIE		;Enable peripheral interrupts - INTCON <6>
		BSF	IPR1, TMR2IP	;Set Timer2 as high-priority
		MOVLW B'01111101'		;Set postscaler = 16,presacler = 4,
		MOVWF T2CON			;and turn on Timer2
		BSF	PIE1, TMR2IE	;Enable Timer2 overflow interrupt	
		BCF	PIR1, TMR2IF	;Clear flag to start
		NOP
HERE	GOTO	HERE

ISR_1ms	BCF	PIR1, TMR2IF	;TMR2 and PR2 match occurred – clear flag
		RETFIE
		END
