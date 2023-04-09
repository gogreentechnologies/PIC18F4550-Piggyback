	Title "Ex6-10 Multiplication"
	List p=18F452
	#include <p18F452.inc>	;This is a header file

REG10	EQU	0x10
REG11	EQU	0x11

		ORG		00
		GOTO 	MAIN

		ORG		0x020 		;Begin assembly at 0020H
MAIN:	MOVLW	0x81
		MULLW 	0x04
		MOVFF	PRODL, REG10
		MOVFF	PRODH, REG11
		END





