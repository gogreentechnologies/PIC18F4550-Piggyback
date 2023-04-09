	Title "Ex10-1 Interrupts"
 	List p=18F452, f =inhx32
	#include <p18F452.inc>			;This is a header file 

REG1	EQU		0x01				;Define Register1		

		ORG		0x00
		GOTO	MAIN

		ORG		0x0008				;High Priority Interrupt Vector
		GOTO	INT1_ISR			;Go to ISR

MAIN:	BSF		RCON, 	 IPEN		;Enable priority -RCON <7>
		BSF		INTCON,  GIEH		;Enable high-priority -INTCON <7>
		BCF		INTCON2, INTEDG1	;Interrupt on falling edge-INTCON2 <5>
		BSF		INTCON3, INT1IP		;Set high priority for INT1-INTCON3 <6>
		BSF		INTCON3, INT1IE		;Enable Interrupt1- INTCON3 <3>
		MOVLW	D'10'				;Set up REG1 to count 10
		MOVWF	REG1,0

		ORG		0x100
INT1_ISR
		DECF	REG1,1,0
		BNZ		GOBACK
		MOVLW	D'10'
		MOVWF	REG1,0
GOBACK:	RETFIE	FAST
		END
