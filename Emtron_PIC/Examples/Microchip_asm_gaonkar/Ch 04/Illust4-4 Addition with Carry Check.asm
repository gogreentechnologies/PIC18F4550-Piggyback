	Title "Illust4-4 Addition with Carry Check"
	List p=18F452, f=inhx32
	#include <p18F452.inc>	;This is a header file for 18F452  
							;It includes definitions of SFRs						
BYTE1	EQU		0xF2		;Data bytes
BYTE2	EQU		0x32
REG0	EQU		0x00		;Data Register addresses
REG1	EQU		0x01
REG2	EQU		0x02	

		ORG		00			;Reset vector
		GOTO	START

		ORG		0020H		;Begin assembly at 0020H 
START:	MOVLW	BYTE1		;Load F2H into W register
        MOVWF	REG0,0		;Save F2H in REG0
		MOVLW	BYTE2		;Load 32H into W register
		MOVWF	REG1,0		;Save 32H in REG1
		ADDWF	REG0,0,0	;Add byte in REG0 to REG1
		BNC    	SAVE		;If no carry, go to location SAVE
		MOVLW	0x00		;Load 00 in W
SAVE:	MOVWF	REG2,0 		;Save Result or clear REG
		SLEEP				;Power down
		END

 
