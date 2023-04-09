Title "PIC18F452 EX11-2 One Second Delay With Interrupt"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>			;This is a header file

		ORG	00
		GOTO	MAIN

		ORG	0x08
		GOTO	TMR0_ISR

MAIN:	CLRF	INTCON3		;Disable all INT flags		
		CLRF	PIR1			;Clear all internal peripheral flags	BSF	RCON,	 IPEN		;Enable priority - RCON <7>
		BSF	INTCON2,TMR0IP	;Set Timer0 as high-priority
		MOVLW	B'11100000'		;Set Timer0:global interrupt, high
		IORWF	INTCON,1		; piority, overflow, interrupt flag 
		MOVLW	B'10000110'		;Enable Timer0: 16-bit, internal clock,
		MOVWF	T0CON			; prescaler- 1:128

DELAY_1s:
		MOVLW	0xB3			;High count of B3B4H
		MOVWF	TMR0H			;Load high count in Timer0		
		MOVLW	0xB4			;Low count of B3B4H
		MOVWF	TMR0L			;Load low count in Timer0
		BCF 	INTCON, TMR0IF	;Clear TIMR0 overflow flag – Start counter
HERE:	GOTO	HERE			;Wait here for an interrupt

		ORG	0x100
TMR0_ISR:
		MOVLW	0xB3			;High count of B3B4H
		MOVWF	TMR0H			;Load high count in Timer0		
		MOVLW	0xB4			;Low count of B3B4H
		MOVWF	TMR0L			;Load low count in Timer0
		BCF 	INTCON, TMR0IF	;Clear TIMR0 overflow flag – Start counter
		RETFIE FAST			;Return
		END
