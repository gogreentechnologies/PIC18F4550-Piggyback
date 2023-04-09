	Title "Ex6-11 Division by Rotation"
	List p=18F452
	#include <p18F452.inc>	;This is a header file

REG10	EQU	0x10			;Define registers
REG11	EQU	0x11
C		EQU	0				;Bit0 is C (carry flag)in STATUS

		ORG	00
		GOTO MAIN

		ORG		0x020 		;Begin assembly at 0020H
MAIN:	MOVLW	0x94		;Load 0794H in REG1 and REG2
		MOVWF	REG10,0
		MOVLW	0x07
		MOVWF	REG11,0
		MOVLW	0x03		;Set up W as a counter for 3
REPEAT:	BCF		STATUS,C,0	;Clear carry flag
		RRCF	REG11,1,0	;Divide REG11 by 2
		RRCF	REG10,1,0	;Divide REG10 by 2
		DECF	WREG,0,0	;Reduce counter by one
		BNZ		REPEAT		;If counter =/ 0, go back and repeat
		END


