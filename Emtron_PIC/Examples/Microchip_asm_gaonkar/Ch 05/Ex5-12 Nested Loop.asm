	Title "Ex5-12 Dealay Using Nested Loop"
	List p=18F452, 
	#include <p18F452.inc>	;This is a header file for 18F452

COUNT1	EQU		D'250'
REG10	EQU		0x10
REG11	EQU		0x11		


		CLRF	REG11	;Set up REG11= COUNT2 =0 for 256 execution
LOOP2:	MOVLW	COUNT1	;Load decimal count in W
		MOVWF	REG10	;Set up REG10 as a counter
LOOP1:	DECF	REG10,1	;Decrement REG10 - 1W/1C/4CLK
		BNZ		LOOP1	;Go back to LOOP1 if REG 10 =/ 0
		DECF	REG11,1	;Decrement REG11
		BNZ		LOOP2 	;Go back to load 250 in REG10 and start LOOP1 again
		END
