	Title "Ex10-3"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>			;This is a header file 
	

			ORG		0x00
			GOTO	MAIN

			ORG		0x0018			;Low Priority Interrupt Vector
			BTFSC	PIR1,TMR1IF		;Check Timer1 flag - skip if it is clear
			GOTO	TMR1_ISR		;If Timer1 flag set, go to its ISR
			BTFSC	PIR1,TMR2IF		;Check Timer2 flag - skip if it is clear
			GOTO	TMR2_ISR		;If Timer2 flag set, go to its ISR
			BTFSC	PIR1,ADIF		;Check A/D flag - skip if it is clear
			GOTO	ADC_ISR			;If A/D flag set, go to its ISR

MAIN:		;Main program begins here

			ORG		0x100			;Interrupt Service routines begin here
TMR1_ISR:	RETFIE					;Timer1 Service Routine
			
TMR2_ISR:	RETFIE					;Timer2 Service Routine
			
ADC_ISR:	RETFIE					;A/D Converter Service Routine
			END
