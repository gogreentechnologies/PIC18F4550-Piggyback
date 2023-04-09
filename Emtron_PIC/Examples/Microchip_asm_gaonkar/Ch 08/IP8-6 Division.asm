    Title "PIC18F452 IP8-6 Division of 8-bit Numbers"
	List p=18F452, f =inhx32
	#include <p18F452.inc>	;The header file 

DIVIDND		EQU	0x10			;Define registers
DIVISOR		EQU	0x11
REMAINDR	EQU	0x12
COUNT		EQU	0x13

MAIN:		MOVLW	0xFF			;Number to be divided		
			MOVWF	DIVIDND		
			MOVLW	0x0A			;Divisor		
			MOVWF	DIVISOR		
			RCALL	DIVIDE		;Call divide routine
HERE:		BRA		HERE		

DIVIDE:	MOVLW	0x08			;Set up counter for 8 rotations
		MOVWF	COUNT
		CLRF	REMAINDR		;Clear remainder register 
LOOP:	BCF		STATUS,C,0		;Clear carry flag
		RLCF	DIVIDND		;Take seventh bit in Carry flag
		RLCF	REMAINDR		;Place carry flag in remainder
		MOVF	DIVISOR,W		;Get divisor in WREG 		
		SUBWF	REMAINDR,0		;Subtract divisor from remainder - save in WREG		
		BTFSS	STATUS,C,0		;Test carry flag
		BRA		RESET0		;If dividend < divisor, go to reset carry flag SET0:		
		BSF		DIVIDND,0,0		;If dividend > divisor, set carry flag
		MOVWF	REMAINDR,0		;Save remainder for next operation		
		BRA		NEXT
RESET0:	BCF		DIVIDND,0,0		;No quotient - reset carry flag
NEXT:	DECF	COUNT,1,0		;One operation complete - decrement count	
		BNZ		LOOP			;Are eight rotations complete? If not go back
		RETURN		
		END		


