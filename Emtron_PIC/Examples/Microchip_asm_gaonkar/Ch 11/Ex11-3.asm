	Title "PIC18F452 EX11-3 "
 	List p=18F452, f =inhx32
	#include <p18F452.inc>			;This is a header file


	BSF		RCON, IPEN		;Enable priority interrupt
	MOVLW	B'11000000'		;Enable global and peripheral priority
	MOVWF	INTCON		;by setting Bits <7-6> in Interrupt Control Register

	MOVLW	B'00000001'		;Set up TMR1 interrupt as high priority
	MOVWF	IPR1			;by setting Bit0 in Interrupt Priority Register1
	MOVWF	PIE1			;Enable Timer1 overflow interrupt –Bit0 in PIE1

	MOVLW	B'10000111'		;Bit7 = 16-bit mode, Bit2 = No sync.with ext. clock
	MOVWF	T1CON		;Bit1 = External clock, and Bit0 = Enable TMR1
	END
