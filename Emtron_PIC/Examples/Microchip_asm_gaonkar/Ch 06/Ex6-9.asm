	Title "Ex6-9 - Multiplication Using Rotate Instructions"
	List p=18F452
	#include <p18F452.inc>	;This is a header file

REG1	EQU	0x01			;Define registers
REG2	EQU	0x02
C		EQU	0				;Bit0 is C (carry flag)in STATUS

		ORG		00
		GOTO 	MAIN

		ORG		0x020 		;Begin assembly at 0020H
MAIN:	MOVLW	0x81		;Load 0181H in REG1 and REG2
		MOVWF	REG1,0
		MOVLW	0x01
		MOVWF	REG2,0
		MOVLW	0x02		;Set up W as a counter for 2
REPEAT:	BCF		STATUS,C,0	;Clear carry flag
		RLCF	REG1,1,0	;Multiply REG1 by 2
		RLCF	REG2,1,0	;Multiply REG2 by 2
		DECF	WREG,0,0	;Reduce counter by one
		BNZ		REPEAT		;If counter =/ 0, go back and repeat
		END



